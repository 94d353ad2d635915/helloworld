class CreditsController < ApplicationController
  def index
    @credits = current_user.credits
    @creditlogs = current_user.creditlogs.includes(:eventlog, :event)
  end
end
