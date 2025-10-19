class TailwindBuilder < ActionView::Helpers::FormBuilder
  delegate :tag, :safe_join, to: :@template

  def default_classes
    "w-full rounded border-slate-300 shadow-inner shadow-slate-100 disabled:bg-slate-100 placeholder-slate-300"
  end

  def label(method, text = nil, options={})
    super(method, text, options.merge(class: "#{options[:class]} block text-sm text-slate-500 mb-2"))
  end

  def file_field(method, options = {})
    super(method, options.merge(class: "#{options[:class]} w-full p-2 bg-slate-200 rounded disabled:bg-slate-100"))
  end

  def text_field(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def email_field(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def password_field(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def date_field(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def datetime_field(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def text_area(method, options={})
    super(method, options.merge(class: "#{options[:class]} #{default_classes}"))
  end

  def error(method)
    return unless @object.errors.include?(method)

    tag.div(safe_join(@object.errors.full_messages_for(method), tag.br), class: "text-sm text-rose-600")
  end

  def markdown_text_area(method, options={})
    text_area_id = options.fetch(:id) { field_id(method) }
    space = options.delete(:space)

    @template.render(
      MarkdownToolbarComponent.new(id: text_area_id, space: space).tap do |c|
        c.with_text_area do
          text_area(
            method,
            options.merge(
              toolbar: true,
              class: "block focus:ring-0 focus:ring-offset-0 focus:border-slate-300 rounded-t-none",
            )
          )
        end
      end
    )
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    super(method, options.merge(class: "#{options[:class]} border-slate-300 rounded disabled:bg-slate-100"), checked_value, unchecked_value)
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    super(method, choices, options, html_options.merge(class: "#{html_options[:class]} #{default_classes}"), &block)
  end

  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {}, &block)
    super(method, priority_zones, options, html_options.merge(class: "#{html_options[:class]} #{default_classes}"), &block)
  end
end
