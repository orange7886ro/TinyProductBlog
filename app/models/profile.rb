class Profile < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  # association
  has_one :user, dependent: :destroy
end