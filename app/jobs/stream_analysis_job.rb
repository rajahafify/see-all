require 'net/http'
require 'open3'
require 'json'

class StreamAnalysisJob < ApplicationJob
  queue_as :default

  def perform(stream_key)
    puts "Performing analysis for stream_key: #{stream_key}" # Debugging output

    puts "Real-time analysis started for stream: #{stream_key}"

    analyze_stream(stream_url, stream_key)

    puts "Real-time analysis finished for stream: #{stream_key}"
  end

  private

  def analyze_stream(url, stream_k)
  end
end
