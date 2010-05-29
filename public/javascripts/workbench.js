window.addEvent('domready', function(){
	$$('.domain').each(function(i){
		var myDrag = new Drag.Move(i, {
			handle: i.getElement('.domain-nob'),
			container: 'workbench',

			onDrop: function(element, droppable, event){
				if (!droppable) console.log(element, ' dropped on nothing');
				else console.log(element, 'dropped on', droppable, 'event', event);
			},

			onEnter: function(element, droppable){
				console.log(element, 'entered', droppable);
			},

			onLeave: function(element, droppable){
				console.log(element, 'left', droppable);
			}
		});
		
		i.getElement('.domain_edit').addEvent('click', function(event){
			console.log('opening options for ' + i.id);
			open_preferences(i);
			event.stop();
		});
	});
	
	open_preferences($('domain1'));
	
	function open_preferences(parent_element) {
		if (parent_element.getElement('.settings-bubble') == null) {
			var settings_bubble = $('settings_bubble_blueprint').clone().removeClass('hidden');
			settings_bubble.fade('hide').inject(parent_element).fade('in');
			
			var jsonRequest = new Request({
				url: "/domains/folder_structure.xml",
				onSuccess: function(response){
					temp = new Element('div').set('html', response);
					
					// hide sub-trees
					temp.getElements('.is_sub').each(function(e){
						e.addClass('hidden');
					});
					
					// make sub-holders extendable
					temp.getElements('.has_sub').each(function(e){
						e.addClass('extendable');
					});
					
					// make all selectable
					temp.getElements('li').each(function(e){
						e.addEvent('click', function(event){
							e.highlight('#ff8', '#444');
						});
					});
					
					temp.inject(settings_bubble.getElement('.browser'));
				}
			}).get();
		} else {
			parent_element.getElement('.settings-bubble').fade('toggle');
		}
	}
});