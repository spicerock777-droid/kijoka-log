class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all.order(:name)
    @invoices = Invoice.includes(:project).recent
  end

  def show
  end

  def new
    @invoice = @project.invoices.new(
      invoiced_on: Date.today,
      client_name: params[:client_name],
      amount:      params[:amount],
      subject:     params[:subject]
    )
  end

  def edit
  end

  def create
    @invoice = @project.invoices.new(invoice_params)
    @invoice.user = current_user
    if @invoice.save
      redirect_to project_invoice_path(@project, @invoice), notice: "請求書を保存しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to project_invoice_path(@project, @invoice), notice: "請求書を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @invoice.destroy!
    redirect_to project_path(@project), notice: "請求書を削除しました"
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_id])
  end

  def set_invoice
    @invoice = @project.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:invoiced_on, :client_name, :amount, :subject, :due_date, :note)
  end
end
