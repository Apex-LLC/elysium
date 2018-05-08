class MicrodepositsController < ApplicationController

  def create
    # Check for a customer ID and bank account ID -- needed to validate account
    # You could also retrieve this from a session or database
    if params[:customer] && params[:bank_account]
      customer = params[:customer]
      bank_account = params[:bank_account]

      # Check for valid amount submissions, strip decimals and dollar signs
      if params[:amount1] && params[:amount2]
        amount1 = params[:amount1].tr('.$', '')
        amount2 = params[:amount2].tr('.$', '')

        # Verify the amounts
        begin
          customer = Stripe::Customer.retrieve(customer)
          bank_account = customer.sources.retrieve(bank_account)
          bank_account.verify(amounts: [amount1, amount2])

          current_user.set_payments_verified

          # Direct the customer to pay
          flash[:notice] = 'Your bank account has been connected.'

        rescue Stripe::StripeError => e
          # Too many requests made to the API too quickly
          flash[:notice] = e.message
        end
      else
        flash[:notice] = 'Invalid deposit amounts entered'
      end
    else
      flash[:notice] = 'No bank account or customer provided. Add a bank account to make a payment.'
    end
    redirect_to request.referrer, notice: flash[:notice]
  end
end