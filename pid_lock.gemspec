# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pid_lock'

Gem::Specification.new do |spec|
  spec.name          = "pid_lock"
  spec.version       = PidLock::VERSION
  spec.authors       = ["xuxiangyang"]
  spec.email         = ["54049924@qq.com"]
  spec.summary       = %q{ruby pid lock file}
  spec.description   = %q{ruby pid lock file}
  spec.homepage      = "https://github.com/xuxiangyang/pid_lock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake",  "~> 10.4"
end
