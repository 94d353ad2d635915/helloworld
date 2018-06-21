class Console::NotificationsController < Console::ApplicationController
  def show
    @notifications_type_count = Notification.group(:_type).count
  end

  def destroy
    Notification.where('created_at < ?', 30.day.ago).delete_all
    respond_to do |format|
      format.html { redirect_to console_notifications_url, notice: 'Notifications was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
