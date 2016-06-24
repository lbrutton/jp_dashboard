class CampaignsController < ApplicationController
    
    def show
        Campaign.all.each do |campaign|
            campaign.cpc = 0.2
            campaign.spend = (campaign.clicks * 0.2).round(2)
            campaign.ecpi = ((campaign.clicks * 0.2)/campaign.installs).round(2)
            campaign.save
        end
        flash[:cpc] = 0
    end
    
    def update
        render 'campaigns/show'
    end
    
end
