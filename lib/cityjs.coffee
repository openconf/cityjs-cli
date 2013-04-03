commander = require 'commander'
fs = require 'fs'
path = require 'path'
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
    generator = this._createGenerator 'cityjs:app', commander.name

    gitClone    = (done) => this._git "clone #{repo} .", done
    generateApp = (done) => generator.run {}, done
    npmInstall  = (done) => this._npm  ['install'], done
    build       = (done) => this.build commander, done

    async.series [gitClone, generateApp, npmInstall, build], cb

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

    build     = (done) => this.build commander, done
    gitAdd    = (done) => this._git 'add -A', done
    gitCommit = (done) => this._git 'commit -m message', done
    gitPush   = (done) => this._git 'push origin master', done

    async.series [build, gitAdd, gitCommit, gitPush], cb

  _createGenerator: (name, args) ->
    env = generators()
    env.register cityjsAppGenerator, 'cityjs'
    env.create name,
      arguments: args,
      options: { silent: true }

  _git: (command, cb) ->
    exec 'git --version', (err) ->
      if err
        console.error 'Git executable not found.'
        return cb()
      exec "git #{command}", (err, stdout, stderr) ->
        console.log stdout
        cb err

  _npm: (params, cb) ->
    npmName = 'npm'
    npmName = 'npm.cmd' if process.platform is 'win32'
    npm = spawn npmName, params, {stdio: 'inherit'}
    npm.on 'exit', cb

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
