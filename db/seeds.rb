# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if Rails.env.development?
  puts "Cleaning development database..."

  QueueEntry.destroy_all
  TableType.destroy_all
  Venue.destroy_all
  User.destroy_all

  puts "Development database cleaned"
else
  puts "Existing production data will not be deleted"
end
puts "Creating team users..."
team_users_data = [
  {
    first_name: "Yasmine",
    last_name: "Mouahidi",
    email: "yasminemouahidi@gmail.com",
    phone_number: "+33652948943"
  },
  {
    first_name: "Yassir",
    last_name: "Khalid",
    email: "y@ssir.net",
    phone_number: "+33630178045"
  },
  {
    first_name: "Nicolas",
    last_name: "beladen",
    email: "nicolas@beladen.fr",
    phone_number: "+33624248706"
  },
  {
    first_name: "Youssef",
    last_name: "Guizour",
    email: "youssef.guizour@hqueue.test",
    phone_number: "+33652948943"
  }
]

team_users = team_users_data.map do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])

  user.assign_attributes(
    attributes.merge(
      password: "password123",
      password_confirmation: "password123",
      is_manager: true,
      terms_opt_in: true,
      marketing_opt_in: true
    )
  )

  user.save!
  user
end

puts "✅ #{team_users.count} team users created"

puts "Creating fake users..."
first_names = %w[
  Emma Lucas Léa Hugo Chloé Louis Inès Gabriel
  Manon Arthur Jade Adam Camille Jules Sarah Nathan
  Zoé Tom Lina Raphaël
]

last_names = %w[
  Martin Bernard Thomas Robert Richard Petit Durand Dubois
  Moreau Laurent Simon Michel Lefebvre Leroy Roux David
  Bertrand Morel Fournier Girard
]
team_phone_numbers = team_users.map(&:phone_number)

fake_users = 20.times.map do |index|
  email = "demo.user#{index + 1}@hqueue.test"
  user = User.find_or_initialize_by(email: email)

  user.assign_attributes(
    first_name: first_names[index],
    last_name: last_names[index],
    phone_number: team_phone_numbers[index % team_phone_numbers.length],
    password: "password123",
    password_confirmation: "password123",
    is_manager: false,
    terms_opt_in: true,
    marketing_opt_in: true
  )

  user.save!
  user
end

puts "✅ #{fake_users.count} fake users created"
# VENUES
  puts "Creating venues..."

venues_data = [
  {
    name: "Le Bistrot d'Yves",
    address: "33 Rue Cardinet, 75017 Paris",
    description: "Bistrot parisien proposant une cuisine française traditionnelle revisitée, à partir de produits frais et de saison.",
    venue_type: "French",
    opening_hours: "Monday-Friday: 12:00-14:00 / 19:30-22:00",
    photo_url: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
    avg_wait_minutes: 25,
    latitude: 48.8846,
    longitude: 2.3107
  },
  {
    name: "Nonno Nino",
    address: "10 Rue Brémontier, 75017 Paris",
    description: "Restaurant italien chaleureux proposant des pâtes maison et une cuisine méditerranéenne inspirée des Pouilles.",
    venue_type: "Italian",
    opening_hours: "Monday-Saturday: 12:00-14:30 / 19:30-23:00",
    photo_url: "https://images.unsplash.com/photo-1579684947550-22e945225d9a",
    avg_wait_minutes: 30,
    latitude: 48.8868,
    longitude: 2.3037
  },
  {
    name: "Phébé",
    address: "190 Rue de Courcelles, 75017 Paris",
    description: "Bistrot de quartier à l'ambiance élégante servant une cuisine française traditionnelle et généreuse.",
    venue_type: "French",
    opening_hours: "Monday-Friday: 12:00-14:00 / 19:00-22:00",
    photo_url: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
    avg_wait_minutes: 20,
    latitude: 48.8874,
    longitude: 2.2987
  },
  {
    name: "Le Potager de Charlotte",
    address: "21 Rue Rennequin, 75017 Paris",
    description: "Restaurant végétal et gourmand proposant une cuisine faite maison, de saison et centrée sur les légumes.",
    venue_type: "Vegan",
    opening_hours: "Monday-Sunday: lunch and dinner service",
    photo_url: "https://images.unsplash.com/photo-1547592180-85f173990554",
    avg_wait_minutes: 35,
    latitude: 48.8819,
    longitude: 2.2966
  },
  {
    name: "Rooster",
    address: "137 Rue Cardinet, 75017 Paris",
    description: "Restaurant contemporain proposant une cuisine française créative dans un décor moderne et convivial.",
    venue_type: "Contemporary French",
    opening_hours: "Monday-Friday: 12:00-14:00 / 19:30-22:00",
    photo_url: "https://images.unsplash.com/photo-1552566626-52f8b828add9",
    avg_wait_minutes: 30,
    latitude: 48.8868,
    longitude: 2.3144
  },
  {
    name: "Bistrot Flaubert",
    address: "10 Rue Gustave Flaubert, 75017 Paris",
    description: "Bistrot gastronomique à l'esprit parisien proposant des assiettes modernes inspirées du terroir français.",
    venue_type: "French Bistro",
    opening_hours: "Tuesday-Saturday: lunch and dinner service",
    photo_url: "https://images.unsplash.com/photo-1559339352-11d035aa65de",
    avg_wait_minutes: 25,
    latitude: 48.8805,
    longitude: 2.2995
  },
  {
    name: "Le Truffaut",
    address: "89 Rue Truffaut, 75017 Paris",
    description: "Bistrot de quartier apprécié pour sa cuisine française de saison et son atmosphère chaleureuse.",
    venue_type: "French Bistro",
    opening_hours: "Monday-Friday: lunch and dinner service",
    photo_url: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0",
    avg_wait_minutes: 20,
    latitude: 48.8874,
    longitude: 2.3181
  },
  {
    name: "Buzkashi",
    address: "7 Rue des Dames, 75017 Paris",
    description: "Restaurant afghan proposant des plats parfumés, des grillades et des spécialités traditionnelles à partager.",
    venue_type: "Afghan",
    opening_hours: "Tuesday-Sunday: 12:00-14:30 / 19:00-23:00",
    photo_url: "https://images.unsplash.com/photo-1569058242253-92a9c755a0ec",
    avg_wait_minutes: 15,
    latitude: 48.8833,
    longitude: 2.3265
  },
  {
    name: "Un Air de Famille",
    address: "118 Rue des Dames, 75017 Paris",
    description: "Restaurant français convivial à l'esprit brocante, proposant une cuisine familiale et généreuse.",
    venue_type: "French",
    opening_hours: "Monday-Saturday: 12:00-14:30 / 19:00-23:00",
    photo_url: "https://images.unsplash.com/photo-1590846406792-0adc7f938f1d",
    avg_wait_minutes: 20,
    latitude: 48.8843,
    longitude: 2.3173
  },
  {
    name: "Le Cyrano",
    address: "3 Rue Biot, 75017 Paris",
    description: "Adresse emblématique des Batignolles mêlant cuisine de bistrot, assiettes à partager et ambiance animée.",
    venue_type: "French Bistro",
    opening_hours: "Tuesday-Saturday: lunch and dinner service",
    photo_url: "https://images.unsplash.com/photo-1578474846511-04ba529f0b88",
    avg_wait_minutes: 30,
    latitude: 48.8834,
    longitude: 2.3273
  }
]

