# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nearby}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Clarke"]
  s.date = %q{2009-05-11}
  s.description = %q{Quick and easy geocoding using Geonames.org data and TokyoCabinet}
  s.email = ["norman@rubysouth.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/nearby.rb", "test/test_helper.rb", "test/test_nearby.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/norman/nearby}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nearby}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Quick and easy geocoding library.}
  s.test_files = ["test/test_helper.rb", "test/test_nearby.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
