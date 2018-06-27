class ApplicationController < AppController
  before_action :cancan?
  helper_method :canLink?

  private
    def cancan?
      # can? 默认是否为公开权限
      # 若不是，则登录
      return true if has_right_todo? or is_public?
      return authenticate_user! unless login?
      html_404
    end

    def canLink?(route)
      if login?
        return true if root?
        return true if can?(@user_permissions, route)
      else
        return true if can?(@public_permissions, route)
      end
      false
    end
end
