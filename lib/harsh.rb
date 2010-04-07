# Harsh

module ::Haml
  module Filters
    module Harsh
      def initialize(text)
        @text = highlight_text(text)
      end
      def highlight_text(text, opts = ::Harsh::DEFAULT_OPTIONS)
        Uv.parse( text, "xhtml", opts[:format], opts[:lines], opts[:theme])
      end
      def parse_opts(text)
        opts = {}
        all_lines = text.split(/\n/)
        return [opts, text] unless all_lines.first =~ /#!harsh/
        
        line = all_lines.first
        opts[:format] = $1 if line =~ /syntax\s*=\s*([\w-]+)/
        opts[:theme]  = $1 if line =~ /theme\s*=\s*([\w-]+)/
        opts[:lines]  = (line =~ /lines\s*=\s*(\w+)/) ? ($1 == 'true') : false
        
        [opts, all_lines[1..-1].join("\n")]
      end
      
      def render(text)
        opts, text = parse_opts(text)
        Haml::Helpers.preserve(highlight_text(text.rstrip, ::Harsh::DEFAULT_OPTIONS.merge(opts)))
      end
    end
  end
end
  
module Harsh
  module ErbMethods
    def syntax_highlight(*args, &block)
      require 'uv' unless defined? Uv
      opts, text = Harsh::parse_args(args)
      if block_given?
        text = capture(&block)
        text = text.sub(/\n/,"") if text =~ /^(\s*)\n/
      end
      concat(Uv.parse( text, "xhtml", opts[:format].to_s, opts[:lines], opts[:theme].to_s))
      ""
    end
    alias_method :harsh, :syntax_highlight
  end
  
  class << self
    def enable_haml
      ::Haml::Filters::Harsh.send(:include, Haml::Filters::Base)
      ::Haml::Filters::Harsh.module_eval do
        lazy_require 'uv'
      end
    end
    
    def defaults(settings={})
      settings.each do |k, v|
        Harsh::DEFAULT_OPTIONS[k] = v
      end
    end
    alias_method :defaults=, :defaults
  end
  
  private
  
  DEFAULT_OPTIONS = {:format => "ruby", :theme => "twilight", :lines => false}
  
  def self.parse_args(args)
    return DEFAULT_OPTIONS if args.empty?
    
    text = args.first.is_a?(String) ? args.first : nil
    opts = args.last.is_a?(String) ? DEFAULT_OPTIONS : DEFAULT_OPTIONS.merge(args.last)
    text = text.sub(/\n/,"") if text =~ /^(\s*)\n/
    
    [opts, text]
  end
end