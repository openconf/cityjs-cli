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
    -o, --output [path]  set output directory

### Init

CityJS website generation.

Usage: `cityjs init <git repo> [options]`

Options:

    -o, --output [path]  set output directory
    -n, --name [name]    set application or package name

### Update

Pulling all changes from remote repo.

Usage: `cityjs update [options]`

Options:

    -o, --output [path] working directory
