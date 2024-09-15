class Stream < ApplicationRecord
  has_one_attached :recording
  validates :stream_key, presence: true
end
