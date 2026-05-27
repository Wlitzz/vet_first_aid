class SessionsController < ApplicationController
  
  skip_before_action :require_login

  def new
  end

  def create
    @email = params[:email]
    account = Account.find_by(email: params[:email])

    if account&.authenticate(params[:password])
      session[:account_id] = account.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:account_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end
end