class Pitch < ApplicationRecord
  validates :mlb_key, presence: true
end
