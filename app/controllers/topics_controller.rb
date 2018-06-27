class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Rails.cache.fetch("Topics") { Topic.all.includes(:user).to_a }
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @node = node_find(@topic.node_id)
    @comments = Rails.cache.fetch("Topics:#{@topic.id}_comments") { @topic.comments.includes(:posttext).to_a }
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
    respond_to do |format|
      if @topic.save
        Rails.cache.delete("Topics")
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      _topic_params = (topic_params).merge({updated_at:Time.now})
      # puts _topic_params
      if @topic.update(_topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :node_id, posttext_attributes: [:body])
    end
end
