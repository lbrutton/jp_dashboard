class AddAttributesToPlacements < ActiveRecord::Migration
  def change
    
    add_column :placements, :impressions, :integer
    add_column :placements, :clicks, :integer
    add_column :placements, :installs, :integer
    add_column :placements, :cpc, :float
    add_column :placements, :spend, :float
    add_column :placements, :ecpi, :float
    add_column :placements, :budget, :integer
    add_column :placements, :cvr, :float
    add_column :placements, :ctr, :float
    add_column :placements, :CPM, :float
    add_column :placements, :day, :date
    add_column :placements, :user_id, :integer
    
  end
end
