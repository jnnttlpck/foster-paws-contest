class Order < ApplicationRecord
  belongs_to :user
  belongs_to :submission, optional: true
  has_many :line_items, dependent: :destroy

  validates_presence_of :line_1, :city, :state, :zip, if: :ship?
  validates_presence_of :delivery_option, :name

  enum status: {
    open: 0,
    complete: 1,
    expired: 2
  }

  enum delivery_option: {
    ship: 0,
    pickup_laurens_rd: 1,
    pickup_taylors: 2,
    pickup_spartanburg: 3
  }


  accepts_nested_attributes_for :line_items, reject_if: proc { |attrs| attrs[:quantity].blank? }

end
