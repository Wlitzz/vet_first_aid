module Admin
  class InstructionalVideosController < BaseController
    before_action :set_procedure
    before_action :set_video, only: [:edit, :update, :destroy]

    def new
      @video = InstructionalVideo.new(first_aid_procedure: @procedure)
    end

    def create
      @video = InstructionalVideo.new(video_params_with_attachment)
      if @video.save
        redirect_to admin_first_aid_procedure_path(@procedure), notice: "Video added successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @video.update(video_params_with_attachment)
        redirect_to admin_first_aid_procedure_path(@procedure), notice: "Video updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @video.destroy
      redirect_to admin_first_aid_procedure_path(@procedure), notice: "Video deleted."
    end

    private

    def set_procedure
      @procedure = FirstAidProcedure.find(params[:first_aid_procedure_id])
    end

    def set_video
      @video = InstructionalVideo
        .where(first_aid_procedure: @procedure)
        .or(InstructionalVideo.where(step_id: @procedure.step_ids))
        .find(params[:id])
    end

    def video_params
      params.require(:instructional_video).permit(:title, :url, :description)
    end

    def video_params_with_attachment
      attrs = video_params

      if params[:attach_to] == "step"
        step_id = params.dig(:instructional_video, :step_id)
        step = @procedure.steps.find(step_id) if step_id.present?
        attrs.merge(first_aid_procedure: nil, step: step)
      else
        attrs.merge(first_aid_procedure: @procedure, step: nil)
      end
    end
  end
end
