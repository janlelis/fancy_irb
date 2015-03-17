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

# TODO testing and improving, e.g. getc does not contain "\n"
class << $stdin
  FancyIrb::STDIN_HOOKS.map(&:to_sym).each{ |m|
    if $stdin.respond_to? m
      define_method m do |*args|
        res = super(*args)
        FancyIrb.track_height res
        res
      end
    end
  }
end
