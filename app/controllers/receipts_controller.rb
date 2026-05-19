class ReceiptsController < ApplicationController
  before_action :authenticate_user!, except: [:public_show]
  before_action :set_project, except: [:public_show]
  before_action :set_receipt, only: [:show, :edit, :update, :destroy, :extend_share]

  def public_show
    @receipt = Receipt.find_by!(share_token: params[:token])
    if @receipt.share_token_expired?
      render "estimates/expired", layout: "application", status: :gone and return
    end
    @project = @receipt.project
    render :public_show, layout: "application"
  end

  def extend_share
    @receipt.update!(share_token_expires_at: 30.days.from_now)
    redirect_to project_receipt_path(@project, @receipt), notice: "共有リンクを30日延長しました"
  end

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
