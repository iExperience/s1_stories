require 'rest-client'
require 'json'

require_relative 'story'
require_relative 'petition'
require_relative 'reddit_story'

# greet the user
puts "Hello! Welcome to Stories!"

# ask the user what they want to see, given options:
# 1. top petitions
# 2. top reddit stories
puts "What would you like to see? Choose from options (enter number):"
puts "1. Open Petitions"
puts "2. Top Reddit Stories"

choice = gets.strip
# get & store the user choice

#petitions = []
#reddit_stories = []
stories = []

# if user chose petitions
if (choice == "1")
	# get the petitions from data.gov
	# print out 5 petitions
	puts "Loading open petitions..."
	response = RestClient.get("https://api.whitehouse.gov/v1/petitions.json" + 
		"?limit=5&status=open")
	parsed_response = JSON.parse(response)
	petition_hashes = parsed_response["results"]

	petition_hashes.each do |petition_hash|
		petition = Petition.new(petition_hash["title"], petition_hash["url"])
		stories << petition
	end
elsif (choice == "2")
	# else if user chose reddit stories
	# get the reddit stories from reddit.com
	# print out 5 stories
	puts "Loading Reddit top stories..."
	response = RestClient.get("http://reddit.com/top.json?limit=5")
	parsed_response = JSON.parse(response)
	story_hashes = parsed_response['data']['children']

	story_hashes.each do |story_hash|
		reddit_story = RedditStory.new(story_hash['data']['title'], story_hash['data']['url'])
		stories << reddit_story
	end
else
	puts "Invalid Selection."
end


stories.each_with_index do |story, index|
	puts "#{index+1}. #{story.title} [#{story.url}]"
end
