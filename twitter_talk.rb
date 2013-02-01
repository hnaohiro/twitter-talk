# -*- coding: utf-8 -*-

require 'tweetstream'
require 'json'
require 'yaml'
require 'pp'
require 'kconv'
require 'facter'
require 'MeCab'

class TwitterTalk
  def initialize()
    @client = init_tweetstream
    @accounts = YAML.load_file('./config/accounts.yaml')
    @mecab = MeCab::Tagger.new('-Oyomi')
  end

  def init_tweetstream
    config = YAML.load_file('./config/twitter.yaml')
    config.each do |key, value|
      TweetStream.send(key + '=', value)
    end
    TweetStream::Client.new
  end

  def run
    @client.userstream do |status|
      # skip if it's retweet
      next if status.text.include?('RT')

      talk(status.text, '@' + status.user.screen_name)
    end
  end

  def softalk(text)
    case Facter.value(:operatingsystem)
    when 'windows'
      system('SofTalk /X:1 /W:"' + Kconv::tosjis(text) + '"')
    when 'Darwin'
      system('saykana "' + text.gsub(' ', '　') + '"')
    end
  end

  def talk(text, screen_name)
    puts "#{text} by #{screen_name}"

    # rid url
    text.gsub!(/https?.+/, '')

    # @screen_name to name
    @accounts.each do |key, value|
      text.gsub!(/#{key}/, value + 'へ')
    end  

    # convert to katakana
    text = mecab.parse(text)

    # split text
    max = 100
    if text.length > max
      softalk(text[0...max])
      softalk(text[max...text.length])
    else
      softalk(text)
    end

    # name
    softalk('ばい')
    if @accounts.has_key?(screen_name) 
      softalk(@accounts[screen_name])
    else
      softalk('だれかさん')
    end
  end
end
