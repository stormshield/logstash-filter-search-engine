# encoding: utf-8
require "logstash/filters/utils"

class YahooQueryParser

  public
  def initialize
    @re_url = /(?:[^\.]*\.)?search.yahoo\..*/
    @re_query = /^\/search\?(?:[^&]*&)?p=(?<query>[^&#]*)/i
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
