class CategoryProductsController < ApplicationController
  # load_and_authorize_resource
  skip_authorize_resource only: :read
  before_action :authenticate_user!
  before_action :find_category
  before_action :find_user

  def index
    flash[:notice] = "hello this is tagged #{@tag.name} products pages"
    @product = Product.by_category(@tag.name)
    @product = [] if @product.nil?
  end

  def show
    @product = Product.by_category(@tag.name).find( params[:id] )
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
      redirect_to tag_products_path( @tag )
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
      redirect_to tag_products_path( @tag )
    else
      render :action => :edit
    end

  end

  def destroy
    @product = Product.find( params[:id] )
    unless permitted(@product)
      redirect_to products_path( @user )
      return
    end
    if @product.nil?
      Rails.logger.debug ("product is NULL")
    else
      @product.destroy
    end
    redirect_to tag_products_path( @tag )
  end

  def vote_up
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to tag_products_path( @tag )
    end
    if !Product.vote_up(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to tag_products_path( @tag )
  end

  def vote_down
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to tag_products_path( @tag )
    end
    if !Product.vote_down(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to tag_products_path( @tag )
  end

  def add_to_collection
    if current_user.nil?
      flash[:alert] = "You need to login first"
      redirect_to tag_products_path( @tag )
    end
    binding.pry
    Product.add_to_collection(params[:collection_id], params[:id])
    redirect_to tag_products_path( @tag )
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

  def find_category
    @tag = Tag.find( params[:tag_id] )
  end

  def product_params
    params.require(:product).permit(:title, :image, :description, :category_list)
  end

end
