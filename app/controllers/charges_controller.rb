class ChargesController < ApplicationController

  def new
  end

  def create

    # Amount in cents
    @amount = params[:amount]
    @invoice = Invoice.find(params[:invoice_id])

    customer_id = @invoice.tenant.stripe_token
    customer = Stripe::Customer.retrieve(customer_id)

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    @invoice.set_paid

    float_amount = @amount.to_f / 100.0
    payment = 
    Payment.new(date: DateTime.now, amount: float_amount, email: params[:stripeEmail], tenant: @invoice.tenant, invoice: @invoice)
    payment.save
    
    redirect_back(fallback_location: root_path,notice: "Thank your for your payment!")

    rescue Stripe::CardError => e
      flash[:notice] = e.message
      redirect_to root_path
  end

end
