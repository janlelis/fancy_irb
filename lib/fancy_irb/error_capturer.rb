require 'stringio'

module FancyIrb
  class ErrorCapturer
    def initialize
      @original_stdout, $stdout = $stdout, StringIO.new
      @fake_stdout = $stdout
    end

    def error_string
      @fake_stdout.string
    end

    def restore_original_stdout
      $stdout = @original_stdout
    end
  end
end
