lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dao/repository/version'

Gem::Specification.new do |spec|
  spec.name          = 'dao-repository'
  spec.version       = Dao::Repository::VERSION
  spec.authors       = %w(llxff ssnikolay)
  spec.email         = ['ll.wg.bin@gmail.com']

  spec.summary       = 'Base repository for DAO'
  spec.description   = 'Base repository for DAO'
  spec.homepage      = 'https://github.com/dao-rb/dao-repository'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.2'

  spec.add_dependency 'dao-gateway', '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec-its'
end
