CityJS cli  [![Build Status](https://travis-ci.org/openconf/cityjs-cli.png)](https://travis-ci.org/openconf/cityjs-cli)
=====

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

### Update

Pulls all changes from remote repo.

Usage: `cityjs update [options]`

Options:

    -d, --directory [path]  working directory

### Install

Installs given extension.

Usage: `cityjs install <extension> [options]`

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
