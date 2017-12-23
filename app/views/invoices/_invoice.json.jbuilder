json.extract! invoice, :id, :Number, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
