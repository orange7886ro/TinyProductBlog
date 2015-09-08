class Comment < ActiveRecord::Base
  acts_as_voteable
  belongs_to :post
  belongs_to :user

  def self.vote_up(current_user, id)
    begin
      current_user.vote_for(comment = Comment.find(id))
    rescue ActiveRecord::RecordInvalid
      return false

    end
  end

  def self.vote_down(current_user, id)
    begin
      current_user.vote_against(comment = Comment.find(id))
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

end
