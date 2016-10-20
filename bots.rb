require 'twitter_ebooks'
require 'date'
require 'net/http'
require 'json'
require 'open-uri'
require_relative './keys.rb'
$key = Keychain. new #make an instance of the keychain class that holds the keys

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = $key.consumer_key # Your app consumer key
    self.consumer_secret = $key.consumer_secret # Your app consumer secret
    temp_cutoff = -10 #the temperature below which will cause the bot to tweet

    # Users to block instead of interacting with
    #self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    #oncd a day
    puts("The bot is active")
    scheduler.cron '00 23 * * *' do # See https://github.com/jmettraux/rufus-scheduler
      ### Find the temperature
      url = "http://api.openweathermap.org/data/2.5/weather?lat=44.461869&lon=-93.153986&units=imperial&APPID=#{$key.weather_api_key}"  #url for carleton weather
      uri = URI(url)  #convert to url object
      response = Net::HTTP.get(uri) #use the api to get the weather in JSON format
      results = JSON.parse(response)  #parse the responses into a hash object
      temp = (results["main"]["temp_min"]) #get temperature
      wind = (results["wind"]["speed"])
      
      windChillTemp = (34.74) + (0.6215*temp) - (34.75*(wind**0.16)) + (0.4275*temp*(wind**0.16)) #convert temperature to windchill
      
      #remove some decimals 
      temp = (temp * 10).floor / 10
      windChillTemp = (windChillTemp * 10).floor / 10
      puts(temp)
      puts(windChillTemp)
      ### Tweeting section
      #if temp < temp_cutoff #if it is cold enough to tweet
      tweet_String = "Today's low was #{windChillTemp}. Classes were not canceled." #create the 
      
      ###download the graph
      d = Date.today

      #get a line graph of the temperature of the last 24 hours from the carleton website
      picurl = ("http://weather.carleton.edu/rplot.php?year=#{d.year}&month=#{d.month}&day=#{(d.day-1)}&hour=17&year2=#{d.year}&month2=#{d.month}&day2=#{d.day}&hour2=17&check1=temp&end=end&graphtype=line")
      
      #Download the graph
      File.open('graph.gif', 'wb') do |fo|
        fo.write open(picurl).read 
      end

      #make the tweet with the 
      pictweet(tweet_String,"graph.gif")
      #end

      # Tweet something every 24 hours
    end
  end

  def on_message(dm)
    # Reply to a DM
    reply(dm, "I'm a bot what did you think would happen?")
  end

  def on_follow(user)
    # Follow a user back
    follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    reply(tweet, "B)")
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    # reply(tweet, "nice tweet")
  end

  def on_favorite(user, tweet)
    # Follow user who just favorited bot's tweet
    follow(user.screen_name)
  end

  def on_retweet(tweet)
    # Follow user who just retweeted bot's tweet
    follow(tweet.user.screen_name)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("Weatherbot") do |bot|
  bot.access_token = $key.access_token # Token connecting the app to this account
  bot.access_token_secret = $key.access_token_secret # Secret connecting the app to this account
end
