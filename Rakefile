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

site = 'doc'
source_branch = 'master'
deploy_branch = 'gh-pages'

desc "generate and deploy documentation website to github pages"
multitask :pages do
  puts ">>> Deploying #{deploy_branch} branch to Github Pages <<<"
  require 'git'
  repo = Git.open('.')
  puts "\n>>> Checking out #{deploy_branch} branch <<<\n"
  repo.branch("#{deploy_branch}").checkout
  (Dir["*"] - [site]).each { |f| rm_rf(f) }
  Dir["#{site}/*"].each {|f| mv(f, "./")}
  rm_rf(site)
  puts "\n>>> Moving generated site files <<<\n"
  Dir["**/*"].each {|f| repo.add(f) }
  repo.status.deleted.each {|f, s| repo.remove(f)}
  puts "\n>>> Commiting: Site updated at #{Time.now.utc} <<<\n"
  message = ENV["MESSAGE"] || "Site updated at #{Time.now.utc}"
  repo.commit(message)
  puts "\n>>> Pushing generated site to #{deploy_branch} branch <<<\n"
  repo.push
  puts "\n>>> Github Pages deploy complete <<<\n"
  repo.branch("#{source_branch}").checkout
end

task :doc => [:docs]

desc "Generate and open class diagram (needs Graphviz installed)"
task :graph do |t|
 `bundle exec yard graph -d --full --no-private | dot -Tpng -o graph.png && open graph.png`
end

task :default => [:test]
