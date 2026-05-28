class FirstAidProceduresController < ApplicationController
  skip_before_action :require_login
  def index
    @species = params[:species]
    @query = params[:query]
    @searched = params.key?(:query) || params.key?(:species)
    @has_filters = @species.present? || @query.present?

    @procedures = FirstAidProcedure.all
    @procedures = @procedures.by_species(@species) if @species.present?
    @procedures = @procedures.search(@query) if @query.present?
    @procedures = @procedures.order(:name)
  end

  def show
    @procedure = FirstAidProcedure.find(params[:id])
    @steps = @procedure.steps
    @procedure_videos = @procedure.instructional_videos
  end
end
