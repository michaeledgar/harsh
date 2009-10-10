namespace :harsh do
  namespace :theme do
    desc 'List available themes'
    task :list do
      puts `uv -l themes`
    end
    desc 'Install a theme - either use install[themename] or install THEME=themename'
    task :install, :theme do |task, args|
      require 'uv'
      args.with_defaults(:theme => ENV['THEME'])
      
      unless Uv.themes.include? args[:theme]
        puts "Error: #{args[:theme]} is not a valid theme."
        next
      end
      
      tmpfolder = File.join(File.dirname(__FILE__), "..", "tmp")
      FileUtils.mkdir_p tmpfolder
      FileUtils.mkdir_p File.join(RAILS_ROOT,"/public/stylesheets/harsh/")
      
      puts "Generating themes..."
      `uv -s ruby --copy-files #{tmpfolder} #{File.dirname(__FILE__)+"/../README.markdown"}`
      
      puts "Copying #{args[:theme]}.css..."
      FileUtils.cp File.join(tmpfolder, "css", "#{args[:theme]}.css"), File.join(RAILS_ROOT, "public", "stylesheets", "harsh")
      
      puts "Cleaning up..."
      FileUtils.rm_rf Dir.glob("#{tmpfolder}/*")
    end
    desc 'Uninstall a theme - either use uninstall[themename] or uninstall THEME=themename'
    task :uninstall, :theme do |task, args|
      args.with_defaults(:theme => ENV['THEME'])
      FileUtils.rm_rf File.join(RAILS_ROOT,"/public/stylesheets/harsh/#{args[:theme]}.css")
    end
  end
  namespace :syntax do
    desc 'List available syntaxes'
    task :list do
      puts `uv -l syntaxes`
    end
  end
end