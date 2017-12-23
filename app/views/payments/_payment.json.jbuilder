json.extract! payment, :id, :date, :amount, :tenant_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
