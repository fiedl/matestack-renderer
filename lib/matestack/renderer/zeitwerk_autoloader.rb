# frozen_string_literal: true

# This file configures the zeitwerk autoloader for out gem.
#
# As the gem name includes dashes, i.e. the gem entry file
# `matestack/renderer.rb` is not directly in the `lib`
# directory, zeitwerk's default mechanism does not work
# out of the box, but needs to configured manually.
#
# See: https://github.com/fxn/zeitwerk/issues/48

require "zeitwerk"

lib_root_path = File.expand_path(File.join(__dir__, "../.."))

loader = Zeitwerk::Loader.new
loader.tag = "matestack-renderer"
loader.push_dir(lib_root_path)
loader.push_dir(File.join(lib_root_path, "matestack/concerns"))

loader.inflector = Class.new(Zeitwerk::Inflector) do
  def camelize(basename, _abspath)
    basename == 'version' ? 'VERSION' : super
  end
end.new

loader.enable_reloading
loader.setup
