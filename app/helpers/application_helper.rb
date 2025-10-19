module ApplicationHelper
  def icon(path, **options)
    render("icons/#{path}", options)
  end

  def avatar(user:, size: "size-30")
    if user.avatar.attached? && user.avatar.variable?
      image_tag(
        user.avatar.variant(:thumb),
        class: "#{size} rounded-full bg-neutral-500"
      )
    else
      tag.div(class: "#{size} rounded-full bg-neutral-500 flex shrink-0 justify-center items-center")
    end
  end

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
