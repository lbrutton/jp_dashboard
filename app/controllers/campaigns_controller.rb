require 'rake'
require 'net/http'
class CampaignsController < ApplicationController

    def show
        Campaign.all.each do |campaign|
            campaign.cpc = 0.2 #this is hard coded for now - need to allow this value to be changed from the admin
            campaign.spend = (campaign.clicks * 0.2).round(2)
            campaign.ecpi = ((campaign.clicks * 0.2)/campaign.installs).round(2)
            campaign.save
        end
    end
    
    def update
        
        @start_date = params[:start_date]
        @end_date = params[:end_date] #getting the start date from the params in the form on the show page. Need validations here,
        # maybe using activemodel?
        if params[:placements] == "1" #if the "placements" checkbox is checked, group the API call by 'apps'
            @group_by = "apps"
        else
            @group_by = "campaigns"
        end
        
        def get_data(date_range,group_by)
            Campaign.delete_all #wipe the db clean before refilling it
            api_key_data = {
	        "api_key" => "811c0107d1e9c801edc3aed133be9b0d", # all of this info is currently hardcoded - needs to be dependant on 
	        # the user who's logged in
	        "email" => "bear@8crops.com"
	        }.to_json
	        api_uri = URI "http://demandapi.bidstalk.com/advertiser/auth"
        	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
        	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
        	  request.body = api_key_data
              puts request
        	  http.request request
        	end
        	response_body = JSON.parse response.body
        	#puts response_body
        	@token = response_body["data"]["token"]# all the previous lines use the api key to get the token, which is used
        	# for the api calls below
        	data = {
            "token" => @token,
            "filter" => {
            },
            "group_by" => [@group_by],# depending on what the user selected in the "placements" check box
            "order_by" => {
                "impressions" => "desc"#could add an option to let the user change this
                },
              "page" => 1,
              "per_page" => 10,#currently set to 10 pages, because the API is too slow to handle much more. Need to 
              #add an option to let the user select the number of pages at his risk
            "start_date" => @start_date,
            "end_date" => @end_date
            }.to_json
            #puts data
        	api_uri = URI "http://demandapi.bidstalk.com/advertiser/reports"
        	#puts api_uri
        	response = Net::HTTP.start(api_uri.host, api_uri.port, :read_timeout => 500) do |http|
        	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
        	  request.body = data
              puts request
        	  http.request request
        	end
            response_body = JSON.parse response.body# all the previous lines use the token, the info added by the user, and 
            # some hardcodecd values, to get the the data from the api and put it in the response_body variable
            puts response_body # useful for debugging - check the terminal where the server is running to see what's coming 
            #through
            body_length = response_body['reports'].length #response_body['reports'] is exactly the same as per_page
            if @group_by == "apps" # could be a much better way of doing this - currently checking the value of group_by,
            # and parsing the data accordingly
                for i in (0..body_length-1)
            		Campaign.create(name: response_body['reports'][i]['apps']['name'],
            		impressions: response_body['reports'][i]['impressions'].to_i,
            		clicks: response_body['reports'][i]['clicks'].to_i,
            		installs: response_body['reports'][i]['installs'].to_i,
            		cvr: response_body['reports'][i]['cvr'].to_f,
            		ctr: response_body['reports'][i]['ctr'].to_f
            		)
                end
            else
                for i in (0..body_length-1)
            		Campaign.create(name: response_body['reports'][i]['campaigns']['name'],
            		impressions: response_body['reports'][i]['impressions'].to_i,
            		clicks: response_body['reports'][i]['clicks'].to_i,
            		installs: response_body['reports'][i]['installs'].to_i,
            		cvr: response_body['reports'][i]['cvr'].to_f,
            		ctr: response_body['reports'][i]['ctr'].to_f
            		)
            		end
            end
            
        end
        
        get_data(@date_range,@group_by) # run the get_data function using the date range and group by selection decided by the user
        
        redirect_to action: "show" # redirect to the show action, so it can calculate the financials based on the set CPC rate etc
        
    end
    
end
