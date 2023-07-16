class Submission < ApplicationRecord
    validates :email, presence: true
end
