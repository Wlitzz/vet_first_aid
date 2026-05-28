class StepsController < ApplicationController
  skip_before_action :require_login
  def show
    @procedure = FirstAidProcedure.find(params[:first_aid_procedure_id])
    @step = @procedure.steps.find(params[:id])
    @steps = @procedure.steps
    @total = @steps.count
    @video = @step.instructional_videos.first

    current_index = @steps.index(@step)
    @prev_step = current_index > 0 ? @steps[current_index - 1] : nil
    @next_step = current_index < @total - 1 ? @steps[current_index + 1] : nil
  end
end
