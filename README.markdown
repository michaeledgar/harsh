harsh
=====
* http://www.carboni.ca/

DESCRIPTION:
============
"Harsh: Another Rails Syntax Highlighter," is just that - it highlights code
in Rails, much like Radiograph or tm_syntax_highlighting. However, it does it well, _better_.
Oh, and it also supports Haml, as well as ERb. And it comes with rake tasks.

Firstly, it allows block form:
    <% harsh :theme => :dawn do %>
      class Testing
        def initialize(str)
          puts str
        end
      end
    <% end %>
as well as the form the other plugins offer, which is text as a parameter:
    <% harsh %Q{
      class Testing
        def initialize(str)
          puts str
        end
      end
    }, :theme => :dawn
    
For haml, harsh is implemented as a filter. First, add this to the bottom of your environment.rb:
    Harsh.enable_haml
    
Then, to use harsh in Haml:
    :harsh
      class Foo < Bar
      end

However, haml's filters can't take options. So how on earth are we going to customize it to our
heart's delight? Easily, my friend, fret not! Enter the BCL (Bootleg Configuration Line):

    :harsh
      #!harsh theme = all_hallows_eve lines=true syntax=css
      h1 {
        float:left;
        clear:left;
        position:relative;
      }

It has to be the first line in the filter. You don't need the config line, though. Also, notice
that you can have spaces between the arguments and the little = sign.

Harsh also offers rake tasks for what tm_syntax_highlighting provides in generators,
and a :harsh as a stylesheet-includer to load all syntax-highlighting files, as such:
    <%= stylesheet_include_tag :harsh %>

The rake tasks for setting up your stylesheets are these:
    rake harsh:theme:list # lists available themes
    rake harsh:theme:install[twilight] # installs the twilight theme into /public/stylesheets/harsh/
    rake harsh:theme:install THEME=twilight # also installs the twilight theme (for *csh shells)
    rake harsh:theme:uninstall[twilight] # removes the twilight theme
    rake harsh:theme:uninstall THEME=twilight # also uninstalls the twilight theme (for *csh shells)
    
While purely informative, you can find out the available syntaxes as follows:
    rake harsh:syntax:list

FEATURES/PROBLEMS
=================

* Syntax highlighting with text as a parameter AND block form!
* Rake tasks for setting up your stylesheets!
* Free hat!

SYNOPSIS
========

You can pass any of these parameters to tweak things:
    <% harsh :theme => :dawn, :lines => true, :format => :css do %>
      h1 {
        float:left;
        clear:left;
        position:relative;
      }
    <% end %>
    
In its default form though, harsh will use the twilight theme, no lines, and
will expect Ruby code.

    <% harsh %Q{
      class Testing
        def initialize(str)
          puts str
        end
      end
    }, :theme => :dawn
    
For Haml:

    :harsh
      #!harsh theme = all_hallows_eve lines=true syntax=css
      h1 {
        float:left;
        clear:left;
        position:relative;
      }
      
The #!harsh line is a configuration line that is optional. Notice that the parameter is "syntax=css",
not "format" as is the case with the ERb helper.

REQUIREMENTS
============

* oniguruma - a regex library. See installation.
* ultraviolet gem - this does the highlighting. See installation.
* haml - if you want to use the haml filter. duh.

CONTRIBUTORS
============

* Michael Edgar
* Evan Sagge

INSTALL
=======

First, you'll need oniguruma - a regex library. If you don't think you have this, you probably don't.
To install it, do the following:
    wget http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.8.0.tar.gz
    tar zxvf onig-5.8.0.tar.gz
    cd onig-5.8.0/
    ./configure && make && sudo make install

ultraviolet gem - do this AFTER oniguruma!
    sudo gem install ultraviolet
    
Then, install this plugin:
    script/plugin install git://github.com/michaeledgar/harsh.git

LICENSE
=======

(The MIT License)

Copyright (c) 2009 Michael J. Edgar

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
