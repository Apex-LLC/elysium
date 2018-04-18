class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :phone, :body
  validates :name, :email, :phone, :body, presence: true
end
