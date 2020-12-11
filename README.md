![Pivpn Banner](docs/img/pivpnbanner.png)

[![Build Status](https://travis-ci.com/pivpn/docs.svg?branch=master)](https://travis-ci.com/pivpn/docs)

## Documentation & User Guides

This repo is the source for the official [PiVPN Documentation](https://docs.pivpn.io).

### How to contribute

PiVPN Documentation is powered by [MKDocs-Material](https://squidfunk.github.io/mkdocs-material/),

Please refer to [MKDocs Documentation](https://www.mkdocs.org/user-guide/) and [MKDocs-Material Documentation](https://squidfunk.github.io/mkdocs-material/) for more detailed information for information on how to install or more detailed documentation


To add a new link on the navigation panel you need to edit the `mkdocs.yml` file in the root of the repo. There is a guide for building the navbar at [mkdocs wiki](https://www.mkdocs.org/user-guide/configuration/#nav)

To add a new document

- Navigate to the `docs/` directory
- Create the file using a URL friendly filename.
    EG. `docs/url-friendly.md` or `docs/guides/url-friendly.md`
- Edit your document using Markdown, there are loads of resources available for the correct syntax.

### Test your changes

When working on this repo, it is advised that you review your changes locally before committing them. The `mkdocs serve` command can be used to live preview your changes (as you type) on your local machine.

* Install [MKDocs-Material](https://squidfunk.github.io/mkdocs-material/getting-started/)
* Fork the repo
* clone it locally with `git clone https://github.com/YOUR-USERNAME/docs`
* run `mkdocs serve`
* open browser, and access `localhost:8000`
* Make your changes and verify them live while you do them
* Commit code `git commit -a`, make sure you add a nice message to your commit
* Push code to your fork `git push origin master`
* Make Pull Request

### Deployment

Once changes are merged to master branch, CI Pipeline will run and take care of everything.
It may take up to 24h until changes are visible on live documentation website.
