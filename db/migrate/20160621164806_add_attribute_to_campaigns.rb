class AddAttributeToCampaigns < ActiveRecord::Migration
  def change
    
    add_column :campaigns, :impressions, :integer
    add_column :campaigns, :clicks, :integer
    add_column :campaigns, :installs, :integer
    add_column :campaigns, :cpc, :float
    add_column :campaigns, :spend, :float
    add_column :campaigns, :ecpi, :float
    add_column :campaigns, :budget, :integer
    
  end
end
