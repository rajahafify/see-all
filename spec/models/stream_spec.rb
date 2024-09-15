require 'rails_helper'

RSpec.describe Stream, type: :model do
  it 'is valid with valid attributes' do
    stream = Stream.new(stream_key: 'unique_key_123') # Changed to use stream_key
    expect(stream).to be_valid
  end

  it 'is not valid without a stream_key' do
    stream = Stream.new(stream_key: nil) # Only checking stream_key
    expect(stream).to_not be_valid
  end

  # Add more tests as needed
end
