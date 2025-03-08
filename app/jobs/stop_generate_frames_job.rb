class StopGenerateFramesJob < ApplicationJob
  queue_as :default

  def perform(stream_id)
    pid = Redis.new.get("generate_frames_job_pid_#{@stream_key}")
    if pid
      Process.kill('TERM', pid.to_i)
      puts "Sent TERM signal to process #{pid}"
    else
      puts "No PID found for stream #{@stream_key}"
    end
  rescue Errno::ESRCH
    puts "Process #{pid} not found"
  end
end
