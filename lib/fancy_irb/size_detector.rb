module FancyIrb
  module SizeDetector
    extend self

    def width_of(data)
      return 0 unless data
      data = Paint.unpaint data.to_s
      FancyIrb[:east_asian_width] ? data.display_size : data.size
    end

    def height_of(data, width)
      data_split = data.to_s.split("\n")
      lines      = data_split.size - 1
      long_lines = data_split.inject(0){ |sum, line|
        sum + (width_of(line) / width)
      }
      lines + long_lines
    end
  end
end
