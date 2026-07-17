class TwilioSmsService
  def self.call(to:, body:)
    client = Twilio::REST::Client.new(
      ENV.fetch("TWILIO_ACCOUNT_SID"),
      ENV.fetch("TWILIO_AUTH_TOKEN")
    )

    client.messages.create(
      from: ENV.fetch("TWILIO_PHONE_NUMBER"),
      to: to,
      body: body
    )
  end
end
