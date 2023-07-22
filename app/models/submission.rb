class Submission < ApplicationRecord
    has_one :order
    has_one_attached :file do |attachable|
        attachable.variant :medium, resize_to_limit: [800, 800]
        attachable.variant :small, resize_to_limit: [300,300]
    end

    validates :email, presence: true

    enum status: {
        open: 0,
        complete: 1,
        expired: 2
    }

    accepts_nested_attributes_for :order
end
