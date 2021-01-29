module ApplicationHelper

  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  def off_hours(end_time, overtime_at, next_day)
    end_time = @user.designated_work_end_time.change(year: overtime_at.year, month: overtime_at.month, day: overtime_at.day)
    unless next_day == true
      format("%.2f", (((overtime_at - end_time) / 60) / 60.0))
    else
      format("%.2f", (((overtime_at - end_time) / 60) / 60.0) + 24)
    end
  end
end
