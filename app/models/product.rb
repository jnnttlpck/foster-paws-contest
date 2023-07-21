class Product < ApplicationRecord
    has_many :prices, dependent: :destroy
end
