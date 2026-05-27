class PetsController < ApplicationController

  def new
    @pet = Pet.new
  end

  def create
    @account = Account.find(session[:account_id])

    @pet = Pet.new(pet_params)

    @pet.pet_owner = PetOwner.find_or_create_by(account: @account)

    if @pet.save
      redirect_to "/profile", notice: "Pet added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pet = Pet.find(params[:id])

    unless @pet.pet_owner.account_id == session[:account_id]
      redirect_to "/profile"
    end
  end

  def edit
    @pet = Pet.find(params[:id])

    unless @pet.pet_owner.account_id == session[:account_id]
      redirect_to "/profile"
    end
  end

  def update
    @pet = Pet.find(params[:id])

    unless @pet.pet_owner.account_id == session[:account_id]
      redirect_to "/profile"
      return
    end

    if @pet.update(pet_params)
      redirect_to @pet, notice: "Pet updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet = Pet.find(params[:id])

    unless @pet.pet_owner.account_id == session[:account_id]
      redirect_to "/profile"
      return
    end

    @pet.destroy

    redirect_to "/profile", notice: "Pet deleted successfully."
  end

  private

  def pet_params
    params.require(:pet).permit(
      :name,
      :species,
      :breed,
      :date_of_birth,
      :weight,
      :allergies,
      :medical_notes
    )
  end

end