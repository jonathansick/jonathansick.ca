# JonathanSick.ca

This is the content and code for Jonathan Sick's [website](http://www.jonathansick.ca).
In this edition of the site, I'm using [Jekyll](https://github.com/mojombo/jekyll/) to help generate the HTML from templates and markdown.
Lets also throw in some SASS, with a Susy responsive grid.

## Development Setup

To develop, in separate terminals run

    jekyll --auto --server

and

    compass watch assets/

Then visit [http://localhost:4000/]()

## Notes on pubindex.rb

To generate populate the publications page I've written te `pubindex.rb` ruby plugin.
I use the [generator](https://github.com/mojombo/jekyll/wiki/Plugins) plugin pattern, where Jekyll will process the plugins, and run any class that inherits from `Generator`.

The entry-point is the `generate()` method of the `PublicationsPageGenerator` class.
It first checks to make sure a `_publications/` directory exists (containing yml publication metadata files), then call the `write_publications_page()` method. It is here that we create a `PublicationsPage` instance that processes the `publications.html` template.
