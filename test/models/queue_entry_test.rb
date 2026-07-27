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

  test "expires an entry waiting for more than a day and lets the same guest rejoin" do
    stale_entry = @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2,
                                               status: :waiting)
    stale_entry.update_column(:created_at, 2.days.ago)

    new_entry = @venue.queue_entries.new(name: "Marcel", phone_number: "+33612345678", party_size: 2, status: :waiting)

    assert new_entry.save
    assert stale_entry.reload.cancelled?
  end

  test "does not expire a cancelled or confirmed entry older than a day" do
    confirmed_entry = @venue.queue_entries.create!(name: "Marcel", phone_number: "+33612345678", party_size: 2,
                                                   status: :confirmed)
    confirmed_entry.update_column(:created_at, 2.days.ago)

    other = @venue.queue_entries.new(name: "Alice", phone_number: "+33698765432", party_size: 2, status: :waiting)
    other.save!

    assert confirmed_entry.reload.confirmed?
  end
end
