# deactivate rocket for common system commands
FancyIrb::DEACTIVATE_ROCKET.each{ |m|
  Object.send(:define_method, m, &lambda{ |*args, &block|
    FancyIrb.skip_next_rocket = true
    super(*args, &block)
  })
}

# patch some input methods to track height
class Object
  private

  def gets(*)
    res = super
    FancyIrb.track_height res
    res
  end
end

# respect full-width chars
if FancyIrb[:east_asian_width]
  require 'unicode/display_size'
else
  class String
    alias display_size size
  end
end
