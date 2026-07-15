class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :queue_entries, dependent: :destroy

  validates :terms_opt_in, acceptance: true
  validates :first_name, :last_name, presence: true
end
