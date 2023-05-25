# frozen_string_literal: true

# require "pry" #if Gem.loaded_specs.has_key? "pry"

require "active_support/concern"
require "active_support/core_ext/kernel/concern"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/output_safety"

require_relative "./renderer/zeitwerk_autoloader"

module Matestack
  # The `matestack-renderer` gem provides a renderer for `matestack-ui-core`.
  #
  # https://github.com/fiedl/matestack-renderer
  # https://github.com/matestack/matestack-ui-core
  #
  module Renderer
  end
end
