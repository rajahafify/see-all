class StreamsController < ApplicationController
  skip_before_action :verify_authenticity_token  # Disable CSRF for RTMP callbacks
  before_action :get_stream_key, only: [:start, :stop]

  # Index action
  def index
    @streams = Stream.all
  end

  # Show stream
  def show
    @stream = Stream.find(params[:id])
  end

  # Authentication logic
  def auth
    render plain: 'OK', status: :ok
  end

  # Start stream with real-time analysis
  def start
    service = StreamStartService.new(stream_key)
    if service.valid_stream_key?
      service.start_stream
      logger.info "Stream #{stream_key} started"
      render plain: 'OK', status: :ok
    else
      logger.error "Error starting stream #{stream_key}"
      render plain: 'Error', status: :bad_request
    end
  end

  # Stop stream
  def stop
    service = StreamStopService.new(stream_key)
    service.stop_stream
    render plain: 'OK', status: :ok
  end

  private

  def get_stream_key
    @stream_key ||= params[:name]
  end

  def stream_key
    @stream_key
  end
end
