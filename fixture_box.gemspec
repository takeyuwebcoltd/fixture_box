$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fixture_box/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fixture_box"
  s.version     = FixtureBox::VERSION
  s.authors     = ["Takeyu Web Inc."]
  s.email       = ["yuichi.takeuchi@takeyuweb.co.jp"]
  s.homepage    = "https://github.com/takeyuwebcoltd/fixture_box"
  s.summary     = "Dynamically creating ActiveRecord Fixtures."
  s.description = "Dynamically creating ActiveRecord Fixtures."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0"

  s.add_development_dependency "sqlite3"
end
