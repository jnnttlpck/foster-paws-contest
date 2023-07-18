class Submission < ApplicationRecord
    has_one_attached :file do |attachable|
        attachable.variant :medium, resize_to_limit: [800, 800]
    end

    validates :email, presence: true

    enum status: {
        open: 0,
        complete: 1,
        expired: 2
    }
end
