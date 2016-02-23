var gulp = require('gulp');
var coffee = require ('gulp-coffee');
var sass = require ('gulp-sass');
var gutil = require ('gulp-util');
var clean = require('gulp-clean');
var server = require('gulp-webserver');
var KarmaServer = require('karma').Server;

gulp.task('styles', function() {
  return gulp.src('./app/stylesheets/*.scss')
    .pipe(sass({ style: 'expanded' }).on('error', sass.logError))
    .pipe(gulp.dest('./dist/stylesheets'));
});

gulp.task('coffee', function() {
  return gulp.src('./app/javascripts/*.coffee')
    .pipe(coffee({ bare: false }).on('error', swallowError))
    .pipe(gulp.dest('./dist/javascripts'));
});

gulp.task('images', function() {
  return gulp.src('./app/images/*.*')
    .pipe(gulp.dest('./dist/images'));
});

gulp.task('markup', function() {
  return gulp.src('./app/*.html')
    .pipe(gulp.dest('./dist'));
});

gulp.task('clean', function() {
  return gulp.src(['./dist'], { read: false })
    .pipe(clean());
});

gulp.task('default', ['clean'], function() {
  return gulp.start('styles', 'coffee', 'images', 'markup');
});

gulp.task('server', ['watch'], function() {
  gulp.src('./dist')
    .pipe(server({ livereload: true }));
});

gulp.task('test', function (done) {
  new KarmaServer({
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  }, done).start();
});

gulp.task('watch', function() {
  gulp.watch('app/stylesheets/*.scss', ['styles']);
  gulp.watch('app/javascripts/*.coffee', ['coffee']);
  gulp.watch('app/images/*.*', ['images']);
  gulp.watch('app/*.html', ['markup']);
});

function swallowError (error) {
  console.log(error.toString());
  this.emit('end');
}