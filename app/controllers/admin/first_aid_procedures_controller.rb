module Admin
  class FirstAidProceduresController < BaseController
    before_action :set_procedure, only: [:show, :edit, :update, :destroy]

    def index
      @procedures = FirstAidProcedure.order(:species, :name)
    end

    def show
    end

    def new
      @procedure = FirstAidProcedure.new
    end

    def create
      @procedure = FirstAidProcedure.new(procedure_params)
      if @procedure.save
        redirect_to admin_first_aid_procedure_path(@procedure), notice: "Procedure created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @procedure.update(procedure_params)
        redirect_to admin_first_aid_procedure_path(@procedure), notice: "Procedure updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @procedure.destroy
      redirect_to admin_first_aid_procedures_path, notice: "Procedure deleted."
    end

    private

    def set_procedure
      @procedure = FirstAidProcedure.find(params[:id])
    end

    def procedure_params
      params.require(:first_aid_procedure).permit(:name, :species, :severity, :description, :symptom_keywords)
    end
  end
end
