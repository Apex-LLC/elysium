module AccountsHelper

  def stripe_connect_link
    stripe_url = "https://connect.stripe.com/express/oauth/authorize"
    client_id = ENV["STRIPE_CONNECT_CLIENT_ID"]

    "#{stripe_url}?client_id=#{client_id}"
  end

end
