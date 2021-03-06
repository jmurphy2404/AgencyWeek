require 'dotenv/load'
require 'sendgrid-ruby'

class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /jobs
  # GET /jobs.json
  def index
    @valets = User.where(user_type: :valet)
    if current_user.client?
      @jobs = Job.where(user_id: current_user.id)
    else
      @jobs = Job.all
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
      @jobs = Job.all
    else

  end

  # GET /jobs/new
  def new
    if current_user.client?
      @job = Job.new
    else
      redirect_to request.referrer, notice: 'You do not have access to this feature. Please sign up as a client.'
    end
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  def create
      @job = Job.new(job_params)
      @job.user = current_user
        if @job.save
          redirect_to jobs_path, notice: 'Job was successfully created.'
        else
          render :new
      end
  end

  # POST /jobs.json
#  def create
#    @job = Job.new(job_params)
#    respond_to do |format|
#      if @job.save
#        format.html { redirect_to @job, notice: 'Job was successfully created.' }
#        format.json { render :show, status: :created, location: @job }
#      else
#        format.html { render :new }
#        format.json { render json: @job.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to jobs_path, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end


#  def assign_valet
#    @job = Job.find(params[:job_id])
#    @valet = User.find params[:valet_id]
#    @job.valet = @valet
#    # @job.valet_id = @valet.id
#
#  end

  def update_status
    @job = Job.find(params[:job_id])
  end

  def job_coords
    @job = Job.find(params[:job_id])
    @job_coords = User.find params[:job_coords_id]

  end

  def notify_user
    email_addr = 'lisamae135b7@me.com'  # TODO: get this from @job
    @job = Job.find(params[:id])
    #email_addr = @job.bike.user.email
    from = SendGrid::Email.new(email: 'blitz@example.com')
    to = SendGrid::Email.new(email: email_addr)
    subject = "[blitz] #{params[:subject]}"
    first_name = @job.bike.user.fullname
    content = SendGrid::Content.new(type: 'text/plain', value: "Hello #{first_name}, thanks for using blitz! #{params[:subject]}.")
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    redirect_to jobs_url, notice: 'Customer was successfully notified.'
  end


  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    if current_user.client?
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully deleted.' }
      format.json { head :no_content }
    end
     else
      redirect_to request.referrer, notice: 'You do not have access to this feature. Please sign up as a client.'
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:origin_lat, :origin_lng, :dest_lat, :dest_lng, :origin, :destination, :date, :time, :bike_id, :valet_id, :status, :user_id)
    end
end
