module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end

  def over_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end

  def month_state(user)
    return 'から承認済' if user.month_status == '承認'
    return 'から否認' if user.month_status == '否認'
    return 'へ申請中' if user.month_status == '申請中'
    return '未' unless user.month_status == '承認' || '否認' || '申請中'
  end
end
