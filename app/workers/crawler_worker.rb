require "mechanize"
require "nokogiri"

class CrawlerWorker
  include Sidekiq::Worker
  include CrawlerHelper

  def perform class_num
    step = (Settings.record_limit.to_i / 50)
    start_page = (Settings.start_from_record.to_i / 50) + (class_num - 1) * step + 1
    @list_link_job = []
    agent = Mechanize.new
    agent.user_agent_alias = Settings.agent_alias
    list_page = agent.get "http://doda.jp/DodaFront/View/JobSearchList.action?so=50&tp=1&pic=1&ds=0&page=#{start_page}"
    get_link_job list_page
    save_record
  end
end