
twitter-talk
==========

Description
-----------

ホームタイムラインのツイートを読み上げます。 

Requirements
-----------

* [tweetstream](https://github.com/intridea/tweetstream)

     `gem install tweetstream`

* facter

    `gem install facter`

* mecab, mecab-ruby

* 読み上げソフト

    Windows: [SofTalk](http://www35.atwiki.jp/softalk/)

    Mac: [SayKana](http://www.a-quest.com/quickware/saykana/)


Usage
-----------

config/twitter.yamlにTwitter OAuthで必要な情報を入力してから

`./main.rb`

