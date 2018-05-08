class BanksController < ApplicationController
  def new
  end

  def create
    # Check for a bank token
    if params[:stripeToken] && current_user.tenant && current_user.tenant?
      token = params[:stripeToken]

      customer_id = current_user.stripe_token

      # Create Stripe customer with token
      begin
        # If there's not a customer object for the current user, create one
        if customer_id.nil?
          customer = Stripe::Customer.create(
            source: token,
            description: 'Bank account form example customer'
          )
          current_user.tenant.stripe_token = customer.id
          current_user.tenant.save

        # Replace the existing bank account for the existing customer
        else
          customer = Stripe::Customer.retrieve(customer_id)
          customer.source = token
          customer.save
        end

        # Create a session for the customer and bank account ID
        session[:customer] = customer.id
        session[:bank_account] = customer.sources.data.first.id

        # Redirect to verify microdeposit amounts
        flash[:success] = 'Your bank account has been connected.'
      rescue Stripe::StripeError => e
        # Too many requests made to the API too quickly
        flash[:alert] = e.message
      end
    else
      flash[:alert] = 'Cannot add a bank account at this time. Contact Apex for support.'
    end

    redirect_to request.referrer
  end

end
