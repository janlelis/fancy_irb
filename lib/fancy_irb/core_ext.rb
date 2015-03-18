# patch streams to track height & apply colors
FancyIrb.patch_stream $stdout, :stdout
FancyIrb.patch_stream $stderr, :stderr

# patch some $stdin methods to track height
FancyIrb.register_height_trackers $stdin, FancyIrb::TRACK_HEIGHT_INPUT_METHODS

# patch some ARGF methods to track height
FancyIrb.register_height_trackers $<, FancyIrb::TRACK_HEIGHT_INPUT_METHODS

# deactivate rocket for common system commands
FancyIrb.register_skipped_rockets Object, FancyIrb::SKIP_ROCKET_METHODS
