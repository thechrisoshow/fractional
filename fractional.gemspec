Gem::Specification.new do |spec|
  spec.name          = "fractional"
  spec.version       = "1.2.0"
  spec.authors       = ["Chris O'Sullivan"]
  spec.email         = ["thechrisoshow@gmail.com"]
  spec.description   = %q{Fractional is a Ruby library for parsing fractions.}
  spec.summary       = %q{You can use fractional to convert decimal numbers to string representations of fractions. e.g: Fractional.to_s(1.5) #=> "1 1/2"}
  spec.homepage      = "http://github.com/thechrisoshow/fractional"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 0'
  spec.add_development_dependency "rspec", '~> 0'
  spec.add_development_dependency "byebug", '~> 0'
end
