# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'capit/version'

Gem::Specification.new do |s|
  s.name        = "capit"
  s.version     = CapIt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ezekiel Templin"]
  s.email       = ["ezkl@me.com"]
  s.homepage    = "http://capit.mdvlrb.com"
  s.summary     = %q{Easy screen captures with the help of CutyCapt}
  s.description = %q{Easy screen captures with the help of CutyCapt}

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
