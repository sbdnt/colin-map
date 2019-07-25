class ClaimedsController < ApplicationController
  before_action :set_claimed, only: [:show, :edit, :update, :destroy]
  skip_before_filter  :verify_authenticity_token
  # GET /claimeds
  # GET /claimeds.json
  def index
    @claimeds = Claimed.all
  end

  # GET /claimeds/1
  # GET /claimeds/1.json
  def show
  end

  # GET /claimeds/new
  def new
    @claimed = Claimed.new
  end

  # GET /claimeds/1/edit
  def edit
  end

  # POST /claimeds
  # POST /claimeds.json
  def create
    if params[:claim_house].present?
      if user_signed_in?
        if current_user.claimeds.count == 0
          flag_claimed = false
          Claimed.all.each do |claimed|
            if claimed.latitude == params[:latitude].to_f &&  claimed.longitude == params[:longitude].to_f
              flag_claimed = true
              break
            end
          end
          if flag_claimed == true
            arr = [1, "This house claimed !"]
            return render :text => arr.to_json
          else     
            claim = Claimed.create(
              :user_id => current_user.id,
              :latitude => params[:latitude].to_f,
              :longitude => params[:longitude].to_f
            )
            arr = [0, "Created successfully !"]
            return render :text => arr.to_json
          end
        else
          arr = [2, "You registered house, can't claim more !"]
          return render :text => arr.to_json
        end
      end
    elsif params[:find_neighbors].present?
      items = []
      claim = current_user.claimeds.first
      latitude = claim.try(:latitude)
      longitude = claim.try(:longitude)
      address = claim.try(:address)
      items << [address, latitude, longitude]
      neighbors = Claimed.near([latitude,longitude], 3, :units => :km)
      if neighbors.present?
        neighbors.each do |item|
          email = item.try(:user).try(:email)
          if item.latitude != latitude && item.longitude != longitude
            items << [item.address, item.latitude, item.longitude, email]
          end
        end
      end
      return render :text => items.uniq.to_json
    elsif params[:find_claimed].present?
      items = []
      latitude = params[:latitude]
      longitude = params[:longitude]
      neighbors = Claimed.near([latitude,longitude], 3, :units => :km)
      if neighbors.present?
        neighbors.each do |item|
          email = item.try(:user).try(:email)
          if item.latitude != latitude && item.longitude != longitude
            items << [item.address, item.latitude, item.longitude, email]
          end
        end
      end
      return render :text => items.uniq.to_json
    end
    
    # @claimed = Claimed.new(claimed_params)

    # respond_to do |format|
    #   if @claimed.save
    #     format.html { redirect_to @claimed, notice: 'Claimed was successfully created.' }
    #     format.json { render :show, status: :created, location: @claimed }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @claimed.errors, status: :unprocessable_entity }
    #   end
    # end
    render :nothing => true
  end

  # PATCH/PUT /claimeds/1
  # PATCH/PUT /claimeds/1.json
  def update
    respond_to do |format|
      if @claimed.update(claimed_params)
        format.html { redirect_to @claimed, notice: 'Claimed was successfully updated.' }
        format.json { render :show, status: :ok, location: @claimed }
      else
        format.html { render :edit }
        format.json { render json: @claimed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claimeds/1
  # DELETE /claimeds/1.json
  def destroy
    @claimed.destroy
    respond_to do |format|
      format.html { redirect_to claimeds_url, notice: 'Claimed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claimed
      @claimed = Claimed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def claimed_params
      params.require(:claimed).permit(:user_id, :longitude, :latitude, :address, :claim_house, :find_neighbors, :find_claimed)
    end
end
