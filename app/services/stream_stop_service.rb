class StreamStopService
  def initialize(stream_key)
    @stream_key = stream_key
  end

  def stop_stream
    stop_jobs
    manage_stop_signals
  end

  private

  def stop_jobs
    stream = Stream.find_by(stream_key: @stream_key)
    if stream
      stream.stop_jobs
    else
      logger.error "Stream with key #{@stream_key} not found"
    end
  end

  def manage_stop_signals
    stream = Stream.find_by(stream_key: @stream_key)
    if stream
      Redis.new.set("stop_job_#{stream.id}", "true")
    else
      logger.error "Stream with key #{@stream_key} not found"
    end
  end
end
