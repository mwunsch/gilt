# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gilt/version"

Gem::Specification.new do |s|
  s.name        = "gilt"
  s.version     = Gilt::VERSION
  s.authors     = ["Mark Wunsch"]
  s.email       = ["mwunsch@gilt.com"]
  s.homepage    = "http://github.com/mwunsch/gilt"
  s.summary     = %q{Ruby client for the Gilt public API.}
  s.description = %q{Ruby client for the Gilt public API (http://dev.gilt.com). Written with the Weary framework.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "money", "~> 4.0.2"
  s.add_runtime_dependency "weary", "~> 1.1.0"
end
