require 'spec_helper'

describe TrainTrack do
  let(:image){Image.new(["hack", "fraud"])}
  let(:user){ double }
  it 'has a version number' do
    expect(TrainTrack::VERSION).not_to be nil
  end

  describe ".tracker_class" do
    it "finds via class name" do
      expect(TrainTrack.tracker_class(Image.new([]))).to eq(ImageTracker)
    end
    it "finds via a class method" do
      expect(TrainTrack.tracker_class(Post.new)).to eq(MagicTracker)
    end
    it "finds via an instance method" do
      expect(TrainTrack.tracker_class(Comment.new)).to eq(HackTracker)
    end
  end
  describe "tracking" do
    context "with the update action" do
      it "sends both the .update_before and .edit_after messages" do
        c = Controller.new(user, {action: :update})
        tracker_double = double("tracker")
        # do some injection magic
        # basically, TrainTrack normally creates a new instance of a tracker
        # in this case we snipe that with our own double
        # so we can test it more easily
        c.instance_variable_set(:@_tracker, tracker_double)
        expect(tracker_double).to receive(:update_before)
        expect(tracker_double).to receive(:update_after)
        c.update
      end
    end
    context "with arbitrary actions" do
      it "sends the tracker the message of the action" do
        c = Controller.new(user, {action: :create})
        tracker_double = double("tracker")
        c.instance_variable_set(:@_tracker, tracker_double)
        expect(tracker_double).to receive(:create)
        c.create
      end
    end
  end
end
