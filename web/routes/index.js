
/*
 * GET home page.
 */
var dl = require('datalanche');



module.exports = {
	index: function(req, res){
  		res.render('index', { title: "Scholar Search"});
	},
	getfairs: function(req, res){
		var client = new dl.Client({
    		key: 'l9umNDiaQAe7oLnidLgGcw==',
    		secret: '8OEtau8PS2OQEcVSwPGuNw=='
		});

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
		
	}
};