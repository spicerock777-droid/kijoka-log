class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(settings_params)
      redirect_to edit_settings_path, notice: "設定を保存しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user).permit(:bank_name, :branch_name, :account_type, :account_number, :account_holder)
  end
end
