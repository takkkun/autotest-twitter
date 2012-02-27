What is autotest-twitter
========================

This gem sends to Twitter a result of your testing.

Installation
------------

Add this line to your application's Gemfile:

    gem 'autotest-twitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autotest-twitter

Usage
-----

First, please write configuration to ~/.autotest or .autotest in project directroy.

    require 'autotest-twitter'

    Autotest::Twitter.configure do |config|
      # The following settings is required
      config.consumer_key       = 'your consumer key'
      config.consumer_secret    = 'your consumer secret'
      config.oauth_token        = 'your access token'
      config.oauth_token_secret = 'your access token secret'

      # The following settings is optional
      config.label     = 'any project'
      config.image_dir = 'path/to/images'
    end

So please autotest.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
