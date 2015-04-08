module ExerciseRealizationsHelper
  # Return string with time formatted as (from)H-M(-S) - (until)H-M(-S)
  def time_formatted(from, til)
    haml_tag :i, :class => 'fa fa-clock-o'
    haml_tag :strong, " "+Time.at(from).utc.strftime((from.to_i%60==0)?"%H:%M":"%H:%M:%S")+" - "+Time.at(til).utc.strftime((til.to_i%60==0)?"%H:%M":"%H:%M:%S")
  end

  def render_spinner
    haml_tag :i, :class => 'fa fa-2x fa-spinner fa-spin col-sm-12 text-center text-muted'
    haml_tag :br, :style => 'clear: both;'
  end
end