require 'paint'

EXAMPLE_HEIGHT_DATA = [
  ["bla", 10, 0],
  ["\n", 10, 1],
  ["bla\n", 10, 1],
  ["bla\nblubb", 10, 1],
  ["bla\n\nblubb", 10, 2],
  ["b"*10, 10, 0],
  ["b"*11, 10, 1],
  [Paint["b"*10, :red], 10, 0],
  [Paint["b"*11, :red], 10, 1],
]
