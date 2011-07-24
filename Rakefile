require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
desc "Run rack-webconsole specs"
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new(:docs) do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['-m', 'markdown', '--no-private', '-r', 'Readme.md', '--title', 'rack-webconsole documentation']
end
task :doc => [:docs]

desc "Generate and open class diagram (needs Graphviz installed)"
task :graph do |t|
 `bundle exec yard graph -d --full --no-private | dot -Tpng -o graph.png && open graph.png`
end
task :default => [:test]
