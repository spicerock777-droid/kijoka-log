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
      preprocess_photo_variants(@construction_record)
      redirect_to project_construction_record_path(@project, @construction_record), notice: "施工記録を保存しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    p = construction_record_params
    new_photos = !(params.dig(:construction_record, :photos).blank? ||
                   params.dig(:construction_record, :photos).all?(&:blank?))
    p = p.except(:photos) unless new_photos
    if @construction_record.update(p)
      preprocess_photo_variants(@construction_record) if new_photos
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

  def preprocess_photo_variants(record)
    record.photos.each do |photo|
      photo.variant(resize_to_fill: [400, 300]).processed
    rescue StandardError
      next
    end
  end

  def construction_record_params
    params.require(:construction_record).permit(
      :worked_on, :site, :work_items, :intent, :observations, :next_steps,
      :construction_cost, :labor_cost, :cost_memo,
      photos: [], photo_captions: {}, photo_types: {}
    )
  end
end
