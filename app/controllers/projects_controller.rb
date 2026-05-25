class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.order(:name)
  end

  def show
    @project = Project.find_by!(slug: params[:id])
    @construction_records = @project.construction_records.recent
  end

  def gallery
    @project = Project.find_by!(slug: params[:id])
    records_with_photos = @project.construction_records
                                  .with_photos
                                  .order(worked_on: :asc)
                                  .includes(photos: :blob)
    @records_by_site = records_with_photos.group_by(&:site)
  end
end
