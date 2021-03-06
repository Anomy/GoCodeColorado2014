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
    key: '',
    secret: ''
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

    search(req.body.searchText, function(err, result) {
        if (err) {
            return next(err);
        }

        return res.render("index", {
            searchResults: result.data,
            searchText: req.body.searchText,
        });
    });
}

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);
app.get('/users', user.list);
app.post('/search', getSearchResults);

app.post('/getfairs', routes.getfairs);
app.post('/institution', routes.institution);

app.get('/about', routes.about);


http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
