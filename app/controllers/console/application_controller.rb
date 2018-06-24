class Console::ApplicationController < AppController
  before_action :canConsole?
  layout :current_layout
  helper_method :menuTree

  private
    def current_layout
      'console'
    end

    def canConsole?
      # return authenticate_user! unless login?
      html_404 unless has_right_todo?
    end
    # .empty?
    # not shown goto console url
    # force to console will be blocked.
    def menuTree(menu_name=nil, current_user=nil)
      # menusTree()
      # menusTree('Console')
      # menusTree('Console', current_user)
      menus = @Menu_all
      menu_start = { id: nil }
      # menu_class_name = menus.class.to_s.gsub(/::\S+/,'').downcase

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
