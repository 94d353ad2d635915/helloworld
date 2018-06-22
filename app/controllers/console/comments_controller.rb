class Console::CommentsController < Console::ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :destroy_from_topic]
  before_action :set_topic, only: [:create_from_topic, :destroy_from_topic]
  after_action only: [:update, :create_from_topic] do 
    update_posttext(@comment, posttext_params)
  end

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all.includes(:user, :posttext)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/1/edit
  def edit
  end
  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      format.html { redirect_to console_comment_path(@comment), notice: 'Comment was successfully updated.' }
      format.json { render :show, status: :ok, location: console_comment_path(@comment) }
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

  def create_from_topic
    @comment = @topic.comments.build
    @comment.user = current_user
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
