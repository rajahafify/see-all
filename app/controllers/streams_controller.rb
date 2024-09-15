class StreamsController < ApplicationController
  skip_before_action :verify_authenticity_token  # Disable CSRF for RTMP callbacks
  before_action :get_stream_key

  # Authentication logic
  def auth
    # TODO: Implement proper authentication logic
    render plain: 'OK', status: :ok
  end

  # Start stream with real-time analysis
  def start
    unless valid_stream_key?(stream_key)
      logger.error "Invalid stream key: #{stream_key}"
      head :bad_request
      return
    end
    RealTimeAnalysisJob.perform_later(stream_key)
    render plain: 'OK', status: :ok
  end

  # Stop stream
  def stop
    head :ok
  end

  private

  # Check if stream key is valid
  def valid_stream_key?(stream_key)
    stream_key == 'test_stream' 
  end

  def get_stream_key
    @stream_key = params[:name]
  end

  def stream_key
    @stream_key
  end
end
