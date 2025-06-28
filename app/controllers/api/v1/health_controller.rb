class Api::V1::HealthController < ApplicationController
  skip_before_action :authorize_request

  def status
    render json: {
      status: "API is running",
      version: "v1"
    }, status: :ok
  end
end
