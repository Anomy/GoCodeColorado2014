
/**
 * Module dependencies.
 */

// includes/requires
var dl = require('datalanche');
var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');

var client = new dl.Client({
    key: 'xTf3fPTITSmWkgykP6+skA==',
    secret: 'kM6A+tQGT4CoyDW1XrOSWQ=='
});

function search(searchText, callback) {
    var q = new dl.Query('rpedela.gocodecolorado');

    q.select([ 
                  "id",
                  "name",
                  "department",
                  "profile_url",
                  "profile_img_url",
                  "_es_highlights"
        ]);

    q.from("cu_faculty_profiles");
    q.search(searchText);
    q.offset(0);
    q.limit(10);

    client.query(q, function(err, result) {
        return callback(err, result);
    });
}

function getSearchResults(req, res, next) {
    // search(req, function(err, result) {
    // if (err) {
    //     console.log(err);
    // } else {
    //     console.log(JSON.stringify(result, null, 4));
    // }
// });
    console.log(req);
}

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);
app.get('/users', user.list);
app.post('/search/', getSearchResults);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
