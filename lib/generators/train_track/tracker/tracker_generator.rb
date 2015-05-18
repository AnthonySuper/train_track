module TrainTrack
  module Generators
    class TrackerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      def create_tracker
        template 'tracker.rb', File.join('app/trackers', class_path, "#{file_name}_tracker.rb")
      end

     end
  end
end
