require 'sinatra/base'
require 'json'

class API < Sinatra::Base
  post '/test' do
    request_data = JSON.parse(request.body.read)

    request_data['failed_critical_profiles'].each do |profile|
      profile['controls'].each do |control|
        puts "\n"
        puts "The Control Id is: #{control['id']}"
        
      end
      
    end
    response
  end
end