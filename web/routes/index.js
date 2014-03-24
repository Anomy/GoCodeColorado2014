/*
 * GET home page.
 */
var dl = require('datalanche');
var client = new dl.Client({
	key: '',
	secret: ''
});


module.exports = {
	index: function(req, res){
  		res.render('index', { title: "Scholar Search"});
	},
	getfairs: function(req, res){
		

		var q = new dl.Query('rpedela.gocodecolorado');
		q.selectAll();
		q.from('career_fair');
 
		client.query(q, function(err, result) {
		    if (err) {
		        console.log(err);
		    } else {
		        console.log(JSON.stringify(result, null, 4));
		        res.send(result);
		    }
		});
		
	},
	institution: function(req, res){
		var term = req.param('institution');
		console.log('req param i: ', term);

		var q = new dl.Query('rpedela.gocodecolorado');
		q.selectAll();
		q.from('degrees_awarded');
		q.search(term)
 
		client.query(q, function(err, result) {
		    if (err) {
		        console.log(err);
		    } else {
		        console.log(JSON.stringify(result, null, 4));
		        res.send(result);
		    }
		});
		
	},
	about: function(req, res){
		res.render('about', {title: "Scholar Search" });
	}
};
