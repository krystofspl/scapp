module ApplicationHelper
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  # Get _object_ value of specified _field_ or dash when _field_ not available or empty
  #
  # Designed especially for data retrieved as {ActiveRecord::Relation}
  #
  # @return [String]
  def dash_or_value(object, field)
    return "-" if object.blank?
    return "-" unless object.class.attribute_names.include?(field.to_s) && (!object[field].blank?)
    object[field]
  end

  # Get _object_ or dash when nil
  def dash_or_object(obj)
    return "-" if obj.nil?
    obj
  end

  # Wraps public status into label with specific color
  # @param [String] label label to labelize
  # @return [String] label wrapped in label span
  def self.labelize_boolean(label)
    case label
      when true
        return '<span class="label label-success">✓</span>'
      when false, nil
        return '<span class="label label-danger">✗</span>'
    end
  end

  # Wraps exercise measurement optimal value into label with specific color
  # @param [String] label
  # @return [String] label wrapped in label span
  def self.labelize_optimal_value(label)
    case label.to_s
      when "higher"
        return "<span class=\"label label-info\"><i class=\"fa fa-arrow-up\"></i> #{I18n.t('optimal_value.higher')}</span>"
      when "lower"
        return "<span class=\"label label-info\"><i class=\"fa fa-arrow-down\"></i> #{I18n.t('optimal_value.lower')}</span>"
      else
        return label
    end
  end

  # Wraps exercise [,measurement,setup] realizations count into label with specific color
  # @param [Integer] count number of realizations
  # @return [String] label wrapped in label span
  def self.labelize_realizations(count)
    count = count.to_s
    case count
      when "0"
        return "<span class=\"label label-default\">#{count}x</span>"
      else
        return "<span class=\"label label-success\">#{count}x</span>"
    end
  end

  # Wraps remaining time in label and highlight with warning colors
  #
  # @param [DateTime] date_time specific time which is compared current
  # @return [String] remaining time wrapped in span
  def self.labelize_time_remain(date_time)
    cur = DateTime.current
    seconds = (date_time.to_i - cur.to_i).to_f
    minutes = (seconds / 1.minute).round
    hours = (seconds / 1.hour).round(1)
    days = (seconds / 1.day).round(1)
    if seconds < 0
      ret = "<span class=\"label label-danger\">#{I18n.t('dictionary.passed')}</span>"
    else
      ret = "<span class=\"label label-success\">#{I18n.t('dictionary.remain')} #{distance_of_time_in_words_difference(seconds)}</span>"
    end
    ret
  end

  # Create help link
  #
  # @param [String] theme main topic - exist as file inside helps views
  # @param [String] keyword term we show help for - exist es keyword with description isnise theme file
  # @param [String] locale specify language version of help file to pick up
  # @return [String] html snippet required to link us to help page and scroll to anchor
  def self.link_help(theme, keyword, locale = 'en')
    # TODO implement anchor from keyword
    "(<a href=\"#{Rails.application.routes.url_helpers.show_help_path(locale, theme)}\" target=\"_blank\"><i class=\"fa fa-question-circle\"></i><span> help</span></a>)"
  end

  # Create help modal link
  #
  #   Do not forget to add html snippet to page: #modal-help.modal.fade{role: 'dialog', 'aria-hidden' => true}
  #
  # @param [String] theme main topic - exist as file inside helps views
  # @param [String] keyword term we show help for - exist es keyword with description isnise theme file
  # @param [String] locale specify language version of help file to pick up
  # @return [String] html snippet required to fetch help and display it to modal window
  def self.link_modal_help(theme, keyword, locale = 'en')
    "(<a href=\"#{Rails.application.routes.url_helpers.show_modal_help_path(locale, theme, key: keyword)}\" data-toggle=\"modal\" data-target=\"#modal-help\">
      <i class=\"fa fa-question-circle\"></i><span> help</span>
    </a>)"
  end

  # Colorize specified text against positive or negative value
  #
  # @param [String] text Text to colorise
  # @param [Float] value Numeric value determining result color
  # @return [String] Colorized text wrapped in span
  def self.colorize_negative_positive(text, value)
    value = 0 if value.nil?
    raise StandardError, 'Numeric value is required!' unless value.kind_of?(Float) || value.kind_of?(Integer) ||value.kind_of?(BigDecimal) || (value.kind_of?(String) && value.is_number?)

    out = "<span class=\"#{value < 0 ? 'negative' : ''}#{value == 0 ? 'neutral' : ''}#{value > 0 ? 'positive' : ''}\">"
    out += "<i class=\"fa fa-long-arrow-down\"></i>" if value < 0
    out += "<i class=\"fa fa-long-arrow-up\"></i>" if value > 0
    out += " #{text}</span>"
  end

  # Modified distance_of_time_in_words for some locales, used for "Remaining time: 1 hour", instead of the original "before 1 hour"
  # Original-File: actionpack/lib/action_view/helpers/date_helper.rb, line 63
  def self.distance_of_time_in_words_difference(from_time, to_time = 0, include_seconds = true, options = {})
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    I18n.with_options :locale => options[:locale], :scope => 'datetime.distance_in_words_difference' do |locale|
      case distance_in_minutes
        when 0..1
          return distance_in_minutes == 0 ?
              locale.t('less_than_x_minutes.one') : locale.t('x_minutes.one') unless include_seconds

          case distance_in_seconds
            when 0..1   then locale.t 'x_seconds.one'
            when 2..4   then locale.t 'x_seconds.few', :count => distance_in_seconds
            when 5..25  then locale.t 'x_seconds.other', :count => distance_in_seconds
            when 26..34 then locale.t 'half_a_minute'
            when 35..50 then locale.t 'x_seconds.other', :count => distance_in_seconds
            when 51..59 then locale.t 'less_than_x_minutes.one'
            else             locale.t 'x_minutes.one'
          end

        when 2..4            then locale.t 'x_minutes.few', :count => distance_in_minutes
        when 5..54           then locale.t 'x_minutes.other', :count => distance_in_minutes
        when 55..59          then locale.t 'about_x_hours.one'
        when 60              then locale.t 'x_hours.one'
        when 61..90          then locale.t 'about_x_hours.one'
        when 91..299         then locale.t 'about_x_hours.few', :count => (distance_in_minutes.to_f / 60.0).round
        when 300..1439       then locale.t 'about_x_hours.other', :count => (distance_in_minutes.to_f / 60.0).round
        when 1440..2529      then locale.t 'x_days.one'
        when 2530..7199      then locale.t 'x_days.few', :count => (distance_in_minutes.to_f / 1440.0).round
        when 7200..43199     then locale.t 'x_days.other', :count => (distance_in_minutes.to_f / 1440.0).round
        when 43200..64799    then locale.t 'about_x_months.one'
        when 64800..215999   then locale.t 'x_months.few', :count => (distance_in_minutes.to_f / 43200.0).round
        when 86400..525599   then locale.t 'x_months.other', :count => (distance_in_minutes.to_f / 43200.0).round
        else
          distance_in_years           = distance_in_minutes / 525600
          minute_offset_for_leap_year = (distance_in_years / 4) * 1440
          remainder                   = ((distance_in_minutes - minute_offset_for_leap_year) % 525600)
          if remainder < 131400
            case distance_in_years
              when 0..1 then locale.t 'about_x_years.one'
              when 2..4 then locale.t 'about_x_years.few', :count => distance_in_years
              else           locale.t 'about_x_years.other', :count => distance_in_years
            end
          elsif remainder < 394200
            case distance_in_years
              when 0..1 then locale.t 'over_x_years.one'
              when 2..4 then locale.t 'over_x_years.few', :count => distance_in_years
              else           locale.t 'over_x_years.other', :count => distance_in_years
            end
          else
            case distance_in_years
              when 0 then locale.t 'almost_x_years.one'
              when 1..4 then locale.t 'almost_x_years.few', :count => distance_in_years+1
              else           locale.t 'almost_x_years.other', :count => distance_in_years+1
            end
          end
      end
    end
  end

end
