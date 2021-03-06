class Composer < ApplicationRecord
  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/sqlite3_adapter'

  has_many :composings
  has_many :works, through: :composings
  
  def self.my_import(file)
    composers = []
    CSV.foreach(file.path, headers: true) do |row|
      row[5] = Date.strptime(row[5], '%m/%d/%Y').to_datetime
      row[6] = Date.strptime(row[6], '%m/%d/%Y').to_datetime
      composers << Composer.new(row.to_h)
    end
    Composer.import composers, recursive: true
  end

  def next
    Composer.where("id > ?", id).first
  end
  
  def prev
    Composer.where("id < ?", id).last
  end
end
