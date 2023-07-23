class LineItem < ApplicationRecord
  belongs_to :price
  belongs_to :order

  validates :quantity, presence: true
end
