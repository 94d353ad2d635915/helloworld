class Console::PermissionsController < Console::ApplicationController
  def index
    permissions_params = params.permit(:rails, :all, :raw)
    if params.include? :raw
      @permissions = raw 
      return
    end

    # create if @permissions.empty?
    # .empty / .size  one more sql
    # Permission Exists (0.3ms)  SELECT  1 AS one FROM "permissions" LIMIT ?  [["LIMIT", 1]]
    @permissions = @permission_all.sort_by(&:priority)#.order(priority: :ASC)
    init if @permissions.length < 1

    permissions_controllers_default = ['rails/info', 'rails/mailers', nil, 'rails/welcome']

    if permissions_params.empty?
      #@permissions.reject! { |permission| !permissions_controllers_default.include?(permission[:controller]) }
      @permissions = Permission.where.not(controller: permissions_controllers_default).order(priority: :ASC)
    elsif params.include? :rails
      #@permissions.reject! { |permission| permissions_controllers_default.include?(permission[:controller]) }
      @permissions = Permission.where(controller: permissions_controllers_default).order(priority: :ASC)
    elsif params.include? :all
      @permissions ||= @permission_all.sort_by(&:priority)
    end
  end

  # 系统id，要变换，不适合系统维护，适合系统初始化
  def reset
    respond_to do |format|
      if clear && init
        format.html { redirect_to console_permissions_path, notice: 'Permissions was successfully reseted.' }
      else
        format.html { redirect_to console_permissions_path, notice: 'Reseted Permissions was failed.' }
      end
    end
  end

  def update
    permission_params = params.require(:permission).permit(:id) if !params.permit(:permission).empty?
    if !permission_params.presence
      updates
    end
  end

  private
    # 适合系统：初始化，维护，增量更新
    def updates
      i = 0
      permissions_db = {}
      @permissions = Permission.all
      @permissions.each do |permission|
        result = {
          { # 3点唯一
            verb: permission[:verb], 
            controller: permission[:controller],
            action: permission[:action], # 变化后更改
            alias: permission[:alias], # 变化后更改
            path: permission[:path], 
          } => {
            priority: permission[:priority],
            name: permission[:name],
          }
        }
        permissions_db.merge! result
      end
      #permissions_update = (routes_map.keys - permissions_db.keys)#dup

      permissions_update = 0
      permissions_create = 0
      permissions_delete = 0
      permissions_db_keys = permissions_db.keys

      routes_map.each do |route, priority|
        if permissions_db_keys.dup.include? route
          # if route is not exsit.
          if routes_map[route] != permissions_db[route]
            # priority is not same
            Permission.where(route).update(priority)
            # @permissions.select do |permission|
            #   result = {
            #     verb: permission[:verb], 
            #     controller: permission[:controller],
            #     action: permission[:action], # 变化后更改
            #     alias: permission[:alias], # 变化后更改
            #     path: permission[:path], 
            #   }
            #   puts result 
            #   puts route
            #   puts priority
            #   puts result.eql?(route)
            #   return false
            # end#.first.update(priority)

            permissions_update +=1
          end
          permissions_db_keys.delete(route)
        else
          Permission.create(route.merge! priority)
          permissions_create +=1
        end
      end
      permissions_db_keys.each do |route|
        Permission.find_by(route).destroy
        # @permissions.select do |permission|
        #   result = {
        #     verb: permission[:verb], 
        #     controller: permission[:controller],
        #     action: permission[:action], # 变化后更改
        #     alias: permission[:alias], # 变化后更改
        #     path: permission[:path], 
        #   }
        #   puts result.eql?(route)
        #   return result.eql?(route)
        # end.first.destroy

        permissions_delete +=1
      end
      puts notice = "
        #{permissions_update} permissions have been updated.
        #{permissions_create} permissions have been created.
        #{permissions_delete} permissions have been deleted.
      "
      respond_to do |format|
        if permissions_update == 0 && permissions_create == 0 && permissions_delete == 0
          format.html { redirect_to console_permissions_path, notice: 'No permission needs change.' }
        else
          format.html { 
            redirect_to console_permissions_path, 
            notice: notice
          }
        end
      end
    end

    def clear
      Permission.all.destroy_all
    end

    def init
      @permission_all = nil
      routes_map.each do |route, priority| 
        Permission.create(route.merge! priority) 
      end
    end

    # raw
    def raw
      routes_map.map { |route, priority| route.merge! priority }
    end

    def routes_map
      routes_controllers_default = ['rails/info', 'rails/mailers', nil, 'rails/welcome']

      i = 0
      routes_map = {}
      # Rails.application.routes.recognize_path '/permissions'
      Rails.application.routes.routes.each do |route|
        # app, name, path.spec.to_s, verb, default
        if route.name.presence
          route.name.gsub!( '_path', '') 
          # route.name << '_path'
        end
        result = {
           { 
            verb: route.verb, 
            controller: route.defaults[:controller],
            action: route.defaults[:action], 
            alias: route.name, 
            path: route.path.spec.to_s.gsub('(.:format)', ''), 
          } => { 
            priority: i+=1,
            name: "#{route.defaults[:controller]}_#{route.defaults[:action]}(#{route.verb}:#{route.name})",
          }
        }
        routes_map.merge! result
      end
      routes_map
    end
end

