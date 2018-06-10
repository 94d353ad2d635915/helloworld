module ApplicationHelper
  def getMenuTree(tree)
    _html = "<ul class=tree>"
    tree.each do |menu|
      _html += "<li>"
      _html += link_to_route(menu.permission, "<label>#{menu.name}</label>")
      _html += getMenuTree(menu.children) if menu.children
      _html += "</li>"
    end
    _html += "</ul>"
    _html
  end

  def getMenuTreeIndex(tree, is_child=nil)
    _class = is_child ? 'tree-node' : 'tree-root'
    _html = ""
    tree.each do |menu|
      _class = 'tree-leaf' if menu.permission_id
      _node = "<li class='#{_class}' data-father='#{menu.menu_id}' data-self='#{menu.id}' data-priority='#{menu.priority}'>"
      _node += check_box_tag ''
      _node += link_to_route(menu.permission, menu.name)
      _node += "<span>"
      _node += link_to 'Show', console_menu_path(menu)
      _node += link_to 'Edit', edit_console_menu_path(menu)
      _node += link_to 'Destroy', console_menu_path(menu), method: :delete, data: { confirm: 'Are you sure?' }
      _node += "</span>"
      _node += "</li>"
      _node += getMenuTreeIndex(menu.children, true) if menu.children
      _html += is_child ? _node : "<ul class=treeIndex>#{_node}</ul>"
    end
    is_child ? "<ul class=treeIndex>#{_html}</ul>" : _html
  end


  # override father class methods
  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options ||= {}
    # html_options = convert_options_to_data_attributes(options, html_options)
    # https://github.com/rails/rails/blob/master/actionpack/test/controller/routing_test.rb
    # @routes =ActionDispatch::Routing::RouteSet.new
    route = Rails.application.routes.recognize_path(url_for(options), html_options.slice(:method)).slice(:controller, :action).stringify_keys
    #route[:verb] = html_options.slice(:method).empty? ? 'GET' : 'DELETE'
    # Rails.application.routes.recognize_path
    super if current_layout.presence || canLink?(route)
  end

  def link_to_route(route, name=nil)
    # ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']
    methods = ['GET']
    if route.presence
      name ||= route[:path]
      if methods.include?(route[:verb]) and !route[:path].include?(':') and route[:alias]
        return link_to(raw(name), route[:alias].to_sym, method: route[:verb].to_sym)
      end
    end
    name
  end
end
