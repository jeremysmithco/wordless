class Track < ApplicationRecord
  belongs_to :user
  has_many :recordings

  before_create :set_number

  def to_param
    number.to_s
  end

  private

  def set_number
    self.number = SecureRandom.random_number(900_000_000_000) + 100_000_000_000
  end
end
