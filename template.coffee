global.ejs = require 'ejs'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
async = require 'async'

module.exports = class Template
  constructor: (@conf, @templateDir, @generator, @outputDir, @template, @params = {}) ->
    @options = @conf.templates[template]
    @single = !!(@options.file)

  write: (done) ->
    if @single
      async.series [
        (done) =>
          if @options.dir
            dir = path.resolve process.cwd(), @outputDir, ejs.render(@options.dir, @params)
            console.log "Create directory: #{dir}"
            mkdirp dir, done()
          else
            done()

        (done) =>
          @writeOne @options.file, @options.output, done
      ], (done || ->)
    else
      async.series [
        (done) =>
          if @options.dirs
            f = (dir, done) =>
              _dir = path.resolve process.cwd(), @outputDir, ejs.render(dir, @params)
              console.log "Create directory: #{_dir}"
              mkdirp _dir, done

            async.forEach @options.dirs, f, done
          else
            done()
        (done) =>
          f = (file, done) =>
            @writeOne file[0], file[1], done

          async.forEach @options.files, f, done
      ], (done || ->)

    this

  writeOne: (templateFile, outputFile, done) ->
    filename = ejs.render(outputFile, @params)
    outputFilename = path.resolve(process.cwd(), @outputDir, filename)
    file = path.resolve @templateDir, "./#{@generator}/#{templateFile}"
    fs.readFile file, 'utf8', (err, template) =>
      return done(err) if err

      content = ejs.render(template, @params)
      console.log "Create file: #{outputFilename}"
      fs.writeFile outputFilename, content, 'utf8', done

# Custom filters
ejs.filters.underscore = (str) ->
  str.replace(/\ /g, '_')
