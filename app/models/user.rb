class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_validation :ensure_token

  enum role: [:admin, :owner, :tenant]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :account


  private
    def ensure_token
      self.token = generate_hex(:token) unless token.present?
    end

    def generate_hex(column)
      loop do
        hex = SecureRandom.hex
        break hex unless self.class.where(column => hex).any?
      end
    end

    def set_default_role
      self.role ||= :tenant
    end
end
