require 'spec_helper'

module Chingu
  describe Animation do  
    before :each do
      @game = Chingu::Window.new
      @test_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'images')
      Gosu::Image.autoload_dirs << @test_dir
      @animation_clean = Animation.new(:file => File.join(@test_dir, "droid_11x15.bmp"))
      @animation = Animation.new(:file => File.join(@test_dir, "droid_11x15.bmp"), :delay => 0)
    end

    after :each do
      @game.close
    end
    
    describe "newly initialized object" do
      it "should have default values" do
        @animation_clean.bounce.should == false
        @animation_clean.loop.should == true
        @animation_clean.delay.should == 100
        @animation_clean.index.should == 0
        @animation_clean.step.should == 1
      end
      
      it "should find single filename in Image.autoload_dirs" do
        @anim = Animation.new(:file => "droid_11x15.bmp")
        @anim.frames.count.should == 14
      end
      
      it "should find relative filename path" do
        Dir.chdir(File.dirname(File.expand_path(__FILE__)))
        @anim = Animation.new(:file => "images/droid_11x15.bmp")
        @anim.frames.count.should == 14
      end
    end

    describe "Animation loading file: droid_11x15.bmp" do
      it "should detect size and frames automatically from filename" do
        @animation.size.should == [11,15]
        @animation.frames.count.should == 14
      end
      
      it "should give correct frames for .first and .last" do
        @animation.first.should == @animation.frames.first
        @animation.last.should == @animation.frames.last
      end

      it "should return frame with []" do
        @animation[0].should == @animation.frames.first
      end

      it "should step animation forward with .next" do
        @animation.next
        @animation.index.should == 1
      end

      it "should stop animation when reaching end if loop and bounce are both false" do
        @animation.loop = false
        @animation.bounce = false
        @animation.index = 14
        @animation.next
        @animation.index.should == 14
      end

      it "should loop animation when reaching end if loop is true" do
        @animation.index = 14
        @animation.next
        @animation.index.should == 0
      end
      
      it "should bounce animation when reaching end if bounce is true" do
        @animation.bounce = true
        @animation.index = 14
        @animation.next
        @animation.index.should == 13
      end
      
      it "should use .step when moving animation forward" do
        @animation.step = 5
        @animation.next
        @animation.index.should == 5
        @animation.next
        @animation.index.should == 10        
      end
      
      it "should handle 'frame_names' pointing to a new animation containing a subset of the original frames" do
        @animation.frame_names = { :scan => 0..5, :up => 6..7, :down => 8..9, :left => 10..11, :right => 12..13 }
        
        @animation[:scan].should be_kind_of(Animation)
        @animation[:scan].frames.count.should == 6
        @animation[:up].frames.count.should == 2
        @animation[:down].frames.count.should == 2
        @animation[:left].frames.count.should == 2
        @animation[:right].frames.count.should == 2
      end
      
    end
  end
end
