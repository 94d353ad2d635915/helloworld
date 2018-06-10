class ApplicationController < AppController
  before_action :canUser?
  helper_method :canLink?
  private
    def cancan?
      # can? 默认是否为公开权限
      # 若不是，则登录
      return true if is_public?
      authenticate_user! unless login?
      return true if current_user.id == 1
      return true if can?(Role.find_by(name: 'user'))
      false
    end

    def canUser?
      html_404 unless cancan?
    end

    def canLink?(route)
      return true if can?( Role.find_by(name: 'public'), route)
      return false unless login?
      return true if current_user.id == 1
      return true if can?(Role.find_by(name: 'user'), route)
      false
    end
end
