# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rical/version'

Gem::Specification.new do |spec|
  spec.name          = 'rical'
  spec.version       = Rical::VERSION
  spec.authors       = ['Luis Bacelar']
  spec.email         = ['lmbacelar@gmail.com']
  spec.summary       = %q{Computes roots and x value for given y for arbitrary math f(x)=y}
  spec.description   = <<-DESCRIPTION
Computes approximation within a given error_limit to the values of a root of an arbitrary function f(x) or to the value of inverse function g(y) = x.
Uses Newton-Raphson or Secant methods.
Requires one (Newton-Raphson) or two (Secant) estimates of the target value.
Raises NoConvergenceError when it does not converge within the set error_limit, on set number of iterations.
DESCRIPTION
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
