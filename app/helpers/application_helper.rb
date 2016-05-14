module ApplicationHelper
  def time_ago(date)
    time_tag date, t("time_ago", time: time_ago_in_words(date)),
      title: date, class: "time_ago"
  end
end
