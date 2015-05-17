# :steam_locomotive: TrainTrack :steam_locomotive: 

[![Code Climate](https://codeclimate.com/github/AnthonySuper/train_track/badges/gpa.svg)](https://codeclimate.com/github/AnthonySuper/train_track)
[![Test Coverage](https://codeclimate.com/github/AnthonySuper/train_track/badges/coverage.svg)](https://codeclimate.com/github/AnthonySuper/train_track/coverage)
[![Build Status](https://travis-ci.org/AnthonySuper/train_track.svg?branch=master)](https://travis-ci.org/AnthonySuper/train_track)

TrainTrack is a gem that makes it easier to track changes in your rails projects.
It doesn't make any decisions on how to do that.
That part is up to you.
All it does is provide some nice helpers to make that task easier.

TrainTrack may gain features in the future that also manage the actual tracking side.
If you want to help develop that, shoot us a pull request!
### Why not just use ActiveRecord callbacks?

Well, you could use those.
In fact, for very simple tracking, those are probably better.
However, that has some limitations:

1. Doesn't fully work with collections: a `has_many` is going to cause severe trouble for your code, since some methods will trigger `before_update` and `after_update`, while others won't.

2. Will run on records updated by automated tasks, when you probably care more about what users are doing

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'train_track'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install train_track

## Usage

Include TrainTrack in your controller:

```ruby
class ImagesController < ApplicationController
  include TrainTrack

end
```

Call the `record` method in the controller when there's a state you wish to track.
What do I mean by this?
Well, in the create method, you probably only want to track that it has been created
```ruby
  def create
    i = Image.new(image_params)
    if i.save
      track i 
      redirect_to i
    else
      # handle error
    end
  end
```

Whereas in an update action, you probably want to manage multiple states:

```ruby
  def edit
    i = Image.find(params[:id])
    track i 
    if i.update(image_params)
      track i
      redirect_to i
    else
      # handle error
    end
  end
```

### Trackers
Now, all those calls to track are pretty useless right now.
In order to make them do something, you have to specify a tracker.
We recommend you put those in `/app/trackers/`

A tracker looks like this:
```ruby
class ImageTracker < ApplicationTracker
  # user is taken from the `current_user` method on your controller
  def initialize(user, record)
    @user = user
    @record = record
  end
  # Called on the create action
  def create
    # assuming we have a model called "ImageEdit" that tracks modifications of Images
    ImageEdit.create(user: @user,
                     image: @record,
                     action: :created)
  end

  # Called on the first call to "track" in the edit action
  def edit_before
    @old_tags = @record.tags.pluck(&:id)
  end

  def edit_after
    @new_tags = @record.tags.reload.pluck(&:id)
    # Assuming ImageEdit makes use of Postgres' arrays 
    ImageEdit.create(user: @user,
                     image: @record,
                     action: :edited,
                     old_tags: @old_tags,
                     new_tags: @new_tags)
  end
end
```

Much like in [Pundit](https://github.com/elabs/pundit), a tracker is a PORO.
This gives TrainTracks a higher level of flexibility.

Also like in pundit, we infer the name of the tracker from the class name.
If you want to over-ride this behavior, simple include a method called `train_tracker_class` on the class.

```ruby
class Noided < ActiveRecord::Base
  def self.train_tracker_class
    ParanoidTracker
  end
end
```
You can also define it as an instance method.
This lets you do fancy things:
```ruby
class ElfmanSong < ActiveRecord::Base
  def train_tracker_class
    if band == "Oingo Boingo"
      BoingoTracker
    else
      SoloTracker
  end
end
```

## Contributing

1. Fork it ( https://github.com/AnthonySuper/train_track/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
