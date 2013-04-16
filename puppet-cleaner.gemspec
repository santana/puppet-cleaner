PKG_NAME = 'puppet-cleaner'
PKG_VERSION = '0.1.0'
PKG_FILES = Dir["lib/*.rb"] + Dir["lib/puppet-cleaner/*.rb"] +
            Dir["lib/puppet-cleaner/workers/*.rb"] +
            %w{COPYRIGHT Changelog README.md}

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = 'Puppet Source Code Cleaner'
  s.description = 'Cleans puppet source code'
  s.files = PKG_FILES
  s.require_path = 'lib'
  s.executables = %w(puppet-diff puppet-inspect puppet-clean)
  s.author = 'Gerardo Santana Gomez Garrido'
  s.email = 'gerardo.santana@gmail.com'
  s.homepage = 'http://puppet-cleaner.rubyforge.org/'
  s.rubyforge_project = PKG_NAME
end
