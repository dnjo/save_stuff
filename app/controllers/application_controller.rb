class ApplicationController < ActionController::API
  private

  def client_has_valid_token?
    !!valid_token_sub
  end

  def current_user
    User.from_subject(valid_token_sub)
  end

  def valid_token_sub
    begin
      token = request.cookies['next-auth.session-token']
      jwks = { keys: [Rails.configuration.jwt_signing_key] }
      verified_token = JWT.decode(token, nil, true, algorithms: ['PS256'], jwks: jwks).first
    rescue JWT::VerificationError, JWT::DecodeError
      return nil
    end
    verified_token['sub']
  end

  def require_login
    render json: { error: 'Unauthorized' }, status: :unauthorized unless client_has_valid_token?
  end
end
