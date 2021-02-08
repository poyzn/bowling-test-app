class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    render json: { status: 'error', data: { message: e.message } }, status: :bad_request
  end
end
