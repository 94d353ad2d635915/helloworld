class Console::TopicsController < Console::ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all.includes(:user, :posttext)
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comments = @topic.comments.includes(:posttext)
    @comment = @topic.comments.build
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = current_user.topics.build(topic_params)
    update_posttext(@topic, posttext_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to console_topic_path(@topic), notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: console_topic_path(@topic) }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    update_posttext(@topic, posttext_params)
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to console_topic_path(@topic), notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: console_topic_path(@topic) }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to console_topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title)
    end
    def posttext_params
      params.require(:posttext).permit(:body)
    end
end
