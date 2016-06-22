require 'net/http'
desc "get some data from reporting API and add it to the DB"
task :get_data => :environment do 
	puts "starting task..."
	api_key_data = {
	    "api_key" => "811c0107d1e9c801edc3aed133be9b0d",
	    "email" => "bear@8crops.com"
	}.to_json
	puts api_key_data
	api_uri = URI "http://demandapi.bidstalk.com/advertiser/auth"
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	  request.body = api_key_data
      puts request
	  http.request request
	end
	response_body = JSON.parse response.body
	puts response_body
	token = response_body["data"]["token"]
	puts token
	data = {
    "token" => token,
    "filter" => {
    },
    "group_by" => ["campaigns"],
    "order_by" => {
        "impressions" => "desc"
        },
      "page" => 1,
    "start_date" => "2016-05-01",
    "end_date" => "2016-05-20"
    }.to_json
  puts data
	api_uri = URI "http://demandapi.bidstalk.com/advertiser/reports"
	puts api_uri
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	  request.body = data
      puts request
	  http.request request
	end
    puts response
    response_body = JSON.parse response.body
    Rake::Task['db:reset'].invoke
    puts response_body
    body_length = response_body.length
    for i in (1..body_length)
		Campaign.create(name: response_body['reports'][i]['campaigns']['name'],
		impressions: response_body['reports'][i]['impressions'].to_i,
		clicks: response_body['reports'][i]['clicks'].to_i,
		installs: response_body['reports'][i]['installs'].to_i,
		cpc: response_body['reports'][i]['cpc'].to_f,
		cvr: response_body['reports'][i]['cvr'].to_f,
		ctr: response_body['reports'][i]['ctr'].to_f
		)
	end
    puts "task finished"
end