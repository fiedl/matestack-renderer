# frozen_string_literal: true

require_relative "lib/matestack/renderer/version"

Gem::Specification.new do |spec|
  spec.name = "matestack-renderer"
  spec.version = Matestack::Renderer::VERSION
  spec.authors = ["Sebastian Fiedlschuster"]
  spec.email = ["git@fiedlschuster.de"]

  spec.summary = "Renderer for matestack-ui-core"
  spec.homepage = "https://github.com/fiedl/matestack-renderer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fiedl/matestack-renderer"
  spec.metadata["changelog_uri"] = "https://github.com/fiedl/matestack-renderer/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
