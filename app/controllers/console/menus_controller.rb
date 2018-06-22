class Console::MenusController < Console::ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
    @menus = menuTree
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
    @menu_root = menu_find(@menu.menu_id)
    @menu_permission = permission_find(@menu.permission_id)
  end

  # GET /menus/new
  def new
    @menu = Menu.new
    menus_permissions
  end

  # GET /menus/1/edit
  def edit
    menus_permissions
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = current_user.menus.build(menu_params)
    respond_to do |format|
      if @menu.save
        format.html { redirect_to console_menu_path(@menu), notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: console_menu_path(@menu) }
      else
        menus_permissions
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to console_menu_path(@menu), notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: console_menu_path(@menu) }
      else
        menus_permissions
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to console_menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = menu_find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:menu_id, :priority, :name, :permission_id, :description)
    end

    def menus_permissions
      @menus = @menu_all
      role = role_find_by(name: 'menu')
      @permissions = role.permissions
        .where(verb: 'GET')
        .where.not(id: @menus.map(&:permission_id).compact.uniq - [@menu.permission_id])
      @menus = @menus.reject {|menu| menu.permission_id.presence }
    end
end
