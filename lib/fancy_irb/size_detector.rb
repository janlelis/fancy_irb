module FancyIrb
  module SizeDetector
    extend self

    def width_of(data)
      return 0 unless data
      data = Paint.unpaint data.to_s
      FancyIrb.unicode_display_width? ? Unicode::DisplayWidth.of(data) : data.length
    end

    def height_of(data, width)
      data = data.to_s
      long_lines = data.split("\n").inject(0){ |sum, line|
        sum + width_of(line) / (width + 1)
      }
      data.count("\n") + long_lines
    end
  end
end
