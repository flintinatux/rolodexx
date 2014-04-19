# rolodexx

A simple Rails/Backbone contact manager that uses [Brunch](http://brunch.io) to compile assets.

## How to use it

It's hosted live [here on Heroku](http://rolodexx.herokuapp.com/), but if you want to check it out and run it locally, you can do something like this:
```
$ git clone git@github.com:flintinatux/rolodexx.git && cd rolodexx
$ bundle install
$ bundle exec rake db:setup
$ npm install
$ npm install -g bower brunch
$ bower install
$ brunch w
$ rails s puma
```
That should just about do it.  Then access it here: [http://localhost:3000/](http://localhost:3000/)

### What's so special about it?

It's a pretty simple app, but I tried to make it as performant as possible.  It uses [Rails](http://rubyonrails.org) for the backend with Sprockets completely disabled, so it only acts as a JSON API for the [Backbone](http://backbonejs.org) frontend.

Rather than rely on Sprockets for compiling assets, I went with Brunch, which does a fantastic job of watching your files and concatenating them in an optionated manner.

### What I'd probably add next

1. A `User` model, along with some authentication.  That way your contact data aren't shared with the world.
2. Probably an import or export machanism.
3. [Jasmine](http://jasmine.github.io/) specs for the frontend app.
