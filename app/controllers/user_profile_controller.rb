class UserProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def index
    flash[:notice] = "hello this is personal profile pages"
    @profile = Profile.find_by(user_id: @user.id)
  end

  def show
    @profile = Profile.find_by(user_id: @user.id)
  end

  def edit
    @profile = Profile.find_by(user_id: @user.id)
  end

  def update
    @profile = Profile.find_by(user_id: @user.id)
    unless permitted(@profile)
      redirect_to profile_path( @user )
      return
    end
    if @profile.update( profile_params )
      redirect_to profile_path( @user )
    else
      render :action => :edit
    end

  end

  protected
  def permitted(profile)
    unless can? :manage, profile
      flash[:alert] = "You need to login"
      return false
    end
    true
  end

  def find_user
    @user = current_user
  end

  def profile_params
    params.require(:profile).permit(:name, :image)
  end

end