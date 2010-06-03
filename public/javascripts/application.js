function generate_password(pwlength) {
  if (pwlength == null) {
    pwlength = 8;
  }

  var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  var password = "";
  
  for (var i=0; i<pwlength; i++) {
    password += chars.charAt(Math.floor(Math.random()*chars.length));
  }

  document.getElementById('user_password').value = password;
}

window.addEvent('domready', function(){
	$('infobar').fade('hide');
	
	var infobar_fx = new Fx.Tween($('infobar'), {
		property: 'height',
		link: 'cancel',
		onComplete: function(){
			//$('infobar-collapsed').fade('toggle');
			//$('infobar-expanded').fade('toggle');
		}
	});
	
	var infobar_original_height = $('infobar').getStyle('height');
	
	$('infobar').addEvent('click', function(e){
		if (this.getStyle('height') == infobar_original_height) {
			infobar_fx.start(250);
		} else {
			infobar_fx.start(infobar_original_height);
		}
		e.stop();
	});
});