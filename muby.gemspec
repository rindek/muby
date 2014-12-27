# -*- encoding : utf-8 -*-
require File.expand_path('../lib/muby/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'muby'
  s.version     = Muby::VERSION
  s.date        = '2014-12-27'
  s.summary     = "A simple but powerful mud client."
  s.authors     = ["Martin Kihlgren", "Sy Ali", "Jacek Jakubik"]
  s.email       = ['jakubik.jacek@gmail.com']
  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage    = 'http://github.com/rindek/muby'
  s.add_dependency 'ncurses-ruby', '~> 1.2'
end
