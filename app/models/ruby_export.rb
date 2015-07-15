class RubyExport < ActiveRecord::Base
  def self.export_xlsx companies, jobs
    current_day = Time.now.strftime("%Y/%m/%d")
    @companies = companies
    @jobs = jobs
    book = RubyXL::Workbook.new

    sheet1 = book[0]
    sheet1.sheet_name = "Job"
    sheet1.change_row_fill(0, "737373")
    sheet1.change_row_font_size(0, 11)
    sheet1.change_row_font_color(0, "ffffff")
    sheet1.add_cell(0, 0, "NO") #NO
    sheet1.add_cell(0, 1, "求人ID") #Job.id
    sheet1.add_cell(0, 2, "企業ID") #companies.id
    sheet1.add_cell(0, 3, "N社の企業ID") #null
    sheet1.add_cell(0, 4, "企業名") #companies.name
    sheet1.add_cell(0, 5, "掲載媒体") #"doda"
    sheet1.add_cell(0, 6, "掲載URL") #job.url
    sheet1.add_cell(0, 7, "案件タイトル") #job.titles
    sheet1.add_cell(0, 8, "応募資格") #job.requirement
    sheet1.add_cell(0, 9, "未経験OK") #job.inexperience
    sheet1.add_cell(0, 10, "勤務地") #job.workplace
    sheet1.add_cell(0, 11, "業種") #job.business_category
    sheet1.add_cell(0, 12, "募集職種") #job.job_category
    sheet1.add_cell(0, 13, "仕事内容") #job.content
    sheet1.add_cell(0, 14, "勤務時間") #job.work_time
    sheet1.add_cell(0, 15, "給与") #job.salary
    sheet1.add_cell(0, 16, "休日、休暇") #job.holiday
    sheet1.add_cell(0, 17, "待遇") #job.treatment
    sheet1.add_cell(0, 18, "取得日") #Today
    sheet1.add_cell(0, 19, "掲載期間") #null
    sheet1.add_cell(0, 20, "掲載更新日") #null
    sheet1.add_cell(0, 21, "部署名(その他)") #null
    sheet1.add_cell(0, 22, "業種カテゴリー") #null
    sheet1.add_cell(0, 23, "業種サブカテゴリー") #null
    sheet1.add_cell(0, 24, "郵便番号") #companies.postal_code
    sheet1.add_cell(0, 25, "都道府県") #address1
    sheet1.add_cell(0, 26, "市区町村番地") #address2+3
    sheet1.add_cell(0, 27, "ビル名") #address4
    sheet1.add_cell(0, 28, "電話番号") #companies.tel
    sheet1.add_cell(0, 29, "採用担当部署") #null
    sheet1.add_cell(0, 30, "採用担当者") #null
    sheet1.add_cell(0, 31, "メールアドレス") #null
    sheet1.add_cell(0, 32, "URL") #null
    sheet1.add_cell(0, 33, "企業業種") #null
    sheet1.add_cell(0, 34, "事業内容") #null
    sheet1.add_cell(0, 35, "従業員数") #null
    sheet1.add_cell(0, 36, "売上高") #null
    sheet1.add_cell(0, 37, "設立年") #null

    for i in 0..4
      sheet1[0][i].change_fill("000000")
    end

    for i in 5..6
      sheet1[0][i].change_fill("1155CC")
    end

    for i in 7..17
      sheet1[0][i].change_fill("990000")
    end

    for i in 18..20
      sheet1[0][i].change_fill("134F5C")
    end

    for i in 21..37
      sheet1[0][i].change_fill("351C75")
    end

    @jobs.each_with_index do |job, num|
      sheet1.add_cell(num + 1, 0, num + 1)
      sheet1.add_cell(num + 1, 1, job.id)
      sheet1.add_cell(num + 1, 2, @companies[num].id)
      sheet1.add_cell(num + 1, 3, "")
      sheet1.add_cell(num + 1, 4, @companies[num].company_name)
      sheet1.add_cell(num + 1, 5, "doda")
      sheet1.add_cell(num + 1, 6, job.url)
      sheet1.add_cell(num + 1, 7, job.job_name)
      sheet1.add_cell(num + 1, 8, job.requirement)
      sheet1.add_cell(num + 1, 9, job.inexperience? ? "◯" : "")
      sheet1.add_cell(num + 1, 10, job.work_address)
      sheet1.add_cell(num + 1, 11, job.category)
      sheet1.add_cell(num + 1, 12, job.job_type)
      sheet1.add_cell(num + 1, 13, job.job_info)
      sheet1.add_cell(num + 1, 14, job.work_time)
      sheet1.add_cell(num + 1, 15, job.salary)
      sheet1.add_cell(num + 1, 16, job.holiday)
      sheet1.add_cell(num + 1, 17, job.treatment)
      sheet1.add_cell(num + 1, 18, current_day)
      sheet1.add_cell(num + 1, 19, "")
      sheet1.add_cell(num + 1, 20, "")
      sheet1.add_cell(num + 1, 21, "")
      sheet1.add_cell(num + 1, 22, "")
      sheet1.add_cell(num + 1, 23, "")
      sheet1.add_cell(num + 1, 24, @companies[num].postal_code)
      sheet1.add_cell(num + 1, 25, @companies[num].address1)
      sheet1.add_cell(num + 1, 26, @companies[num].address2 + @companies[num].address3)
      sheet1.add_cell(num + 1, 27, @companies[num].address4)
      sheet1.add_cell(num + 1, 28, "")
      sheet1.add_cell(num + 1, 29, "")
      sheet1.add_cell(num + 1, 30, "")
      sheet1.add_cell(num + 1, 31, "")
      sheet1.add_cell(num + 1, 32, "")
      sheet1.add_cell(num + 1, 33, "")
      sheet1.add_cell(num + 1, 34, "")
      sheet1.add_cell(num + 1, 35, "")
      sheet1.add_cell(num + 1, 36, "")
      sheet1.add_cell(num + 1, 37, "")
    end

    ###############################

    book.add_worksheet("Company")
    sheet2 = book[1]
    sheet2.change_row_font_size(0, 11)
    sheet2.change_row_font_color(0, "ffffff")
    sheet2.add_cell(0, 0, "企業ID")
    sheet2.add_cell(0, 1, "取得日")
    sheet2.add_cell(0, 2, "企業名")
    sheet2.add_cell(0, 3, "業種カテゴリー")
    sheet2.add_cell(0, 4, "業種サブカテゴリー")
    sheet2.add_cell(0, 5, "郵便番号")
    sheet2.add_cell(0, 6, "都道府県")
    sheet2.add_cell(0, 7, "市区町村番地")
    sheet2.add_cell(0, 8, "ビル名")
    sheet2.add_cell(0, 9, "電話番号")
    sheet2.add_cell(0, 10, "採用担当部署")
    sheet2.add_cell(0, 11, "採用担当者")
    sheet2.add_cell(0, 12, "メールアドレス")
    sheet2.add_cell(0, 13, "URL")
    sheet2.add_cell(0, 14, "従業員数")
    sheet2.add_cell(0, 15, "売上高")
    sheet2.add_cell(0, 16, "設立年")
    sheet2.change_row_fill(0, "666666")

    @companies.each_with_index do |company, num|
      sheet2.add_cell(num + 1, 0, company.id)
      sheet2.add_cell(num + 1, 1, current_day)
      sheet2.add_cell(num + 1, 2, company.company_name)
      sheet2.add_cell(num + 1, 3, "")
      sheet2.add_cell(num + 1, 4, "")
      sheet2.add_cell(num + 1, 5, company.postal_code)
      sheet2.add_cell(num + 1, 6, company.address1)
      sheet2.add_cell(num + 1, 7, company.address2 + company.address3)
      sheet2.add_cell(num + 1, 8, company.address4)
      sheet2.add_cell(num + 1, 9, "")
      sheet2.add_cell(num + 1, 10, "")
      sheet2.add_cell(num + 1, 11, "")
      sheet2.add_cell(num + 1, 12, "")
      sheet2.add_cell(num + 1, 13, "")
      sheet2.add_cell(num + 1, 14, "")
      sheet2.add_cell(num + 1, 15, "")
      sheet2.add_cell(num + 1, 16, "")
    end
    book.stream.string
  end

  def self.export_csv companies, jobs
    current_day = Time.now.strftime("%Y/%m/%d")
    CSV.generate do |csv|
      csv << ["NO", "Jobs Id", "Companies Id", "Companies name", "doda", "Job url", "Job title", "Job requirement",
        "Job workplace", "Business category", "Job category", "Job content", "Job worktime", "Job salary",
        "Holiday", "Treatment", "Today", "Postal code", "Address 1", "Address 2 + 3", "Address 4", "Tel"]

      jobs.each_with_index do |job, num|
        csv << [num + 1, job.id, companies[num].id, companies[num].company_name, "doda",
                job.url, job.job_name, job.requirement, job.work_address, job.category,
                job.job_type, job.job_info, job.work_time, job.salary, job.holiday,
                job.treatment, current_day, companies[num].postal_code, companies[num].address1,
                companies[num].address2 + companies[num].address3, companies[num].address4]
      end
    end
  end
end