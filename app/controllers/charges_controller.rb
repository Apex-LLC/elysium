class ChargesController < ApplicationController

  def new
  end

  def create

    # Amount in cents
    @amount = params[:amount]
    @invoice = Invoice.find(params[:invoice_id])

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

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
      flash[:error] = e.message
      redirect_to new_charge_path
  end

end
