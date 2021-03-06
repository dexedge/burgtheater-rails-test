# Based on https://medium.com/@amanahluwalia/uploading-massive-csvs-into-rails-using-active-record-import-8f382d06cea1
# Uses activerecord-import
# The CSV file must have headers matching the field names in the Rails database. Filemaker date formats are converted to Rails dates, and the fields for the timestamps are converted to datetime.

class Event < ApplicationRecord
  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/sqlite3_adapter'

  has_many :performances
  has_many :works, through: :performances

  def self.my_import(file)
    events = []
    CSV.foreach(file.path, headers: true) do |row|
      row[1] = Date.strptime(row[1], '%m/%d/%Y')
      row[7] = Date.strptime(row[7], '%m/%d/%Y').to_datetime
      row[8] = Date.strptime(row[8], '%m/%d/%Y').to_datetime
      events << Event.new(row.to_h)
    end
    Event.import events, recursive: true
  end

  def next
    Event.where("id > ?", id).first
  end
  
  def prev
    Event.where("id < ?", id).last
  end
end
