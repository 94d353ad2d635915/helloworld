class CreditsController < ApplicationController
  def index
    @credits = current_user.credits.order('created_at DESC')
    @creditlogs = current_user.creditlogs.includes(:eventlog, :event).order('created_at DESC')
  end
end
