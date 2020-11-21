module DriversHelper
  def break_by_words(str)
    str.gsub(' ', '<br>').html_safe
  end
end
