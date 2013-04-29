fs               = require 'fs'
path             = require 'path'
grunt            = require 'grunt'
spawn            = require('child_process').spawn
exec             = require('child_process').exec
async            = require 'async'
nodefs           = require 'node-fs'
commander        = require 'commander'
generators       = require '../../generator-cityjs/node_modules/yeoman-generator/'
appGenerator     = require '../../generator-cityjs/app/'
packageGenerator = require '../../generator-cityjs/package/'

initialDir = process.cwd()

engine =

  init: (commander, cb) ->
    if commander.args.length < 2
      return commander.outputHelp()
    repo      =  commander.args[1]
    branch    =  'master'
    branch    =  'gh-pages' if commander.ghPages
    generator = this._createGenerator 'cityjs:app', commander.name
    
    gitClone    = (done) => this._git "clone #{repo} .", done
    gitBranch   = (done) => this._git "checkout -B #{branch}", done
    gitConfig   = (done) => this._git 'config push.default current', done
    generateApp = (done) => generator.run {}, done
    npmInstall  = (done) => this._npm 'install', done
    build       = (done) => this.build commander, done
    that = this
    gitGhBranch = (done) =>
      that._checkBranch 'gh-pages', (exists)->
        if(!exists)
          return that._git "checkout -b gh-pages", ->
            that._git "push origin gh-pages", ->
              that._git "checkout master"
        done()

    async.series [gitClone, gitBranch, gitConfig, generateApp, npmInstall, build, gitGhBranch], cb

	#TODO: it should update all packages instead of pulling repo I guess
  update: (commander, cb) ->
    this._git 'pull origin', cb

  start: (commander, cb) ->
    return this._branchName ->
    grunt.tasks 'default', {}, cb

  install: (commander, cb) ->
    if commander.args.length < 2
      return commander.outputHelp()
    packageName =  commander.args[1]
    generator = this._createGenerator 'cityjs:package', packageName
    generator.run {}, cb

  build: (commander, cb) ->
    grunt.tasks 'build', {}, cb

###
  publish: (commander, cb) ->
    build     = (done) => this.build commander, done
    gitAdd    = (done) => this._git 'add -A', done
    gitCommit = (done) => this._git 'commit -am Publish', done
    gitPush   = (done) => this._git 'push origin', done

    async.series [build, gitAdd, gitCommit, gitPush], cb
###

  #build better with http://jgoodall.me/posts/2012/10/26/keep-gh-pages-in-sync-with-master/
  deliver: (commander, cb) ->
    gitGhPages= (done) => this._git 'checkout gh-pages', done
    merge     = (done) => this._git 'merge master', done
    build     = (done) => this.build commander, done
    
    gitAdd    = (done) => this._git 'add -A', done
    gitCommit = (done) => this._git 'commit -am Publish', done
    gitPush   = (done) => this._git 'push origin gh-pages master', done
    gitBack   = (done) => this._git 'checkout master', done
    

    async.series [gitGhPages, merge, build, gitAdd, gitCommit, gitPush, gitBack], cb


  _createGenerator: (name, args) ->
    env = generators()
    env.register appGenerator, 'cityjs:app'
    env.register packageGenerator, 'cityjs:package'
    env.create name,
      arguments: args,
      options: { silent: true }

  _git: (params, cb) ->
    git = spawn 'git', params.split(' '), {stdio: 'inherit'}
    git.on 'exit', cb
  
  _gitExec: (params, cb) ->
    git = exec 'git ' + params, cb
  
  _clean: (cb) ->
    clean = exec 'ls | grep -v deploy | xargs rm -rf', {stdio: 'inherit'}, cb

  _checkBranch: (branch, cb) ->
    this._git "show-ref --verify --quiet refs/heads/#{branch}", (exitCode)->
      cb(exitCode is 0)

  _branchName: (cb) ->
    this._gitExec "rev-parse --abbrev-ref HEAD", (err, out)->
      if(err or not out)
        return cb(err)
      cb null, out.split("\n").join("")

  _npm: (params, cb) ->
    npmName = 'npm'
    npmName = 'npm.cmd' if process.platform is 'win32'
    npm = spawn npmName, params.split(' '), {stdio: 'inherit'}
    npm.on 'exit', cb

run = () ->
  commander
    .version('0.0.5')
    .usage('<command> [options] \n\n  where <command> is one of: init, update, start, install, build, deliver')
    .option('-d, --directory [path]', 'working directory', '.')
    .option('-n, --name [name]', 'set application or package')
    .option('-g, --gh-pages', 'use `gh-pages` branch')
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
