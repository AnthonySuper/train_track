module TrainTrack
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))
      def copy_application_tracker
        template 'application_tracker.rb', 'app/trackers/application_tracker.rb'
      end
    end
  end
end

