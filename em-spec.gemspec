# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'lib', 'em-spec', 'version')

Gem::Specification.new do |s|
  s.name = 'em-spec'
  s.version = EventMachine::Spec::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aman Gupta", "Julien Ammous"]
  s.summary = "BDD for Ruby/EventMachine"
  s.description = "Simple BDD API for testing asynchronous Ruby/EventMachine code"
  s.email = %q{schmurfy@gmail.com}
  s.extra_rdoc_files = ['README.rdoc']
  s.files = `git ls-files`.split("\n")
  s.homepage = %q{https://github.com/joshbuddy/em-spec}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.test_files = `git ls-files`.split("\n").select{|f| f =~ /^test/}
  s.rubyforge_project = 'em-spec'

  s.add_dependency 'eventmachine'
  
  # These are not runtime dependencies since in most cases people will use
  # em-spec with only one of these libraries
  s.add_development_dependency 'rspec', '> 2.6.0'
  s.add_development_dependency 'bacon'
  s.add_development_dependency 'test-unit'

  if RUBY_PLATFORM.downcase.include?("darwin")
    # also install growlnotify from the
    # Extras/growlnotify/growlnotify.pkg in Growl disk image
    s.add_development_dependency 'growl'
  end
  
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'rake', '= 0.8.7'
end
