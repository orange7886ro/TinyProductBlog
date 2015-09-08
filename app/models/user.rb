class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :products, dependent: :destroy
  has_many :comments
  has_many :collections, dependent: :destroy
  has_one  :profile, dependent: :destroy
  belongs_to :role, counter_cache: :users_count
  acts_as_voter
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # callback
  before_save :defaults
  after_save  :create_profile

  def defaults
    # RegisteredUser
    if self.role_id == 0
      self.role_id = Role.find_by(name: 'RegisteredUser').id
    end
  end

  def create_profile
    Profile.create(name: self.email, user_id: self.id)
  end

  def role?(check_role)
    return false if role.nil?
    return role.name == check_role.to_s.camelize
  end
end
