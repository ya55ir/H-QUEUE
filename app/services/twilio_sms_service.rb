class TwilioSmsService
  # hqueue.app (domaine récent, sans réputation) est filtré comme phishing par
  # les carriers FR (Twilio 30007). En prod on force herokuapp (réputation
  # établie) pour le lien SMS. En dev/test on garde le host de l'env (ngrok).
  PRODUCTION_LINK_HOST = "h-queue-e3ac180a05f9.herokuapp.com".freeze
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

  def self.link_host
    return PRODUCTION_LINK_HOST if Rails.env.production?

    Rails.application.routes.default_url_options[:host]
  end
end
