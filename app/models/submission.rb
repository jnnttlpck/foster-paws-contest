class Submission < ApplicationRecord
    belongs_to :user
    has_one :order, dependent: :destroy
    has_one_attached :file do |attachable|
        attachable.variant :medium, resize_to_limit: [800, 800]
        attachable.variant :small, resize_to_limit: [300,300]
    end

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :location, presence: true
    validates :pet_name, presence: true, uniqueness: { scope: :user_id }
    validates :file, presence: true
    validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
    validates :rules_and_conditions, acceptance: true
    validate :file_image_format
    enum status: {
        open: 0,
        complete: 1,
        expired: 2
    }

    accepts_nested_attributes_for :order

    delegate :email, to: :user

    private

    def file_image_format
        return unless file.attached?
        return if file.blob.content_type.starts_with?('image/')

        file.purge
        errors.add(:base, 'File must be an image.') and return false
    end
end
