class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_overtime_approval, :update_overtime_approval]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  #before_action :next_day?, only: :update_overtime_apply

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:success] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0)) 
        flash[:success] = "お疲れ様でした！"    
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1か月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def edit_overtime_apply
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
  end

  def update_overtime_apply
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
    if @attendance.update_attributes(overtime_apply_params)
      flash[:success] = "残業申請しました。"
    else
      flash[:danger] = "無効な入力データがあります。"
    end
    redirect_to user_url(@user)
  end

  def edit_overtime_approval
    @attendances = Attendance.where.not(overtime_at: nil, work_content: nil, superior_confirmation: nil).order(:user_id).group_by(&:user_id)
  end


  def update_overtime_approval
    ActiveRecord::Base.transaction do
      overtime_approval_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
      flash[:success] = "変更を送信しました。"
      redirect_to user_url(@user)
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあります。"
    redirect_to user_url(@user)
  end

  
  private

    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end

    def overtime_apply_params
      params.require(:user).permit(attendance: [:overtime_at, :next_day, :work_content, :superior_confirmation])[:attendance]
    end

    def overtime_approval_params
      params.require(:user).permit(attendances: [:change, :overtime_status])[:attendances]
    end
end
