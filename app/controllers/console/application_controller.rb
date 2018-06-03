class Console::ApplicationController < ApplicationController

  def get_menus(menu_name=nil, current_user=nil)
    # get_menu()
    # get_menu('console')
    # get_menu('console', current_user)
    menus = Menu.all.includes(:menu, :user, :permission)
    if menu_name.presence
      menu_start = menus.select{|o| o.name == menu_name }
      menus = tree_child(menus, menu_start.first)

      if current_user.presence
        permissions = current_user.permissions.ids.uniq 
        menus_member = menus.select{|o| permissions.include?(o.permission_id)}
        menus_group_ids = menus_member.map(&:menu_id).uniq
        menus_group = menus.select{|o| menus_group_ids.include?(o.id)}
        menus = menus_group + menus_member
      end
      menus -= menu_start
    end
    return menus
  end
end
