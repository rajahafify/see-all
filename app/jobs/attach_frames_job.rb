class AttachFramesJob < ApplicationJob
  queue_as :default

  def perform(stream_id, output_directory)
    stream = Stream.find(stream_id)
    redis = Redis.new
    stop_signal = redis.get("stop_job_#{stream_id}").present?

    until stop_signal do
      FfmpegService.attach_generated_frames_to_stream(stream, output_directory)
      
      stop_signal = redis.get("stop_job_#{stream_id}").present?
      puts "AttachFramesJob: Stop signal: #{stop_signal}"
      
      sleep 5 unless stop_signal # Wait for 5 seconds before checking for new frames again
    end
  end
end
