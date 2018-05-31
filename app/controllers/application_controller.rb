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
end
