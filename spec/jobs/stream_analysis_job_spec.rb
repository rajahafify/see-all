require 'rails_helper'

RSpec.describe StreamAnalysisJob, type: :job do
  let(:stream_key) { 'test_stream' }
  let(:stream_url) { "rtmp://nginx/stream/#{stream_key}" }

  before do
    allow(Stream).to receive(:generate_frames_from_url).and_return(true) # Mocking FFmpeg call
  end

  describe '#perform' do
    before do
      allow(subject).to receive(:analyze_stream).and_call_original # Allow the original method to be called
    end

    it 'logs the start and finish of the analysis' do
      expect { subject.perform(stream_key) }.to output(/Real-time analysis started for stream: #{stream_key}/).to_stdout
      expect { subject.perform(stream_key) }.to output(/Real-time analysis finished for stream: #{stream_key}/).to_stdout
    end

    it 'calls analyze_stream with the correct URL' do
      subject.perform(stream_key) # Call the perform method
      expect(subject).to have_received(:analyze_stream).with(stream_url, stream_key) # Ensure both arguments are passed
    end

    it 'captures stream data and saves a new Stream record' do
      expect {
        subject.perform(stream_key)
      }.to change(Stream, :count).by(1) # Check if this line is reached
    end

    it 'generates frames from the stream URL' do
      stream = instance_double(Stream)
      allow(Stream).to receive(:new).and_return(stream)
      allow(stream).to receive(:save).and_return(true)
      expect(Stream).to receive(:generate_frames_from_url).with(stream_url, stream)
      subject.perform(stream_key)
    end
  end
end
