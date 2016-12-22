# encoding: utf-8
require 'spec_helper'
require "logstash/filters/search_engine"

describe LogStash::Filters::SearchEngine do
  describe "should do nothing if no engine specified" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => []
       }
      }
    CONFIG
    end

    sample("dstname" => "www.google.fr", "arg" => "/search?q=Kibana") do
      expect(subject.get("search_engine_query")).to be_nil
    end
  end

  describe "should do nothing if unknown engine specified" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => ["FakeEngine"]
       }
      }
    CONFIG
    end

    sample("dstname" => "www.google.fr", "arg" => "/search?q=Kibana") do
      expect(subject.get("search_engine_query")).to be_nil
    end
  end

  describe "should extract query from Google search" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => ["Google"]
       }
      }
    CONFIG
    end

    sample("dstname" => "www.google.fr", "arg" => "/search?q=Kibana") do
      expect(subject.get("search_engine_query")).to eq('Kibana')
    end
  end

  describe "should extract query from Bing search" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => ["Bing"]
       }
      }
    CONFIG
    end

    sample("dstname" => "www.bing.fr", "arg" => "/search?q=Kibana") do
      expect(subject.get("search_engine_query")).to eq('Kibana')
    end
  end

  describe "should extract query from Yahoo search" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => ["Yahoo"]
       }
      }
    CONFIG
    end

    sample("dstname" => "fr.search.yahoo.com", "arg" => "/search?p=Kibana") do
      expect(subject.get("search_engine_query")).to eq('Kibana')
    end
  end

  describe "should extract query with encoded parameters" do
    let(:config) do <<-CONFIG
      filter {
       search_engine {
         engines => ["Google", "Bing", "Yahoo"]
       }
      }
    CONFIG
    end

    sample("dstname" => "fr.search.yahoo.com", "arg" => "/search%3Fp%3DKibana%26ie%3Dutf-8%26oe%3Dutf-8%26safe%3Dstrict") do
      expect(subject.get("search_engine_query")).to eq('Kibana')
    end
  end
end
