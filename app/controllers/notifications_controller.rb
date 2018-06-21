class NotificationsController < ApplicationController
  before_action :set_notification, only: [:destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = current_user.notifications.includes(:user, :sender, :notifiable, :second_notifiable, :third_notifiable)
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:user_id, :sender_id, :_type)
    end
end
