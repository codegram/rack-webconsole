#rack-webconsole

Rack-webconsole is a Rack-based interactive console (à la IRB) in your web
application's frontend. That means you can interact with your application's=
backend from within the browser itself!

Rack-webconsole is a Rack middleware designed to be unobtrusive. With Rails 3,
for example, you only have to include the gem in your Gemfile and it already
works. Without any configuration.

##Install

In your Gemfile:

    gem 'rack-webconsole'

##Usage with Rails 3

If you are using Rails 3, you have no further steps to do. It works! To give
it a try, fire up the Rails server and go to any page, press the `\`` key and
the console will show :)

##Usage with Sinatra

With Sinatra you have to tell your application to use the middleware:

````ruby
require 'sinatra'

class MySinatraApp < Sinatra::Application
  use Rack::Webconsole
  # . . .
end
````

And it works! Fire up the server, go to any page and press the `\`` key.

##Under the hood

Run the test suite by typing:

    rake

You can also build the documentation with the following command:

    rake docs

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Codegram. See LICENSE for details.
