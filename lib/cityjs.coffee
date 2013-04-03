commander = require 'commander'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
async = require 'async'
nodefs = require 'node-fs'
grunt = require 'grunt'
spawn  = require('child_process').spawn
exec  = require('child_process').exec
generators = require '../node_modules/generator-cityjs/node_modules/yeoman-generator/'
cityjsAppGenerator = require "#{__dirname}/../node_modules/generator-cityjs/app/"

initialDir = process.cwd()

engine =

  init: (commander, cb) ->
    if commander.args.length < 2
      return commander.outputHelp()
    repo =  commander.args[1];
    this._git "clone #{repo} .", (err) =>
      return cb err if err
      generator = this._createGenerator 'cityjs:app', commander.name
      generator.run {}, (err) =>
        return cb err if err
        npmName = 'npm'
        npmName = 'npm.cmd' if process.platform is 'win32'
        npmInstall = spawn npmName, ['install'], {stdio: 'inherit'}
        npmInstall.on 'exit', (err) =>
          cb err if err
          this.build commander, cb

  update: (commander, cb) ->
    #TODO: master or gh-pages?
    this._git "pull origin master", cb

  start: (commander, cb) ->
    grunt.tasks 'default', {}, cb

  install: (commander, cb) ->
    console.log 'Not implemented yet ;('
    cb()

  build: (commander, cb) ->
    grunt.tasks 'build', {}, cb

  publish: (commander, cb) ->

    build = (done) => this.build commander, done
    gitAdd = (done) => this._git 'add -A', done
    gitCommit = (done) => this._git 'commit -m message', done
    gitPush = (done) => this._git 'push origin master', done

    async.series [build, gitAdd, gitCommit, gitPush], cb

  _createGenerator: (name, args) ->
    env = generators()
    env.register cityjsAppGenerator, 'cityjs'
    env.create name,
      arguments: args,
      options: { silent: true }

  _git: (command, cb) ->
    exec 'git --version', (err) ->
      console.error 'Git executable not found.' if err
      return cb err if err
      exec "git #{command}", (err, stdout, stderr) ->
        console.log stdout
        cb err

run = () ->
  commander
    .version('0.0.1')
    .usage('<command> [options] \n\n  where <command> is one of: init, update, start, install, build, publish')
    .option('-d, --directory [path]', 'working directory', '.')
    .option('-n, --name [name]', 'set application or package', undefined)
    .parse process.argv

  if commander.args.length == 0 or not engine[commander.args[0]]
    return commander.outputHelp()

  workingDir = path.join process.cwd(), commander.directory
  nodefs.mkdirSync workingDir, null, true
  process.chdir workingDir
  engine[commander.args[0]] commander, (err) ->
    console.error err if err
    process.chdir initialDir

module.exports.run = run
