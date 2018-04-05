class AdminCostsController < ApplicationController
  before_action :set_admin_cost, only: [:show, :edit, :update, :destroy]

  # GET /admin_costs
  # GET /admin_costs.json
  def index
    @admin_costs = AdminCost.all
  end

  # GET /admin_costs/1
  # GET /admin_costs/1.json
  def show
  end

  # GET /admin_costs/new
  def new
    @admin_cost = AdminCost.new
  end

  # GET /admin_costs/1/edit
  def edit
  end

  # POST /admin_costs
  # POST /admin_costs.json
  def create
    amount = params[:admin_cost][:amount]
    label = params[:admin_cost][:label]
    description = params[:admin_cost][:description]
    account_id = params[:admin_cost][:account_id]
    percent = nil
    flat_fee = nil

    if (amount)
      if (amount.include?("%"))
        percent = amount.delete('$ , %')
      else
        flat_fee = amount.delete('$ , %')
      end
    end

    @admin_cost = AdminCost.new(label: label, percent: percent, flat_fee: flat_fee, description: description, account_id: account_id)

    noticeText=""
    if (@admin_cost.save)
      noticeText = @admin_cost.label + " was successfully added."
    else
      noticeText = @admin_cost.errors
    end
    redirect_back(fallback_location: root_path,notice: noticeText)
  end

  # PATCH/PUT /admin_costs/1
  # PATCH/PUT /admin_costs/1.json
  def update
    respond_to do |format|
      if @admin_cost.update(admin_cost_params)
        format.html { redirect_to @admin_cost, notice: 'Admin cost was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_cost }
      else
        format.html { render :edit }
        format.json { render json: @admin_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_costs/1
  # DELETE /admin_costs/1.json
  def destroy
    noticeText = @admin_cost.label + " was successfully removed."
    @admin_cost.destroy
    redirect_back(fallback_location: root_path,notice: noticeText)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_cost
      @admin_cost = AdminCost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_cost_params
      params.require(:admin_cost).permit(:label, :description, :percent, :flat_fee, :account_id)
    end
end
