require "test_helper"

class QueueEntryTest < ActiveSupport::TestCase
  setup do
    @venue = Venue.create!(name: "Le Wagon Bleu", address: "1 rue de Rivoli, Paris")
  end

  test "prevents the same guest (by phone number) from joining the venue queue twice while active" do
    @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)
    duplicate = @venue.queue_entries.new(name: "Marcel", phone_number: "+33612345678", party_size: 3, status: :waiting)

    assert_not duplicate.save
    assert_includes duplicate.errors[:base], "You are already in this queue"
  end

  test "prevents the same signed-in user from joining the venue queue twice while active" do
    user = User.create!(email: "marcel@hqueue.test", password: "password123", first_name: "Marcel",
                        last_name: "Dupont", terms_opt_in: true)
    @venue.queue_entries.create!(user: user, party_size: 2, status: :waiting)
    duplicate = @venue.queue_entries.new(user: user, party_size: 3, status: :notified)

    assert_not duplicate.save
    assert_includes duplicate.errors[:base], "You are already in this queue"
  end

  test "allows a different guest to join the same venue" do
    @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)
    other = @venue.queue_entries.new(name: "Alice", phone_number: "+33698765432", party_size: 2, status: :waiting)

    assert other.save
  end

  test "archive_daily! archives active entries regardless of status and keeps their status" do
    waiting = @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)
    confirmed = @venue.queue_entries.create!(name: "Alice", phone_number: "+33698765432", party_size: 2, status: :confirmed)

    QueueEntry.archive_daily!

    assert waiting.reload.archived?
    assert confirmed.reload.archived?
    assert waiting.waiting?
    assert confirmed.confirmed?
  end

  test "archive_daily! lets the same guest rejoin the venue queue" do
    entry = @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)
    QueueEntry.archive_daily!

    new_entry = @venue.queue_entries.new(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)

    assert new_entry.save
    assert entry.reload.archived?
  end
end
