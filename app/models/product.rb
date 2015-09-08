class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_voteable
  acts_as_taggable_on :categorys
  # association
  belongs_to :user, counter_cache: true
  has_many :collection_items, dependent: :destroy
  has_many :collections, through: :collection_items
  has_many :posts, dependent: :destroy

  # scope
  scope :latest_order, -> { order(:updated_at) }

  after_destroy :destroy_category

  # Class Method
  def self.vote_up(current_user, id)
    begin
      current_user.vote_for(product = Product.find(id))
    rescue ActiveRecord::RecordInvalid
      return false

    end
  end

  def self.vote_down(current_user, id)
    begin
      current_user.vote_against(product = Product.find(id))
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

  def self.add_to_collection(collection_id, product_id)
    begin
      CollectionItem.create(collection_id: collection_id, product_id: product_id)
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

  def self.by_category(category)
    tagged_with(category, on: :categorys, any: true).latest_order
  end

  def self.category_list
    tag_counts_on(:categorys)
  end

  # Instance Method
  def update_category(category_ids)
    destroy_category
    category_ids.each do |cid|
      next unless Tag.exists?(cid)
      add_to_category(Tag.find(cid).name)
    end
  end

  def destroy_category
    category_list.each{ |c| remove_from_category(c) }
  end

  def add_to_category(category)
    category_list.add(category)
    save
    reload
  end

  def remove_from_category(category)
    category_list.remove(category)
    save
    reload
  end
end