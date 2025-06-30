class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
  
    if $redis.get(token)
      render json: { error: 'Token has been revoked' }, status: :unauthorized
      return
    end
  
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
  
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
   
end
