$(function(){
	$('#careerfairs').on('click', function(e){
		e.preventDefault();
		$('#mainSearch').closest('div').remove();
		$.post('/getfairs', function(data){
			console.log('Data: ', data.data.rows)
			for(var i=0; i < data.data.rows.length; i++){
				var fair = $('<div class="fair cf"></div>');
				var image = $('<div class="image"><img src="/images/career-fair-' + i + '.png"></div>');
				var info = $('<div class="info"></div>');
				var name = $('<h3 class="name">' + data.data.rows[i].fair_name + '</h3>');
				var institution = $('<p class="institution">' + data.data.rows[i].institution + '</p>');
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


	$(document).on('click', '.institution', function(e){
		e.preventDefault();

		var institution = $(this).text();
		console.log('institution: ',institution);
		$.post('/institution', {institution: institution},function(data){
			console.log('Data: ', data)
			var degree_levels = ['Associate'];
			var student_levels = ['Undergraduate'];

			for(var i=0; i < 100; i++){
				var push = true;
				for(var j=0; j < degree_levels.length; j++){
					if(data.data.rows[i].degree_level === degree_levels[j]) {
						
						push = false;
					}
				}
				if (push){
					degree_levels.push(data.data.rows[i].degree_level);
				}
			}
			for(var i=0; i < 100; i++){
				var push = true;
				for(var j=0; j < student_levels.length; j++){
					if(data.data.rows[i].student_level === student_levels[j]) {
						
						push = false;
					}
				}
				if (push){
					student_levels.push(data.data.rows[i].student_level);
				}
			}
			$('#search-content').before('<h1>' + institution + '</h1>');
			$('#search-content').empty().append('<h3>Degree Levels</h3><ul></ul>');
			$('#more-search-content').empty().append('<h3>Student Levels</h3><ul></ul>');
			for(var k=0; k < degree_levels.length; k++){
				$('#search-content ul').append('<li>'+ degree_levels[k]+ '</li>');
			}
			for(var k=0; k<student_levels.length; k++){
				$('#more-search-content ul').append('<li>'+ student_levels[k]+ '</li>');
			}
		})
	})

});