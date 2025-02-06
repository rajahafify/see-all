class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  def redis
    @redis ||= Redis.new
  end

  def stop_signal?(stream_id)
    redis.get("stop_job_#{stream_id}").present?
  end

  def set_stop_signal(stream_id)
    redis.set("stop_job_#{stream_id}", "true")
  end
end
