class UserCollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def new
    @collection = Collection.new
  end

  def show
    @collection = Collection.find_by(id: params[:id])
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user_id = @user.id
    unless permitted(@collection)
      redirect_to collections_path
      return
    end
    if @collection.save
      redirect_to collections_path
    else
      render :new
    end
  end

  def edit
    @collection = Collection.find_by(id: params[:id])
  end

  def update
    @collection = Collection.find_by(id: params[:id])
    unless permitted(@collection)
      redirect_to collections_path
      return
    end
    if @collection.update(collection_params)
      redirect_to collections_path
    else
      render :edit
    end
  end

  def index
    @collection = Collection.where(user_id: @user)
  end

  def destroy
    @collection = Collection.find_by(id: params[:id])
    unless permitted(@collection)
      redirect_to collections_path
      return
    end
    @collection.destroy

    redirect_to collections_path
  end

  private

  def permitted(collection)
    unless can? :manage, collection
      flash[:alert] = "You need to login"
      return false
    end
    true
  end

  def find_user
    @user = current_user
  end

  def collection_params
    params.require(:collection).permit(:title, :user_id)
  end
end
