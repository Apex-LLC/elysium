class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :update_billing_day, :update_days_until_invoice_due]
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if current_user.tenant?
      redirect_to current_user
    else
      @account = current_user.account
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    @user = current_user
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    set_account_defaults

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_billing_day

    noticeText = ""
    billing_day = params[:billing_cycle_start_day]

    if (@account && billing_day != nil)
      @account.billing_cycle_start_day = billing_day
      @account.save
      noticeText = "The first day of your billing cycle is now set to the " + billing_day.to_i.ordinalize + " of the month."
    else
      noticeText = "There was a problem updating your billing cycle start date. Contact Apex for support"
    end
    redirect_back(fallback_location: root_path, notice: noticeText)
  end

  def update_days_until_invoice_due
    noticeText = ""
    days_until_due = params[:days_until_invoice_due]

    if (@account && days_until_due != nil)
      @account.days_until_invoice_due = days_until_due
      @account.save
      noticeText = "Your invoices will be due " + days_until_due + " days after they are sent."
    else
      noticeText = "There was a problem updating your invoice due date. Contact Apex for support"
    end
    redirect_back(fallback_location: root_path,notice: noticeText)
  end

  def stripe_callback
    options = {
      site: 'https://connect.stripe.com',
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/token'
    }
    code = params[:code]
    client = OAuth2::Client.new(ENV['STRIPE_CONNECT_CLIENT_ID'], ENV['STRIPE_SECRET_KEY'], options)
    @resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    @access_token = @resp.token
    @account.update!(stripe_account_id: @resp.params["stripe_user_id"]) if @resp

    flash[:notice] = "Your account has been successfully created and is ready to process payments!"

    redirect_to edit_account_path
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      if (current_user)
        @account = current_user.account
      else
        redirect_to new_user_session_path
      end
    end

    def set_account_defaults
      if (@account.billing_cycle_start_day == nil)
        @account.billing_cycle_start_day = 1
      end
      
      if (@account.days_until_invoice_due == nil)
        @account.days_until_invoice_due = 20
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.fetch(:account, {})
    end
end
