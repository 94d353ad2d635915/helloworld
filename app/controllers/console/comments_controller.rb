class Console::CommentsController < Console::ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :destroy_from_topic]
  before_action :set_topic, only: [:create_from_topic, :destroy_from_topic]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/1/edit
  def edit
  end

  def create_from_topic
    posttext = Posttext.new(posttext_params)
    posttext.save
    @comment = @topic.comments.build
    @comment.user = current_user
    @comment.posttext = posttext

    respond_to do |format|
      if @comment.save
        format.html { redirect_to console_topic_path(@topic), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: console_topic_path(@topic) }
      else
        @comments = @topic.comments.includes(:posttext)
        format.html { render 'console/topics/show'  }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.posttext.update(posttext_params)
        format.html { redirect_to console_comment_path(@comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: console_comment_path(@comment) }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to console_comments_path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_from_topic
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to console_topic_path(@topic), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def posttext_params
      params.require(:posttext).permit(:body)
    end
end
