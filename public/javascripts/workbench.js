window.addEvent('domready', function(){
	$$('.domain').each(function(e){
		console.log('whoot' + e);
	});
	
	// var myDrag = new Drag.Move('draggable', {
	// 
	//     container: 'workbench',
	// 
	//     onDrop: function(element, droppable, event){
	//         if (!droppable) console.log(element, ' dropped on nothing');
	//         else console.log(element, 'dropped on', droppable, 'event', event);
	//     },
	// 
	//     onEnter: function(element, droppable){
	//         console.log(element, 'entered', droppable);
	//     },
	// 
	//     onLeave: function(element, droppable){
	//         console.log(element, 'left', droppable);
	//     }
	// 
	// });
});