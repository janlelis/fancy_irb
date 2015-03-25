require_relative "../lib/fancy_irb"
require_relative 'fixtures'

describe FancyIrb::SizeDetector do
  include FancyIrb::SizeDetector

  before do
    FancyIrb.instance_variable_set(:@options, {east_asian_width: false})
  end


  describe ".width_of" do
    it "returns 0 when no data given" do
      expect( width_of(nil) ).to eq 0
    end

    it "returns string length for 'normal' data" do
      expect( width_of("string") ).to eq 6
    end

    it "removes ansi escape chars" do
      expect( width_of("\e[31mstring\e[0m") ).to eq 6
    end

    it "does not respect double-width chars by default" do
      expect( width_of('一') ).to eq 1
    end

    context "east_asian_width? true" do
      before do
        require 'unicode/display_size'
        FancyIrb.instance_variable_set(:@options, {east_asian_width: true})
      end

      it "respects double-width chars" do
        expect( width_of('一') ).to eq 2
      end
    end
  end

  describe ".height_of" do
    EXAMPLE_HEIGHT_DATA.each{ |data, terminal_cols, expected|
      example "#{data[0...20]}#{'...' if data[20]}".inspect.ljust(28) +
              "with terminal width #{terminal_cols} is #{expected}" do
        expect( height_of(data, terminal_cols) ).to eq expected
      end
    }

    it "can be accumulated" do
      data_head = "head"
      data_tail = "tail"
      expect(
        height_of(data_head, 80) + height_of(data_tail, 80)
      ).to eq height_of(data_head + data_tail, 80)
    end
  end

end
