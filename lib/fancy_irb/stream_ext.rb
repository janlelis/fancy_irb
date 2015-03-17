class << $stdout
  def write(data)
    FancyIrb.track_height data
    super FancyIrb.prepare_stream_data(data, FancyIrb[:colorize, :stdout])
  end
end

class << $stderr
  def write(data)
    FancyIrb.track_height data
    super FancyIrb.prepare_stream_data(data, FancyIrb[:colorize, :stderr])
  rescue Exception # catch fancy_irb errors
    super data
  end
end

FancyIrb.register_height_trackers $stdin.singleton_class, FancyIrb::STDIN_TRACK_HEIGHT_METHODS
