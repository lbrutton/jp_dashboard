require 'net/http'

desc "get data from API and add to DB for each user"
task :campaign_data_today => :environment do
	puts "starting task..."
	@date = DateTime.now.strftime("%Y-%m-%d").to_s
	puts @date
	def get_data(user)
      api_key_data = {
        "api_key" => user.api_key,
        "email" => user.email
      }.to_json
      api_uri = URI "http://demandapi.bidstalk.com/advertiser/auth"
    	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
    	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    	  request.body = api_key_data
        puts request
    	  http.request request
    	end
    	response_body = JSON.parse response.body
    	puts response_body
    	@token = response_body["data"]["token"]# all the previous lines use the api key to get the token, which is used
    	# for the api calls below
    	data = {
        "token" => @token,
        "filter" => {
        },
        "group_by" => ["campaigns"],# depending on what the user selected in the "placements" check box
        "order_by" => {
          "impressions" => "desc"#could add an option to let the user change this
        },
        "page" => 1,
        "per_page" => 50,#currently set to 10 pages, because the API is too slow to handle much more. Need to 
        #add an option to let the user select the number of pages at his risk
        "start_date" => @date,
        "end_date" => @date
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
      if response_body['messages'] == ["no records found to generate reports."]
        flash[:error] = "No data for this date range"
      else
        body_length = response_body['reports'].length #response_body['reports'] is exactly the same as per_page
        date2 = Date.parse(@date) 
        puts date2#this is kind of a lash-up to get the system to properly find the records by date - will fix later
        Campaign.where(user_id: user.id, day:date2).delete_all
          for i in (0..body_length-1)
        		campaign = Campaign.new(
              name: response_body['reports'][i]['campaigns']['name'],
              day: date2,
          		impressions: response_body['reports'][i]['impressions'].to_i,
          		clicks: response_body['reports'][i]['clicks'].to_i,
          		installs: response_body['reports'][i]['installs'].to_i,
          		cvr: response_body['reports'][i]['cvr'].to_f,
          		ctr: response_body['reports'][i]['ctr'].to_f,
          		user_id: user.id
        		)
        		if Campaign.find_by(name:response_body['reports'][i]['campaigns']['name'])
        		  campaign.cpc = Campaign.find_by(name:response_body['reports'][i]['campaigns']['name']).cpc
        		else
        		  campaign.cpc = 0.2
        		end
        		campaign.save
        		puts campaign.day
      	  end
        end
      end
    for i in (1..User.all.length)
      get_data(User.find(i))
    end
end
