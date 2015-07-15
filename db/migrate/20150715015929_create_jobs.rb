class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :company, index: true, foreign_key: true
      t.string :job_name
      t.text :work_address
      t.string :category
      t.string :job_type
      t.text :job_info
      t.text :requirement
      t.integer :inexperience, limit: 2
      t.text :work_time
      t.text :salary
      t.text :holiday
      t.text :treatment
      t.string :capture_path
      t.text :raw_html
      t.string :url
      t.datetime :update_time
      t.datetime :register_time

      t.timestamps null: false
    end
  end
end
