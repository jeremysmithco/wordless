module ApplicationHelper
  def flash_class(level)
    case level
    when "success" then "bg-green-700"
    when "notice" then "bg-blue-700"
    when "message" then "bg-blue-700"
    when "warning" then "bg-amber-700"
    when "error" then "bg-red-700"
    when "alert" then "bg-red-700"
    end
  end
end
