class AttachFramesJob < ApplicationJob
  queue_as :default

  def perform(stream_id, output_directory)
    stream = Stream.find(stream_id)

    until stop_signal?(stream_id) do
      FfmpegService.attach_generated_frames_to_stream(stream, output_directory)
      
      puts "AttachFramesJob: Stop signal: #{stop_signal?(stream_id)}"
      
      sleep 5 unless stop_signal?(stream_id) # Wait for 5 seconds before checking for new frames again
    end
  end
end
