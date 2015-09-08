class CategoryTaggingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category

  def index
    flash[:notice] = "at least add one product to the tag"
    @tagging = @tag.taggings
    @product = Product.by_category(@tag.name)
    @product = [] if @product.nil?
  end

  def show
    @product = Product.by_category(@tag.name).find( @tagging.taggable_id )
    @product = [] if @product.nil?
  end

  def new
    flash[:notice] = "at least add one product to the tag"
    unless permitted(Tagging)
      redirect_to tags_path
      return
    end
    @tagging = @tag.taggings.build
  end

  def create
    flash[:notice] = "at least add one product to the tag"
    params = tagging_params
    params[:taggable_type] = "Product"
    params[:context] = "categorys"
    @tagging = @tag.taggings.build( params )
    unless permitted(@tagging)
      redirect_to tags_path
      return
    end
    if @tagging.save
      redirect_to tags_path
    else
      render :action => :new
    end
  end

  # def edit
  #   @tagging = @tag.taggings.find( params[:id] )
  # end

  # def update
  #   @tagging = @tag.taggings.find( params[:id] )

  #   if @tagging.update( tagging_params )
  #     redirect_to category_taggings_path( @tag )
  #   else
  #     render :action => :edit
  #   end

  # end

  def destroy
    @tagging = @tag.taggings.find( params[:id] )
    unless permitted(@tagging)
      redirect_to tags_path
      return
    end
    if @tagging.nil?
      Rails.logger.debug ("tagging is NULL")
    else
      @tagging.destroy
    end
    redirect_to tag_taggings_path( @tag )
  end

  protected
  def permitted(tagging)
    unless can? :manage, tagging
      flash[:alert] = "You need to login as admin user"
      return false
    end
    true
  end

  def find_category
    @tag = Tag.find( params[:tag_id] )
  end

  def tagging_params
    params.require(:acts_as_taggable_on_tagging).permit(:taggable_id, :taggable_type, :context)
  end
end
