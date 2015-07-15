require "open-uri"
require "sidekiq/api"

class HomeController < ApplicationController
  BASE_URL = "http://doda.jp/"
  include CrawlerHelper

  def index
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end

  def export
    @companies = Company.all
    @jobs = Job.all
    respond_to do |format|
      format.html
      format.xlsx {send_data RubyExport.export_xlsx @companies, @jobs}
      format.csv {send_data RubyExport.export_csv @companies, @jobs}
    end
  end

  def new
    @list_link_job = []
    @agent = Mechanize.new
    @agent.user_agent_alias = Settings.agent_alias
    home_page = @agent.get BASE_URL
    search_page = @agent.click home_page.at ".kyujin a"
    list_page = @agent.submit search_page.form_with id: "JobSearchTop_clickSearchBtn"
    # list_page = @agent.get "http://doda.jp/DodaFront/View/JobSearchList.action?so=100&tp=1&pic=1&ss=1&ds=0&page=7"
    get_link_job list_page
    save_record
    # @job_array = []
    # @company_array = []
    # @list_link_job.each_with_index do |job, num|
    #   go_page_detail job
    #   @job_array[num] = @hash_job
    #   @company_array[num] = @hash_company
    # end
    # if (@job_array.length == Settings.record_limit && @company_array.length == Settings.record_limit)
    #   puts "Begin save"
    #   begin
    #     ActiveRecord::Base.transaction do
    #       @job_array.zip(@company_array).each do |job, company|
    #         Job.create job
    #         Company.create company
    #       end
    #     end
    #   rescue Exception => e
    #     File.open("crawlerlog.txt", "a+") do |file|
    #       file << "Exception sql #{e} \n---------------------------------------\n"
    #     end
    #   end
    # else
    #   puts "Something got wrong in here #{start_page}"
    # end

    # for i in 1..20
    #   CrawlerWorker.perform_async i
    # end

    # CrawlerWorker1.perform_async
    # CrawlerWorker2.perform_async
    # CrawlerWorker3.perform_async
    # CrawlerWorker4.perform_async
    # CrawlerWorker5.perform_async
    # CrawlerWorker6.perform_async
    # CrawlerWorker7.perform_async
    # CrawlerWorker8.perform_async
    # CrawlerWorker9.perform_async
    # CrawlerWorker10.perform_async
    # CrawlerWorker11.perform_async
    # CrawlerWorker12.perform_async
    # CrawlerWorker13.perform_async
    # CrawlerWorker14.perform_async
    # CrawlerWorker15.perform_async
    # CrawlerWorker16.perform_async
    # CrawlerWorker17.perform_async
    # CrawlerWorker18.perform_async
    # CrawlerWorker19.perform_async
    # CrawlerWorker20.perform_async
  end
end
