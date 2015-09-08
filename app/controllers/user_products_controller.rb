class UserProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def index
    flash[:notice] = "hello this is personal products pages"
    @product = @user.products
  end

  def show
    @product = Product.find( params[:id] )
  end

  def new
    unless permitted(Product)
      redirect_to products_path( @user )
      return
    end
    @product = @user.products.build
  end

  def create
    @product = @user.products.build( product_params )
    unless permitted(@product)
      redirect_to products_path( @user )
      return
    end
    if @product.save && @product.update_category(params[:product][:category_ids])
      redirect_to products_path( @user )
    else
      render :action => :new
    end
  end

  def edit
    @product = Product.find( params[:id] )
  end

  def update
    @product = Product.find( params[:id] )
    unless permitted(@product)
      redirect_to products_path( @user )
      return
    end
    if @product.update( product_params ) && @product.update_category(params[:product][:category_ids])
      redirect_to products_url( @user )
    else
      render :action => :edit
    end

  end

  def destroy
    @product = @user.products.find( params[:id] )
    unless permitted(@product)
      redirect_to products_path( @user )
      return
    end
    if @product.nil?
      Rails.logger.debug ("product is NULL")
    else
      @product.destroy
    end
    redirect_to products_url( @user )
  end

  def vote_up
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to products_path( @user )
      return
    end
    if !Product.vote_up(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to products_path( @user )
  end

  def vote_down
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to products_path( @user )
      return
    end
    if !Product.vote_down(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to products_path( @user )
  end

  protected
  def permitted(product)
    unless can? :manage, product
      flash[:alert] = "You need to login as admin user"
      return false
    end
    true
  end

  def find_user
    @user = current_user
  end

  def product_params
    params.require(:product).permit(:title, :image, :description, :category_list)
  end

end
