class Order < ApplicationRecord
  # consider allowing > 1 product for the future just in case?
  belongs_to :product

  enum status: {
    open: 0,
    complete: 1,
    expired: 2
}
end
