require 'open3'
require 'shellwords'

class FfmpegService
  def self.generate_frames_from_stream(stream)
    url = "rtmp://nginx/stream/#{stream.stream_key}"
    output_directory = "tmp/frames/#{stream.id}"  # Use stream ID to ensure uniqueness
    FileUtils.mkdir_p(output_directory)    # Create the directory if it doesn't exist

    GenerateFramesJob.perform_later(stream.id, url, output_directory)
    AttachFramesJob.perform_later(stream.id, output_directory)
  end

  def self.attach_generated_frames_to_stream(stream, output_directory)
    # Get a list of the PNG files in the output directory for this stream
    Dir.glob("#{output_directory}/frame_*.png").sort.each_with_index do |file_path, index|
      puts "Filename exists: #{stream.frames.joins(:blob).where(active_storage_blobs: {filename: File.basename(file_path)}).exists?}"
      unless stream.frames.joins(:blob).where(active_storage_blobs: {filename: File.basename(file_path)}).exists?
        File.open(file_path, 'rb') do |file|
          stream.frames.attach(
            io: file,
            filename: File.basename(file_path),
            content_type: 'image/png'
          )
        end
      end
    end
  end

  def self.stop_jobs(stream_id)
      Redis.new.set("stop_job_#{id}", "true")
      StopGenerateFramesJob.perform_later(stream_id)
      logger.info("Stream: Stopped jobs for stream #{stream_id}")
    end
  end
end
