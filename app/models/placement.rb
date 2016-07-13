class Placement < ActiveRecord::Base
  belongs_to :user
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |placement|
        csv << placement.attributes.values_at(*column_names)
      end
    end
  end
  
end

