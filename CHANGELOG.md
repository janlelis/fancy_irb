# CHANGELOG

## 2.1.0 (unreleased)
* Refactor IRB extension to accommodate IRB 1.8.2

## 2.0.0
* Fix core functionality for newer IRB
* Require Ruby 3.x / IRB 1.7+
* Bump display-width gem to latest version
* Remove option to disable display-width check, since it now has good performance

## 1.4.3
* Fix options given to `script` so it doesn't output timing info

## 1.4.2
* Support Alpine Linux (fix #12)

## 1.4.1
* Relax unicode-display_width requirement

## 1.4.0
* Full support for non-ttys

## 1.3.0
* Use `script` wrapper on linux in case we are not on a tty

## 1.2.1
* Fix 2.7 keyword warning

## 1.2.0
* Read indentation level directly so it won't fail on newer Rubies

## 1.1.0
* Rename `east_asian_width` option to `unicode_display_width` and activate by default
* Relax paint dependency

## 1.0.2
* Bump unicode-display_width to 1.0

## 1.0.1
* Fix that unicode-display_width was not used properly

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
