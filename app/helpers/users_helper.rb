module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end

  def over_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
end
