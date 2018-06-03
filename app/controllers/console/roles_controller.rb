class Console::RolesController < Console::ApplicationController
  before_action :set_role, only: [
    :show, :edit, :update, :destroy, 
    :update_role_permissions, :update_role_users
  ]
  before_action :get_permissions, only: [
    :show,:update_role_permissions
  ]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all.includes(:user, :role)
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
    @roles = Role.all
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    # @role = current_user.roles.build(role_params)
    # belongs_to user 混淆 has_many users
    # 仅能采用以下方式，避免rails内部方法混淆
    # 以后均采用如下方式执行。
    @role = Role.new(role_params)
    @role.user = current_user

    respond_to do |format|
      if @role.save
        format.html { redirect_to console_role_path(@role), notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: console_role_path(@role) }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to console_role_path(@role), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: console_role_path(@role) }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_role_permissions
    # has_and_belongs_to_many
    # ::HABTM ... create many-to-many
    # @role.permission_ids = (params[:role] ? params[:role][:permission_ids] : [])

    #
    # start # just for extra attributes: assignee_id
    #
    # has_many ..., through:
    _update = @permissions.map(&:id) & (params[:role] ? params[:role][:permission_ids] : []).map(&:to_i)
    # _current = @role.permission_ids
    _current = @apr.select{|o| o.role_id == @role.id}.map(&:permission_id)

    # _delete
    _delete = _current - _update
    # AssignPermissionsRole.where({
    #   permission_id: _delete, 
    #   role_id: tree_child_ids(Role.all, @role.id)
    # }).destroy_all#.map(&:destroy)
    role_child_ids = tree_child_ids(@roles, @role.id)
    @apr.each do |o|
      o.destroy if _delete.include?(o.permission_id) && role_child_ids.include?(o.role_id)
    end

    # _create
    _create = _update - _current
    _create.each do |permission_id|
      assign = AssignPermissionsRole.new({assignee_id: current_user.id})
      assign.permission = @permissions.select{|p| p.id.eql?(permission_id)}[0]
      assign.role = @role
      assign.save
    end
    #
    # end # just for extra attributes: assignee_id
    #

    respond_to do |format|
      format.html { redirect_to console_role_path(@role), notice: 'Role Permissions was successfully updated.' }
      format.json { render :show, status: :ok, location: console_role_path(@role) }
    end
  end

  def update_role_users
    # has_and_belongs_to_many
    # ::HABTM ... create many-to-many
    # @role.user_ids = (params[:role] ? params[:role][:user_ids] : [])

    #
    # start # just for extra attributes: assignee_id
    #
    # has_many ..., through:
    users = User.all
    _update = users.ids & (params[:role] ? params[:role][:user_ids] : []).map(&:to_i)
    _current = @role.user_ids

    # _delete
    _delete = _current - _update
    AssignRolesUser.where({
      role_id: @role.id,
      user_id: _delete
    }).destroy_all#.map(&:destroy)

    # _create
    _create = _update - _current
    _create.each do |user_id|
      assign = AssignRolesUser.new({assignee_id: current_user.id})
      assign.user = users.select{|u| u.id.eql?(user_id)}.first
      assign.role = @role
      assign.save
    end
    #
    # end # just for extra attributes: assignee_id
    #

    respond_to do |format|
      format.html { redirect_to console_role_path(@role), notice: 'Role Users was successfully updated.' }
      format.json { render :show, status: :ok, location: console_role_path(@role) }
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to console_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @roles = Role.all
      role_id = params[:id].to_i
      @role = @roles.select{|o| o.id == role_id }.first
      # @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:role_id, :name, :description)
    end

    def get_permissions
      @permissions_all = Permission.all
      @apr = AssignPermissionsRole.all
      if @role.role_id
        # @permissions = @apr.select{|o| o.role_id == @role.role_id}.map(&:permission_id)
        # @permissions = @permissions_all.select{|o| @permissions.include? o.id}
        @permissions = select_many_from_many(@role,@apr,@permissions_all)
      else 
        @permissions = @permissions_all
      end
      # @permissions = @role.role_id ? @role.role.permissions : @permissions_all
    end
end
