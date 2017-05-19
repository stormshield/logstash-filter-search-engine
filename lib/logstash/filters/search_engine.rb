# encoding: utf-8
require "logstash/filters/base"
require "logstash/filters/parsers/bing"
require "logstash/filters/parsers/google"
require "logstash/filters/parsers/yahoo"
require "logstash/filters/utils"
require "logstash/namespace"
require "uri"

# Filter to extract search engine query from HTTP query
class LogStash::Filters::SearchEngine < LogStash::Filters::Base

  #
  # filter {
  #  search_engine {
  #    engines => ["Google", "Bing", "Yahoo"]
  #    site_name_field => "dstname"
  #    query_field => "arg"
  #    output_field => "search_engine_query"
  #  }
  # }
  #
  config_name "search_engine"

  config :engines, :validate => :array, :default => ["Google", "Bing", "Yahoo"]
  config :site_name_field, :validate => :string, :default => "dstname"
  config :query_field, :validate => :string, :default => "arg"
  config :output_field, :validate => :string, :default => "search_engine_query"

  public
  def register
    @queryParsers = {
       "Google" => GoogleQueryParser.new,
       "Bing"   => BingQueryParser.new,
       "Yahoo"  => YahooQueryParser.new
    }
  end

  public
  def filter(event)

    @queryParsers.each do |name, parser|
      if @engines.include?(name) && parser.match(event.get(@site_name_field))
        valid_query_field = Utils.removeInvalidChars(event.get(@query_field))
        event.set(@output_field, parser.parse(URI.decode(valid_query_field)))
      end
    end

    filter_matched(event)
  end
end
