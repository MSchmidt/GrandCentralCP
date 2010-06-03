window.addEvent('domready', function(){
	$$('.domain').each(function(i){
		var myDrag = new Drag.Move(i, {
			handle: i.getElement('.domain-nob'),
			container: 'workbench',

			onDrop: function(element, droppable, event){
				if (!droppable) console.log(element, ' dropped on nothing');
				else console.log(element, 'dropped on', droppable, 'event', event);
				$('infobar').fade('hide').fade('in');
			},

			onEnter: function(element, droppable){
				console.log(element, 'entered', droppable);
			},

			onLeave: function(element, droppable){
				console.log(element, 'left', droppable);
			}
		});
		
		i.getElement('.domain_edit').addEvent('click', function(event){
			open_preferences(i);
			event.stop();
		});
	});
	
	//open_preferences($('domain1'));
		
	function open_preferences(parent_element) {
		if (parent_element.getElement('.settings-bubble') == null) {
			var settings_bubble = $('settings_bubble_blueprint').clone().removeClass('hidden');
			settings_bubble.fade('hide').inject(parent_element).fade('in');
			
			var jsonRequest = new Request({
				url: "/users/folder_structure.xml",
				onSuccess: function(response){
					var fibro = new MooFibro(parent_element.getElement('span.domain_path'), {
						container: settings_bubble.getElement('.browser'),
						tree: response,
						//preselected: 'more/eeven_more/really_deep',
						animate: true,
						onSelect: function(selected){
							console.log('select: ' + selected);
						},
						onExtend: function(extended, path, direction){
							console.log('extend: ' + extended + ' - ' + path + ' | ' + direction);
						}
					});
				}
			}).get();
		} else {
			parent_element.getElement('.settings-bubble').fade('toggle');
		}
	}
});