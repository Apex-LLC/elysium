class Api::V1::SessionSerializer < Api::V1::BaseSerializer
  type :session

  attributes :email, :token, :user_id


  def user
    object
  end

  def user_id
    object.id
  end

  def token
    object.token
  end

  def email
    object.email
  end
end