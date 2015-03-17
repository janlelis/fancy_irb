module FancyIrb
  class << self
    attr_accessor :original_stdout
    attr_accessor :capture_irb_errors
    attr_accessor :real_lengths
    attr_accessor :continue
    attr_accessor :stdout_colorful
    attr_accessor :skip_next_rocket
    attr_accessor :options

    def start(user_options = {})
      @height_counter   = []
      @real_lengths     = { :output => 1, :input_prompt => Float::INFINITY }
      @stdout_colorful  = false
      @continue         = false
      @skip_next_rocket = false

      set_options(user_options)

      # hook into IRB
      require_relative 'irb_ext'
      require_relative 'core_ext'
      require_relative 'stream_ext'
      require_relative 'clean_up'

      true
    end

    def set_options(user_options)
      @options = DEFAULT_OPTIONS.dup
      @options[:colorize] = @options[:colorize].dup if @options[:colorize]

      DEFAULT_OPTIONS.each{ |key, value|
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
              user_options.has_key?(key) ? user_options[key] : DEFAULT_OPTIONS[key]
        end
      }
    end

    def [](key, key2 = nil)
      if key2
        @options[key][key2]
      else
        @options[key]
      end
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
      @height_counter << HeightDetector.run(data, TerminalInfo.cols)
    end

    def get_height
      1 + ( @height_counter == [0] ? 0 : @height_counter.reduce(:+) || 0 )
    end

    def prepare_stream_data(data, color = nil)
      @stdout_colorful ? Paint[data, *Array(color)] : data.to_s
    end

    def colorize(string, color)
      Paint[string, *Array(color)]
    end

    # get_result and pass it into every format_output_proc
    def get_output_from_irb_context(irb_context)
      Array(@options[:output_procs]).inject(
        @options[:result_proc][irb_context]
      ){ |output, formatter|
        formatter[output].to_s
      }
    end

    def get_offset_from_irb_scanner(irb_scanner)
      last_line = irb_scanner.instance_variable_get(:@line).split("\n").last
      1 + @real_lengths[:input_prompt] + (last_line ? last_line.display_size : 0)
    end

    def get_cols_to_show_from_offset(offset)
      offset + @options[:rocket_prompt].size + @real_lengths[:output]
    end

    # TODO testing and improving, e.g. getc does not contain "\n"
    def register_height_trackers(object_class, methods_)
      methods_.each{ |method_|
        if object_class.respond_to? method_, true
          object_class.send(:define_method, method_){ |*args|
            res = super(*args)
            FancyIrb.track_height(res)
            res
          }
        end
      }
    end
  end
end
