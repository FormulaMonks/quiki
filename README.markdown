Quiki
=====

Quiki is a simple wiki aimed at developers.

NAQ (Never Asked Questions)
---------------------------

Q. Why is a tiny app like Quiki written in big bulky Rails and not in something *quick* like Sinatra/Merb/Raw Machine Code?

A. Because Rails is so easy to extend and add to and can take advantage of all the wonderful plugins! (Quiki is built upon the backs of many previous laborers).

Installation
------------

Quiki is a Ruby on Rails application, so in order to use it just clone this repository and start playing.

    git clone git://github.com/citrusbyte/quiki.git

### Dependencies

It depends on Ultraviolet for code syntax highlighting:

    $ gem install ultraviolet

If it complains about needed Oniguruma, check http://snippets.aktagon.com/snippets/61-Installing-Ultraviolet-and-Oniguruma

It also depends on Graphviz for diagram generation

    http://graphviz.org/

License
-------

Copyright (c) 2009 Ben Alavi for Citrusbyte

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
