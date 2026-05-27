class ProfilesController < ApplicationController

  def show
    @account = Account.find(session[:account_id])

    @pet_owner = @account.pet_owner

    @pets = @pet_owner.present? ? @pet_owner.pets : []
  end

  def edit
    @account = Account.find(session[:account_id])
  end

  def update
    @account = Account.find(session[:account_id])

    if @account.update(account_params)
      redirect_to "/profile", notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(
      :first_name,
      :last_name,
      :email
    )
  end

end