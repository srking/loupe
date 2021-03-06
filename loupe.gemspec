require_relative 'lib/loupe/version'

Gem::Specification.new do |spec|
  spec.name          = "loupe"
  spec.version       = Loupe::VERSION
  spec.authors       = ["Steven King"]
  spec.email         = ["1659565+srking@users.noreply.github.com"]

  spec.summary       = %q{Identify and report vulnerable and outdated dependencies.}
  spec.homepage      = "https://github.com/srking/loupe"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
    
  spec.add_dependency "octokit"
  spec.add_dependency "thor"
  
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
