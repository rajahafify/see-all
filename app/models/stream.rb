class Stream < ApplicationRecord
  has_one_attached :recording
  has_many_attached :frames
  validates :stream_key, presence: true

  def generate_frames_from_stream
    FfmpegService.new(self).execute
  end

  def stop_jobs
    FfmpegService.new(self).quit
  end
end
