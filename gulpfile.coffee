gulp              = require('gulp')
gutil             = require('gulp-util')
coffee            = require('gulp-coffee')
exec              = require('gulp-exec')
rename            = require('gulp-rename')
path              = require 'path'
monitorCtrlC      = require 'monitorctrlc'
{spawn, execSync} = require 'child_process'
{colors, log}     = gutil

config =
  watchers:
    index: '*.coffee'
    files: 'src/**/*.coffee'
  index:
    src: 'index.ios.coffee'
    dist: './'
  files:
    src: 'src/**/*.coffee'
    dist: './dist'

gulp.task 'build', ->
  options =
    continueOnError: false
    pipeStdout: true
  gulp.src(config.files.src).pipe(exec('cjsx-transform <%= file.path %>', options)).pipe(rename((path) ->
    path.extname = '.js'
  )).pipe(coffee(bare: true).on('error', gutil.log)).pipe gulp.dest(config.files.dist)

gulp.task 'cjsx', [ 'build' ], ->
  options =
    continueOnError: false
    pipeStdout: true
  gulp.src(config.index.src).pipe(exec('cjsx-transform <%= file.path %>', options))
    .pipe(coffee(bare: true).on('error', gutil.log)).pipe gulp.dest(config.index.dist)

gulp.task 'watch', [ 'cjsx' ], ->
  packageServer = null

  monitorCtrlC ->
    if packageServer
      log "'#{colors.cyan('^C')}', exiting"
      execSync 'pkill -P ' + packageServer.pid
      packageServer = null
    process.exit()

  packageServer = startPackageServer()

  gulp.watch [config.watchers.index, config.watchers.files], [ 'cjsx' ]

gulp.task 'default', [ 'watch' ]

startPackageServer = ->
  cmd = './node_modules/react-native/packager/packager.sh'
  args = [
    path.resolve process.cwd(), 'node_modules/react-native'
    process.cwd()
    8081
  ]
  opts = stdio: 'inherit'
  spawn cmd, args, opts
