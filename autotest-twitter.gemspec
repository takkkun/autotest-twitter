# -*- encoding: utf-8 -*-
require File.expand_path('../lib/autotest/twitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Takahiro Kondo"]
  gem.email         = ["kondo@atedesign.net"]
  gem.description   = %q{This gem sends to Twitter a result of your testing.}
  gem.summary       = %q{Twitter support for autotest}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "autotest-twitter"
  gem.require_paths = ["lib"]
  gem.version       = Autotest::Twitter::VERSION

  gem.add_runtime_dependency 'twitter'
end
