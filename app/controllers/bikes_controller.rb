class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /bikes
  # GET /bikes.json
  def index
    if current_user.client?
      @bikes = Bike.where(user_id: current_user.id)
    else
      redirect_to request.referrer, notice: 'You do not have access to this feature. Please sign up as a client.'
    end

  end

  # GET /bikes/1
  # GET /bikes/1.json
  def show
  end

  # GET /bikes/new
  def new
    if current_user.client?
      @bike = Bike.new
    else
      redirect_to request.referrer, notice: 'You do not have access to this feature. Please sign up as a client.'
    end

  end

  # GET /bikes/1/edit
  def edit
  end

  # POST /bikes
  def create
    @bike = Bike.new(bike_params)
    @bike.user = current_user
      if @bike.save
        redirect_to bikes_path, notice: 'Bike was successfully created.'
      else
        render :new
      end
  end
  # POST /bikes.json
#  def create
#    @bike = Bike.new(bike_params)
#
#    respond_to do |format|
#      if @bike.save
#        format.html { redirect_to @bike, notice: 'Bike was successfully created.' }
#        format.json { render :show, status: :created, location: @bike }
#      else
#        format.html { render :new }
#        format.json { render json: @bike.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PATCH/PUT /bikes/1
  # PATCH/PUT /bikes/1.json
  def update
    if current_user.client?
    respond_to do |format|
      if @bike.update(bike_params)
        format.html { redirect_to @bike, notice: 'Bike was successfully updated.' }
        format.json { render :show, status: :ok, location: @bike }
      else
        format.html { render :edit }
        format.json { render json: @bike.errors, status: :unprocessable_entity }
      end
    end
    else
      redirect_to request.referrer, notice: 'You do not have access to this feature. Please sign up as a client.'
    end
    
  end

  # DELETE /bikes/1
  # DELETE /bikes/1.json
  def destroy
    @bike.destroy
    respond_to do |format|
      format.html { redirect_to bikes_url, notice: 'Bike was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bike
      @bike = Bike.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bike_params
      params.require(:bike).permit(:make, :model, :color, :image, :user_id)
    end
end
