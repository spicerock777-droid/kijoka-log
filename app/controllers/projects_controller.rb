class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :gallery, :edit, :update]

  def index
    @projects = Project.all.order(:name)
  end

  def show
    @construction_records = @project.construction_records.recent
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.slug = generate_slug(@project.name)
    if @project.save
      redirect_to @project, notice: "現場「#{@project.name}」を追加しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "現場名を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def gallery
    records_with_photos = @project.construction_records
                                  .with_photos
                                  .order(worked_on: :asc)
                                  .includes(photos: :blob)
    @records_by_site = records_with_photos.group_by(&:site)
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def generate_slug(name)
    base = name.to_s.parameterize
    base = SecureRandom.hex(4) if base.blank?
    slug = base
    counter = 1
    while Project.exists?(slug: slug)
      slug = "#{base}-#{counter}"
      counter += 1
    end
    slug
  end
end
