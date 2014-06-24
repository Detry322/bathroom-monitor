// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function changeFavicon(src) {
 var link = document.createElement('link'),
     oldLink = document.getElementById('dynamic-favicon');
 link.id = 'dynamic-favicon';
 link.rel = 'icon';
 link.href = src;
 if (oldLink) {
  document.head.removeChild(oldLink);
 }
 document.head.appendChild(link);
}

function update()
{
  xmlhttp=new XMLHttpRequest();
  xmlhttp.open("GET","/update?with_time=yes",false);
  xmlhttp.send();
  var time = Math.round(parseInt(xmlhttp.responseText.split(' ')[1],10) * 1.6666)/100;
  x = $('body');
  if (xmlhttp.responseText.match(/occupied/)) {
    $('h3').html("The bathroom has been occupied for "+time+" minutes.");
    if (x.hasClass("green")) {
      x.removeClass("green");
      x.addClass("red");
      $('h1').html("IN USE");
      changeFavicon("/assets/occupied.png");
    }
  } else {
    $('h3').html("The bathroom has been vacant for "+time+" minutes.");
    if (x.hasClass("red")) {
      x.removeClass("red");
      x.addClass("green");
      $('h1').html("VACANT");
      changeFavicon("/assets/vacant.png");
    }
  }
  setTimeout("update();",15000);
}
