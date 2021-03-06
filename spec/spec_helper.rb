require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'train_track'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
##
# Dummy model to use for testing
class Image
  def initialize(tags)
    @tags = tags
  end
  attr_accessor :tags
end

##
# Dummy tracker class
class ImageTracker; end
class MagicTracker; end
class HackTracker; end
##
# Another dummy model
class Post
  def self.train_tracker_class
    MagicTracker
  end
end

## 
# Yet another dummy model
class Comment
  def train_tracker_class
    HackTracker
  end
end
class ImageTracker
  def initialize(user, image)
    @user = user
    @image = image
  end

  def create

  end

  def update_before

  end

  def update_atfter

  end
end

##
# Controller class used for testing
class Controller
  include TrainTrack
  attr_reader :current_user, :params
  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end

  def update
    i = Image.new(["hack", "fraud"])
    track i 
    i.tags = ["foo", "bar"]
    track i
  end

  def create
    i = Image.new(["hack", "fraud"])
    track i
  end
end
