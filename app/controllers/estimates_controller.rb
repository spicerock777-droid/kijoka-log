class EstimatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:index]
  before_action :set_estimate, only: [:show, :edit, :update, :destroy]

  def public_show
    @estimate = Estimate.find_by!(share_token: params[:token])
    @project = @estimate.project
    render :public_show, layout: "application"
  end

  def index
    @projects = Project.all.order(:name)
    @estimates = Estimate.includes(:project).recent
    @estimates = @estimates.search(params[:q]) if params[:q].present?
  end

  def show
  end

  def new
    @estimate = @project.estimates.new(doc_date: Date.today)
  end

  def edit
  end

  def create
    @estimate = @project.estimates.new(estimate_params)
    @estimate.user = current_user
    @estimate.items = parse_items

    if @estimate.save
      redirect_to project_estimate_path(@project, @estimate), notice: "見積書を保存しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @estimate.items = parse_items
    if @estimate.update(estimate_params)
      redirect_to project_estimate_path(@project, @estimate), notice: "見積書を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @estimate.destroy!
    redirect_to project_path(@project), notice: "見積書を削除しました"
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_id])
  end

  def set_estimate
    @estimate = @project.estimates.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(:client_name, :subject, :doc_date, :doc_number, :note, :apply_tax)
  end

  def parse_items
    raw = params.dig(:estimate, :items_json)
    return [] if raw.blank?
    JSON.parse(raw)
  rescue JSON::ParserError
    []
  end
end
