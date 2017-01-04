task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/pastewin.zip autoload/ doc/pastewin.txt plugin/'
end
