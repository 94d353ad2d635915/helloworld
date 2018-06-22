class Console::EventlogsController < Console::ApplicationController
  before_action :set_eventlog, only: [:show, :destroy]

  # GET /eventlogs
  # GET /eventlogs.json
  def index
    @eventlogs = Eventlog.all.includes(:user).sort_by(&:created_at).reverse#.order(created_at: :DESC)
  end

  # GET /eventlogs/1
  # GET /eventlogs/1.json
  def show
  end

  # DELETE /eventlogs/1
  # DELETE /eventlogs/1.json
  def destroy
    @eventlog.destroy
    respond_to do |format|
      format.html { redirect_to console_eventlogs_path, notice: 'Eventlog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eventlog
      @eventlog = Eventlog.find(params[:id])
    end
end
