class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :update, :destroy]
  after_action only: [:update] do 
    update_posttext(@profile, posttext_params)
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to settings_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: settings_path }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to settings_path, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      # @profile = Profile.find(params[:id])
      @profile = current_user.profile
      @profile ||= current_user.build_profile
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:user_id, :location, :company, :tagline, :avatar)
    end

    def posttext_params
      params.require(:posttext).permit(:body)
    end
end
