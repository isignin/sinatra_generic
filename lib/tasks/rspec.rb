desc "Run those specs"
task :spec do
    require 'rspec/core/rake_task'
 
    RSpec::Core::RakeTask.new do |t|
      # t.spec_files = FileList['spec/**/*_spec.rb']
      t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
      t.pattern = 'spec/**/*_spec.rb'
     end
end
