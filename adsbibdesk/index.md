---
layout: basic
type: adsbibdesk
title: "ADS to BibDesk"
lede: Retrieve the BibTeX, abstract and PDF of an astrophysics journal article published on SAO/NASA ADS or astro-ph on arXiv.org and add it to your BibDesk database with a single click.
version: 3.2.0
download_url: http://files.jonathansick.ca/adsbibdesk/adsbibdesk_3.2.0.zip
updated: 2014-5-12
toc:
  - {a: usage, label: How to use it}
  - {a: updating, label: Updating Preprints}
  - {a: configs, label: Configurations}
  - {a: history, label: Release Notes}
---

## Using the Service ##
<a name="usage"></a>

You can gather papers from many sources. In any browser window or document, select any one of the following pieces of text:

- The URL of an ADS or arXiv article page, 
- The ADS bibcode of an article (*e.g.,* `1998ApJ...500..525S`), or 
- The arXiv identifier of an article (*e.g.,* `astro-ph/9710327` or `0911.4956`).
- A DOI on ADS (*e.g.,* `10.1086/305772`)

With the text selected, right-click and choose `Services > Add to BibDesk`.
An Automator icon should pop up in your menu bar while the article downloads, and a notification will appear when the import is complete.

## Using the Command Line Edition ##

Once the script `adsbibdesk` is installed (see above), you can run it with any of the above text tokens to add to add the paper to BibDesk:

    adsbibdesk 1998ApJ...500..525S

You can also use the `-o` flag to download an article&rsquo;s PDF without adding the paper to BibDesk. Useful for quickly previewing an article.

    adsbibdesk -o 1998ApJ...500..525S

This command line edition has even more tricks! Read on to learn how to update arXiv preprints, or import PDFs from a folder on your computer.

<a name="updating"></a>
## Updating Preprints ##

Run the adsbibdesk CL program with the `-u` switch to find and update all astro-ph preprints in your BibDesk bibliography:

    adsbibdesk -u

To restrict this update to a date range, you can use the `--from_date` (`-f`) and `--to_date` (`-t`) flags with dates in `MM/YY` format.
For example, to update preprints published in 2012, run:

    adsbibdesk -u --from_date=01/12 --to_date=12/12

Note that this operation can take some time since we throttle requests to ADS to be a nicer robot.

If you annotated any pre-print PDFs in Skim, we keep those alongside the refereed copy in BibDesk, however custom BibTeX fields are not carried over (this may be addressed in the future).

## Ingesting a Folder of PDFs into BibDesk ##

