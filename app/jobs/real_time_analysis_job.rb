require 'net/http'
require 'open3'
require 'json'

class RealTimeAnalysisJob < ApplicationJob
  queue_as :default

  def perform(stream_key)
    stream_url = "rtmp://nginx/stream/#{stream_key}"

    puts "Real-time analysis started for stream: #{stream_key}"

    analyze_stream(stream_url)

    puts "Real-time analysis finished for stream: #{stream_key}"
  end

  private

  def analyze_stream(stream_url)
    # Construct the FFmpeg command
    # command = "ffmpeg -i #{stream_url} -vf fps=1 -f image2pipe -vcodec png -"
    #TODO: generate image frames from the video and save them to the tmp directory.
  end
end
