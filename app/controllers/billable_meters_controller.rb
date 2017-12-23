class BillableMetersController < ApplicationController
  before_action :set_billable_meter, only: [:show, :edit, :update, :destroy]

  # GET /billable_meters
  # GET /billable_meters.json
  def index
    @billable_meters = BillableMeter.all
  end

  # GET /billable_meters/1
  # GET /billable_meters/1.json
  def show
  end

  # GET /billable_meters/new
  def new
    @billable_meter = BillableMeter.new
    @tenant = params[:tenant]
    respond_to do |format|
      format.js
    end
  end

  # GET /billable_meters/1/edit
  def edit
  end

  # POST /billable_meters
  # POST /billable_meters.json
  def create
    @billable_meter = BillableMeter.new(billable_meter_params)

    respond_to do |format|
      if @billable_meter.save
        format.html { redirect_to @billable_meter.tenant, notice: 'Your meter was associated with ' + @billable_meter.tenant.name + '.' }
        format.json { render :show, status: :created, location: @billable_meter }
      else
        format.js { render :new, notice: @billable_meter.errors }
        format.html { render :new }
        format.json { render json: @billable_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billable_meters/1
  # PATCH/PUT /billable_meters/1.json
  def update
    respond_to do |format|
      if @billable_meter.update(billable_meter_params)
        format.html { redirect_to @billable_meter, notice: 'Billable meter was successfully updated.' }
        format.json { render :show, status: :ok, location: @billable_meter }
      else
        format.html { render :edit }
        format.json { render json: @billable_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billable_meters/1
  # DELETE /billable_meters/1.json
  def destroy
    @billable_meter.destroy
    respond_to do |format|
      format.html { redirect_to @billable_meter.tenant, notice: 'The meter was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billable_meter
      @billable_meter = BillableMeter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billable_meter_params
      params.require(:billable_meter).permit(:meter_id, :description, :percent_allocation, :start_time, :end_time, :tenant_id)
    end
end
