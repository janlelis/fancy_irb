# deactivate rocket for common system commands
FancyIrb.register_skipped_rockets Object, FancyIrb::SKIP_ROCKET_METHODS

# patch some kernel methods to track height
FancyIrb.register_height_trackers Object, FancyIrb::STDIN_TRACK_HEIGHT_METHODS
