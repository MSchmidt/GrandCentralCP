/*
authors:
  - Matthias Schmidt (http://www.m-schmidt.eu)

license:
  - MIT-style license

requires:
  core/1.2.4: '*'
  more/1.2.4.4: Fx.Scroll

provides: MooFibro

...
*/
var MooFibro = new Class({
	Implements: [Options],
	
	options: {
		container: $empty,
		tree: $empty,
		animate: true,
		seperator: '/',
		back_label: 'go back'
	},
	
	initialize: function(target, options) {
		if ($type(target) == 'element') {
			this.target = target;
		} else {
			this.target = $(target);
		}
		
		this.setOptions(options);
		if ($type(this.options.container) == 'element') {
			this.container = this.options.container;
		} else {
			this.container = $(this.options.container);
		}
		
		if ($type(this.options.tree) == 'element') {
			this.tree = this.options.tree;
		} else {
			var temp = new Element('div', {'html': this.options.tree});
			this.tree = temp.getFirst();
		}
		
		this.animate = this.options.animate;
		this.seperator = this.options.seperator;
		this.back_label = this.options.back_label;
	
		this.prepareTree();
	},
	
	prepareTree: function() {
		this.container.setStyle('overflow', 'hidden');
		this.sliding_div = new Element('div');
		this.container_width = this.container.getSize().x;	
		
		this.current_level = 0;
		this.current_path = new Array();
		
		// tree level 0
		this.scanAndPrepareBranch(this.tree);
		this.sliding_div.adopt(this.tree);
		this.container.adopt(this.sliding_div);
	},
	
	getCurrentPath: function() {
		if (this.current_path.length > 0) {
			return this.current_path.join(this.seperator) + this.seperator;
		} else {
			return '';
		}
	},
	
	scanAndPrepareBranch: function(branch) {		
		// hide sub-trees
		branch.getChildren('.is_sub').each(function(e){
			e.addClass('hidden');
		});
		
		// make selectable
		branch.getChildren('li:not(.is_sub)').each(function(e){
			// move 'li' html to 'a' html to keep clean name for later path building
			var a = new Element('a', {
				'href': '#select_' + e.get('html'),
				'html': e.get('html'),
				'class': 'select_link'
			});
			e.set('html', '');
			a.inject(e);
			
			a.addEvent('click', function(event){
				this.target.set('html', this.getCurrentPath() + a.get('html'));
				e.highlight('#ff8', '#444');
				event.stop();
			}.bind(this));
		}, this);
		
		// make extendable
		branch.getChildren('.has_sub').each(function(e){
			var a = new Element('a', {
				'href': '#go_' + e.getFirst('a').get('html'),
				'class': 'extend_link',
				'events': {
					'click': function(event){
						var wanted_view_name = e.getElement('a.select_link').get('html');
						this.current_path.push(wanted_view_name);
						console.log('extend ' + wanted_view_name);
						
						this.current_level++;
						this.calculateAndSetSlidingDivWidth();
						
						console.log('getting ' + '.'+wanted_view_name+'-sub as level ' + this.current_level);
						var new_branch = branch.getFirst('.'+wanted_view_name+'-sub').getFirst('ul').clone();
						this.scanAndPrepareBranch(new_branch);
						
						if (this.current_level > 0) {
							this.addBackButtonToBranch(new_branch, this.current_level);
						}
						
						new_branch.inject(this.sliding_div);
						
						if (this.animate && Fx.Scroll) {
							new Fx.Scroll(this.container, {duration: 200}).start(this.current_level * this.container_width);
						} else {
							this.container.scrollTo(this.current_level * this.container_width);
						}
						
						event.stop();
					}.bind(this)
				}
			});
			a.inject(e);
		}, this);
	},
	
	calculateAndSetSlidingDivWidth: function() {
		this.sliding_div.setStyle('width', this.container_width * (this.current_level + 1));
	},
	
	addBackButtonToBranch: function(branch, current_level) {
		var back_button = new Element('a', {
			'html': this.back_label,
			'href': '#back',
			'class': 'select_link',
			'events': {
				'click': function(event) {
					this.current_level = current_level - 1;
					this.current_path.pop();
					
					if (this.animate && Fx.Scroll) {
						new Fx.Scroll(this.container, {
							duration: 200,
							onComplete: function() {
								this.calculateAndSetSlidingDivWidth();
								this.sliding_div.getLast('ul').destroy();
							}.bind(this)
						}).start(this.current_level * this.container_width);
					} else {
						this.container.scrollTo(this.current_level * this.container_width);
						this.calculateAndSetSlidingDivWidth();
						this.sliding_div.getLast('ul').destroy();
					}
					
					console.log('back to level ' + this.current_level);
					event.stop();
				}.bind(this)
			}
		});
		
		var temp = new Element('li');
		back_button.inject(temp);
		temp.inject(branch, 'top');
	}
});