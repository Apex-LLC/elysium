class TenantFeesController < ApplicationController
  before_action :set_tenant_fee, only: [:show, :edit, :update, :destroy]

  # GET /tenant_fees
  # GET /tenant_fees.json
  def index
    @tenant_fees = TenantFee.all
  end

  # GET /tenant_fees/1
  # GET /tenant_fees/1.json
  def show
  end

  # GET /tenant_fees/new
  def new
    @tenant_fee = TenantFee.new
  end

  # GET /tenant_fees/1/edit
  def edit
  end

  # POST /tenant_fees
  # POST /tenant_fees.json
  def create
    @tenant_fee = TenantFee.new(tenant_fee_params)

    noticeText=""
    if (@tenant_fee.save)
      noticeText = "Fee was successfully added."
    end
    redirect_back(fallback_location: root_path,notice: noticeText)
  end

  # PATCH/PUT /tenant_fees/1
  # PATCH/PUT /tenant_fees/1.json
  def update
    respond_to do |format|
      if @tenant_fee.update(tenant_fee_params)
        format.html { redirect_to @tenant_fee, notice: 'Tenant fee was successfully updated.' }
        format.json { render :show, status: :ok, location: @tenant_fee }
      else
        format.html { render :edit }
        format.json { render json: @tenant_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenant_fees/1
  # DELETE /tenant_fees/1.json
  def destroy
    @tenant_fee.destroy
    respond_to do |format|
      format.html { redirect_to tenant_fees_url, notice: 'Tenant fee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant_fee
      @tenant_fee = TenantFee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_fee_params
      params.require(:tenant_fee).permit(:tenant_id, :amount, :description, :recurring, :account_id)
    end
end
