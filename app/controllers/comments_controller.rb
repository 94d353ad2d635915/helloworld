class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :set_topic, only: [:create, :destroy]

  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @topic, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        @comments = @topic.comments.includes(:posttext)
        format.html { render 'topics/show'  }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @topic, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def comment_params
      params.require(:comment).permit(posttext_attributes: [:body])
    end
end
