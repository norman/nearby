%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/nearby'

$hoe = Hoe.new('nearby', Nearby::VERSION) do |p|
  p.developer('Norman Clarke', 'norman@rubysouth.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.rubyforge_name       = "nearby"
  # p.extra_deps         = [
  #   ['activesupport','>= 2.0.2'],
  # ]
  p.description = "Quick and easy geocoding using Geonames.org data and TokyoCabinet"
  p.summary = "Quick and easy geocoding library."
  p.url = "http://github.com/norman/nearby"
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log coverage]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }
