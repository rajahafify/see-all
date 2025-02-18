require 'rails_helper'

RSpec.describe TwilioService, type: :service do
  let(:twilio_service) { TwilioService.new }
  let(:to) { '+1234567890' }
  let(:body) { 'Test message' }

  describe '#send_sms' do
    it 'sends an SMS using Twilio' do
      expect_any_instance_of(Twilio::REST::Client).to receive_message_chain(:messages, :create).with(
        from: TWILIO_PHONE_NUMBER,
        to: to,
        body: body
      )
      twilio_service.send_sms(to: to, body: body)
    end
  end
end
