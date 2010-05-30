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
	Implements: [Options,Events],
	
	options: {
		container: $empty,			// block element to hold complete browser
		tree: $empty,				// ul/li tree with folder structure
		preselected: false,			// li to select upon startup
		animate: 200,				// animation speed, false disables animation
		seperator: '/',				// directory seperator
		back_label: 'go back'		// label for first 'back' li
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
		
		this.animate = this.options.animate == true ? 200 : this.options.animate;
		this.seperator = this.options.seperator;
		this.back_label = this.options.back_label;
		
		this.preselected = (this.options.preselected ? this.options.preselected : this.target.get('html')).split(this.seperator);
	
		this.prepareTree();
		//this.autoselect(this.preselected);
	},
	
	prepareTree: function() {
		this.container.setStyle('overflow', 'hidden');
		this.sliding_div = new Element('div');
		this.container_width = this.container.getSize().x;	
		
		this.current_level = 0;
		this.current_path = new Array();
		
		this.scanned_branches = new Array();
		
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
				var target_path = this.getCurrentPath() + a.get('html');
				this.target.set('html', target_path);
				a.highlight('#ff8', '#c6e7ad');
				e.setStyle('background-color', '#99b286');
				this.fireEvent('select', [target_path]);
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
						this.fireEvent('extend', [wanted_view_name, this.getCurrentPath(), '1']);
						
						this.current_level++;
						this.calculateAndSetSlidingDivWidth();
						
						var new_branch = branch.getFirst('.'+wanted_view_name+'-sub').getFirst('ul');
						
						// scan branch if not happened yet
						if (!this.scanned_branches.contains(this.getCurrentPath())) {
							this.scanAndPrepareBranch(new_branch);

							if (this.current_level > 0) {
								this.addBackButtonToBranch(new_branch, this.current_level);
							}
							// save branch path to avoid double scanning
							this.scanned_branches.push(this.getCurrentPath());
						}
						
						new_branch.inject(this.sliding_div);
						
						if (this.animate && Fx.Scroll) {
							new Fx.Scroll(this.container, {duration: this.animate}).start(this.current_level * this.container_width);
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
					
					if (this.animate && Fx.Scroll) {
						new Fx.Scroll(this.container, {
							duration: this.animate,
							onComplete: function() {
								this.removeLast();
							}.bind(this)
						}).start(this.current_level * this.container_width);
					} else {
						this.container.scrollTo(this.current_level * this.container_width);
						this.removeLast();
					}
					
					event.stop();
				}.bind(this)
			}
		});
		
		var temp = new Element('li');
		back_button.inject(temp);
		temp.inject(branch, 'top');
	},
	
	removeLast: function() {
		var branch_name = this.current_path.pop();
		var element_to_remove = this.sliding_div.getLast('ul');
		element_to_remove.inject(element_to_remove.getPrevious('ul').getFirst('.'+branch_name+'-sub'));
		this.calculateAndSetSlidingDivWidth();
		this.fireEvent('extend', ['back', this.getCurrentPath(), '-1']);
	}
});