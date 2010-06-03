window.addEvent('domready', function(){
	$$('.domain').each(function(i){
		i.store('pos_x', i.getStyle('left'));
		i.store('pos_y', i.getStyle('top'));
		i.store('domain_path', i.getElement('.domain_path').get('html'));
		
		var myDrag = new Drag.Move(i, {
			handle: i.getElement('.domain-nob'),
			container: 'workbench',

			onDrop: function(element, droppable, event){
				register_change(i);
			}
		});
		
		// bring clicked to top
		i.addEvent('mousedown', function(event){
			$$('.domain').each(function(d_to_send_back){
				d_to_send_back.setStyle('z-index', 0);
			});
			i.setStyle('z-index', 10);
		});
		
		i.getElement('.domain_edit').addEvent('click', function(event){
			open_preferences(i);
			event.stop();
		});
	});
	
	// UNDO
	$('undo_button').addEvent('click', function(event){
		$$('.domain').each(function(i){
			var move = new Fx.Morph(i);
			move.start({
				'left': i.retrieve('pos_x'),
				'top': i.retrieve('pos_y')
			});
			
			i.getElement('.domain_path').set('html', i.retrieve('domain_path'));
			i.getElement('.domain_changed').set('html', '0');
		});
		
		$('infobar').fade('out');
		$('infobar-expanded').set('html', '');
		event.stop();
	});
	
	// SAVE
	$('save_button').addEvent('click', function(event){
		$$('.domain').each(function(i){
			if (i.getElement('.domain_changed').get('html') == '1') {
				var request = new Request({
					url: "/domains/" + i.getElement('.domain_id').get('html') + '.xml',
					onSuccess: function(response) {
						console.log('updated');
					}
				}).post({
					'_method': 'put',
					'domain[mount_point]': i.getElement('.domain_path').get('html'),
					'domain[workbench_x]': i.getStyle('left'),
					'domain[workbench_y]': i.getStyle('top')
				});
			}
		});
		
		$('infobar').fade('out');
		$('infobar-expanded').set('html', '');
		event.stop();
	});
	
	//open_preferences($('domain1'));
		
	function open_preferences(parent_element) {
		if (parent_element.getElement('.settings-bubble') == null) {
			var settings_bubble = $('settings_bubble_blueprint').clone().removeClass('hidden');
			settings_bubble.fade('hide').inject(parent_element).fade('in');
			
			var request = new Request({
				url: "/users/" + parent_element.getElement('.domain_owner').get('html') + "/folder_structure.xml",
				onSuccess: function(response){
					var fibro = new MooFibro(parent_element.getElement('span.domain_path'), {
						container: settings_bubble.getElement('.browser'),
						tree: response,
						animate: true,
						onSelect: function(selected){
							this.target.highlight();
							change_domain_path(parent_element, selected);
						},
						onExtend: function(extended, path, direction){
							//console.log('extend: ' + extended + ' - ' + path + ' | ' + direction);
						}
					});
				}
			}).get();
		} else {
			parent_element.getElement('.settings-bubble').fade('toggle');
		}
	}
	
	function change_domain_path(element, new_path){
		register_change(element);
		
		var request = new Request.JSON({
			url: "/domains/" + element.getElement('.domain_id').get('html') + "/change_preview.js",
			onSuccess: function(response){
				$('infobar-expanded').set('html', response.vhost);
			}
		}).get({
			'domain_path': new_path
		});
	}
	
	function register_change(element) {
		element.getElement('.domain_changed').set('html', '1');
		$('infobar').fade('in');
	}
});