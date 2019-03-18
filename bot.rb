require 'sinatra/base'
require 'json'
require './waiverprofile'

class API < Sinatra::Base
  post '/test' do
    request_data = JSON.parse(request.body.read)

    request_data['failed_critical_profiles'].each do |profile|
      profile_path = "./new_profiles/#{profile['name']}_#{profile['sha256']}"
      new_profile = WaiverProfile.new(profile, 
                                      profile_path, 
                                      "waiver_#{profile['name']}", 
                                      '0.1.0', 
                                      profile['name'], 
                                      'thlunaticscripter', 
                                      './template', 
                                      profile['controls'])
      new_profile.build_profile
    end
    response
  end
end