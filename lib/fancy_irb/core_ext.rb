# deactivate rocket for common system commands
FancyIrb::DEACTIVATE_ROCKET.each{ |m|
  Object.send(:define_method, m, &lambda{ |*args, &block|
    FancyIrb.skip_next_rocket = true
    super(*args, &block)
  })
}

# patch some kernel methods to track height
FancyIrb.register_height_trackers Object, FancyIrb::STDIN_TRACK_HEIGHT_METHODS
