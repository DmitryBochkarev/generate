global.ejs = require 'ejs'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'

HOME = process.env.HOME
TEMPLATE_DIR = if process.env.TEMPLATE_DIR
  path.resolve(process.cwd(), process.env.TEMPLATE_DIR)
else
  "#{HOME}/.templates"

module.exports = class Template
  constructor: (@generator, @outputDir, @template, @params = {}) ->
    @conf = require(path.resolve(TEMPLATE_DIR, "./#{generator}/conf"))
    @options = @conf.templates[template]
    @single = !!(@options.file)

  write: ->
    if @single
      if @options.dir
        console.log("Create directory:")
        dir = path.resolve process.cwd(), @outputDir, ejs.render(@options.dir, @params)
        mkdirp.sync dir
        console.log dir
      @writeOne @options.file, @options.output
    else
      for dir in @options.dirs
        console.log("Create directory:")
        _dir = path.resolve process.cwd(), @outputDir, ejs.render(dir, @params)
        mkdirp.sync _dir
        console.log(_dir)
      for file in @options.files
        @writeOne file[0], file[1]
    this

  writeOne: (templateFile, outputFile) ->
    filename = ejs.render(outputFile, @params)
    outputFilename = path.resolve(process.cwd(), @outputDir, filename)
    template = fs.readFileSync(path.resolve(TEMPLATE_DIR, "./#{@generator}/#{templateFile}"), 'utf8')
    content = ejs.render(template, @params)
    console.log("Create file:")
    fs.writeFileSync(outputFilename, content, 'utf8')
    console.log(outputFilename)

# Custom filters
ejs.filters.underscore = (str) ->
  str.replace(/\ /g, '_')
