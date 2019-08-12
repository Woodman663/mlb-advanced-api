class Batter < ApplicationRecord
  validates :mlb_key, presence: true
end