venues = venues_data.map do |attributes|
  venue = Venue.find_or_initialize_by(name: attributes[:name])
  venue.assign_attributes(attributes)
  venue.save!

  puts "   ↳ Created #{venue.name}"
  venue
end

puts "✅ #{venues.count} venues created"
# DEMO QUEUE


puts "⏳ Creating demo queues..."

demo_venue = venues.first

demo_users = fake_users.first(5)

QueueEntry.create!(
  user: demo_users[0],
  venue: demo_venue,
  party_size: 2,
  status: :waiting,
  created_at: 35.minutes.ago
)

QueueEntry.create!(
  user: demo_users[1],
  venue: demo_venue,
  party_size: 2,
  status: :waiting,
  created_at: 20.minutes.ago
)

QueueEntry.create!(
  user: demo_users[2],
  venue: demo_venue,
  party_size: 4,
  status: :notified,
  notified_at: 5.minutes.ago,
  created_at: 30.minutes.ago
)

QueueEntry.create!(
  user: demo_users[3],
  venue: demo_venue,
  party_size: 2,
  status: :confirmed,
  created_at: 50.minutes.ago
)

QueueEntry.create!(
  user: demo_users[4],
  venue: demo_venue,
  party_size: 3,
  status: :confirmed,
  created_at: 45.minutes.ago
)

puts "✅ Demo venue queue created"
puts "⏳ Creating queues for other venues..."

other_venues = venues.drop(1)

other_venues.each_with_index do |venue, venue_index|
  selected_users = fake_users.rotate(venue_index * 2).first(6)

  selected_users.each_with_index do |user, user_index|
    status =
      case user_index
      when 0..2
        :waiting
      when 3
        :notified
      else
        :confirmed
      end

    QueueEntry.create!(
      user: user,
      venue: venue,
      party_size: [2, 2, 3, 4, 2, 3][user_index],
      status: status,
      notified_at: status == :notified ? 5.minutes.ago : nil,
      created_at: (60 - user_index * 7).minutes.ago
    )
  end

  puts "   ↳ Queue created for #{venue.name}"
end

puts "✅ Queues created for all venues"
#récap final
puts
puts "🎉 H-Queue seed completed!"
puts "--------------------------------"
puts "Users: #{User.count}"
puts "Managers: #{User.where(is_manager: true).count}"
puts "Venues: #{Venue.count}"
puts "Queue entries: #{QueueEntry.count}"
puts "Waiting: #{QueueEntry.waiting.count}"
puts "Notified: #{QueueEntry.notified.count}"
puts "Confirmed: #{QueueEntry.confirmed.count}"
puts "--------------------------------"
