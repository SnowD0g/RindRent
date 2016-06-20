module API
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    protected

    def record_not_found(exception)
      render json: {data: { message: exception.message}}, status: :not_found
    end

    def record_invalid(exception)
      render json: {data: { message: exception.record.errors.full_messages}}, status: :unprocessable_entity
    end
  end
end