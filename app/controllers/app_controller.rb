class AppController < ActionController::Base
  before_action :global_init_all_cache
  after_action :creat_eventlog

  helper_method :login?, :current_layout
  
  helper_method :node_find,  :node_find_by
  helper_method :event_find, :event_find_by
  helper_method :permission_find, :permission_find_by
  helper_method :role_find, :role_find_by
  helper_method :menu_find, :menu_find_by

  def global_init_all_cache
    # @@
    @node_all ||= Node.all

    @role_all    ||= Role.all
    @user_role    ||= role_find_by(name: 'user')
    @public_role  ||= role_find_by(name: 'public')

    @permission_all    ||= Permission.all
    @user_permissions   ||= (@user_role.presence ? @user_role.permissions : [])
    @public_permissions ||= (@public_role.presence ? @public_role.permissions : [])
    # @@assign_permissions_roles = 
    # @@assign_roles_users =
    @menu_all  ||= Menu.all
    @event_all ||= Event.all
  end

  private
    def object_find_by_uniq(class_name, *options)
      options = options.extract_options!
      return nil if options.empty?
      collection = self.instance_variable_get("@#{class_name}_all")
      collection.select do |o|
        result = true
        options.each {|k,v| result = false if o.send(k).to_s != v.to_s }
        result
      end.first
    end

    # Role.find_by(name: 'user')
    # @role_all.select{|o| o.id == role_id.to_i}.first
    # @role_all.select{|o| o.name == role_name}.first
    # @role_all.includes(:user)
    # node/permission/role/menu/event
    def node_find(node_id)
      node_find_by(id: node_id)
    end

    def node_find_by(*options)
      object_find_by_uniq('node', *options)
    end

    def permission_find(permission_id)
      permission_find_by(id: permission_id)
    end

    def permission_find_by(*options)
      object_find_by_uniq('permission', *options)
    end

    def role_find(role_id)
      role_find_by(id: role_id)
    end

    def role_find_by(*options)
      object_find_by_uniq('role', *options)
    end

    def menu_find(menu_id)
      menu_find_by(id: menu_id)
    end

    def menu_find_by(*options)
      object_find_by_uniq('menu', *options)
    end

    def event_find(event_id)
      event_find_by(id: event_id)
    end

    def event_find_by(*options)
      object_find_by_uniq('event', *options)
    end

    def route_permission(route=nil)
      if route.nil?
        route = params.permit(:controller, :action).to_h
        route[:verb] = request.request_method
      end
      permission = @permission_all.select{|o| route.eql?( o.slice(:controller, :action, :verb) )}

      # puts "#"*2**7
      # puts route
      # puts permission.size
      # puts "#"*2**7

      permission.empty? ? nil : permission.first
    end

    def creat_eventlog(permission=route_permission)
      if login? and permission
        event = event_find_by(permission_id: permission.id)#permission.event
        # puts response.to_a
        if event
          object = eval("@#{permission[:controller].gsub(/s$/,'')}")
          return if object.id.nil?
          eventlog = current_user.eventlogs.build
          eventlog.ip = request.remote_ip
          eventlog.user_agent = request.user_agent
          eventlog.event = event
          eventlog.description = object.id
          eventlog.save
          creat_creditlog(event,eventlog)
        end
      end
    end

    def creat_creditlog(event,eventlog=nil)
      if login? and eventlog and event.currency and event.amount != 0
        user_credit = current_user.credits.select{|o| o.currency == event.currency }.first
        unless user_credit
          user_credit = current_user.credits.build(currency: event.currency, balance: 0)
        end
        if !user_credit.valid? or (user_credit.balance += event.amount) < 0
          # respond_to do |format|
            notice = "该操作需要消耗：#{event.amount} #{event.currency}，你没有足够的“#{event.currency}”，请充值后进行该项操作。"
            # format.html { redirect_to root_path, notice: notice }
          # end
          return
        end
        user_credit.save

        creditlog = current_user.creditlogs.build
        creditlog.eventlog = eventlog
        creditlog.currency = event.currency
        creditlog.amount = event.amount
        creditlog.balance = user_credit.balance
        creditlog.save
      end
    end

    def current_layout
    end
    
    def is_public?
      can?( @public_permissions )
    end

    def can?(permissions=nil,route=nil)
      return false unless permissions.presence
      # can?
      # can?(current_user)
      # can?(role_public)
      # can?(role_user)
      #object = login? ? current_user : Role.find_by(name: 'public'))

      # if route.nil?
      #   route = params.permit(:controller, :action).to_h
      #   route[:verb] = request.request_method
      # end
      # permission = object.permissions.uniq.select{|o| route.eql?( o.slice(:controller, :action, :verb) )}
      permission = route_permission(route)
      permission ? permissions.ids.uniq.include?(permission.id) : false
    end

    def login?
      !current_user.nil?
    end

    def html_404
      raise ActionController::RoutingError.new('Not Found') 
    end

    def update_posttext(object, params)
      update_nested_attributes(object, 'posttext', params)
    end

    def update_nested_attributes(object, nested, params)
      return false unless object.valid?
      nested = object.send(nested)
      params.select!{ |k,v| !v.blank? }
      if nested.nil?
        object.create_posttext(params) unless params.empty?
      else
        params.empty? ? nested.destroy : nested.update(params)
      end
      return true
    end

    def tree_child_ids(objects=nil, tree_ids=[])
      tree_ids = [tree_ids] if tree_ids.class != Array
      object_class_name = objects.class.to_s.gsub(/::\S+/,'').downcase
      _tree_ids = objects.select{ |object| tree_ids.include?( object.send("#{object_class_name}_id") ) }.map(&:id)
      _tree_ids = tree_child_ids(objects, _tree_ids) unless _tree_ids.empty?
      tree_ids + _tree_ids
    end

    def tree_child(tree, node)
      tree.select{|o| tree_child_ids(tree, node.id).include?( o.id ) }
    end

    def tree_parent(tree, node)
      tree.select{|o| tree_parent_ids(tree, node.id).include?( o.id ) }
    end

    def tree_parent_ids(objects=nil, tree_ids=[])
      tree_ids = [tree_ids] if tree_ids.class != Array
      object_class_name = objects.class.to_s.gsub(/::\S+/,'').downcase
      _tree_ids = objects.select{ |object| tree_ids.include?( object.id ) }.map(&("#{object_class_name}_id").to_sym)
      _tree_ids = tree_parent_ids(objects, _tree_ids) unless _tree_ids.empty?
      (tree_ids + _tree_ids).uniq
    end

    def select_many_from_many(which_object, many_to_many_objects, target_objects)
      # @permissions = @apr.select{|o| o.role_id == @role.role_id}.map(&:permission_id)
      # @permissions = @permissions_all.select{|o| @permissions.include? o.id}
      which_id = "#{which_object.class.name.downcase}_id"
      target_id = "#{target_objects.class.to_s.gsub(/::\S+/,'').downcase}_id"

      _ids = many_to_many_objects.select do |o|
        o.send(which_id) == which_object.send(which_id)
      end.map(&target_id.to_sym)

      target_objects.select{|o| _ids.include? o.id}
    end
end
