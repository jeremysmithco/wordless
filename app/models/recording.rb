class Recording < ApplicationRecord
  belongs_to :track
  belongs_to :user

  has_one_attached :file

  validates :duration, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 60000 }
end
