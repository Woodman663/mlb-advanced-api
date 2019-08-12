class Pitcher < ApplicationRecord
  validates :mlb_key, presence: true
end
