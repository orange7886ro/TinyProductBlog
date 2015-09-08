#
class Collection < ActiveRecord::Base
  # association
  has_many :collection_items, dependent: :destroy
  has_many :products, through: :collection_items
end