With the command-line ADS to BibDesk, you can ingest a folder of PDFs that originated from ADS or arXiv.org.
This is great for users who have amassed a literature folder, but are just starting to use BibDesk.
This will get you started quickly.
You need the program [pdf2json](http://code.google.com/p/pdf2json/) to use this script.
The easiest way to get pdf2json and its dependencies is through [Homebrew](http://mxcl.github.com/homebrew/), the Mac package manager.
Once homebrew is setup, simply run `brew install pdf2json`.
To run this workflow,

    adsbibdesk -p my_pdf_dir/

where `my_pdf_dir/` is a directory containing PDFs that you want to ingest.
Note that this workflow relies on a DOI existing in the PDF.
As such, it will not identify astro-ph pre-prints, or published papers older than a few years.
Typically the DOI is published on the first page of modern papers.
This method was inspired by a script by [Dr Lucy Lim](http://www.mit.edu/people/lucylim/BibDesk.html).

<a name="configs"></a>
## Configurations ##

ADS to BibDesk reads configurations from a hidden preferences file located at `~/.adsbibdesk` (ADS to BibDesk will automatically create it if missing).
The configurations, and defaults, are:

- `ads_mirror=adsabs.harvard.edu` &mdash; domain name of your local ADS server
- `arxiv_mirror=None` &mdash; leave unset to use the arXiv mirror pointed to by your ADS mirror
- `download_pdf=True` &mdash; True to automatically get PDF of a paper from ADS/arXiv; False to skip PDFs.

### SSH Proxy ###

You can have ADS to BibDesk download PDFs through a remote machine over SSH. This is useful if you&rsquo;re working from home or abroad and don&rsquo;t have access to journals, yet you have an account on a machine in home institution&rsquo;s network. By setting a SSH URL and user name (see below), ADS to BibDesk will use the computer at your institution to log into the journal and download the PDF.

- `ssh_user=None` &mdash; set to your username on your institutional computer
- `ssh_server=None` &mdash; set to the domain name of your institutional computer (e.g. mymac.university.edu)

Note: the computer at your institution must have [wget](http://www.gnu.org/software/wget/) installed.
You&rsquo;ll also need to setup a public/private key for smooth SSH access.

<a name="history"></a>
## History ##

- v3.2 May 12, 2014 &mdash; A number of improvements to make ADS to BibDesk rock solid:
  - Improved handling of URL redirects (R. Pereira)
  - We finally carry over custom bibtex fields and annotations when we update a paper! (R. Pereira)
  - We open BibDesk if it&rsquo;s closed (R. Pereira)
  - Better fuzzy comparisons of papers before replacing old versions (R. Pereira)
  - Handling for cases when arXiv posts don&rsquo;t have comments (A. Ginsburg)
  - Updated MNRAS PDF downloading (J. Sick)
  - Cleaner package structure (J. Sick)
- v3.1.1 May 5, 2013 &mdash; Fixes for users of Python 2.6, and fixes for quotation marks in ADS comments (R. Pereira).
- v3.1.0 January 15, 2013 &mdash; New engine for interacting with BibDesk (we use pyobjc rather than AppleScript); Integration of arXiv updating pipeline with the adsbibdesk command line program; Integration with the arXiv API for cases where ADS does not yet have the paper in its database (R. Pereira).
- v3.0.6 October 30, 2012 &mdash; Fixes a problem with parsing ADS pages for papers with quotation marks in their titles. Also adds logging support and pip installation support for the command line version.
- v3.0.5 October 11, 2012 &mdash; More robust method of passing data to the injector AppleScript (via a temporary file rather than over the shell).
- v3.0.4 October 6, 2012 &mdash; Supports A&amp;A and ARAA articles that don&rsquo;t have DOIs (via Adam Ginsburg).
- v3.0.3 September 24, 2012 &mdash; Better escaping of text passed between Python and AppleScript.
- v3.0.2 September 23, 2012 &mdash; Integrate PDF ingest workflow into adsbibdesk.py commands and better command line usage
- v3.0.1 September 23, 2012 &mdash; Introduce PDF ingest workflow and adsbibdesk.py can be <code>setup.py install</code>&rsquo;d.
- v3.0 September 16, 2012 &mdash; Supports Mac OS 10.8 with new Automator architecture.
- v2.1.3 October 24, 2011 &mdash; Fixes growl support is Mac OS 10.7 Lion.
- v2.1 May 2011
  - `update_bibdesk_arxiv.sh` for bulk updates of astro-ph articles. Saves astro-ph PDFs with Skim annotations.
  - Numerous bug fixes.
  - Build script for developers.
- v2.1.1 June 21, 2011 &mdash; fix handling of user preferences of ADS mirrors.
- v2.1.2 June 22, 2011
  - MNRAS articles are downloaded (*mostly*) properly. MNRAS has changed their distribution methods over time; a future version will soon address all these cases.
  - Better resolution of arXiv identifiers (*e.g.,* astro-ph/YYMMNNN, arxiv:YYMMNNNN), ADS bibcodes and (new!) DOIs.
  - Strings without &lsquo;http://&rsquo; can still be treated as URLs (useful for Chrome users)
- v2.0 Nov 2009 Robust web parsing and PDF downloading (R. Pereira).
  - Automatically downloads the refereed PDF from ADS if possible, or the PDF from arXiv if not. Can set the script to fetch the article through your institution&rsquo;s network using SSH (see instructions above). Now accepts ADS bibcodes and arxiv reference IDs in addition to URLs. Works from any application, not just Safari. Robust parsing of ADS webpages; proper parsing of HTML/UTF-8 entities in the ADS page; no temporary files. Handles old scanned articles whose abstract is an image. Adds BibDesk external URLs with ADS/DOI links. Uses growl notification.
- v1.1 Dec 2007 &mdash; Changed webpage parsing logic (R. de Jong)
- v1.0 Aug 2007 &mdash; First release. (J. Sick)
