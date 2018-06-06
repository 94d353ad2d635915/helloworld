class ApplicationController < ActionController::Base

  private
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
