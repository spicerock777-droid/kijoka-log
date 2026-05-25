class ConstructionRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_construction_record, only: %i[show edit update destroy]

  def show
  end

  def new
    @construction_record = @project.construction_records.new
  end

  def edit
  end

  def create
    @construction_record = @project.construction_records.new(construction_record_params)
    @construction_record.user = current_user

    if @construction_record.save
      PhotoAttachmentService.new(@construction_record).attach(new_photo_files)
      redirect_to project_construction_record_path(@project, @construction_record), notice: "施工記録を保存しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @construction_record.update(construction_record_params)
      service = PhotoAttachmentService.new(@construction_record)
      service.update_metadata(params[:photo_updates])
      service.attach(new_photo_files)
      redirect_to project_construction_record_path(@project, @construction_record), notice: "施工記録を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @construction_record.destroy!
    redirect_to project_path(@project), notice: "施工記録を削除しました"
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_id])
  end

  def set_construction_record
    @construction_record = @project.construction_records.find(params[:id])
  end

  def construction_record_params
    params.require(:construction_record).permit(
      :worked_on, :site, :work_items, :intent, :observations, :next_steps,
      :construction_cost, :labor_cost, :cost_memo
    )
  end

  def new_photo_files
    (params[:new_photos] || []).reject(&:blank?)
  end
end
