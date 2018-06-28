class  Console::CreditsController <  Console::ApplicationController
  before_action :set_credit, only: [:show, :charge, :update, :destroy]

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.all.includes(:user)
  end

  # GET /credits/1
  # GET /credits/1.json
  def new
    @credit = Credit.new
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/1/edit
  def charge
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = current_user.credits.build(credit_params)

    respond_to do |format|
      if @credit.save
        format.html { redirect_to console_credit_path(@credit), notice: 'Credit was successfully created.' }
        format.json { render :show, status: :created, location:console_credit_path(@credit) }
      else
        format.html { render :new }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    credit_params.each{ |k,v| @credit.increment(k,v.to_i) }
    respond_to do |format|
      if @credit.save
        format.html { redirect_to console_credit_path(@credit), notice: 'Credit was successfully updated.' }
        format.json { render :show, status: :ok, location: console_credit_path(@credit) }
      else
        format.html { render :charge }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    currencies = CURRENCIES.keys
    @credit.attributes.each{|k,v| @credit[k] = 0 if currencies.include? k }
    @credit.save
    # @credit.destroy
    respond_to do |format|
      format.html { redirect_to console_credits_url, notice: 'Credit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit
      @credit = Credit.find_by(user_id: params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:POINT, :CNY, :BTC, :USD)
    end
end
