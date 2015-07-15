class ExportCsv < ActiveRecord::Base
  def self.to_csv companies, jobs
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
      # csv << [I18n.t(:correct), I18n.t(:word)]
      # all.each do |item|
      #   csv << [item.word_correct, item.word.content]
      # end
      # csv << [I18n.t(:total), all.word_correct.count.to_s + I18n.t(:per_20)]
    end
  end
end