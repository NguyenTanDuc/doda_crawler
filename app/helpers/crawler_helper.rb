require "nokogiri"
require "mechanize"

module CrawlerHelper
  def get_link_job list_page
    @list_link_job += list_page.search("h2.ttl a:first-child").map{|link| link["href"]}
    puts @list_link_job.count
    ##############################
    return if @list_link_job.count >= Settings.record_limit
    ##############################
    unless list_page.link_with(text: Settings.text_jap.next).blank?
      list_page = list_page.link_with(text: Settings.text_jap.next).click
      return get_link_job list_page
    end
  end

  def go_page_detail job
    begin
      agent = Mechanize.new
      agent.user_agent_alias = Settings.agent_alias
      detail_page = agent.get job
      detail_page = agent.click detail_page.at ".tab_btn li a[href$='/-mpsc_sid__10/-tp__1/']"
      @hash_job = Hash.new
      @hash_company = Hash.new
      job_name = detail_page.search ".main_ttl_box p:nth-child(2)"
      company_name = detail_page.search ".main_ttl_box h1"
      inexperience = detail_page.search ".ico_box01 img"
      binding.pry
      inexperience.each do |inexp|
        if inexp.attributes["alt"].text.squish == "未経験歓迎"
          @hash_job[:inexperience] = 1
          break
        end
      end
      @hash_job[:inexperience] ||= 0
      @hash_job[:job_name] = job_name.text.strip
      @hash_company[:company_name] = company_name.text.strip
      job_rows = detail_page.at("div.recruit_box02").search("table tr")
      raw_html = detail_page.search("body").to_html
      raw_html = raw_html.gsub Settings.regex.script, ""
      # @hash_job[:raw_html] = raw_html.squish
      @hash_job[:url] = detail_page.uri
      divide_table_job job_rows

      clr = detail_page.search("dl.clr")
      clr.each do |row|
        case row.search("dt").text.strip
        when Settings.title_jap.address
          @address = row.search("dd").text.strip
          @hash_company[:raw_address] = @address
          address_spliter @address
        when Settings.title_jap.job_type
          binding.pry
          @hash_job[:job_type] = row.search("dd").text.squish.gsub ">", ","
        when Settings.title_jap.category
          binding.pry
          @hash_job[:category] = row.search("dd").text.squish.gsub ">", ","
        end
      end
    rescue => e
      File.open("crawlerlog.txt", "a+") do |file|
        file << "#{e} in url #{job}\n---------------------------------------\n"
      end
      retry
    end
  end

  def divide_table_job job_rows
    job_rows.each do |row|
      col_left = row.at "th"
      col_right = row.at "td"
      case col_left.text.strip
      when Settings.title_jap.job_info
        @hash_job[:job_info] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.requirement
        @hash_job[:requirement] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.work_address
        @hash_job[:work_address] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.work_time
        @hash_job[:work_time] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.salary
        @hash_job[:salary] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.treatment
        @hash_job[:treatment] = make_newline col_right.at(".txt_area").to_html.squish
      when Settings.title_jap.holiday
        @hash_job[:holiday] = make_newline col_right.at(".txt_area").to_html.squish
      end
    end
  end

  def address_spliter address
    replacements = Settings.special_word.number_array
    replacements.each {|replacement| address.gsub!(replacement[0], replacement[1])}

    if address.count("〒") > 1
      unless /^〒(\d+-\d+)\s〒(\d+-\d+)/.match(address).blank?
        return address_spliter address.sub /^〒(\d+-\d+)\s/, ""
      end
      spliter = Settings.regex.address.match(address).to_a
    else
      spliter = Settings.regex.address.match(address).to_a
    end

    spliter = spliter.map{|item| item.nil? ? "" : item.strip}

    postal_code = spliter[1]
    address1 = spliter[2]
    address2 = spliter[3]
    address3 = spliter[4]
    address4 = spliter[5]

    if address4.include? Settings.special_word.divide
      address4 = check_build address4
    end
    if address4.include?(" ＜")
      address4 = check_build2 address4
    end
    address4 = address4.gsub /（[本店|本社|本部|【.*】]*）.*/, ""
    unless /^（.*）/.match(address4).blank?
      address4 = address4.sub "（", ""
      address4 = address4.sub "）", ""
    end
    unless /^(・3スクエア)/.match(address4).blank?
      address3 = address3 + /^(・3スクエア)/.match(address4).to_a[1]
      address4 = address4.sub /^(・3スクエア)/, ""
    end

    if address4.include? "※"
      address4 = address4.sub /※.*/, ""
    end

    if address3.end_with?("Ｆ") || address3.end_with?("B")
      if /-\d+[Ｆ|B]$/.match(address3).blank?
        address4 = /-\d+[Ｆ|B]$/.match(address3).to_a[1] + address4
        address2 = address2.sub /-\d+[Ｆ|B]$/, ""
      end
    end

    if !address4.blank? && address3.blank?
      address3 = address4
      address4 = ""
    end

    @hash_company[:postal_code] = postal_code
    @hash_company[:address1] = address1
    @hash_company[:address2] = address2
    @hash_company[:address3] = address3
    @hash_company[:address4] = address4
  end

  def check_build build_address
    unless Settings.regex.town.match(build_address).blank?
      build_address = build_address.split Settings.special_word.divide
      build_address.first
    else
      if build_address.start_with? Settings.special_word.divide
        build_address = build_address.sub Settings.special_word.divide, ""
      else
        build_address
      end
    end
  end

  def check_build2 build_address
    unless Settings.regex.town.match(build_address).blank?
      build_address = build_address.split "＜"
      build_address.first
    else
      build_address = build_address.sub "＜", ""
    end
  end

  def make_newline stuff
    stuff = stuff.gsub /<p.*?>/, ""
    stuff = stuff.gsub /<\/p>|<\/?br>/, "\n"
  end

  def save_record
    @job_array = []
    @company_array = []
    @list_link_job.each_with_index do |job, num|
      go_page_detail job
      @job_array[num] = @hash_job
      @company_array[num] = @hash_company
    end
    # if (@job_array.length == Settings.record_limit && @company_array.length == Settings.record_limit)
      puts "Begin save"
      begin
        ActiveRecord::Base.transaction do
          @job_array.zip(@company_array).each do |job, company|
            Job.create job
            Company.create company
          end
        end
      rescue Exception => e
        File.open("CrawlerSqlLog.txt", "a+") do |file|
          file << "Exception sql #{e} \n---------------------------------------\n"
        end
      end
    # else
    #   puts "Something got wrong in here when save record"
    # end
  end
end
