#
class CollectionItem < ActiveRecord::Base
  # association
  belongs_to :collection, counter_cache: :products_count
  belongs_to :product, counter_cache: :collections_count

end