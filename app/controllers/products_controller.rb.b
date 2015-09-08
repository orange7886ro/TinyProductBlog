class ProductsController < ApplicationController
  # before_filter :authenticate_user!, except: [:some_action_without_auth]

  def new
    @collection = Collection.find_by(id: params[:collection_id])
    @product = @collection.products.new
  end

  def create
    @collection = Collection.find_by(id: params[:collection_id])
    @product = @collection.products.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      @product.reload
      if CollectionItem.create(collection_id: @collection.id, product_id: @product.id)
        redirect_to collection_products_path(@collection.id)
      else
        render :new
      end
    else
      render :new
    end
  end

  def edit
    @collection = Collection.find_by(id: params[:collection_id])
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])

    if @product.update(product_params)
      redirect_to collection_products_path(params[:collection_id])
    else
      render :edit
    end
  end

  def index
    @collection = Collection.find_by(id: params[:collection_id])
    @products = @collection.products.all
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy

    redirect_to collection_products_path(params[:collection_id])
  end

  private

  def product_params
    params.require(:product).permit(:title)
  end
end
