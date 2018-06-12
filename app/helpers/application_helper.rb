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

  def getMenuTreeIndex(tree)
    _html = "<ul>"
    tree.each do |menu|
      _html += "<li data-menu-id='#{menu.id}' data-priority='#{menu.priority}'>"
      _html += "<div>"
      _html += check_box_tag ''
      _html += link_to_route(menu.permission, menu.name)
      _html += "<span>"
      _html += link_to 'Show', console_menu_path(menu)
      _html += link_to 'Edit', edit_console_menu_path(menu)
      _html += link_to 'Destroy', console_menu_path(menu), method: :delete, data: { confirm: 'Are you sure?' }
      _html += "</span>"
      _html += "</div>"
      _html += getMenuTreeIndex(menu.children) if menu.children
      _html += "</li>"
    end
    _html += "</ul>"
  end


  # override father class methods
  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options ||= {}
    # html_options = convert_options_to_data_attributes(options, html_options)
    # https://github.com/rails/rails/blob/master/actionpack/test/controller/routing_test.rb
    # @routes =ActionDispatch::Routing::RouteSet.new
    route = Rails.application.routes.recognize_path(url_for(options), html_options.slice(:method)).slice(:controller, :action)
    route[:verb] = html_options.slice(:method).empty? ? 'GET' : 'DELETE'
    # Rails.application.routes.recognize_path
    super if current_layout.presence || canLink?(route.stringify_keys)
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

  def money(credit, currency)
    currency = CURRENCIES[currency.upcase]
    currency ||= {symbol: ''}
    "#{currency[:symbol]}#{number_with_delimiter(credit*0.01)}"
  end

  def money_name(currency)
    CURRENCIES[currency.upcase][:name]
  end
end
