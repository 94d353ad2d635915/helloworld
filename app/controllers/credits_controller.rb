class CreditsController < ApplicationController
  def index
    @credits = current_user.credits.sort_by(&:balance)#.order('created_at DESC')
    @creditlogs = current_user.creditlogs.includes(:eventlog).sort_by(&:created_at).reverse
  end
end
