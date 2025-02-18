require 'twilio-ruby'

class TwilioService
  def initialize
    @client = Twilio::REST::Client.new
  end

  def send_sms(to:, body:)
    @client.messages.create(
      from: TWILIO_PHONE_NUMBER,
      to: to,
      body: body
    )
  end
end
