class Api::V1::BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!, except: :options
  
  def authenticate_user!
    token, _ = ActionController::HttpAuthentication::Token.token_and_options(
      request
    )

    user = User.find_by(token: token)

    if user
      @current_user = user
    else
      unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'Bad credentials' }, status: 401
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def destroy_session
    request.session_options[:skip] = true
  end

  def api_error(status: 500, errors: [])
    puts errors.full_messages if errors.respond_to?(:full_messages)

    render json: Api::V1::ErrorSerializer.new(status, errors).as_json,
      status: status
  end

end