class BillableMetersController < ApplicationController
  before_action :set_billable_meter, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /billable_meters
  # GET /billable_meters.json
  def index
    site_ids=Site.where(user_id: current_user.id).select(:id)
    site_ids=[1,2,3]
    @billable_meters = BillableMeter.joins(:meter).where(meters: { site_id:site_ids })
    respond_to do |format|
      format.json { render :json => @products }
      format.html { render :index }
    end
  end

  # GET /billable_meters/1
  # GET /billable_meters/1.json
  def show
  end

  # def test
  #   @billable_meter = BillableMeter.last
  #   usage = @billable_meter.get_usage(DateTime.now-11, DateTime.now)
  #   puts usage
  # end

  # GET /billable_meters/new
  def new
    @billable_meter = BillableMeter.new
    @tenant = get_tenant_from_params
    if (@tenant)
      respond_to do |format|
        format.js
      end
    end
  end

  # GET /billable_meters/1/edit
  def edit
  end

  # POST /billable_meters
  # POST /billable_meters.json
  def create
    if associating_with_tenant
      update
      return
    end

    @billable_meter = BillableMeter.new(billable_meter_params)

    if @billable_meter.save
      @billable_meter = BillableMeter.new
      flash[:notice] =  'Your meter was successfully created.'
    else
      flash[:notice] = 'Unable to save your meter'
    end
    render :configure
  end

  # PATCH/PUT /billable_meters/1
  # PATCH/PUT /billable_meters/1.json
  def update
    if (associating_with_tenant)
      @billable_meter = BillableMeter.find(billable_meter_params[:meter_id])
      @billable_meter.tenant = Tenant.find(billable_meter_params[:tenant_id])
      @billable_meter.is_peak_demand_meter = billable_meter_params[:is_peak_demand_meter]
      @billable_meter.percent_allocation = billable_meter_params[:percent_allocation]

      respond_to do |format|
        if @billable_meter.save
          format.html { redirect_to @billable_meter.tenant, notice: 'Your meter was associated with ' + @billable_meter.tenant.name + '.' }
        else
          @tenant=@billable_meter.tenant
          format.js { render :new, notice: @billable_meter.errors }
          format.html { render :new }
          format.json { render json: @billable_meter.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @billable_meter.update(billable_meter_params)
          format.html { redirect_to @billable_meter.tenant, notice: 'Your meter was associated with ' + @billable_meter.tenant.name + '.' }
          format.json { head :no_content }
        else
          format.js { render :new, notice: @billable_meter.errors }
          format.html { render :new }
          format.json { render json: @billable_meter.errors, status: :unprocessable_entity }
        end
      end   
    end # end of billable meter if
  end

  # DELETE /billable_meters/1
  # DELETE /billable_meters/1.json
  def destroy
    @billable_meter.destroy
    respond_to do |format|
      if (@billable_meter.tenant)
        format.html { redirect_to @billable_meter.tenant, notice: 'The meter was successfully removed.' }
        format.json { head :no_content }
      else
        flash[:notice] = 'The meter was successfully removed.'
        format.html { render :configure }
      end
    end
  end

  def configure
    @billable_meter = @billable_meter ? @billable_meter : BillableMeter.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billable_meter
      @billable_meter = BillableMeter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billable_meter_params
      params.require(:billable_meter).permit(:meter_id, :description, :percent_allocation, :start_time, :end_time, :tenant_id, :rate_id, :account_id, :is_peak_demand_meter)
    end

    def get_tenant_from_params
      return Tenant.find(params[:tenant])
    end

    def associating_with_tenant
      return !billable_meter_params[:tenant_id].blank? && !billable_meter_params[:meter_id].blank?
    end
end
