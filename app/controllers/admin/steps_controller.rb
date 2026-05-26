module Admin
  class StepsController < BaseController
    before_action :set_procedure
    before_action :set_step, only: [:show, :edit, :update, :destroy]

    def index
      @steps = @procedure.steps
    end

    def show
    end

    def new
      @step = @procedure.steps.new
    end

    def create
      @step = @procedure.steps.new(step_params)
      if @step.save
        redirect_to admin_first_aid_procedure_steps_path(@procedure), notice: "Step created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @step.update(step_params)
        redirect_to admin_first_aid_procedure_steps_path(@procedure), notice: "Step updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @step.destroy
      redirect_to admin_first_aid_procedure_steps_path(@procedure), notice: "Step deleted."
    end

    private

    def set_procedure
      @procedure = FirstAidProcedure.find(params[:first_aid_procedure_id])
    end

    def set_step
      @step = @procedure.steps.find(params[:id])
    end

    def step_params
      params.require(:step).permit(:position, :instruction, :checklist)
    end
  end
end
