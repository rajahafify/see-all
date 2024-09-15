require 'open3'
require 'shellwords'

class Stream < ApplicationRecord
  has_one_attached :recording
  has_many_attached :frames
  validates :stream_key, presence: true

  def self.generate_frames_from_url(url, stream)
    return unless url.present?
    
    # Build the command as an array to prevent shell injection
    command = [
      'ffmpeg',
      '-i', url,
      '-vf', 'fps=1,scale=1920:1080,crop=1920:1080', # Crop to 1080p
      '-f', 'image2pipe',
      '-vcodec', 'png',
      '-'
    ]

    # Use Open3 to run ffmpeg and read stdout
    Open3.popen3(*command) do |stdin, stdout, stderr, wait_thr|
      # Read each frame from stdout and attach it to the stream
      while (frame_data = stdout.read(1920 * 1080 * 3)) # Adjust buffer size as needed
        break if frame_data.empty? # Exit if no more data

        # Create a temporary file for each frame
        temp_frame_file = Tempfile.new(['frame', '.png'])
        File.open(temp_frame_file.path, 'wb') do |file|
          file.write(frame_data)
        end

        # Attach the generated frame to the stream
        stream.frames.attach(
          io: File.open(temp_frame_file.path),
          filename: "frame_#{Time.now.to_i}.png",
          content_type: 'image/png'
        )

        # Clean up the temporary frame file
        temp_frame_file.close
        temp_frame_file.unlink
      end

      # Check for errors
      unless wait_thr.value.success?
        error_message = stderr.read
        Rails.logger.error "FFmpeg error: #{error_message}"
        raise "FFmpeg error: #{error_message}"
      end
    end
  end

  def png_frames
    frames.joins(:blob).where(active_storage_blobs: { content_type: 'image/png' }).map do |frame|
      frame.filename.to_s # This will return the binary data of the file
    end
  end
end
