module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    
    #resource.errors[field_name].empty? ? nil : resource.errors[field_name][0]
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    #resource.errors[field_name].empty? ? nil : resource.errors[field_name][0]
    html = <<-HTML
    <div id="error_explanation">
      <ul class="email-uniqueness-error-message">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end