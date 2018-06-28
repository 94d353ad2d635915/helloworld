class CreditsController < ApplicationController
  def index
    @credit = current_user.credit#.sort_by(&:balance)#.order('created_at DESC')
    @creditlogs = Creditlog.where(["user_id = ? or receiver_id = ?", current_user.id, current_user.id ]).includes(:eventlog).sort_by(&:created_at).reverse
  end
end
