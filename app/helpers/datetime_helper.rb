# sweet place to put your fancy date formatting methods...
module DatetimeHelper
  DATE_FORMATS = { 
    :medium_date     => "%b %e, %Y", 
    :medium_datetime => "%b %e, %Y %I:%M%p %Z",
    :pretty_date     => "%b %d %Y", 
    :pretty_datetime => "%b %d %Y, %I:%M %p"
  }.freeze
  
  def time(time, format=:medium_datetime)
    time.strftime(DATE_FORMATS[format])
  end
  
  def local_time(time, format=:medium_datetime)
    time(time.localtime, format)
  end
  
  # if the given time is less than 1 day old, it uses the time in words ago
  # helper to output the time since. if it's more than 1 day old it outputs the
  # time according to the given stftime format
  def smart_datetime(datetime, format=nil)
    if happened_today?(datetime)
      time_ago_in_words(datetime) + ' ago'
    else
      datetime.strftime(format || DATE_FORMATS[:pretty_datetime])
    end
  end
  
  def local_smart_datetime(datetime, format=nil)
    smart_datetime(datetime.localtime, format)
  end
  
  def happened_today?(datetime)
    datetime > 1.days.ago
  end
end