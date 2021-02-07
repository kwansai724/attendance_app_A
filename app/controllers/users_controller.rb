require 'csv'

class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info, :working_index, :edit_page]
before_action :set_one_month, only: [:show, :send_users_csv]
before_action :general_or_superior_user, only: [:show]

  def index
    @users = User.all.order(:id)
  end

  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      remember @user
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @overtime_count = Attendance.where(overtime_status: "申請中", superior_confirmation: @user.name).count
    @change_count = Attendance.where(change_status: "申請中", superior_check: @user.name).count
    @month_count = Attendance.where(month_status: "申請中", month_superior: @user.name).count
    @months = Attendance.where(user_id: params[:id], worked_on: @first_day)

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_users_csv(@attendances)
      end
    end
  end

  def send_users_csv(attendances)
    csv_data = CSV.generate(row_sep: "\r\n", encoding:Encoding::CP932) do |csv|
      header = %w(日付 出社時間 退社時間 備考)
      csv << header
      attendances.each do |attendance|
        values = [l(attendance.worked_on, format: :short),
                  if attendance.change_status == '承認'
                    attendance.change_started_at.strftime('%H:%M') if attendance.change_started_at.present?
                  else
                    attendance.started_at.strftime('%H:%M') if attendance.started_at.present?
                  end,
                  if attendance.change_status == '承認'
                    attendance.change_finished_at.strftime('%H:%M') if attendance.change_finished_at.present?
                  else
                    attendance.finished_at.strftime('%H:%M') if attendance.finished_at.present?
                  end,
                  if attendance.change_status == '承認'
                    attendance.note
                  end]
        csv << values
      end
    end
    send_data(csv_data, filename: "attendances.csv")
  end

  def edit
  end
  
  def edit_page
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def working_index
    @working_users = User.working_users
  end

  
  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:affiliation, :employee_number, :uid, :basic_work_time, :work_time)
    end

end
