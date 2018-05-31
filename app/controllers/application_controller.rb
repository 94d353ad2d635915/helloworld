class ApplicationController < ActionController::Base

  private
    def update_posttext(object, params)
      if params[:body].presence
        if object.posttext.nil?
          posttext = Posttext.new(params)
          posttext.save
          object.posttext = posttext
        else
          object.posttext.update(params)
        end
      else
        unless object.posttext.nil?
          object.posttext.destroy
          object.posttext = nil unless object.frozen?
        end
      end
      return true
    end
end
