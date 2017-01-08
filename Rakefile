task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/yankwin.zip autoload/ doc/yankwin.txt plugin/'
end
