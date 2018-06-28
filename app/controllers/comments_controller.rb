class CommentsController < ApplicationController
  before_action :set_topic, only: [:create]

  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        Rails.cache.delete("Topics:#{@topic.id}_comments")
        format.html { redirect_to @topic, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { redirect_to @topic, notice: 'Comment was not successfully created.' }
        # @comments = @topic.comments.includes(:posttext)
        # format.html { render 'topics/show'  }
        # format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def comment_params
      params.require(:comment).permit(posttext_attributes: [:body])
    end
end
