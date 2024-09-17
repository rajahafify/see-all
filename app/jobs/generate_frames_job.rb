require 'open3'

class GenerateFramesJob < ApplicationJob
    queue_as :default

    def perform(stream_id, url, output_directory)
        FfmpegService.generate_image_from_frames(stream_id, url, output_directory)
    end
end
