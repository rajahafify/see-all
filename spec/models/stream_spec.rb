require 'rails_helper'

RSpec.describe Stream, type: :model do
  describe 'validations' do
    it 'is valid with a stream_key' do
      stream = build(:stream)
      expect(stream).to be_valid
    end

    it 'is not valid without a stream_key' do
      stream = build(:stream, stream_key: nil)
      expect(stream).to_not be_valid
    end
  end

  describe '.generate_frames_from_url' do
    let(:stream) { create(:stream) }
    let(:url) { 'rtmp://localhost/live/test_stream' }
    let(:fake_image_data) { File.read(Rails.root.join('spec', 'fixtures', 'images', 'frame.png'), mode: 'rb') }

    before do
      stub_ffmpeg_process(fake_image_data)
    end

    after do
      stream.frames.purge
    end

    it 'attaches a frame to the stream' do
      expect {
        Stream.generate_frames_from_url(url, stream)
      }.to change { stream.frames.count }.by(1)

      attached_frame = stream.frames.last
      expect(attached_frame.filename.to_s).to start_with('frame_')
    end

    it 'raises an error when ffmpeg fails' do
      stub_ffmpeg_process_failure

      expect(Rails.logger).to receive(:error).with('FFmpeg error: ffmpeg error message')

      expect {
        Stream.generate_frames_from_url(url, stream)
      }.to raise_error('FFmpeg error: ffmpeg error message')
    end

    it 'does nothing if url is blank' do
      expect {
        Stream.generate_frames_from_url(nil, stream)
      }.not_to change { stream.frames.count }
    end
  end

  def stub_ffmpeg_process(fake_image_data)
    fake_stdout = StringIO.new(fake_image_data)
    fake_stderr = StringIO.new('')
    fake_thread = double('thread', value: double('status', success?: true))

    allow(Open3).to receive(:popen3).and_yield(nil, fake_stdout, fake_stderr, fake_thread)
  end

  def stub_ffmpeg_process_failure
    fake_stdout = StringIO.new('')
    fake_stderr = StringIO.new('ffmpeg error message')
    fake_thread = double('thread', value: double('status', success?: false))

    allow(Open3).to receive(:popen3).and_yield(nil, fake_stdout, fake_stderr, fake_thread)
  end
end
