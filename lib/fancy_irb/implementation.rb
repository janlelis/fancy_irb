module FancyIrb
  class << self
    attr_reader :options
    attr_reader :error_capturer
    attr_accessor :skip_next_rocket

    def start(user_options = {})
      set_defaults
      apply_user_options(user_options)
      reset_line!
      extend!

      true
    end

    # hook into IRB
    def extend!
      require 'unicode/display_size' if @options[:east_asian_width]
      require_relative 'irb_ext'
      require_relative 'core_ext'
      require_relative 'clean_up'
    end

    def set_defaults
      @skip_next_rocket = false
      @real_lengths     = { :output => 1, :input_prompt => Float::INFINITY }

      @options = DEFAULT_OPTIONS.dup
      @options[:colorize] = @options[:colorize].dup if @options[:colorize]
    end

    def apply_user_options(user_options)
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

    def reset_line!
      @height_counter = []
      @indent = false
    end

    def track_indent!
      @indent = true
    end

    def set_input_prompt_size(prompt, irb_scanner)
      @real_lengths[:input_prompt] =
        prompt.size + irb_scanner.indent * 2 + ( @indent ? 2 : 0 )
    end

    def track_height(data)
      @height_counter << SizeDetector.height_of(data, TerminalInfo.cols)
    end

    def get_height
      1 + ( @height_counter == [0] ? 0 : @height_counter.reduce(:+) || 0 )
    end

    def colorize(string, colorize_key)
      Paint::NOTHING + Paint[string, *Array(@options[:colorize][colorize_key])]
    end

    # Note: No reset, relies on next one
    def append_input_color(string)
      if input_color = @options[:colorize][:input]
        string + Paint.color(*Array(input_color))
      else
        string
      end
    end

    # get_result and pass it into every format_output_proc
    def get_output_from_irb_context(irb_context)
      result = @options[:result_proc][irb_context]
      @real_lengths[:output] = result.size
      Array(@options[:output_procs]).inject(
        result
      ){ |output, output_proc|
        output_proc[output].to_s
      }
    end

    def get_offset_from_irb_scanner(irb_scanner)
      last_line = irb_scanner.instance_variable_get(:@line).split("\n").last
      1 + @real_lengths[:input_prompt] + (last_line ? SizeDetector.width_of(last_line) : 0)
    end

    def get_cols_to_show_from_offset(offset)
      offset + @options[:rocket_prompt].size + @real_lengths[:output]
    end

    # TODO testing and improving, e.g. getc does not contain "\n"
    def register_height_trackers(object, methods_)
      methods_.each{ |method_|
        if object.respond_to?(method_)
          object.send :define_singleton_method, method_ do |*args|
            res = super(*args)
            FancyIrb.track_height(res)
            res
          end
        end
      }
    end

    def register_skipped_rockets(object_class, methods_)
      methods_.each{ |method_|
        object_class.send :define_method, method_ do |*args|
          FancyIrb.skip_next_rocket = true
          super(*args)
        end
      }
    end

    def patch_stream(object, stream_name)
      object.define_singleton_method :write do |data|
        FancyIrb.track_height data
        super FancyIrb.colorize(data, stream_name)
      end
    end

    def register_error_capturer!
      @error_capturer = FancyIrb::ErrorCapturer.new
    end

    def present_and_clear_captured_error!
      if @error_capturer
        @error_capturer.restore_original_stdout
        $stderr.puts colorize(
          @error_capturer.error_string.chomp,
          :irb_errors,
        )
        @error_capturer = nil
      end
    end
  end
end
