class UsersController < ApplicationController

  skip_before_action :require_login

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      @account.create_pet_owner
      session[:account_id] = @account.id
      redirect_to root_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end