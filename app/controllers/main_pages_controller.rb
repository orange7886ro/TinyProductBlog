class MainPagesController < ApplicationController

  def index
    flash[:notice] = "this is main products page"
#TODO: need to pass the proper items to main pages by this action, EX top10 products
    @products = Product.all
    @user = current_user
  end

  def vote_up
    if current_user.nil?
      flash[:alert] = "You need to login first"
    elsif !Product.vote_up(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to main_pages_path
  end

  def vote_down
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to main_pages_path
    elsif !Product.vote_down(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to main_pages_path
  end

end
