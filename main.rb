require 'rubygems'
require 'sinatra'

set :sessions, true



not_found do
  status 404
  'page not found'
end



get "/" do 
	redirect "/start"
end


get "/start" do
	erb :template
end


post '/start' do
	if  session[:player_name] == ""
		redirect "/start"
  	else
  		redirect "/game"
  	end
end
