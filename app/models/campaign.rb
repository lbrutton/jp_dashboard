class Campaign < ActiveRecord::Base
  belongs_to :user
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |campaign|
        csv << campaign.attributes.values_at(*column_names)
      end
  end
    
  end
  
end
