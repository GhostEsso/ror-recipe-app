# -*- encoding: utf-8 -*-
# stub: thin 1.6.2 ruby lib
# stub: ext/thin_parser/extconf.rb

Gem::Specification.new do |s|
  s.name = "thin".freeze
  s.version = "1.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marc-Andre Cournoyer".freeze]
  s.date = "2014-03-04"
  s.description = "A thin and fast web server".freeze
  s.email = "macournoyer@gmail.com".freeze
  s.executables = ["thin".freeze]
  s.extensions = ["ext/thin_parser/extconf.rb".freeze]
  s.files = ["bin/thin".freeze, "ext/thin_parser/extconf.rb".freeze]
  s.homepage = "http://code.macournoyer.com/thin/".freeze
  s.licenses = ["Ruby".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.5".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "A thin and fast web server".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rack>.freeze, [">= 1.0.0"])
    s.add_runtime_dependency(%q<eventmachine>.freeze, [">= 1.0.0"])
    s.add_runtime_dependency(%q<daemons>.freeze, [">= 1.0.9"])
  else
    s.add_dependency(%q<rack>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<eventmachine>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<daemons>.freeze, [">= 1.0.9"])
  end
end
