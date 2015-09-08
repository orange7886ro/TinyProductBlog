class CollectionItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def destroy
    binding.pry
    @collection = CollectionItem.find_by(id: params[:id])
    unless permitted(@collection)
      redirect_to collections_path
      return
    end
    @collection.destroy

    redirect_to collection_path
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
    params.require(:collection).permit(:title)
  end
end
