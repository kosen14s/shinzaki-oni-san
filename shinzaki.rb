require 'slack-ruby-client'
require 'dotenv'
require 'natto'

Dotenv.load

Slack.configure do |conf|
  conf.token = ENV['SLACK_TOKEN']
end

mecab = Natto::MeCab.new
client = Slack::RealTime::Client.new

client.on :hello do
  puts 'connected!'
end

client.on :message do |data|
  text = data['text']
  if text&.include?('力')
    words = []
    skill = ''

    mecab.parse(text) do |word|
      words << word.surface
    end

    words.each_with_index.reverse_each do |word, i|
      skill = words[i-1] if word == '力'
    end

    message = "#{skill}力ぅ…ですかねぇ… "
    client.message channel: data['channel'], text: message
  end
end

client.start!
