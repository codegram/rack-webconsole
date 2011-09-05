#rack-webconsole [![Build Status](http://travis-ci.org/codegram/rack-webconsole.png)](http://travis-ci.org/codegram/rack-webconsole.png)

Rack-webconsole is a Rack-based interactive console (à la Rails console) in
your web application's frontend. That means you can interact with your
application's backend from within the browser itself!

To get a clearer idea, you can check out this video showing a live example :)

[![YouTube video](http://img.youtube.com/vi/yKK5J01Dqts/0.jpg)](http://youtu.be/yKK5J01Dqts?hd=1)

Rack-webconsole is a Rack middleware designed to be unobtrusive. With Rails 3,
for example, you only have to include the gem in your Gemfile and it already
works. Without any configuration.

Tested with MRI versions 1.8.7, 1.9.2, ruby-head, and JRuby 1.6.3.

**SECURITY NOTE**: From version v0.0.5 rack-webconsole uses a token system to
protect against cross-site request forgery.

##Resources

* [Example video](http://youtu.be/yKK5J01Dqts?hd=1)
* [Documentation](http://rubydoc.info/github/codegram/rack-webconsole)


##Install

In your Gemfile:

```ruby
gem 'rack-webconsole'
```

Rack-webconsole **needs JQuery**. If you are using Rails 3, JQuery is loaded by
default. In case you don't want to use JQuery in your application,
**rack-webconsole can inject it for you** only when it needs it. To do that you
should put this line somewhere in your application (a Rails initializer, or
some configuration file):

```ruby
Rack::Webconsole.inject_jquery = true
```

You can also change the javascript key_code used to start webconsole:

```ruby
 # ` = 96 (default), ^ = 94, ç = 231 ... etc.
Rack::Webconsole.key_code = "231"
```

##Usage with Rails 3

If you are using Rails 3, you have no further steps to do. It works! To give
it a try, fire up the Rails server and go to any page, press the ` ` ` key and
the console will show :)

##Usage with Sinatra/Padrino

With Sinatra and Padrino you have to tell your application to use the
middleware:

```ruby
require 'sinatra'
require 'rack/webconsole'

class MySinatraApp < Sinatra::Application
  use Rack::Webconsole
  # . . .
end

class SamplePadrino < Padrino::Application
  use Rack::Webconsole
  # . . .
end
```

NOTE: If you are using Bundler and initializing it from config.ru, you don't
have to `require 'rack/webconsole'` manually, otherwise you have to.

And it works! Fire up the server, go to any page and press the ` ` ` key.

##Usage with Rails 2

You need to add the following code to an intializer (i.e. config/initializers/webconsole.rb):

```ruby
require 'rack/webconsole'
ActionController::Dispatcher.middleware.insert_after 1, Rack::Webconsole
```

##Commands

In the console you can issue whatever Ruby commands you want, except multiline commands. Local variables are kept, so you can get a more IRB-esque feeling.

* `reload!` resets all local variables
* `request` returns the current page request object

##Under the hood

Run the test suite by typing:

    rake

You can also build the documentation with the following command:

    rake docs

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself we can ignore when we pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Codegram. See LICENSE for details.
