commander = require 'commander'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
rimraf = require 'rimraf'

engine =

  init: (commander) ->
    console.log 'Not implemented yet ;('

  start: (commander) ->
    console.log 'Not implemented yet ;('

  install: (commander) ->
    console.log 'Not implemented yet ;('

  build: (commander) ->
    console.log 'Not implemented yet ;('

  publish: (commander) ->
    console.log 'Not implemented yet ;('

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
