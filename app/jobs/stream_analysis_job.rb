require 'net/http'
require 'open3'
require 'json'

class StreamAnalysisJob < ApplicationJob
  queue_as :default

  def perform(stream_key)
    puts "Performing analysis for stream_key: #{stream_key}" # Debugging output
    stream_url = "rtmp://nginx/stream/#{stream_key}"

    puts "Real-time analysis started for stream: #{stream_key}"

    analyze_stream(stream_url, stream_key)

    puts "Real-time analysis finished for stream: #{stream_key}"
  end

  private

  def analyze_stream(url, stream_key)
    puts "Analyzing stream at #{url} with key: #{stream_key}" # Debugging output
    stream = Stream.new(stream_key: stream_key) # Use stream_key for the Stream instance
    if stream.save
      puts "Stream created successfully: #{stream.inspect}" # Debugging output
    else
      puts "Failed to create Stream: #{stream.errors.full_messages}" # Debugging output
    end
  end
end
