class  Console::CreditlogsController <  Console::ApplicationController
  before_action :set_creditlog, only: [:show, :destroy]

  # GET /creditlogs
  # GET /creditlogs.json
  def index
    @creditlogs = Creditlog.all
  end

  # GET /creditlogs/1
  # GET /creditlogs/1.json
  def show
  end

  # DELETE /creditlogs/1
  # DELETE /creditlogs/1.json
  def destroy
    @creditlog.destroy
    respond_to do |format|
      format.html { redirect_to console_creditlogs_url, notice: 'Creditlog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_creditlog
      @creditlog = Creditlog.find(params[:id])
    end
end
