class TenantsController < ApplicationController
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only, except: [:show, :edit, :update]

  # GET /tenants
  # GET /tenants.json
  def index
    @tenants = current_user.tenants
  end

  # GET /tenants/1
  # GET /tenants/1.json
  def show
    if (current_user.tenant?)
      @tenant = Tenant.find_by(email: current_user.email)
      if (@tenant == nil)
        @tenant=Tenant.first
        params[:notice]="No user could be found with that email."
      end
    end
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
    respond_to do |format|
      format.js
    end
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants
  # POST /tenants.json
  def create
    @tenant = current_user.tenants.build(tenant_params)
    respond_to do |format|
      if @tenant.save
        format.html { redirect_to @tenant, notice: @tenant.name + ' was successfully created.' }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.js { render :new, notice: @tenant.errors }
        format.html { render :new }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenants/1
  # PATCH/PUT /tenants/1.json
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @tenant, notice: 'Tenant was successfully updated.' }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenants/1
  # DELETE /tenants/1.json
  def destroy
    name = @tenant.name
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to tenants_url, notice: name + ' was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:name, :email, :phone, :logo)
    end

    def admin_only
    unless current_user.admin? || current_user.owner?
      redirect_to root_path, :notice => "Access denied."
    end
  end
end
