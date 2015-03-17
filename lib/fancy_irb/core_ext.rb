# deactivate rocket for common system commands
FancyIrb::DEACTIVATE_ROCKET.each{ |m|
  Object.send(:define_method, m, &lambda{ |*args, &block|
    FancyIrb.skip_next_rocket = true
    super(*args, &block)
  })
}

# patch some kernel methods to track height
FancyIrb.register_height_trackers Object, FancyIrb::STDIN_TRACK_HEIGHT_METHODS

# respect full-width chars
if FancyIrb[:east_asian_width]
  require 'unicode/display_size'
else
  class String
    alias display_size size
  end
end
