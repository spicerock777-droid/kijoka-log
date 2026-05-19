class WsLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_ws_log, only: [:show, :edit, :update, :destroy]

  def new
    @ws_log = @project.ws_logs.build(held_on: Date.today)
  end

  def create
    @ws_log = @project.ws_logs.build(ws_log_params)
    @ws_log.user = current_user
    if @ws_log.save
      redirect_to project_ws_log_path(@project, @ws_log), notice: "WSログを保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @ws_log.update(ws_log_params)
      redirect_to project_ws_log_path(@project, @ws_log), notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ws_log.destroy
    redirect_to project_path(@project), notice: "削除しました"
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_id])
  end

  def set_ws_log
    @ws_log = @project.ws_logs.find(params[:id])
  end

  def ws_log_params
    params.require(:ws_log).permit(
      :held_on, :title, :participants_count, :participant_notes,
      :weather, :content, :reflection, :reactions, :improvements,
      photos: []
    )
  end
end
