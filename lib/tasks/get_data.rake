require 'net/http'
desc "get some data from reporting API and add it to the DB"
task :get_data => :environment do 
	puts "starting task..."
	@data = {
    "token" => "8620634f138131ebdd4a0003b3955d20",
    "filter" => {
    },
    "group_by" => ["date"],
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
    puts "task finished"
end