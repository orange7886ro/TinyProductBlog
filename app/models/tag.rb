class Tag < ActsAsTaggableOn::Tag
  scope :categorylist, -> { where(name: Product.tag_counts_on(:types).pluck(:name))}
end
