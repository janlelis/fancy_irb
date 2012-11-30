require 'stringio'
require 'paint'

module FancyIrb
  VERSION = ( File.read File.expand_path( '../VERSION', File.dirname(__FILE__)) ).chomp.freeze
end

class << FancyIrb
  # setup instance variable accessors
  attr_reader :options
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

  def start(user_options = {})
    # track some irb stuff
    @height_counter  = []
    @real_lengths    = { :output => 1, :input_prompt => 9999 } # or whatever
    @stdout_colorful = false
    @continue        = false

    # set defaults and parse user options
    default_result_proc = proc{ |context|
      if context.inspect?
        context.last_value.inspect
      else
        context.last_value
      end
    }

    default_colorizer_proc = proc{ |value|
      FancyIrb.real_lengths[:output] =    value.size
      if defined?(Wirb) && FancyIrb[:colorize, :output]
        Wirb.colorize_result value
      else
        value 
      end
    }

    default_options = {
      :rocket_mode     => true,   # activate or deactivate #=> rocket output
      :rocket_prompt   => '#=> ', # prompt to use for the rocket
      :result_prompt   => '=> ',  # prompt to use for normal output
      :colorize => {              # colors hash. Set to nil to deactivate colorizing
        :rocket_prompt => [:blue],
        :result_prompt => [:blue],
        :input_prompt  => nil,
        :irb_errors    => [:red],
        :stderr        => [:red, :bright],
        :stdout        => nil,
        :input         => nil,
        :output        => true, # wirb's output colorization
       },
      :result_proc     => default_result_proc,       # how to get the output result
      :output_procs    => [default_colorizer_proc],  # you can modify/enhance/log your output
      :east_asian_width => false, # set to true if you have double-width characters (slower)
    }

    @options = default_options

    default_options.each{ |key, value|
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
        @options[key] = user_options.has_key?(key) ? user_options[key] : default_options[key]
      end
    }

    # hook code into IRB
    require 'fancy_irb/irb_ext'

    "Enjoy your FancyIrb :)"
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
      sum + (line.display_size / current_length)
    }
    @height_counter << lines + long_lines
  end

  def get_height
    1 + ( @height_counter == [0] ? 0 : @height_counter.reduce(:+) || 0 )
  end

  def write_stream(stream, data, color = nil)
    stream.write_non_fancy( FancyIrb.stdout_colorful ? Paint[data, *Array(color)] : data.to_s )
  end

  def win?
    RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  end

  if FancyIrb.win? 
    raise LoadError, 'FancyIrb needs ansicon on windows, see https://github.com/adoxa/ansicon' unless ENV['ANSICON']
    def current_length
       ENV['ANSICON'][/\((.*)x/, 1].to_i
    end

    def current_lines
       ENV['ANSICON'][/\(.*x(.*)\)/, 1].to_i
    end
  else
    def current_length
     `tput cols`.to_i
    end

    def current_lines
     `tput lines`.to_i
    end
  end
end
