module API
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found
      render json: {data: {message: "Couldn't find Element with 'id'=#{params[:id]}"}}, status: :not_found
    end
  end
end