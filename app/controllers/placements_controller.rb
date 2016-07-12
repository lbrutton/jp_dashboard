class PlacementsController < ApplicationController
  
  before_action :authenticate_any!
  
  def show
    
    if params[:start_date] != nil
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])
    end
    
  end
  
end
