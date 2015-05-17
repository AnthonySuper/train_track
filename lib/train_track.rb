require "train_track/version"
require 'active_support/concern'
require 'active_support/core_ext/string/inflections'
module TrainTrack
  extend ActiveSupport::Concern
  ##
  # Find the tracker class for a given model
  def self.tracker_class(model)
    if model.respond_to? :train_tracker_class
      model.train_tracker_class
    elsif model.class.respond_to? :train_tracker_class
      model.class.train_tracker_class
    else
      (model.class.name.to_s + "Tracker").constantize
    end
  end
  ##
  # Methods to add to a controller when included
  included do
    ##
    # Track a model
    #
    def track(model)
      @_tracker ||= TrainTrack.tracker_class(model).new(user_method, model)
      if params[:action] == :edit && _tracker_times_called == 0
        @_tracker.edit_before
        @_tracker_times_called += 1
      elsif params[:action] == :edit && _tracker_times_called == 1
        @_tracker.edit_after
      else
        @_tracker.send(params[:action])
      end
    end


    ##
    # Find the current_user of the controller
    # Done by using current_user
    def user_method
      current_user
    end

    def _tracker_times_called
      @_tracker_times_called ||= 0
      @_tracker_times_called
    end
  end
end
