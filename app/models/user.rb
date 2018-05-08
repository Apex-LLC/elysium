class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_validation :ensure_token

  enum role: [:admin, :owner, :tenant]
  after_initialize :set_default_role, :if => :new_record?

  has_one :tenant_user
  has_one :tenant, through: :tenant_user
  belongs_to :account

  def first_name
    self.name.blank? ? "" : self.name.split(" ")[0]
  end

  def stripe_token
    if (self.tenant? && self.tenant)
      return self.tenant.stripe_token
    else
      return nil
    end
  end

  def payments_verified
    if !stripe_token.nil?
      return self.tenant.payments_verified
    else
      return false
    end
  end

  def set_payments_verified
    byebug
    if !stripe_token.nil?
      self.tenant.payments_verified = true
      self.tenant.save
    end
  end

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
