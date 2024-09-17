require 'open3'
require 'shellwords'

class FfmpegService

  def initialize(stream)
    @stream = stream
  end

  def execute
    generate_frames_from_stream(@stream)
  end

  def quit
    stop_jobs(@stream.id)
  end

  def self.generate_image_from_frames(stream_id, url, output_directory)
    sleep 5 # Wait for the stream to start
    command = [
      'ffmpeg',
      '-i', url,
      '-vf', 'fps=1,scale=1920:1080',
      '-vcodec', 'png',
      '-loglevel', 'repeat+level+verbose',
      "#{output_directory}/frame_%03d.png"
    ]

    puts "Stream ID: #{stream_id}"
    puts "URL: #{url}"
    puts "Output Directory: #{output_directory}"    
    puts "Command: #{command}"
    

    Open3.popen2e(*command) do |stdin, stdout_and_stderr, wait_thr|
      pid = wait_thr.pid
      Redis.new.set("generate_frames_job_pid_#{stream_id}", pid)
      while line = stdout_and_stderr.gets
          puts line  
      end
  
      # Wait for the process to finish
      exit_status = wait_thr.value
      puts "GenerateFramesJob: Exit status: #{exit_status}"
    end
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

  private

  def generate_frames_from_stream(stream)
    url = "rtmp://nginx/stream/#{stream.stream_key}"
    output_directory = "tmp/frames/#{stream.id}"  # Use stream ID to ensure uniqueness
    FileUtils.mkdir_p(output_directory)    # Create the directory if it doesn't exist

    GenerateFramesJob.perform_later(stream.id, url, output_directory)
    AttachFramesJob.perform_later(stream.id, output_directory)
  end

  def stop_jobs(stream_id)
    Redis.new.set("stop_job_#{stream_id}", "true")
    StopGenerateFramesJob.perform_later(stream_id)
  end
end
