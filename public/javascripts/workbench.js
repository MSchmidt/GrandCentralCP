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
			
			if (i.getElement('.settings-bubble') == null) {
				var settings_bubble = new Element('div', {
					class: 'settings-bubble'
				});
				settings_bubble.fade('hide').inject(i).fade('in');
				
				var jsonRequest = new Request.JSON({url: "/domains/folder_structure.js", onSuccess: function(structure){
					console.log(structure.folders);
				}}).get();
			} else {
				i.getElement('.settings-bubble').fade('toggle');
			}
			
			event.stop();
		});
	});
});