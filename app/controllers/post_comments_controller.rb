class PostCommentsController < ApplicationController
  before_action :find_post
  def index
    flash[:notice] = "this is comment page"
    @comments = @post.comments
  end

  def new
    @comment = @post.comments.new(:user_id => current_user.id)
  end

  def create
    @comment = @post.comments.build( :user_id => current_user.id, :content => params[:comment][:content]) #comment_params )
    if @comment.save
      redirect_to post_comments_path(@post)
    else
      render :action => :new
    end
  end

  def edit
    @comment = @post.comments.find( params[:id] )
  end

  def update
    @comment = @post.comments.find( params[:id] )

    if @comment.update( comment_params )
      redirect_to post_comments_path(@post)
    else
      render :action => :edit
    end

  end

  def destroy
    @comment = @post.comments.find( params[:id] )
    if @comment.nil?
      Rails.logger.debug ("comment is NULL")
    else
      @comment.destroy
    end

    redirect_to post_comments_path(@post)
  end

  def vote_up
    if !Comment.vote_up(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to post_comments_path(@post)
  end

  def vote_down
    if !Comment.vote_down(current_user, params[:id])
      flash[:alert] = "You can only vote once"
    end
    redirect_to post_comments_path(@post)
  end

  protected

  def find_post
    @post = Post.find( params[:post_id] )
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id, :post_id, :created_at, :updated_at)
  end

end
