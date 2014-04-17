class SessionsController < ApplicationController
  def show
    render json: current_session
  end

  private

    def current_session
      { csrf_token: form_authenticity_token }
    end
end
