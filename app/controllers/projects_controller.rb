class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.order(:name)
  end

  def show
    @project = Project.find_by!(slug: params[:id])
    @construction_records = @project.construction_records.recent
  end
end
