require 'net/http'
desc "get some data from reporting API and add it to the DB"
task :get_data => :environment do 
	puts "starting task..."
	@data = {
    "token" => "",
    "filter" => {
    },
    "group_by" => ["campaigns"],
    "order_by" => {
        "impressions" => "desc"
        },
      "page" => 1,
    "start_date" => "2016-06-01",
    "end_date" => "2016-06-08"
    }.to_json
  puts @data
	api_uri = URI "http://demandapi.bidstalk.com/advertiser/reports"
	puts api_uri
	response = Net::HTTP.start(api_uri.host, api_uri.port) do |http|
	  request = Net::HTTP::Post.new(api_uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	  request.body = @data
      puts request
	  http.request request
	end
    puts response
    response_body = JSON.parse response.body
    puts response_body
    body_length = response_body.length
    for i in (0..body_length-1)
			Campaign.create(name: response_body['reports'][i]['campaigns']['name'])
			puts response_body['reports'][i]['campaigns']['name']
		end
    puts "task finished"
end