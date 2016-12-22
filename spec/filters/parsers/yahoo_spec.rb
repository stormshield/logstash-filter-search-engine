# encoding: utf-8
require "logstash/filters/parsers/yahoo"

describe YahooQueryParser do
  parser = YahooQueryParser.new

  describe "match site name" do
    it "should match whatever the file extension" do
      country_extensions = ["fr", "com", "eu", "it", "hn", "co"]
      country_extensions.each do |extension|
        expect(parser.match("#{extension}.search.yahoo.#{extension}")).to be_truthy
      end
    end

    it "should match without country prefix" do
      expect(parser.match("search.yahoo.com")).to be_truthy
    end

    it "should not match if not yahoo" do
      expect(parser.match("search.yaboo.com")).to be_falsy
    end
  end

  describe "extract query" do
    it "should not return query when no query" do
      expect(parser.parse("/search?hl=fr")).to be_nil
    end

    it "should not return query when other api" do
        expect(parser.parse("/complete/search?p=kibana")).to be_nil
    end

    it "should return query when no other parameter" do
      expect(parser.parse("/search?p=kibana")).to eq("kibana")
    end

    it "should return query when other parameters afterwards" do
      expect(parser.parse("/search?p=kibana&hl=fr")).to eq("kibana")
    end

    it "should return query when other parameters before" do
      expect(parser.parse("/search?hl=fr&p=kibana")).to eq("kibana")
    end

    it "should return query when anchor" do
      expect(parser.parse("/search?hl=fr&p=kibana#p=toto")).to eq("kibana")
    end

    it "should return query without plus sign when multiple words" do
      expect(parser.parse("/search?hl=fr&p=kibana+4#p=toto")).to eq("kibana 4")
    end
  end
end
