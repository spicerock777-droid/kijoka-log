class ReceiptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @receipt = @project.receipts.new(
      received_on:    Date.today,
      client_name:    params[:client_name],
      amount:         params[:amount],
      tadashi:        params[:tadashi],
      payment_method: params[:payment_method]
    )
  end

  def edit
  end

  def create
    @receipt = @project.receipts.new(receipt_params)
    @receipt.user = current_user
    if @receipt.save
      redirect_to project_receipt_path(@project, @receipt), notice: "領収書を保存しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @receipt.update(receipt_params)
      redirect_to project_receipt_path(@project, @receipt), notice: "領収書を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @receipt.destroy!
    redirect_to project_path(@project), notice: "領収書を削除しました"
  end

  private

  def set_project
    @project = Project.find_by!(slug: params[:project_id])
  end

  def set_receipt
    @receipt = @project.receipts.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:received_on, :client_name, :amount, :tadashi, :payment_method, :note)
  end
end
