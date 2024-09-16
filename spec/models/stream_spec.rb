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
end
