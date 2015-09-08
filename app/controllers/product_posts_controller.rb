class ProductPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product

  def index
    flash[:notice] = "this is posts pages"
    @posts = @product.posts
  end

  def show
    @post = @product.posts.find( params[:id] )
  end

  def new
    @post = @product.posts.build
  end

  def create
    @post = @product.posts.build( post_params )
    if @post.save
      redirect_to product_posts_url( @product )
    else
      render :action => :new
    end
  end

  def edit
    @post = @product.posts.find( params[:id] )
  end

  def update
    @post = @product.posts.find( params[:id] )

    if @post.update( post_params )
      redirect_to product_posts_url( @product )
    else
      render :action => :edit
    end

  end

  def destroy
    @post = @product.posts.find( params[:id] )
    if @post.nil?
      Rails.logger.debug ("Post is NULL")
    else
      @post.destroy
    end

    redirect_to product_posts_url( @product )
  end

  def vote_up
    if !Post.vote_up(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to product_posts_url( @product )
  end

  def vote_down
    if !Post.vote_down(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to product_posts_url( @product )
  end

  protected

  def find_product
    @product = Product.find( params[:product_id] )
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :vote_count, :created_at, :updated_at)
  end
end
