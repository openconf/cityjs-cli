commander = require 'commander'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
rimraf = require 'rimraf'
generators = require '../node_modules/generator-cityjs/node_modules/yeoman-generator/'
cityjsAppGenerator = require "#{__dirname}/../node_modules/generator-cityjs/app/"

engine =

  init: (commander) ->
    generator = this._createGenerator 'cityjs:app', commander.name
    generator.run {}, () ->

  start: (commander) ->
    console.log 'Not implemented yet ;('

  install: (commander) ->
    console.log 'Not implemented yet ;('

  build: (commander) ->
    console.log 'Not implemented yet ;('

  publish: (commander) ->
    console.log 'Not implemented yet ;('

  _createGenerator: (name, args) ->
    env = generators()
    env.register cityjsAppGenerator, 'cityjs'
    env.create name, {arguments: args}

run = () ->
  commander
    .version('0.0.1')
    .usage('<command> [options] \n\n  where <command> is one of: init, start, install, build, publish')
    .option('-o, --output [path]', 'set output directory', '.')
    .option('-n, --name [name]', 'set application or package', undefined)
    .parse process.argv

  if commander.args.length == 0 or not engine[commander.args[0]]
    return commander.outputHelp()

  commander.output = path.join process.cwd(), commander.output
  engine[commander.args[0]] commander

module.exports.run = run
