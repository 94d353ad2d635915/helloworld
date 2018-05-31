class  Console::NodesController <  Console::ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]
  after_action only: [:create, :update] do 
    update_posttext(@node, posttext_params)
    update_avatar(@node, avatar_params)
  end

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all.includes(:posttext, :node, :avatar, :user)
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = current_user.nodes.build(node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to console_node_path(@node), notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: console_node_path(@node) }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to console_node_path(@node), notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: console_node_path(@node) }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to console_nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:node_id, :name, :slug, :tagline)
    end

    def posttext_params
      params.require(:posttext).permit(:body)
    end

    def avatar_params
      params.require(:avatar).permit(:url)
    end
end
