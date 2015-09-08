class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_voteable
  belongs_to :product
  has_many :comments, dependent: :destroy

  def self.vote_up(current_user, id)
    begin
      current_user.vote_for(post = Post.find(id))
    rescue ActiveRecord::RecordInvalid
      return false

    end
  end

  def self.vote_down(current_user, id)
    begin
      current_user.vote_against(post = Post.find(id))
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

end
