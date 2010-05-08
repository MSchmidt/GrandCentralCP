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
