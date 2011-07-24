#rack-webconsole

Rack-webconsole is a Rack-based interactive console (à la IRB) in your web
application's frontend. That means you can interact with your application's=
backend from within the browser itself!

**WARNING**: first version will be released on July 25th, documentation is
pending until that date.

To get a clearer idea, you can check out [this video](
http://youtu.be/yKK5J01Dqts?hd=1) showing a live example :)

Rack-webconsole is a Rack middleware designed to be unobtrusive. With Rails 3,
for example, you only have to include the gem in your Gemfile and it already
works. Without any configuration.

Tested with MRI 1.9.2 and ruby-head (1.9.3).

##Install

In your Gemfile:

    gem 'rack-webconsole'

##Usage with Rails 3

If you are using Rails 3, you have no further steps to do. It works! To give
it a try, fire up the Rails server and go to any page, press the ` ` ` key and
the console will show :)

##Usage with Sinatra/Padrino

With Sinatra and Padrino you have to tell your application to use the
middleware:

````ruby
require 'sinatra'
# If you are using Bundler and initializing it from config.ru, you don't have
# to require 'rack/webconsole' manually, otherwise you have to:
require 'rack/webconsole'

class MySinatraApp < Sinatra::Application
  use Rack::Webconsole
  # . . .
end
````

````ruby
class SamplePadrino < Padrino::Application
  use Rack::Webconsole
  # . . .
end
````

And it works! Fire up the server, go to any page and press the ` ` ` key.

##Commands

In the console you can issue whatever Ruby commands you want, except multiline commands. Local variables are kept, so you can get a more IRB-esque feeling.

To reset all local variables, just issue the `reload!` command.

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




