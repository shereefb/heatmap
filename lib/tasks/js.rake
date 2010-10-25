namespace :js do
  desc "Minify javascript src for production environment"
  require 'tempfile'
  
  task :min => :environment do
    # list of files to minify
    libs = ['public/script.js']

    # paths to jsmin script and final minified file
    jsmin = 'script/jsmin.rb'
    final = 'public/s1.js'

    # create single tmp js file
    tmp = Tempfile.open('all')
    libs.each {|lib| open(lib) {|f| tmp.write(f.read) } }
    tmp.rewind

    # minify file
    %x[ruby #{jsmin} < #{tmp.path} > #{final}]
    puts "\n#{final}"
  end
end

