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
  FancyIrb::STDIN_HOOKS.each{ |m|
    msym   = m.to_sym
    malias = (m+'_non_fancy').to_sym

    if $stdin.respond_to? msym
      alias_method malias, msym
      define_method msym do |*args|
        res = send malias, *args
        FancyIrb.track_height res
        res
      end
    end
  }
end
