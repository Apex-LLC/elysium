class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])

    render json: user, serializer: Api::V1::UserSerializer
  end

  def meters
    user = User.find(params[:id])

    render json: user, serializer: Api::V1::UserMetersSerializer
  end

end 