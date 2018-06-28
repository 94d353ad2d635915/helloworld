class AppController < ActionController::Base
  before_action :global_init_all_cache
  after_action :creat_eventlog

  helper_method :login?, :current_layout
  
  helper_method :node_find,  :node_find_by
  helper_method :event_find, :event_find_by
  helper_method :permission_find, :permission_find_by
  helper_method :role_find, :role_find_by
  helper_method :menu_find, :menu_find_by

  private
    def has_right_todo?
      @current_permission = nil
      @current_event = nil
      @current_credits = nil
      return nil unless login?

      @current_permission = root? ? route_permission : can?(@user_permissions)
      @current_event = @current_permission ? event_find_by(permission_id: @current_permission.id) : nil
      if !root? and @current_event and @current_event.currency and @current_event.amount != 0
        @current_credits = current_user.credit

        # unless user_credit
        #   user_credit = current_user.credits.build(currency: event.currency, balance: 0)
        # end
        if !@current_credits or ( @current_credits.send(@current_event.currency.upcase) + @current_event.amount ) < 0
          notice = "
            该操作需要消耗：#{@current_event.amount} #{@current_event.currency}，
            你没有足够的“#{@current_event.currency}”，请充值后进行该项操作。"
          respond_to do |format|
            # :back
            # fallback_location: root_path
            # session[:return_to] ||= request.referer
            # redirect_to session.delete(:return_to)
            # request.env['HTTP_REFERER']
            format.html { redirect_to request.referer, notice: notice }
          end
        end
      end
      @current_permission
    end

    # return permission or nil
    def can?(permissions=nil,route=nil)
      return false unless permissions.presence
      # can?
      # can?(current_user.permissions)
      # can?(role_public.permissions)
      # can?(role_user.permissions)
      #object = login? ? current_user : Role.find_by(name: 'public'))

      # if route.nil?
      #   route = params.permit(:controller, :action).to_h
      #   route[:verb] = request.request_method
      # end
      # permission = object.permissions.uniq.select{|o| route.eql?( o.slice(:controller, :action, :verb) )}
      permission = route_permission(route)
      if permission and permissions.map(&:id).uniq.include?(permission.id)
        return permission
      else
        return nil
      end
    end

    def route_permission(route=nil)
      if route.nil?
        route = params.permit(:controller, :action).to_h
        route[:verb] = request.request_method
      end
      permission = @Permission_all.select{|o| route.eql?( o.slice(:controller, :action, :verb) )}

      # puts "#"*2**7
      # puts route
      # puts permission.size
      # puts "#"*2**7

      permission.empty? ? nil : permission.first
    end

    def creat_eventlog
      # puts response.to_a
      if @current_event
        object = eval("@#{@current_permission[:controller].gsub(/s$/,'')}")
        return if object.id.nil?

        eventlog             = current_user.eventlogs.build
        eventlog.ip          = request.remote_ip
        eventlog.user_agent  = request.user_agent
        eventlog.event       = @current_event
        eventlog.description = object.id
        eventlog.save

        creat_creditlog( @current_event, eventlog ) unless root?
      end
    end

    def creat_creditlog(event,eventlog=nil)
      if @current_credits
        currency = @current_event.currency.upcase
        @current_credits[currency.to_sym] += event.amount

        receiver = User.find(1)
        receiver_credit = receiver.credit
        receiver_credit[currency.to_sym] -= event.amount
        @current_credits.save
        receiver_credit.save

        creditlog = current_user.creditlogs.build
        creditlog.eventlog = eventlog
        creditlog.currency = event.currency
        creditlog.amount = event.amount
        creditlog.balance = @current_credits.send(currency)
        creditlog.receiver_id = receiver.id
        creditlog.receiver_balance = receiver_credit.send(currency)
        creditlog.save
      end
    end

    def current_layout
    end
    
    def is_public?
      can?( @public_permissions )
    end

    def login?
      !current_user.nil?
    end

    def root?
      current_user.id == 1
    end

    def html_404
      raise ActionController::RoutingError.new('Not Found') 
    end

    def global_init_all_cache
      # @@
      @Node_all ||= _caches(Node, 'all')

      # Rails.cache.delete "articles"
      @Role_all    ||= _caches(Role, 'all')
      @user_role    ||= role_find_by(name: 'user')
      @public_role  ||= role_find_by(name: 'public')

      @Permission_all    ||= _caches(Permission, 'all')
      @user_permissions   ||= _caches(@user_role, "permissions")
      @public_permissions ||= _caches(@public_role, "permissions")
      # @@assign_permissions_roles = 
      # @@assign_roles_users =
      @Menu_all  ||= _caches(Menu, 'all')
      @Event_all ||= _caches(Event, 'all')
    end

    # 
    # cache reslult is a array, not ActiveRecord_Relation
    # 
    # below is [x] not supported: 
    # 
    # => Topic.all.includes(:user)
    # => Node.all.includes(:user)
    # => @node_all.includes(:user)
    # 
    # supported: 
    # 
    # object : user
    # association : topics, get topics by user_id
    # example: 
    # => user.topics          object_associations(user, 'topics')   cache_key: user_<id>_topics
    # => User.all             object_associations(User, 'all')      cache_key: User_all
    def fetch_object_associations(object, associations)
      if object.class.to_s == 'Class'
        cache_key = "#{object.to_s}_#{associations}"
      else 
        cache_key = "#{object.class.name}_#{object.id}_#{associations}"
      end
      Rails.cache.fetch(cache_key) { object.send(associations).to_a }
    end
    alias _caches fetch_object_associations

    def object_find_by_uniq(class_name, *options)
      options = options.extract_options!
      return nil if options.empty? or options.values.join.empty?
      cache_key = "#{class_name}_#{options.flatten.join}"
      # puts cache_key
      Rails.cache.fetch(cache_key) do
        collection = self.instance_variable_get("@#{class_name}_all")
        collection.select do |o|
          result = true
          options.each {|k,v| result = false if o.send(k).to_s != v.to_s}
          result
        end.first
      end
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
      object_find_by_uniq('Node', *options)
    end

    def permission_find(permission_id)
      permission_find_by(id: permission_id)
    end

    def permission_find_by(*options)
      object_find_by_uniq('Permission', *options)
    end

    def role_find(role_id)
      role_find_by(id: role_id)
    end

    def role_find_by(*options)
      object_find_by_uniq('Role', *options)
    end

    def menu_find(menu_id)
      menu_find_by(id: menu_id)
    end

    def menu_find_by(*options)
      object_find_by_uniq('Menu', *options)
    end

    def event_find(event_id)
      event_find_by(id: event_id)
    end

    def event_find_by(*options)
      object_find_by_uniq('Event', *options)
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
      object_class_name = objects.first.class.name.downcase
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
      object_class_name = objects.first.class.name.downcase
      _tree_ids = objects.select{ |object| tree_ids.include?( object.id ) }.map(&("#{object_class_name}_id").to_sym)
      _tree_ids = tree_parent_ids(objects, _tree_ids) unless _tree_ids.empty?
      (tree_ids + _tree_ids).uniq
    end

    def select_many_from_many(which_object, many_to_many_objects, target_objects)
      # @permissions = @apr.select{|o| o.role_id == @role.role_id}.map(&:permission_id)
      # @permissions = @permissions_all.select{|o| @permissions.include? o.id}
      which_id = "#{which_object.class.name.downcase}_id"
      target_id = "#{target_objects.first.class.name.downcase}_id"

      _ids = many_to_many_objects.select do |o|
        o.send(which_id) == which_object.send(which_id)
      end.map(&target_id.to_sym)

      target_objects.select{|o| _ids.include? o.id}
    end
end
