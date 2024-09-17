require 'open3'
require 'shellwords'

class Stream < ApplicationRecord
  has_one_attached :recording
  has_many_attached :frames
  validates :stream_key, presence: true

  def generate_frames_from_stream
    FfmpegService.generate_frames_from_stream(self)
  end

  def stop_jobs
    FfmpegService.stop_jobs(id)
  end
end
