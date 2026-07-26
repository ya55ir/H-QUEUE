require "test_helper"

module Manager
  class QueueEntriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @manager = User.create!(email: "manager@hqueue.test", password: "password123", first_name: "Manon",
                              last_name: "Manager", terms_opt_in: true, is_manager: true)
      sign_in @manager
    end

    test "notify sends an SMS with the confirmation link when the venue has SMS enabled" do
      venue = Venue.create!(name: "Le Wagon Bleu", address: "1 rue de Rivoli, Paris", sms_enabled: true)
      entry = venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2,
                                          status: :waiting)

      sent = nil
      with_stubbed_twilio_call(->(to:, body:) { sent = { to: to, body: body } }) do
        patch notify_manager_queue_entry_path(entry)
      end

      assert_equal "+33612345678", sent[:to]
      assert_includes sent[:body], "Le Wagon Bleu"
      assert_includes sent[:body], "/queue_entries/#{entry.id}/confirmation"
      assert entry.reload.notified?
      assert_not_nil entry.notified_at
    end

    test "notify does not send an SMS when the venue has SMS disabled" do
      venue = Venue.create!(name: "Le Wagon Bleu", address: "1 rue de Rivoli, Paris", sms_enabled: false)
      entry = venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2,
                                          status: :waiting)

      with_stubbed_twilio_call(->(**_args) { raise "should not be called" }) do
        patch notify_manager_queue_entry_path(entry)
      end

      assert entry.reload.notified?
    end

    test "notify still updates the entry and redirects even if Twilio raises" do
      venue = Venue.create!(name: "Le Wagon Bleu", address: "1 rue de Rivoli, Paris", sms_enabled: true)
      entry = venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2,
                                          status: :waiting)

      with_stubbed_twilio_call(->(**_args) { raise Twilio::REST::TwilioError, "boom" }) do
        patch notify_manager_queue_entry_path(entry)
      end

      assert_redirected_to manager_venue_path(venue)
      assert entry.reload.notified?
    end

    private

    # Minitest 6 dropped Object#stub, so we swap the singleton method by hand for the duration of the block.
    def with_stubbed_twilio_call(fake_call)
      original = TwilioSmsService.singleton_method(:call)
      TwilioSmsService.define_singleton_method(:call) { |**kwargs| fake_call.call(**kwargs) }
      yield
    ensure
      TwilioSmsService.define_singleton_method(:call, original)
    end
  end
end
