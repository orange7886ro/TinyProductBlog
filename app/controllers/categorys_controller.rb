class CategorysController < ApplicationController
  before_action :authenticate_user!

  def index
    flash[:notice] = "hello this is tags page"
    @category = Product.tag_counts_on(:categorys)
  end

  def show
    @category = Product.tag_counts_on(:categorys).find( params[:id] )
    @product = Product.by_category(@category.name)
  end

  def new
    unless permitted(Tag)
      redirect_to tags_path
      return
    end
    @category = Tag.new
  end

  def create
    @category = Tag.new( tag_params )
    unless permitted(@category)
      redirect_to tags_path
      return
    end
    if @category.save
      redirect_to new_tag_tagging_path(@category)
    else
      render :action => :new
    end
  end

  def edit
    @category = Product.tag_counts_on(:categorys).find( params[:id] )
  end

  def update
    @category = Product.tag_counts_on(:categorys).find( params[:id] )
    unless permitted(@category)
      redirect_to tags_path
      return
    end

    if @category.update( tag_params )
      redirect_to tags_path
    else
      render :action => :edit
    end

  end

  def destroy
    @category = Product.tag_counts_on(:categorys).find( params[:id] )
    unless permitted(@category)
      redirect_to tags_path
      return
    end
    if @category.nil?
      Rails.logger.debug ("product is NULL")
    else
      @category.destroy
    end
    redirect_to tags_path
  end

  protected
  def permitted(category)
    unless can? :manage, category
      flash[:alert] = "You need to login as admin user"
      return false
    end
    true
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
