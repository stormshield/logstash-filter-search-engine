# encoding: utf-8
require "logstash/filters/parsers/bing"

describe BingQueryParser do
  parser = BingQueryParser.new

  describe "match site name" do
    it "should match whatever the file extension" do
      country_extensions = ["fr", "com", "eu", "it", "hn", "co"]
      country_extensions.each do |extension|
        expect(parser.match("www.bing.#{extension}")).to be_truthy
      end
    end

    it "should match without www" do
      expect(parser.match("bing.com")).to be_truthy
    end

    it "should not match if not bing" do
      expect(parser.match("ding.com")).to be_falsy
    end
  end

  describe "extract query" do
    it "should not return query when no query" do
      expect(parser.parse("/search?hl=fr")).to be_nil
    end

    it "should not return query when other api" do
        expect(parser.parse("/complete/search?q=kibana")).to be_nil
    end

    it "should return query when no other parameter" do
      expect(parser.parse("/search?q=kibana")).to eq("kibana")
    end

    it "should return query when other parameters afterwards" do
      expect(parser.parse("/search?q=kibana&hl=fr")).to eq("kibana")
    end

    it "should return query when other parameters before" do
      expect(parser.parse("/search?hl=fr&q=kibana")).to eq("kibana")
    end

    it "should return query when anchor" do
      expect(parser.parse("/search?hl=fr&q=kibana#q=toto")).to eq("kibana")
    end

    it "should return query without plus sign when multiple words" do
      expect(parser.parse("/search?hl=fr&q=kibana+4#q=toto")).to eq("kibana 4")
    end
  end
end
