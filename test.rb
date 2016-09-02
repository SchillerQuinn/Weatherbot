require 'date'
require 'net/http'
require 'json'
require 'open-uri'
require_relative './keys.rb'
$key = Keychain. new #make an instance of the keychain class that holds the keys

url = "http://api.openweathermap.org/data/2.5/weather?lat=44.461869&lon=-93.153986&units=imperial&APPID=#{$key.weather_api_key}"  #url for carleton weather
uri = URI(url)  #convert to url object
response = Net::HTTP.get(uri) #use the api to get the weather in JSON format
results = JSON.parse(response)  #parse the responses into a hash object
puts(results)
wind = results["wind"]["speed"]
temp = (results["main"]["temp_min"]) #get temperature
windChillTemp = (34.74) + (0.6215*temp) - (34.75*(wind**0.16)) + (0.4275*temp*(wind**0.16))
puts(temp)
puts(windChillTemp)