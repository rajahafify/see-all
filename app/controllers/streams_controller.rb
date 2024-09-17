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
    return head :bad_request unless valid_stream_key?(stream_key)
    stream = Stream.new(stream_key: stream_key) # Use stream_key for the Stream instance
    if stream.save
      stream.generate_frames_from_stream
      logger.info "Stream #{stream.stream_key} started"
    else
      logger.error "Error starting stream #{stream.stream_key}: #{stream.errors.full_messages}"
    end
    render plain: 'OK', status: :ok
  end

  # Stop stream
  def stop
    @stream = Stream.where(stream_key: stream_key).last
    @stream.stop_jobs
    render plain: 'OK', status: :ok
  end

  private

  # Check if stream key is valid
  def valid_stream_key?(stream_key)
    stream_key == 'test_stream' 
  end

  def get_stream_key
    @stream_key ||= params[:name]
  end

  def stream_key
    @stream_key
  end
end
