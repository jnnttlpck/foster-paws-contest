class Order < ApplicationRecord
  belongs_to :submission, optional: true
  has_many :line_items, dependent: :destroy

  enum status: {
    open: 0,
    complete: 1,
    expired: 2
}

accepts_nested_attributes_for :line_items, reject_if: proc { |attrs| attrs[:quantity].blank? }
end
