require 'open3'
require 'shellwords'

class Stream < ApplicationRecord
  has_one_attached :recording
  has_many_attached :frames
  validates :stream_key, presence: true

  def generate_frames_from_stream
    url = "rtmp://nginx/stream/#{stream_key}"
    output_directory = "tmp/frames/#{id}"  # Use stream ID to ensure uniqueness
    FileUtils.mkdir_p(output_directory)    # Create the directory if it doesn't exist

    GenerateFramesJob.perform_later(id, url, output_directory)
    AttachFramesJob.perform_later(id, output_directory)
  end
  
  def attach_generated_frames_to_stream(output_directory)
    # Get a list of the PNG files in the output directory for this stream
    Dir.glob("#{output_directory}/frame_*.png").sort.each_with_index do |file_path, index|
      puts "Filename exists: #{frames.joins(:blob).where(active_storage_blobs: {filename: File.basename(file_path)}).exists?}"
      unless frames.joins(:blob).where(active_storage_blobs: {filename: File.basename(file_path)}).exists?
        File.open(file_path, 'rb') do |file|
          frames.attach(
            io: file,
            filename: File.basename(file_path),
            content_type: 'image/png'
          )
        end
      end
    end
  end

  def stop_jobs
    Redis.new.set("stop_job_#{id}", "true")
    StopGenerateFramesJob.perform_later(id)
    logger.info("Stream: Stopped jobs for stream #{id}")
  end
end
