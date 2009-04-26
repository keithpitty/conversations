namespace :rails do 
  desc "Configure Subversion for Rails"
  task :configure_for_svn do 
		system "svn remove log/* --force"
		system "svn commit -m 'removing all log files from subversion'"
		system "svn propset svn:ignore '*.log' log/ --force"
		system "svn update log/"
		system "svn commit -m 'Ignoring all files in /log/ ending in .log'"
  end 
end

namespace :svn do
  task :st do
    puts %x[svn st]
  end
  
  task :up do
    puts %x[svn up]
  end
  
  task :add do
    %x[svn st].split(/\n/).each do |line|
      trimmed_line = line.delete('?').lstrip
      if line[0,1] =~ /\?/
        %x[svn add #{trimmed_line}]
        puts %[added #{trimmed_line}]
      end
    end
  end
  
  task :delete do
    %x[svn st].split(/\n/).each do |line|
      trimmed_line = line.delete('!').lstrip
      if line[0,1] =~ /\!/
        %x[svn rm #{trimmed_line}]
        puts %[removed #{trimmed_line}]
      end
    end
  end
end

desc "Run before checking in"
task :pc => ['svn:add', 'svn:delete', 'svn:up', :default, 'svn:st']