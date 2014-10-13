#encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'call_rota/version'

Gem::Specification.new do |s|
  s.name        = 'call-rota'
  s.version     = CallRota::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-10-13'
  s.summary     = "Gem that provides a script to generate on-call rotas"
  s.authors     = ["Tom Russell", "Camille Baldock"]
  s.homepage    = "https://github.com/alphagov/call-rota"
  s.email       = 'bradley.wright@digital.cabinet-office.gov.uk'
  s.files       = Dir["{app,lib}/**/*"] + ["LICENSE", "README.md"]
  s.test_files    = Dir["{spec}/**/*"]
  s.require_paths = ["lib"]
  s.license       = 'MIT'
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "gem_publisher"
  s.add_development_dependency "pry"
end
