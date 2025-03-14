# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your wagon's version:
require "hitobito_ejv/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "hitobito_ejv"
  s.version = HitobitoEjv::VERSION
  s.authors = ["Matthias Viehweger"]
  s.email = ["viehweger@puzzle.ch"]
  s.summary = "Eidgenössischer Jodlerverband"
  s.description = "Structure and additonal features for hitobito of Eidgenössischer Jodlerverband"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
end
