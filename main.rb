require 'rubygems'
require 'sinatra'

set :sessions, true

class Card 

  def initialize (suit, face, hidden = false)
    @suit = suit
    @face = face
    @hidden = hidden
  end
 
  def value
    card_value = @face.to_i
    if @face == "A"
      card_value = 11
    end
    if card_value == 0
      card_value = 10
    end
    card_value
  end

  def hidden?
    @hidden
  end

  def hide
    @hidden = true
  end

  def show
    @hidden = false
  end

  def to_s
    #build user friendly string of the Card instance
    suits = {"S" => "Spades", "H" => "Hearts", "D" => "Diamonds", "C" => "Clubs"}
    faces = {"A" => "Ace", "2" => "Two", "3" => "Three", "4"=> "Four",
             "5" => "Five", "6" => "Six", "7" => "Seven", "8" => "Eight",
             "9" => "Nine", "10" => "Ten", "J" => "Jack", "Q" => "Queen", "K" => "King"}
    unless @hidden
      return "#{faces[@face]} of #{suits[@suit]}"
    else
      return "hidden card"
    end
  end

  def show_picture
    #build user friendly string of the Card instance
    suits = {"S" => "spades", "H" => "hearts", "D" => "diamonds", "C" => "clubs"}
    faces = {"A" => "ace", "J" => "jack", "Q" => "queen", "K" => "king"}
    faces[@face] = @face if faces.has_key?(@face) == false
        
    unless @hidden
      image =  "#{suits[@suit]}_#{faces[@face]}"
    else
      image =  "cover"
    end
    "<img src=\"images/cards/#{image}.jpg\" alt=\"#{self.to_s}\" title=\"#{self.to_s}\" class=\"cards\"  >"

  end

end
helpers do
	def score(this_hand)
    	total_score = 0
    	aces = 0
    	this_hand.each do |card|
        	total_score += card.value
        	aces += 1 if card.value == 11
    	end
    	while total_score > 21 && aces > 0
      		total_score -= 10
      		aces -= 1   
    	end
    	
    	return total_score
  	end  

	def check_win 
		if (score(session[:player_hand])) == 21 
			if (score(session[:dealer_hand])) == 21
				return session[:winner] = "Draw"
			else
				return session[:winner] = (session[:player_name])
			end
		
		elsif (score(session[:dealer_hand])) == 21
			return session[:winner] = "Dealer"
		elsif (score(session[:player_hand])) > 21
			return session[:winner] = "Dealer"
		elsif (score(session[:dealer_hand])) > 21
      return session[:winner] = (session[:player_name])
		end
	end

  def show_pic hand
    hand.each do |card|

      (card.to_s).show_picture
    end
  end




end



not_found do
  status 404
  'page not found'
end



get "/" do 
	redirect "/start"
end


get "/start" do
  session[:money] = 500
  session[:char_error] = nil
	erb :name
end


post '/start' do
	
	if params['player_name'].empty?
    session[:char_error] = "bad"

		erb :name
  elsif params['player_name'].match(/^[[:alpha:]]+$/) == nil
    session[:char_error] = "bad"

    erb :name
    
	else
		session[:player_name] = params['player_name']
		redirect "/bet"
	end

end

get "/bet" do
  session[:winner] = nil
  session[:bet_state] = nil
  erb :bet

end

post "/bet" do
  if params['current_bet'].to_i < 1
    puts "working"
    session[:bet_state] = "bad"
    erb :bet
  elsif params['current_bet'].to_i > session[:money]
    erb :bet
  else
    session[:current_bet] = params['current_bet'].to_i
    puts session[:money]
    redirect "/game"
  end
end


get '/game' do
  session[:mode] = nil
	session[:winner] = nil
	session[:cards] = []

    suits = %w(S H C D)
    faces = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    suits.each do |suit|
     faces.each do |face|
     session[:cards] << Card.new(suit,face,false)
     end
    end
    session[:cards].shuffle!
	session[:player_hand] = []
	session[:dealer_hand] = []
	session[:player_points] = 0
	session[:dealer_points] = 0
	session[:player_hand].push(session[:cards].pop)
	session[:player_hand].push(session[:cards].pop)
	session[:dealer_hand].push(session[:cards].pop)
	session[:dealer_hand].push(session[:cards].pop)
	erb :game
end

post "/game" do
  session[:player_hand].push(session[:cards].pop)
  erb :game, layout: false
end

post "/stay" do
  session[:mode] = "stay"
  
  if score(session[:dealer_hand]) > score(session[:player_hand])
  else  
    while score(session[:dealer_hand]) < 17
      if score(session[:dealer_hand]) > score(session[:player_hand])
        break
      end
      session[:dealer_hand].push(session[:cards].pop)
    end
  end

  if score(session[:dealer_hand]) > score(session[:player_hand])
    session[:winner] = "Dealer"
  elsif score(session[:dealer_hand]) == score(session[:player_hand])
    session[:winner] = "Both players"

    
  else
    session[:winner] = session[:player_name]
  end
   erb :game, layout: false
end

get "/thanks" do
  erb :thanks
end
