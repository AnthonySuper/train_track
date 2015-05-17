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
end
