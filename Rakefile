require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('safariwatir', '0.4.a1') do | config |
  config.summary = %q{Automated testing tool for web applications.}
  config.description = %q{WATIR stands for "Web Application Testing in Ruby".  See WATIR project for more information.  This is a Safari-version of the original IE-only WATIR.}
  config.url = 'http://wiki.openqa.org/display/WTR/SafariWatir'
  config.author = ['Dave Hoover', 'Lawrence Leonard Gilbert']
  config.email = 'dave@obtiva.com'
  config.ignore_pattern = ['tmp/*', 'script/*', 'spec/**/**', '*.html']
  config.runtime_dependencies = ["rb-appscript"]
  config.development_dependencies = ["echoe", "rspec", "sinatra"]
end
