# CHANGELOG

## 1.0.0
* More tidying behind the scenes
* Remove :result_proc and :output_procs options. Please use `IRB::Inspector.def_inspector` if you need this feature
* Recognize multi-line regexes
* Improve size detector (-> less wrongly placed rockets)


## 0.8.2
* Support objects that don't support #inspect


## 0.8.1
* Use io/console correctly, fixes bug on mingw


## 0.8.0
* Internals partly refactored
* Bump paint and unicode-display_width dependencies
* Drop official support for Ruby 1
* Don't depend on ansicon specifics for windows (use io/console)
* Also patch input methods for ARGF
* Don't try to catch exception when printing to stderr
* Remove [:[colorizer]](:output) option
* Not patching Kernel anymore
* Only path String if east_asian_width option is used


## 0.7.3
* Don't colorize stdout by default
* Deactivate rocket for common system commands


## 0.7.2
* Fix a small bug that happens if there was no last line


## 0.7.1
* Deactivate buggy input coloring :/


## 0.7.0
* Use paint gem for terminal colors
* Fix some rocket issues (when using with colored content)


## 0.6.5
* Windows support


## < 0.6.5
See https://github.com/janlelis/fancy_irb/commits/0.6.4
