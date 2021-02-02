module AttendancesHelper

  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    return false
  end

  #def working_times(start, finish)
    #format("%.2f", (((finish - start) / 60) / 60.0))
  #end

  def working_times(start, finish, tomorrow, change_status)
    #end_time = @user.designated_work_end_time.change(year: overtime_at.year, month: overtime_at.month, day: overtime_at.day)
    unless tomorrow == true && change_status == '承認'
      format("%.2f", (((finish - start) / 60) / 60.0))
    else
      format("%.2f", (((finish - start) / 60) / 60.0) + 24)
    end
  end
 
  def overtime_state(attendance)
    return '残業承認済' if attendance.overtime_status == '承認'
    return '残業否認' if attendance.overtime_status == '否認'
    return '残業申請中' if attendance.overtime_status == '申請中'
  end

  def change_state(attendance)
    return '勤怠変更承認済' if attendance.change_status == '承認'
    return '勤怠変更否認' if attendance.change_status == '否認'
    return '勤怠変更申請中' if attendance.change_status == '申請中'
  end
end
