class Console::ApplicationController < ApplicationController
  before_action :login?
  layout 'console'
  helper_method :menuTree

  private
    def login?
      raise ActionController::RoutingError.new('Not Found') if current_user.nil?
      # http://101.70.102.199/console/permissions
    end

    # .empty?
    # not shown goto console url
    # force to console will be blocked.
    def menuTree(menu_name=nil, current_user=nil)
      # menusTree()
      # menusTree('Console')
      # menusTree('Console', current_user)
      menus = Menu.all.includes(:menu, :user, :permission)
      menu_start = { id: nil }
      menu_class_name = menus.class.to_s.gsub(/::\S+/,'').downcase

      if menu_name.presence
        # menu_start = menus.select{|o| o.name == menu_name }.first#array[menu]
        menu_start = menus.select{|o| o.name == menu_name }.first
        menus = tree_child(menus, menu_start)

        if current_user.presence && current_user.id != 1
          permissions = current_user.permissions.ids.uniq 
          menus_member = menus.select{|o| permissions.include?(o.permission_id)}
          menus_group_ids = menus_member.map(&:menu_id).uniq
          menus_group = menus.select{|o| menus_group_ids.include?(o.id)}
          menus = menus_group + menus_member
        end

        menus.delete(menu_start)
      end
      menus_root = menus.select{|o| o.menu_id.eql? menu_start[:id] }
      menus = endlessTree(menus.to_a.group_by(&:menu_id), menus_root)
      menus
    end

    def endlessTree(tree, root_nodes)
      root_nodes.sort_by(&:priority).each do |node|
        node[:children] = endlessTree(tree, tree[node.id]) if tree[node.id]
      end
    end
end
