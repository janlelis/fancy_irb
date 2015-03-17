# patch streams to track height & apply colors
FancyIrb.patch_stream $stdout, :stdout
FancyIrb.patch_stream $stderr, :stderr

# patch some $stdin methods to track height
FancyIrb.register_height_trackers $stdin.singleton_class, FancyIrb::STDIN_TRACK_HEIGHT_METHODS
