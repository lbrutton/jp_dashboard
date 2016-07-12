class CampaignsController < ApplicationController

  before_action :authenticate_any!

  def show
    
    if params[:start_date] != nil
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])
    end
    
    @campaigns = Campaign.where(user_id: current_user.id)
    
    respond_to do |format|
      format.html
      format.csv { render text: @campaigns.to_csv}
    end
    
  end

end
