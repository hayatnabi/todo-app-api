class Api::V1::PasswordsController < ApplicationController
  skip_before_action :authorize_request # Skip JWT check

  def forgot
    if params[:email].blank?
      return render json: { error: "Email not present" }, status: :bad_request
    end

    user = User.find_by(email: params[:email])

    if user
      user.generate_password_token!
      # TODO: send token via email (for now, return in response)
      UserMailer.reset_password_email(user).deliver_now
      render json: { message: "Reset password instructions sent to #{user.email}", token: user.reset_password_token }, status: :ok
    else
      render json: { error: "Email address not found" }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s

    user = User.find_by(reset_password_token: token)

    if user && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { message: "Password successfully reset" }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Token not valid or expired" }, status: :not_found
    end
  end
end
