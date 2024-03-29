class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_overtime_approval, :update_overtime_approval,
                                  :edit_change_approval, :update_change_approval, :update_month_apply, :edit_month_approval,
                                  :update_month_approval, :show_attendance_log]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :update_month_apply, :show_attendance_log]

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
        unless item[:superior_check].blank?
          unless item["change_started_at(4i)"] == "" || item["change_finished_at(4i)"] == "" 
            attendance.update_attributes!(item.merge(change_status: '申請中'))
            flash[:success] = "勤怠の変更を申請しました。"
          else
            flash[:danger] = "出社時間または退社時間が未入力です。"
          end
        end
      end
    end
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
    if overtime_apply_params[:overtime_at].present? && overtime_apply_params[:work_content].present?
      @attendance.update_attributes(overtime_apply_params)
        flash[:success] = "残業申請しました。"
    elsif overtime_apply_params[:overtime_at].blank? && overtime_apply_params[:work_content].blank?
      flash[:danger] = "終了予定時間及び業務処理内容が空欄です。"
    elsif overtime_apply_params[:overtime_at].blank?
      flash[:danger] = "終了予定時間が空欄です。"
    elsif overtime_apply_params[:work_content].blank?
      flash[:danger] = "業務処理内容が空欄です。"
    end
    redirect_to @user
  end

  def edit_overtime_approval
    @attendances = Attendance.where(overtime_status: '申請中', superior_confirmation: @user.name).order(:user_id, :worked_on).group_by(&:user_id)
  end


  def update_overtime_approval
    ActiveRecord::Base.transaction do
      overtime_approval_params.each do |id, item|
        attendance = Attendance.find(id)
        if overtime_approval_params[id][:change] == 'true'
          attendance.update_attributes!(item)
          if overtime_approval_params[id][:overtime_status] == '否認'
            attendance.update_columns(overtime_at: nil, next_day: nil, work_content: nil, change: nil)
          elsif overtime_approval_params[id][:overtime_status] == 'なし'
            attendance.update_columns(overtime_at: nil, next_day: nil, work_content: nil, superior_confirmation: nil, change: nil, overtime_status: nil)
          end
        end
      end
    end
    flash[:success] = "変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあります。"
    redirect_to @user
  end

  def edit_change_approval
    @attendances = Attendance.where(change_status: '申請中', superior_check: @user.name).order(:user_id, :worked_on).group_by(&:user_id)
  end

  def update_change_approval
    ActiveRecord::Base.transaction do
      change_approval_params.each do |id, item|
        attendance = Attendance.find(id)
        if change_approval_params[id][:modify] == 'true'
          if change_approval_params[id][:change_status] == '承認'
            attendance.update_attributes(item.merge(approval_day: Date.today,
                                          before_started_at: attendance.change_started_at, before_finished_at: attendance.change_finished_at))
          elsif change_approval_params[id][:change_status] == '否認'
            attendance.update_columns(change_started_at: nil, change_finished_at: nil, note: nil, tomorrow: nil, modify: nil,
                                      change_status: '否認', approval_day: nil)
          elsif change_approval_params[id][:change_status] == 'なし'
            attendance.update_columns(change_started_at: nil, change_finished_at: nil, note: nil, tomorrow: nil, modify: nil,
                                      change_status: nil, superior_check: nil, approval_day: nil, before_started_at: nil, before_finished_at: nil)
          end
        end
      end
    end
    flash[:success] = "変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあります。"
    redirect_to @user
  end

  def update_month_apply
    @attendance = Attendance.where(user_id: month_params[:user_id], worked_on: params[:date])
    unless month_params[:month_superior].blank?
      @attendance.update_all(month_params)
      flash[:success] = "１ヶ月分の勤怠申請しました。"
    else
      flash[:danger] = "申請先を選択してください。"
    end
    redirect_to user_url(date: @first_day)
  end
  

  def edit_month_approval
    @attendances = Attendance.where(month_status: '申請中', month_superior: @user.name).order(:user_id, :apply_month).group_by(&:user_id)
  end

  def update_month_approval
    ActiveRecord::Base.transaction do
      month_approval_params.each do |id, item|
        attendance = Attendance.find(id)
        unless month_approval_params[id][:month_modify] == 'false'
          attendance.update_attributes!(item)
          if month_approval_params[id][:month_status] == 'なし'
            attendance.update_columns(month_modify: nil, month_status: nil, month_superior: nil, apply_month: nil)
          end
        end
      end
    end
    flash[:success] = "変更を送信しました。"
    redirect_to @user
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあります。"
    redirect_to @user
  end

  def show_attendance_log
    if params["year_month(1i)"].present? && params["year_month(2i)"].present?
      @first_day = Date.parse("#{params["year_month(1i)"]}/#{params["year_month(2i)"]}/1")
    end
    @last_day = @first_day.end_of_month
    @logs = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  end
  
  private

    def attendances_params
      params.require(:user).permit(attendances: [:change_started_at, :change_finished_at, :note, :tomorrow, :superior_check])[:attendances]
    end

    def change_approval_params
      params.require(:user).permit(attendances: [:modify, :change_status])[:attendances]
    end

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end

    def overtime_apply_params
      params.require(:user).permit(attendance: [:overtime_at, :next_day, :work_content, :superior_confirmation])[:attendance].merge(overtime_status: '申請中')
    end

    def overtime_approval_params
      params.require(:user).permit(attendances: [:change, :overtime_status])[:attendances]
    end

    def month_params
      params.require(:user).permit(:month_superior).merge(user_id: params[:id], month_status: '申請中', apply_month: params[:date].to_date).to_h
    end

    def month_approval_params
      params.require(:user).permit(attendances: [:month_modify, :month_status])[:attendances]
    end
  end
