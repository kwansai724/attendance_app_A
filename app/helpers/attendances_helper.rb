module AttendancesHelper

  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    return false
  end

  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
 

  def overtime_state(attendance)
    return '残業承認済' if attendance.overtime_status == '承認'
    return '残業否認' if attendance.overtime_status == '否認'
    return '残業申請中' if attendance.overtime_status == '申請中'
  end

  def superior_name(user)
    return ['上長B'] if user.name == "上長A"
    return ['上長A'] if user.name == "上長B"
    return ['上長A', '上長B'] unless user.name == "上長A" && "上長B"
  end
end
