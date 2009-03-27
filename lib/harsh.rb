# Harsh
module Harsh
  module ErbMethods
    def syntax_highlight(*args, &block)
      require 'uv'
      default_options = {:format => "ruby", :theme => "twilight", :lines => false}
      case args.size
      when 0
        opts = default_options
      when 1
        if args[0].is_a? String
          text = args[0]
          opts = default_options
        elsif args[0].is_a? Hash
          opts = default_options.merge(args[0])
        else
          raise ArgumentError.new("Must pass either a string or a hash to syntax_highlight()/harsh()")
        end
      when 2
        text = args[0]
        text = text.sub(/\n/,"") if text =~ /^(\s*)\n/
        opts = default_options.merge(args[1])
      end
      if block_given?
        text = capture(&block)
        text = text.sub(/\n/,"") if text =~ /^(\s*)\n/
        concat(Uv.parse( text, "xhtml", opts[:format].to_s, opts[:lines], opts[:theme].to_s))
        ""
      else
        concat(Uv.parse( text, "xhtml", opts[:format].to_s, opts[:lines], opts[:theme].to_s))
        ""
      end
    end
    alias_method :harsh, :syntax_highlight
  end
  
  def enable_haml
    eval <<-EOF
      module ::Haml
        module Filters
          module Harsh
            include Haml::Filters::Base
            lazy_require 'uv'
            def initialize(text)
              @text = highlight_text(text)
            end
            def highlight_text(text, opts = {:format => "ruby", :theme => "twilight", :lines => false})
              Uv.parse( text, "xhtml", opts[:format], opts[:lines], opts[:theme])
            end
            def render(text)
              all_lines = text.split(/\\n/)
              if all_lines.first =~ /#!harsh/
                line = all_lines.first
                syntax = (line =~ /syntax\\s*=\\s*([\\w-]+)/) ? $1 : "ruby"
                theme = (line =~ /theme\\s*=\\s*(\\w+)/) ? $1 : "twilight"
                lines = (line =~ /lines\\s*=\\s*(\\w+)/) ? ($1 == 'true') : false
                text = all_lines[1..-1].join("\\n")
                puts({:format => syntax, :theme => theme, :lines => lines}.inspect)
                Haml::Helpers.preserve(highlight_text(text.rstrip, :format => syntax, :theme => theme, :lines => lines))
              else
                Haml::Helpers.preserve(highlight_text(text.rstrip))
              end
            end
          end
        end
      end
    EOF
  end
  module_function :enable_haml
end


