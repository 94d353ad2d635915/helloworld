class AppController < ActionController::Base
  helper_method :login?, :current_layout
  before_action :creat_eventlog

  private
    def route_permission(route=nil)
      if route.nil?
        route = params.permit(:controller, :action).to_h
        route[:verb] = request.request_method
      end
      permission = Permission.all.select{|o| route.eql?( o.slice(:controller, :action, :verb) )}

      # puts "#"*2**7
      # puts route
      # puts permission.size
      # puts "#"*2**7
      
      permission.empty? ? nil : permission.first
    end

    def creat_eventlog(permission=route_permission)
      if permission
        event = Event.find_by(permission_id: permission.id)
        if event
          eventlog = current_user.eventlogs.build
          eventlog.ip = request.remote_ip
          eventlog.user_agent = request.user_agent
          eventlog.event = event
          eventlog.save
          # eventlog.description = event.description
        end
      end
    end

    def current_layout
    end
    
    def is_public?
      can?( Role.find_by(name: 'public') )
    end

    def can?(object=nil,route=nil)
      return false unless object.presence
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
      permission ? object.permissions.ids.uniq.include?(permission.id) : false
    end

    def login?
      current_user.presence
    end

    def html_404
      raise ActionController::RoutingError.new('Not Found') 
    end

    def update_posttext(object, params)
      return false unless object.valid?
      if object.posttext.nil?
        if params[:body].presence
          object.create_posttext(params)
        end
      else
        if params[:body].presence
          object.posttext.update(params)
        else
          object.posttext.destroy
        end
      end
      return true
    end
    
    def update_avatar(object, params)
      return false unless object.valid?
      if params[:url].presence
        if object.avatar.nil?
          object.create_avatar(params)
        else
          object.avatar.update(params)
        end
      else
        object.avatar.destroy unless object.avatar.nil?
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
