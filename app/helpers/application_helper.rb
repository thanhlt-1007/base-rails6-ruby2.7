# frozen_string_literal: true

# Application helper
module ApplicationHelper
  def display_icon_type_flash flash_type
    case flash_type
    when Settings.flash_type.success
      content_tag :span, nil, class: 'alert__icon fas fa-check-circle'
    when Settings.flash_type.danger
      content_tag :span, nil, class: 'alert__icon fas fa-times-circle'
    when Settings.flash_type.notice
      content_tag :span, nil, class: 'alert__icon fas fa-info-circle'
    when Settings.flash_type.warning
      content_tag :span, nil, class: 'alert__icon fas fa-exclamation-triangle'
    when Settings.flash_type.alert
      content_tag :span, nil, class: 'alert__icon fas fa-times-circle'
    end
  end
end
