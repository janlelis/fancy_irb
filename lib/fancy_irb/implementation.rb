class << FancyIrb
  attr_accessor :options
  def [](key, key2 = nil)
    if key2
      @options[key][key2]
    else
      @options[key]
    end
  end

  attr_accessor :original_stdout
  attr_accessor :capture_irb_errors
  attr_accessor :real_lengths
  attr_accessor :continue
  attr_accessor :stdout_colorful
  attr_accessor :skip_next_rocket

  def start(user_options = {})
    @height_counter   = []
    @real_lengths     = { :output => 1, :input_prompt => 9999 } # or whatever
    @stdout_colorful  = false
    @continue         = false
    @skip_next_rocket = false
    @options = FancyIrb::DEFAULT_OPTIONS.dup
    @options[:colorize] = @options[:colorize].dup if @options[:colorize]

    FancyIrb::DEFAULT_OPTIONS.each{ |key, value|
      # (ugly) 1 level deep merge, maybe refactor
      if key == :colorize
        if user_options.has_key?(:colorize) && user_options[:colorize].nil?
          @options[:colorize] = {}
        else
          value.each{ |key2, _|
            if user_options[key] && user_options[key].has_key?(key2)
              @options[:colorize][key2] = user_options[key][key2]
            end
          }
        end
      else
        @options[key] =
            user_options.has_key?(key) ? user_options[key] : FancyIrb::DEFAULT_OPTIONS[key]
      end
    }

    # hook code into IRB
    require 'fancy_irb/irb_ext'
    true
  end

  def add_output_proc(prepend = false, &proc)
    action = prepend ? :unshift : :push
    @options[:output_procs].send action, proc
  end

  def set_result_proc(&proc)
    @options[:result_proc] = proc
  end

  def reset_height
    @height_counter = []
  end

  def track_height(data)
    data       = Paint.unpaint(data.to_s)
    lines      = data.count("\n")
    long_lines = data.split("\n").inject(0){ |sum, line|
      sum + (line.display_size / FancyIrb::TerminalInfo.cols)
    }
    @height_counter << lines + long_lines
  end

  def get_height
    1 + ( @height_counter == [0] ? 0 : @height_counter.reduce(:+) || 0 )
  end

  def write_stream(stream, data, color = nil)
    stream.write_non_fancy(
      FancyIrb.stdout_colorful ? Paint[data, *Array(color)] : data.to_s
    )
  end

  def colorize(string, color)
    Paint[string, *Array(color)]
  end
end
