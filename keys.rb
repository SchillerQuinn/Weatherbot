class Keychain
	@@weather_api_key = '8137b65472cffbef8aad8e7270913e01' #api for openweather.org
	@@consumer_key = 'FDVI0dRPqNeMjiBHDqvPmWv4U' # Your app consumer key
	@@consumer_secret = 'pbWExeos0fG5KjxPC3Kl17ww5uKbgA8GNjgcWGHc7vErv9fU8H' # Your app consumer secret
	@@access_token = "771363203091619843-yYHD0qjeO7iyW0ClBVKVIDiUnt0rl28" # Token connecting the app to this account
	@@access_token_secret = "y4h6Dsj2eqBu4kxudiC2tVH5LKz8R3BjvEF7VntTQXgkC" # Secret connecting the app to this account

	def weather_api_key #method for accessing weather_api_key
		@@weather_api_key
	end

	def consumer_key #method for accessing consumer_key
		@@consumer_key
	end

	def consumer_secret #method for accessing consumer_key
		@@consumer_secret
	end

	def access_token #method for accessing access_token
		@@access_token
	end

	def access_token_secret #method for accessing access_token_secret
		@@access_token_secret
	end
end