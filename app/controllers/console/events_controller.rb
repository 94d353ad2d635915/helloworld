class Console::EventsController < Console::ApplicationController
  before_action :set_event, only: [:update]

  # GET /events
  # GET /events.json
  def index
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to console_events_path, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: console_events_path }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to console_events_path, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: console_events_path }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to console_events_path, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      _event_params = event_params
      permission = Permission.find(_event_params[:permission_id])
      @event = permission.event
      @event ||= permission.build_event(event_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:permission_id, :description, :currency, :amount)
    end
end
