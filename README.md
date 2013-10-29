# JonathanSick.ca

This is the content and code for Jonathan Sick's [website](http://www.jonathansick.ca).
In this edition of the site, I'm using [Jekyll](https://github.com/mojombo/jekyll/) to help generate the HTML from templates and markdown.
Lets also throw in some SASS, with a Susy responsive grid.

## Ruby Environment

Ruby 2.0.0-p247 is selected using rbenv.

The website uses the following ruby gems: `jekyll`, `rdiscount`, `sass`, `compass`, `susy`, `sassy-buttons` and `jekyll-s3`. All dependencies are listed in the ``Gemfile``. Then can be installed using

    bundle install

## Development Setup

To develop, in separate terminals run

    bundle exec compass watch assets/

and

    bundle exec jekyll serve --watch

Then visit [http://localhost:4000/]()

## Deployment

After building the site (with Compass and Jekyll, see above), the site is deployed to S3 using the [jekyll-s3](https://github.com/laurilehmijoki/jekyll-s3) Ruby gem.

    jekyll-s3

Note that the first run of `jekyll-s3` will create a `_jekyll_s3.yml` file where S3/Cloudfront info must be entered.
This file isn't included in the git repository for obvious reasons.

## Jekyll Plugins for Managing Publication Lists

To generate the publications page I've written the `pubindex.rb` ruby plugin.
All publication items are stored as YAML files in the `_publications/` directory.
The plugin uses the [generator](https://github.com/mojombo/jekyll/wiki/Plugins) plugin pattern, where Jekyll will process the plugins, and run any class that inherits from `Generator`.

The entry-point is the `generate()` method of the `PublicationsPageGenerator` class.
It first checks to make sure a `_publications/` directory exists (containing yml publication metadata files), then call the `write_publications_page()` method. It is here that we create a `PublicationsPage` instance that processes the `publications.html` template.

To generate a short list of new papers and talks on the homepage, I also wrote the `pubref.rb` plugin. To add a publication block, the plugin expands the following example liquid markup:

    {% pubref published/2013-02-1-skysubpub.yml %}

***

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">jonathansick.ca</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.jonathansick.ca" property="cc:attributionName" rel="cc:attributionURL">Jonathan Sick</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
