require 'twitter_ebooks'
require 'date'
require 'net/http'
require 'json'
require 'open-uri'


api_key = '8137b65472cffbef8aad8e7270913e01'
temp_cutoff = -10 #the temperature below which will cause the bot to tweet

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = '' # Your app consumer key
    self.consumer_secret = '' # Your app consumer secret

    # Users to block instead of interacting with
    #self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    #oncd a day
    scheduler.every '24h' do

      ### Find the temperature
      pi_key = '8137b65472cffbef8aad8e7270913e01' #api key for weather
      url = 'http://api.openweathermap.org/data/2.5/weather?lat=44.461869&lon=-93.153986&APPID='+api_key  #url for carleton weather
      uri = URI(url)  #convert to url object
      response = Net::HTTP.get(uri) #use the api to get the weather in JSON format
      results = JSON.parse(response)  #parse the responses into a hash object
      temp = (results["main"]["temp_min"]*9/5) − 459.67 #convert into farinheit
      
      ### Tweeting section
      if temp < temp_cutoff #if it is cold enough to tweet
        tweet_String = "Today's low was " + temp + " but classes were still not cancled!" #create the 
        
        ###download the graph
        d = Date.today

        #get a line graph of the temperature of the last 24 hours from the carleton website
        picurl = ("http://weather.carleton.edu/rplot.php?year=#{d.year}&month=#{d.month}&day=#{(d.day-1)}&hour=18&year2=#{d.year}&month2=#{d.month}&day2=#{d.day}&hour2=18&check1=temp&end=end&graphtype=line")
        
        #Download the graph
        File.open('graph.gif', 'wb') do |fo|
          fo.write open(picurl).read 
        end

        #make the tweet with the 
        pictweet(tweet_String,"graph.gif")
      end

      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
    end
  end

  def on_message(dm)
    # Reply to a DM
    # reply(dm, "secret secrets")
  end

  def on_follow(user)
    # Follow a user back
    # follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    # reply(tweet, "oh hullo")
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    # reply(tweet, "nice tweet")
  end

  def on_favorite(user, tweet)
    # Follow user who just favorited bot's tweet
    # follow(user.screen_name)
  end

  def on_retweet(tweet)
    # Follow user who just retweeted bot's tweet
    # follow(tweet.user.screen_name)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("Weatherbot") do |bot|
  bot.access_token = "" # Token connecting the app to this account
  bot.access_token_secret = "" # Secret connecting the app to this account
end