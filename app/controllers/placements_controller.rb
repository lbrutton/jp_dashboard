class PlacementsController < ApplicationController
  
  before_action :authenticate_any!
  
  def show
    
    if params[:start_date] != nil
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])
    end
    
    Campaign.all.each do |campaign|
      campaign.cpc = 0.2 #this is hard coded for now - need to allow this value to be changed from the admin
      campaign.spend = (campaign.clicks * 0.2).round(2)
      campaign.ecpi = ((campaign.clicks * 0.2)/campaign.installs).round(2)
      campaign.save
    end
    
  end
  
end
