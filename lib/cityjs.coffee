commander = require 'commander'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
nodefs = require 'node-fs'
grunt = require 'grunt'
spawn  = require('child_process').spawn
generators = require '../node_modules/generator-cityjs/node_modules/yeoman-generator/'
cityjsAppGenerator = require "#{__dirname}/../node_modules/generator-cityjs/app/"

initialDir = process.cwd()

engine =

  init: (commander, cb) ->
    generator = this._createGenerator 'cityjs:app', commander.name
    generator.run {}, (err) ->
      cb err if err
      npmName = 'npm'
      npmName = 'npm.cmd' if process.platform is 'win32'
      npmInstall = spawn npmName, ['install'], {stdio: 'inherit'}
      npmInstall.on 'exit', cb

  start: (commander, cb) ->
    grunt.tasks {tasks: ['default']}, cb

  install: (commander, cb) ->
    console.log 'Not implemented yet ;('
    cb()

  build: (commander, cb) ->
    grunt.tasks {tasks: ['build']}, cb

  publish: (commander, cb) ->
    console.log 'Not implemented yet ;('
    cb()

  _createGenerator: (name, args) ->
    env = generators()
    env.register cityjsAppGenerator, 'cityjs'
    env.create name, arguments: args

run = () ->
  commander
    .version('0.0.1')
    .usage('<command> [options] \n\n  where <command> is one of: init, start, install, build, publish')
    .option('-o, --output [path]', 'set output directory', '.')
    .option('-n, --name [name]', 'set application or package', undefined)
    .parse process.argv

  if commander.args.length == 0 or not engine[commander.args[0]]
    return commander.outputHelp()

  outputDir = path.join process.cwd(), commander.output
  nodefs.mkdirSync outputDir, null, true
  process.chdir outputDir
  engine[commander.args[0]] commander, (err) ->
    console.error err if err
    process.chdir initialDir

module.exports.run = run
