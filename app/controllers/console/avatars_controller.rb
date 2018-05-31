class Console::AvatarsController < Console::ApplicationController
  before_action :set_avatar, only: [:destroy]

  def index
    @avatars = Avatar.all
  end

  def destroy
    @avatar.destroy
    respond_to do |format|
      format.html { redirect_to console_avatars_path, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_avatar
      @avatar = Avatar.find(params[:id])
    end
end
