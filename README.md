# JonathanSick.ca

This is the content and code for Jonathan Sick's [website](http://www.jonathansick.ca).
In this edition of the site, I'm using [Jekyll](https://github.com/mojombo/jekyll/) to help generate the HTML from templates and markdown.
Lets also throw in some SASS, with a Susy responsive grid.

## Dependencies

The website needs the following Ruby gems to compile:

    gem install jekyll sass compass susy sassy-buttons

## Development Setup

To develop, in separate terminals run

    jekyll --auto --server

and

    compass watch assets/

Then visit [http://localhost:4000/]()

## Deployment

After building the site (with Compass and Jekyll, see above), the site is deployed to S3 using the [jekyll-s3](https://github.com/laurilehmijoki/jekyll-s3) Ruby gem.

    jekyll-s3

Note that the first run of `jekyll-s3` will create a `_jekyll_s3.yml` file where S3/Cloudfront info must be entered.
This file isn't included in the git repository for obvious reasons.

## Notes on pubindex.rb

To generate populate the publications page I've written te `pubindex.rb` ruby plugin.
I use the [generator](https://github.com/mojombo/jekyll/wiki/Plugins) plugin pattern, where Jekyll will process the plugins, and run any class that inherits from `Generator`.

The entry-point is the `generate()` method of the `PublicationsPageGenerator` class.
It first checks to make sure a `_publications/` directory exists (containing yml publication metadata files), then call the `write_publications_page()` method. It is here that we create a `PublicationsPage` instance that processes the `publications.html` template.

***

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">jonathansick.ca</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.jonathansick.ca" property="cc:attributionName" rel="cc:attributionURL">Jonathan Sick</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
