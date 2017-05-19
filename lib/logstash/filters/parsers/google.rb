# encoding: utf-8
require "logstash/filters/utils"

class GoogleQueryParser

  public
  def initialize
    @re_url = /(?:www\.)?google\..*/
    @re_query = /^\/search\?(?:[^&]*&)?q=(?<query>[^&#]*)/i
  end

  public
  def match(siteName)
    return @re_url.match(siteName)
  end

  def parse(query)
    query = Utils.removeInvalidChars(query)
    m = @re_query.match(query)
    if m then
      return m["query"].tr("+", " ").split.join(" ")
    end
  end

end
