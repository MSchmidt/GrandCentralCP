//MooTools More, <http://mootools.net/more>. Copyright (c) 2006-2009 Aaron Newton <http://clientcide.com/>, Valerio Proietti <http://mad4milk.net> & the MooTools team <http://mootools.net/developers>, MIT Style License.

MooTools.More={version:"1.2.4.4",build:"6f6057dc645fdb7547689183b2311063bd653ddf"};Fx.Scroll=new Class({Extends:Fx,options:{offset:{x:0,y:0},wheelStops:true},initialize:function(b,a){this.element=this.subject=document.id(b);
this.parent(a);var d=this.cancel.bind(this,false);if($type(this.element)!="element"){this.element=document.id(this.element.getDocument().body);}var c=this.element;
if(this.options.wheelStops){this.addEvent("start",function(){c.addEvent("mousewheel",d);},true);this.addEvent("complete",function(){c.removeEvent("mousewheel",d);
},true);}},set:function(){var a=Array.flatten(arguments);if(Browser.Engine.gecko){a=[Math.round(a[0]),Math.round(a[1])];}this.element.scrollTo(a[0],a[1]);
},compute:function(c,b,a){return[0,1].map(function(d){return Fx.compute(c[d],b[d],a);});},start:function(c,g){if(!this.check(c,g)){return this;}var e=this.element.getScrollSize(),b=this.element.getScroll(),d={x:c,y:g};
for(var f in d){var a=e[f];if($chk(d[f])){d[f]=($type(d[f])=="number")?d[f]:a;}else{d[f]=b[f];}d[f]+=this.options.offset[f];}return this.parent([b.x,b.y],[d.x,d.y]);
},toTop:function(){return this.start(false,0);},toLeft:function(){return this.start(0,false);},toRight:function(){return this.start("right",false);},toBottom:function(){return this.start(false,"bottom");
},toElement:function(b){var a=document.id(b).getPosition(this.element);return this.start(a.x,a.y);},scrollIntoView:function(c,e,d){e=e?$splat(e):["x","y"];
var h={};c=document.id(c);var f=c.getPosition(this.element);var i=c.getSize();var g=this.element.getScroll();var a=this.element.getSize();var b={x:f.x+i.x,y:f.y+i.y};
["x","y"].each(function(j){if(e.contains(j)){if(b[j]>g[j]+a[j]){h[j]=b[j]-a[j];}if(f[j]<g[j]){h[j]=f[j];}}if(h[j]==null){h[j]=g[j];}if(d&&d[j]){h[j]=h[j]+d[j];
}},this);if(h.x!=g.x||h.y!=g.y){this.start(h.x,h.y);}return this;},scrollToCenter:function(c,e,d){e=e?$splat(e):["x","y"];c=$(c);var h={},f=c.getPosition(this.element),i=c.getSize(),g=this.element.getScroll(),a=this.element.getSize(),b={x:f.x+i.x,y:f.y+i.y};
["x","y"].each(function(j){if(e.contains(j)){h[j]=f[j]-(a[j]-i[j])/2;}if(h[j]==null){h[j]=g[j];}if(d&&d[j]){h[j]=h[j]+d[j];}},this);if(h.x!=g.x||h.y!=g.y){this.start(h.x,h.y);
}return this;}});var Drag=new Class({Implements:[Events,Options],options:{snap:6,unit:"px",grid:false,style:true,limit:false,handle:false,invert:false,preventDefault:false,stopPropagation:false,modifiers:{x:"left",y:"top"}},initialize:function(){var b=Array.link(arguments,{options:Object.type,element:$defined});
this.element=document.id(b.element);this.document=this.element.getDocument();this.setOptions(b.options||{});var a=$type(this.options.handle);this.handles=((a=="array"||a=="collection")?$$(this.options.handle):document.id(this.options.handle))||this.element;
this.mouse={now:{},pos:{}};this.value={start:{},now:{}};this.selection=(Browser.Engine.trident)?"selectstart":"mousedown";this.bound={start:this.start.bind(this),check:this.check.bind(this),drag:this.drag.bind(this),stop:this.stop.bind(this),cancel:this.cancel.bind(this),eventStop:$lambda(false)};
this.attach();},attach:function(){this.handles.addEvent("mousedown",this.bound.start);return this;},detach:function(){this.handles.removeEvent("mousedown",this.bound.start);
return this;},start:function(c){if(c.rightClick){return;}if(this.options.preventDefault){c.preventDefault();}if(this.options.stopPropagation){c.stopPropagation();
}this.mouse.start=c.page;this.fireEvent("beforeStart",this.element);var a=this.options.limit;this.limit={x:[],y:[]};for(var d in this.options.modifiers){if(!this.options.modifiers[d]){continue;
}if(this.options.style){this.value.now[d]=this.element.getStyle(this.options.modifiers[d]).toInt();}else{this.value.now[d]=this.element[this.options.modifiers[d]];
}if(this.options.invert){this.value.now[d]*=-1;}this.mouse.pos[d]=c.page[d]-this.value.now[d];if(a&&a[d]){for(var b=2;b--;b){if($chk(a[d][b])){this.limit[d][b]=$lambda(a[d][b])();
}}}}if($type(this.options.grid)=="number"){this.options.grid={x:this.options.grid,y:this.options.grid};}this.document.addEvents({mousemove:this.bound.check,mouseup:this.bound.cancel});
this.document.addEvent(this.selection,this.bound.eventStop);},check:function(a){if(this.options.preventDefault){a.preventDefault();}var b=Math.round(Math.sqrt(Math.pow(a.page.x-this.mouse.start.x,2)+Math.pow(a.page.y-this.mouse.start.y,2)));
if(b>this.options.snap){this.cancel();this.document.addEvents({mousemove:this.bound.drag,mouseup:this.bound.stop});this.fireEvent("start",[this.element,a]).fireEvent("snap",this.element);
}},drag:function(a){if(this.options.preventDefault){a.preventDefault();}this.mouse.now=a.page;for(var b in this.options.modifiers){if(!this.options.modifiers[b]){continue;
}this.value.now[b]=this.mouse.now[b]-this.mouse.pos[b];if(this.options.invert){this.value.now[b]*=-1;}if(this.options.limit&&this.limit[b]){if($chk(this.limit[b][1])&&(this.value.now[b]>this.limit[b][1])){this.value.now[b]=this.limit[b][1];
}else{if($chk(this.limit[b][0])&&(this.value.now[b]<this.limit[b][0])){this.value.now[b]=this.limit[b][0];}}}if(this.options.grid[b]){this.value.now[b]-=((this.value.now[b]-(this.limit[b][0]||0))%this.options.grid[b]);
}if(this.options.style){this.element.setStyle(this.options.modifiers[b],this.value.now[b]+this.options.unit);}else{this.element[this.options.modifiers[b]]=this.value.now[b];
}}this.fireEvent("drag",[this.element,a]);},cancel:function(a){this.document.removeEvent("mousemove",this.bound.check);this.document.removeEvent("mouseup",this.bound.cancel);
if(a){this.document.removeEvent(this.selection,this.bound.eventStop);this.fireEvent("cancel",this.element);}},stop:function(a){this.document.removeEvent(this.selection,this.bound.eventStop);
this.document.removeEvent("mousemove",this.bound.drag);this.document.removeEvent("mouseup",this.bound.stop);if(a){this.fireEvent("complete",[this.element,a]);
}}});Element.implement({makeResizable:function(a){var b=new Drag(this,$merge({modifiers:{x:"width",y:"height"}},a));this.store("resizer",b);return b.addEvent("drag",function(){this.fireEvent("resize",b);
}.bind(this));}});Drag.Move=new Class({Extends:Drag,options:{droppables:[],container:false,precalculate:false,includeMargins:true,checkDroppables:true},initialize:function(b,a){this.parent(b,a);
b=this.element;this.droppables=$$(this.options.droppables);this.container=document.id(this.options.container);if(this.container&&$type(this.container)!="element"){this.container=document.id(this.container.getDocument().body);
}var c=b.getStyles("left","top","position");if(c.left=="auto"||c.top=="auto"){b.setPosition(b.getPosition(b.getOffsetParent()));}if(c.position=="static"){b.setStyle("position","absolute");
}this.addEvent("start",this.checkDroppables,true);this.overed=null;},start:function(a){if(this.container){this.options.limit=this.calculateLimit();}if(this.options.precalculate){this.positions=this.droppables.map(function(b){return b.getCoordinates();
});}this.parent(a);},calculateLimit:function(){var d=this.element.getOffsetParent(),g=this.container.getCoordinates(d),f={},c={},b={},i={},k={};["top","right","bottom","left"].each(function(o){f[o]=this.container.getStyle("border-"+o).toInt();
b[o]=this.element.getStyle("border-"+o).toInt();c[o]=this.element.getStyle("margin-"+o).toInt();i[o]=this.container.getStyle("margin-"+o).toInt();k[o]=d.getStyle("padding-"+o).toInt();
},this);var e=this.element.offsetWidth+c.left+c.right,n=this.element.offsetHeight+c.top+c.bottom,h=0,j=0,m=g.right-f.right-e,a=g.bottom-f.bottom-n;if(this.options.includeMargins){h+=c.left;
j+=c.top;}else{m+=c.right;a+=c.bottom;}if(this.element.getStyle("position")=="relative"){var l=this.element.getCoordinates(d);l.left-=this.element.getStyle("left").toInt();
l.top-=this.element.getStyle("top").toInt();h+=f.left-l.left;j+=f.top-l.top;m+=c.left-l.left;a+=c.top-l.top;if(this.container!=d){h+=i.left+k.left;j+=(Browser.Engine.trident4?0:i.top)+k.top;
}}else{h-=c.left;j-=c.top;if(this.container==d){m-=f.left;a-=f.top;}else{h+=g.left+f.left;j+=g.top+f.top;}}return{x:[h,m],y:[j,a]};},checkAgainst:function(c,b){c=(this.positions)?this.positions[b]:c.getCoordinates();
var a=this.mouse.now;return(a.x>c.left&&a.x<c.right&&a.y<c.bottom&&a.y>c.top);},checkDroppables:function(){var a=this.droppables.filter(this.checkAgainst,this).getLast();
if(this.overed!=a){if(this.overed){this.fireEvent("leave",[this.element,this.overed]);}if(a){this.fireEvent("enter",[this.element,a]);}this.overed=a;}},drag:function(a){this.parent(a);
if(this.options.checkDroppables&&this.droppables.length){this.checkDroppables();}},stop:function(a){this.checkDroppables();this.fireEvent("drop",[this.element,this.overed,a]);
this.overed=null;return this.parent(a);}});Element.implement({makeDraggable:function(a){var b=new Drag.Move(this,a);this.store("dragger",b);return b;}});
