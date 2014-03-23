$(function(){
	$('#careerfairs').on('click', function(e){
		e.preventDefault();

		$.post('/getfairs', function(data){
			console.log('Data: ', data.data.rows)
			for(var i=0; i < data.data.rows.length; i++){
				var fair = $('<div class="fair cf"></div>');
				var image = $('<div class="image"><img src="/images/career-fair-' + i + '.png"></div>');
				var info = $('<div class="info"></div>');
				var name = $('<h3 class="name">' + data.data.rows[i].fair_name + '</h3>');
				var institution = $('<p>' + data.data.rows[i].institution + '</p>');
				var date = $('<p>Date: ' + data.data.rows[i].date + '</p>');
				var location = $('<p>Location: ' + data.data.rows[i].location + '</p>');
				var link = $('<p><a href="'+ data.data.rows[i].career_center_link + '">' + data.data.rows[i].career_center_link + '</a></p>');

				info.append(name);
				info.append(institution);
				info.append(date);
				info.append(location);
				info.append(link);
				fair.append(image);
				fair.append(info);

				$('#search-content').append(fair);

			}
		})
	})

});