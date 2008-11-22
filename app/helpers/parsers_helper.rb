module ParsersHelper
  def parser
    params[:parser] ? params[:parser].humanize : ''
  end
end