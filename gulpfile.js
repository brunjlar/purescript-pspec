var gulp       = require('gulp');
var purescript = require('gulp-purescript');
var foreach    = require('gulp-foreach');
var mocha      = require('gulp-mocha');

var path       = require('path');

var bowerPurs = 'bower_components/purescript-*/src/**/*.purs';
var sources = [bowerPurs, 'src/**/*.purs'];

gulp.task('pscMake', function(){
  return gulp
    .src(sources)
    .pipe(purescript.pscMake());
});

gulp.task('dotPsci', function(){
  return gulp
    .src(sources)
    .pipe(purescript.dotPsci());
});

gulp.task('pscDocs', function(){
  return gulp
    .src('src/**/*.purs')
    .pipe(foreach(function(stream, file){
      var p = path.resolve(
        'docs',
        path.dirname(file.relative),
        path.basename(file.relative, ".purs") + ".md")
      return stream
        .pipe(purescript.pscDocs())
        .pipe(gulp.dest(p));
    }));
});

gulp.task('example', function(){
  return gulp
    .src(sources.concat('examples/Main.purs'))
    .pipe(purescript.psc({main: "Test.Main", output: 'main.js'}))
    .pipe(gulp.dest('examples/'))
    .pipe(mocha());
});

gulp.task('test', ['example']);

gulp.task('default', ['pscMake', 'dotPsci', 'pscDocs', 'example']);
