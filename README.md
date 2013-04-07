CityJS cli  [![Build Status](https://travis-ci.org/openconf/cityjs-cli.png)](https://travis-ci.org/openconf/cityjs-cli)
=====

#Roadmap

The goal Is to build Event site generator. Since we probably use it for JS events the name obviously CityJS.
Since building this stuff should be fun we will do crazy things. First of all we won't generate static site in
usual sense. This will be a single page application that will consume static configurations to render meaningfull 
pages. Than the architecture will be package based (using requirejs) and we gotta do that super easy! or die :(

To be strong we need to be connected. That's why those static sites will also be able to follow each other and
thus we will create decentralized source of geek events, based on github pages or any other simple static sites hostings/.

Stuff that is not possible to do static we will build as open API's with decentralized authentication. I guess we will use browserID. We will use free hosting like nodejitsu - go for it! They support open source initiatives and what could be more open than stuff we are planning to do?

So wear your I'm hacker and I know it t-shirt and go for it:

* TODO: write what to do


CityJS command line tool.

## Usage

Install `cityjs-cli`:
```
npm install cityjs-cli
```

Usage: `cityjs <command> [options]`

Available commands:

* `init`
* `update`
* `start`
* `install`
* `build`
* `publish`

Options:

    -h, --help           output usage information
    -V, --version        output the version number
    -d, --directory [path]  set output directory

### Init

CityJS website generation.

Usage: `cityjs init <git repo> [options]`

Options:

    -d, --directory [path]  working directory
    -n, --name [name]       application or package name
    -g, --github_pages      use `gh-pages` branch

### Update

Pulls all changes from remote repo.

Usage: `cityjs update [options]`

Options:

    -d, --directory [path]  working directory

### Install

Installs given package.

Usage: `cityjs install <package> [options]`

Options:

    -d, --directory [path]  working directory

### Start

Starts developer server (Coffee compiler, livereload, etc.).

Usage: `cityjs start [options]`

Options:

    -d, --directory [path]  working directory

### Build

Builds application.

Usage: `cityjs build [options]`

Options:

    -d, --directory [path]  working directory

### Publish

Commits all changes and pushes to remote repo.

Usage: `cityjs publish [options]`

Options:

    -d, --directory [path]  working directory


