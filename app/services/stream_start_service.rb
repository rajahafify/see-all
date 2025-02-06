class StreamStartService
  def initialize(stream_key)
    @stream_key = stream_key
  end

  def valid_stream_key?
    Stream.exists?(stream_key: @stream_key)
  end

  def start_stream
    stream = Stream.find_by(stream_key: @stream_key)
    stream.generate_frames_from_stream if stream
  end

  def stream_key
    @stream_key
  end
end
