# :steam_locomotive: TrainTrack :steam_locomotive: 

TrainTrack is a small helper gem to let you track things in your Ruby on Rails projects.
It doesn't make any decisions on how to do that.
That part is up to you.
All it does is provide some nice helpers to make that task easier.

### Why not just use ActiveRecord callbacks?

Well, you could use those.
In fact, for very simple tracking, those are probably better.
However, that has some limitations:
1. Doesn't fully work with collections: a has\_many is going to cause severe trouble for your code, since some methods will trigger before\_update and after\_update, while others won't.

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
We recommend you put those in `/app/trackers`

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/train_track/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
