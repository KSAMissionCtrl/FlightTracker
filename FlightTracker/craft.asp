<!DOCTYPE html>
<!-- code/comments not formatted for word wrap -->

<%
'from http://detectmobilebrowsers.com/
dim u,b,v
set u=Request.ServerVariables("HTTP_USER_AGENT")
set b=new RegExp
set v=new RegExp
b.Pattern="(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino"
v.Pattern="1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-"
b.IgnoreCase=true
v.IgnoreCase=true
b.Global=true
v.Global=true
bMobileBrowser = false
if b.test(u) or v.test(Left(u,4)) then bMobileBrowser = true end if
%>

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/HypYkyd.png" />
  
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

  <!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto:900" />
  <link rel="stylesheet" type="text/css" href="http://static.kerbalmaps.com/leaflet.css" />
  <link rel="stylesheet" type="text/css" href="leaflet.label.css" />
  <link rel="stylesheet" type="text/css" href="tipped.css" />
  <link href="http://vjs.zencdn.net/5.0.2/video-js.css" rel="stylesheet">
  
  <!-- JS libraries -->
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script type="text/javascript" src="leaflet.js"></script>
  <script type="text/javascript" src="leafletembed.js"></script>
  <script type="text/javascript" src="sylvester.js"></script>
  <script type="text/javascript" src="sylvester.src.js"></script>
  <script type="text/javascript" src="leaflet.label.js"></script>
  <script type="text/javascript" src="numeral.min.js"></script>
  <script type="text/javascript" src="tipped.js"></script>
  <script type="text/javascript" src="codebird.js"></script>  
  <script type="text/javascript" src="spin.min.js"></script>  

  <!-- "Data load" screen -->
  <style>
    html { 
      width:100%; 
      height:100%; 
      background:url(dataload.png) center center no-repeat;
      cursor:wait;
    }
  </style>

  <script>
    // get our platform properties for post-launch surveys
    // http://stackoverflow.com/questions/11219582/how-to-detect-my-browser-version-and-operating-system-using-javascript
    var nVer = navigator.appVersion;
    var nAgt = navigator.userAgent;
    var browserName  = navigator.appName;
    var fullVersion  = ''+parseFloat(navigator.appVersion); 
    var majorVersion = parseInt(navigator.appVersion,10);
    var nameOffset,verOffset,ix;

    // In Opera, the true version is after "Opera" or after "Version"
    if ((verOffset=nAgt.indexOf("Opera"))!=-1) {
     browserName = "Opera";
     fullVersion = nAgt.substring(verOffset+6);
     if ((verOffset=nAgt.indexOf("Version"))!=-1) 
       fullVersion = nAgt.substring(verOffset+8);
    }
    // In MSIE, the true version is after "MSIE" in userAgent
    else if ((verOffset=nAgt.indexOf("MSIE"))!=-1) {
     browserName = "Microsoft Internet Explorer";
     fullVersion = nAgt.substring(verOffset+5);
    }
    // In Chrome, the true version is after "Chrome" 
    else if ((verOffset=nAgt.indexOf("Chrome"))!=-1) {
     browserName = "Chrome";
     fullVersion = nAgt.substring(verOffset+7);
    }
    // In Safari, the true version is after "Safari" or after "Version" 
    else if ((verOffset=nAgt.indexOf("Safari"))!=-1) {
     browserName = "Safari";
     fullVersion = nAgt.substring(verOffset+7);
     if ((verOffset=nAgt.indexOf("Version"))!=-1) 
       fullVersion = nAgt.substring(verOffset+8);
    }
    // In Firefox, the true version is after "Firefox" 
    else if ((verOffset=nAgt.indexOf("Firefox"))!=-1) {
     browserName = "Firefox";
     fullVersion = nAgt.substring(verOffset+8);
    }
    // In most other browsers, "name/version" is at the end of userAgent 
    else if ( (nameOffset=nAgt.lastIndexOf(' ')+1) < 
              (verOffset=nAgt.lastIndexOf('/')) ) 
    {
     browserName = nAgt.substring(nameOffset,verOffset);
     fullVersion = nAgt.substring(verOffset+1);
     if (browserName.toLowerCase()==browserName.toUpperCase()) {
      browserName = navigator.appName;
     }
    }
    // trim the fullVersion string at semicolon/space if present
    if ((ix=fullVersion.indexOf(";"))!=-1)
       fullVersion=fullVersion.substring(0,ix);
    if ((ix=fullVersion.indexOf(" "))!=-1)
       fullVersion=fullVersion.substring(0,ix);

    majorVersion = parseInt(''+fullVersion,10);
    if (isNaN(majorVersion)) {
     fullVersion  = ''+parseFloat(navigator.appVersion); 
     majorVersion = parseInt(navigator.appVersion,10);
    }
    var browserDeets = browserName + " (v" + fullVersion + ") [" + navigator.appName + "] [" + navigator.userAgent + "]";

    var OSName="Unknown OS";
    if (navigator.appVersion.indexOf("Win")!=-1) OSName="Windows";
    if (navigator.appVersion.indexOf("Mac")!=-1) OSName="MacOS";
    if (navigator.appVersion.indexOf("X11")!=-1) OSName="UNIX";
    if (navigator.appVersion.indexOf("Linux")!=-1) OSName="Linux";

    // determine whether this is a touchscreen device 
    // http://ctrlq.org/code/19616-detect-touch-screen-javascript
    function is_touch_device() {
     return (('ontouchstart' in window)
          || (navigator.MaxTouchPoints > 0)
          || (navigator.msMaxTouchPoints > 0));
    }
    
    // initialize codebird so we can tweet during launches when needed
    // https://github.com/jublonet/codebird-js
    // https://www.youtube.com/watch?v=9L0orUhlhuY
    var cb = new Codebird;
    cb.setConsumerKey("Pad4A5oaphgV4ziuKVyS18wW0", "1QNkDoB0J97yuKczvQj8yK8dEe3TSQLsUaOAVjSgq1elkAwGuv");  
    cb.setToken("2347555800-SrcsRnGCAEa4nCPINVfQ5ta1yT0t01ZyLUCb8ZH", "FhGtNQaDWLMYEnpNWCd6CkOvMbUq1fxOUFqu2oSR9x6iS");
    
    // convert the current UTC to a certain time zone
    // http://stackoverflow.com/questions/9669294/current-date-time-in-et
    Date.toTZString= function(d, tzp){
      var short_months= ['Jan', 'Feb', 'Mar', 'Apr', 'May',
       'Jun', 'Jul','Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      var h, m, pm= 'pm', off, label, str,
      d= d? new Date(d):new Date();

      var tz={
        AK:['Alaska', -540],
        A:['Atlantic', -240],
        C:['Central', -360],
        E:['Eastern', -300],
        HA:['Hawaii-Aleutian', -600],
        M:['Mountain', -420],
        N:['Newfoundland', -210],
        P:['Pacific', -480]
      }[tzp.toUpperCase()];

      //get the selected offset from the object:
      if(!tz) return d.toUTCString();
      off= tz[1];

      //get the start and end dates for dst:(these rules are US only)
      var y= d.getUTCFullYear(), countstart= 8, countend= 1,
      dstart= new Date(Date.UTC(y, 2, 8, 2, 0, 0, 0)),
      dend= new Date(Date.UTC(y, 10, 1, 2, 0, 0, 0));
      while(dstart.getUTCDay()!== 0) dstart.setUTCDate(++countstart);
      while(dend.getUTCDay()!== 0) dend.setUTCDate(++countend);

      //get the GMT time for the localized dst start and end times:
      dstart.setUTCMinutes(off);
      dend.setUTCMinutes(off);

      // if the date passed in is between dst start and dst end, adjust the offset and label:
      if(dstart<= d && dend>= d){
        off+= 60;
        label= '4';
      }
      else label= '5';

      //add the adjusted offset to the date and get the hours and minutes:
      d.setUTCMinutes(d.getUTCMinutes()+off);
      h= d.getUTCHours();
      m= d.getUTCMinutes();
      if(h> 12) h-= 12;
      else if(h!== 12) pm= 'am';
      if(h== 0) h= 12;
      if(m<10) m= '0'+m;
      
      s = d.getUTCSeconds();
      if (d.getUTCSeconds() < 10) {
        s = "0" + s;
      }

      //return a string:
      $("#utc").html("(UTC -" + label + ")");
      var str= short_months[d.getUTCMonth()]+' '+d.getUTCDate()+', ';
      return h+':'+m+':' +s+ ' '+pm.toUpperCase();
    }

    // take an amount of time in seconds and convert it to years, days, hours, minutes and seconds
    // leave out any values that are not necessary (0y, 0d won't show, for example)
    function formatTime(time, precision) {
      var years = 0;
      var days = 0;
      var hours = 0;
      var minutes = 0;
      var seconds = "";
      var ydhms = "";
      time = Math.abs(time);

      if (time >= 86400) {
        days = Math.floor(time / 86400);
        time -= days * 86400;
        ydhms = days + "d, ";
      }

      if (days >= 365) {
        years = Math.floor(days / 365);
        days -= years * 365;
        ydhms = years + "y " + days + "d, ";
      }

      if (time >= 3600) {
        hours = Math.floor(time / 3600);
        time -= hours * 3600;
        ydhms += hours + "h ";
      }

      if (time >= 60) {
        minutes = Math.floor(time / 60);
        time -= minutes * 60;
        ydhms += minutes + "m ";
      }
      
      if (precision) {
        time = numeral(time).format('0.000');
      } else {
        time = Math.floor(time);
      }
      
      if ( time < 10) {
        seconds = "0" + time
      }
      else seconds = time;

      return ydhms += seconds + "s";
    }
    
    // make sure when the user clicks back to a cached page the list boxes are reset
    // http://stackoverflow.com/questions/4287408/how-to-reset-dropdown-list-select-on-back-button-of-browser-using-javascript
    function resetLists() {

      // look for these only when they are there (except during a live launch stream)
      if (!bAscentActive || (bAscentActive && bPastUT)) {
        document.querySelector('#prevEvent').selectedIndex = 0;
        document.querySelector('#nextEvent').selectedIndex = 0;
      }
      return true;
    }
    
    // for retrieving URL query strings
    // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }		
    
    // once we've calculated all the orbital stuff needed, we can draw the map
    var craft;
    var ascentTrack;
    var cardinal;
    var nodeMark;
    var apMark;
    var peMark;
    var apTime;
    var peTime;
    var bNodeExecution = false;
    var bNodeRefreshCheck = false;
    var bMapRender = false;
    var infoControl;
    function renderMap(localUT) {

      // find the times to Apoapsis and Periapsis
      // same code used for determining the change in mean since Eph
      newMean = mean + n * (localUT - eph);
      if (newMean < 0 || newMean > 2*Math.PI) {
        newMean = Math.abs(newMean - (2*Math.PI) * Math.floor(newMean / (2*Math.PI)));
      }
      apTime = Math.round((Math.PI - newMean)/n);
      peTime = Math.round((Math.PI*2 - newMean)/n);
      
      // close to Ap/Pe we can get a negative value, so handle that by just adding the period
      if (apTime <= 0) { apTime += Math.round(period); }
      if (peTime <= 0) { peTime += Math.round(period); }

      if (bDrawMap) {

        // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
        // put in some maximum default values since the JQuery update doesn't adjust the width of the popup
        craft = L.marker(latlon[0], {icon: ship, zIndexOffset: 100}).addTo(map);
        craft.bindPopup("Lat: <span id='lat'>-000.0000&deg;S</span><br>Lng: <span id='lng'>-000.0000&deg;W</span><br>Alt: <span id='alt'>000,000.000km</span><br>Vel: <span id='vel'>000,000.000km/s</span>", {closeButton: false});
        
        // set up a listener for popup events so we can immediately update the information and not have to wait for the next timer event
        cardinal = "";
        craft.on('click', function(e) {
          var dd = new Date();
          dd.setTime(dd.getTime() - timeOffset);
          var currDate = Math.floor(dd.getTime() / 1000);
          var now = currDate - startDate;
          if (now < latlon.length) {
            if (latlon[now].lat < 0) {
              cardinal = "S";
            } else {
              cardinal = "N";
            }
            $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinal);
            if (latlon[now].lng < 0) {
              cardinal = "W";
            } else {
              cardinal = "E";
            }
            $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinal);
            $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + "km");
            $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + "km/s");
          }
        });
        
        // draw the orbital paths
        var coord = 0;
        var colors = ['#00FF00', '#FF0000', '#FFFF00'];
        var pathNum = 0;
        while (coord < latlon.length) {
          var path = [];
          
          while (coord < latlon.length) {
          
            // cut the path if we've reached the end of an orbit
            if (coord/(pathNum+1) > period) {	break; }
            
            // create a new array entry for this location, then advance the array counter
            path.push(latlon[coord]);
            coord++;

            // detect if we've crossed off the edge of the map and need to cut the orbital line
            // compare this lng to the prev and if it changed from negative to positive or vice versa, we hit the edge  
            // (check if the lng is over 100 to prevent detecting a sign change while crossing the meridian)
            if (coord < latlon.length) {
              if (((latlon[coord].lng < 0 && latlon[coord-1].lng > 0) && Math.abs(latlon[coord].lng) > 100) || ((latlon[coord].lng > 0 && latlon[coord-1].lng < 0) && Math.abs(latlon[coord].lng) > 100)) { break; }
            }
          }
          
          // create the path for this orbit
          // using leaflet.label - https://github.com/Leaflet/Leaflet.label
          // because for some reason couldn't get Leaflet popups to work
          var line = L.polyline(path, {smoothFactor: 1.25, clickable: true, color: colors[pathNum], weight: 3, opacity: 1}).bindLabel("Orbit #" + (pathNum+1) + "<br>Click for static view", {className: 'labeltext'}).addTo(map);
          
          // set up a listener for clicks on the line so we can let people switch to the static orbit view
          line.on('click', function(e) {
            $("#map").fadeToggle();
          });
          
          // check if we have completed an orbit, not just hit the end of the map
          // if it's a new orbit, advance to the next line color
          if (coord/(pathNum+1) > period) {	pathNum++; }
        }

        // if we have an upcoming maneuver node, check that it can be drawn along our orbit and do so if possible
        if (bUpcomingNode) {
          if (nodeUT - localUT < latlon.length) {
          
            // create the icon for our maneuver node, taken from the Squad asset file
            var nodeIcon = L.icon({
              iconUrl: 'node.png',
              iconSize: [16, 16],
              iconAnchor: [8, 8]
            });
            
            // add the icon to the map and create the information popup for it
            nodeMark = L.marker(latlon[nodeUT - localUT], {icon: nodeIcon}).addTo(map);
            nodeMark.bindPopup("<center><span id='nodeTime'>Time to Maneuver<br>" + formatTime(nodeUT - localUT, false) + "</span></center><br>Prograde &Delta;v: " + numeral(nodePrograde).format('0.000') + "<br>Normal &Delta;v: " + numeral(nodeNormal).format('0.000') + "<br>Radial &Delta;v: " + numeral(nodeRadial).format('0.000') + "<br>Total &Delta;v: " + numeral(nodeTotal).format('0.000'), {closeButton: false});

            // functions will make sure fresh data is loaded when the popup displays and not just when the update tick happens
            nodeMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(dd.getTime() - timeOffset);
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#nodeTime').html("Time to Maneuver<br>" + formatTime((nodeUT - initialUT)-now, false));
            });
            nodeMark.on('popupopen', function(e) {
              var dd = new Date();
              dd.setTime(dd.getTime() - timeOffset);
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#nodeTime').html("Time to Maneuver<br>" + formatTime((nodeUT - initialUT)-now, false));
            });
          
            // update the tooltip text for the Next list
            // because touchscreen devices can't see tooltips, they will get an alert window
            if (is_touch_device()) {
              $("#nextNode").html($("#nextNode").html() + "<br>Click OK to show Maneuver Node");
            } else {
              $("#nextNode").html($("#nextNode").html() + "<br>Click to show Maneuver Node");
            }
          }
          
          // if we can't yet draw the node, set a reminder to refresh the page when we can
          // update the tooltip text for the Next list
          else {
            bNodeRefreshCheck = true;
            $("#nextNode").html($("#nextNode").html() + "<br>Maneuver Node not yet visible");
          }
        }
        
        // some orbits may be too long to show Ap/Pe markers, so ensure that we can display them at all
        if (apTime < latlon.length) { 
          if (bDrawMap) {
          
            // add the marker, assign its information popup and give it a callback for instant update when opened
            apMark = L.marker(latlon[apTime], {icon: apIcon}).addTo(map); 
            apMark.bindPopup("<center><span id='apTime'>Time to Apoapsis<br>" + formatTime(apTime, false) + "</span></center>", {closeButton: false});
            apMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(dd.getTime() - timeOffset);
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#apTime').html("Time to Apoapsis<br>" + formatTime(apTime-now, false));
            });
          } else { apTime = -1; }
        }
        if (peTime < latlon.length) { 
          if (bDrawMap) {
          
            // add the marker, assign its information popup and give it a callback for instant update when opened
            peMark = L.marker(latlon[peTime], {icon: peIcon}).addTo(map); 
            peMark.bindPopup("<center><span id='peTime'>Time to Periapsis<br>" + formatTime(peTime, false) + "</span></center>", {closeButton: false});
            peMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(dd.getTime() - timeOffset);
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#peTime').html("Time to Periapsis<br>" + formatTime(peTime-now, false));
            });
          } else { peTime = -1; }
        }
        
        // now that the map is fully rendered, we can switch its hidden state from visibility to display so we can fade it in
        // otherwise with a display of none markers and orbits would not be able to render properly
        $('#map').css("display", "none");
        $('#map').css("visibility", "visible");
        $('#map').fadeToggle();
        
        //update the marker popup data
        var dd = new Date();
        dd.setTime(dd.getTime() - timeOffset);
        var currDate = Math.floor(dd.getTime() / 1000);
        var now = currDate - startDate;
        
        // in an instance close to a maneuver node all the previous assignments came up NaN - no idea why yet but check for good index value
        if (now) {
          if (latlon[now].lat < 0) {
            cardinal = "S";
          } else {
            cardinal = "N";
          }
          $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinal);
          if (latlon[now].lng < 0) {
            cardinal = "W";
          } else {
            cardinal = "E";
          }
          $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinal);
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + "km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + "km/s");

          // Show the craft info box. This lets people know it exists and also serves to bring the craft into view
          craft.openPopup(); 
        
          // remove the popup box for the craft position after 5 seconds, user can re-open it if they want to
          setTimeout(function () { 
            craft.closePopup();
            
            // open the maneuver node if we were sent here looking for it and it exists on the map
            if (getParameterByName('node') && bUpcomingNode && !bNodeRefreshCheck) { nodeMark.openPopup(); }
          }, 5000);
        }
        
        // let user know that the maneuver node they were sent here to see is not yet visible on the rendered orbits
        if (getParameterByName('node') && bUpcomingNode && bNodeRefreshCheck) { $("#msgNode").fadeToggle(); }
        
        // let the user know orbital rendering has been cut short for faster page load
        // gives them the option to render full orbits
        if (showMsg && latlon.length >= maxDeltaTime) { $("#msgObtPd").fadeToggle(); }
      }

      // we can get rid of the loading status bar now
      $("#orbDataMsg").fadeOut();
      
      // let our 1s update function know the map is now visible
      bMapRender = true;
    }
    
    // advance the values of ascent data while telemetry is playing
    var bAscentPaused = true;
    var bTimeDilation = false;
    var bTimeRecovered = false;
    var lowestFPS = 6000;
    var diff = 0;
    var lastDiff = 0;
    var maxDiff = 0;
    var perfThreshold = 5;
    var perfHit = 0;
    var recovery = 0;
    var recoveryMax = 3;
    var ascentIntervalElapse = 0;
    var ascentStartTime = -1;
    var ascentDelta = 0;
    var surveyURL;
    function ascentUpdater(delta, bForceUpdate) {

      // update the the mission timer caption
      if (telemetryUT + delta >= launchUT) { 
        $("#captionMET").html("MET: "); 
      } else {
        $("#captionMET").html("Launch in: "); 
      }
      
      // clamp data every interval, perform status updates, check performance
      if (delta - ascentIntervalElapse >= ascentData[0].LogInterval.clamp || bForceUpdate) {
        ascentIntervalElapse = delta;
        velocity = ascentData[delta].Velocity.clamp;
        throttle = ascentData[delta].Throttle.clamp;
        thrust = ascentData[delta].Thrust.clamp;
        mass = ascentData[delta].Mass.clamp;
        pitch = ascentData[delta].Pitch.clamp;
        roll = ascentData[delta].Roll.clamp;
        heading = ascentData[delta].Heading.clamp;
        gravity = ascentData[delta].Gravity.clamp;
        altitude = ascentData[delta].Altitude.clamp;
        apoapsis = ascentData[delta].Apoapsis.clamp;
        Q = ascentData[delta].Q.clamp;
        periapsis = ascentData[delta].Periapsis.clamp;
        inclination = ascentData[delta].Inclination.clamp;
        stageFuel = ascentData[delta].StageFuel.clamp;
        totalFuel = ascentData[delta].TotalFuel.clamp;
        dstDownrange = ascentData[delta].DstDownrange.clamp;
        dstTraveled = ascentData[delta].DstTraveled.clamp;
        aoa = ascentData[delta].AoA.clamp;

        // reposition the craft marker and create/add to the line
        // for some reason, using addLatLng() produced an intractible error, so using spliceLatLngs() instead *shrug*
        craft.setLatLng([ascentData[delta].Lat, ascentData[delta].Lon]);
        ascentTrack.spliceLatLngs(0, 0, craft.getLatLng());

        // reposition the map if the craft has moved out of the current view
        if (!map.getBounds().contains(ascentTrack.getBounds())) { map.fitBounds(ascentTrack.getBounds(), {maxZoom: 5}); }

        // update the craft image/event & video captions
        $('#image-1').attr("src", ascentData[delta].Image);
        $('#event').html(ascentData[delta].Event);
        $('#ascentStatus').html("Current Status: " + ascentData[delta].Event);
        $('#videoCameraName').html(ascentData[delta].Camera);

        // display text for the AoA warning otherwise print a nominal report
        if (ascentData[delta].AoAWarn.length > 0) {
          $("#aoawarn").html(ascentData[delta].AoAWarn.substr(0, ascentData[delta].AoAWarn.search(":")));
          $("#aoawarn").css("color", ascentData[delta].AoAWarn.substr(ascentData[delta].AoAWarn.search(":")+1));
        } else {
          $("#aoawarn").html("Nominal");
          $("#aoawarn").css("color", "green");
        }
        
        // send a tweet?
        // make sure it's mission control sending the tweets!
        if (ascentData[delta].Tweet.length > 0 && !bPastUT && getParameterByName('missionctrl')) {
          var params = {
              status: ascentData[delta].Tweet
          };
          cb.__call(
              "statuses_update",
              params,
              function (reply, rate, err) {
                  console.log(reply);
                  console.log(rate);
                  console.log(err);
              }
          );
        }
        
        // video playback over? Return to static display
        if (bVideoLoaded && !ascentData[delta].Video) {
          $("#mainwrapper").fadeIn();
          $("#videoStatus").fadeOut();
          $("#videoCameraName").fadeOut();
          $("#ascentStatus").fadeIn();
        }
        
        // reset performance hits, less than the threshold per interval isn't worrisome
        perfHit = 0;
        
        // debug data
        if (ascentFPS < lowestFPS) { lowestFPS = ascentFPS; }
        
        // do we need to throttle back the FPS because of performance?
        if (bTimeDilation && !bTimeRecovered && diff > lastDiff) { ascentFPS -= 5; }

        // have we hit bad performance again after catching up?
        else if (bTimeDilation && bTimeRecovered && diff > lastDiff) { ascentFPS--; }
        
        // should we try to get back to default FPS?
        else if (!bTimeDilation && ascentFPS < getParameterByName("fps") && recovery < recoveryMax) { ascentFPS++; }
        
        // clamp FPS and re-calculate data if needed
        if (ascentFPS <= 0) { ascentFPS = 1; }
        if (ascentFPS != ascentData[delta].FPS && delta < ascentData.length-2) {
          $("#timeDilationTip").html("Performance is not optimal @ " + ascentFPS + "fps<br>Data is behind by " + formatTime(diff/1000, true));
          Tipped.refresh(".tip-update");
          ascentData[delta].FPS = ascentFPS;
          ascentData[delta].Velocity.delta = ((ascentData[delta+1].Velocity.clamp - ascentData[delta].Velocity.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Throttle.delta = ((ascentData[delta+1].Throttle.clamp - ascentData[delta].Throttle.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Thrust.delta = ((ascentData[delta+1].Thrust.clamp - ascentData[delta].Thrust.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Mass.delta = ((ascentData[delta+1].Mass.clamp - ascentData[delta].Mass.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Pitch.delta = ((ascentData[delta+1].Pitch.clamp - ascentData[delta].Pitch.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Roll.delta = ((ascentData[delta+1].Roll.clamp - ascentData[delta].Roll.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Heading.delta = ((ascentData[delta+1].Heading.clamp - ascentData[delta].Heading.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Gravity.delta = ((ascentData[delta+1].Gravity.clamp - ascentData[delta].Gravity.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Altitude.delta = ((ascentData[delta+1].Altitude.clamp - ascentData[delta].Altitude.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Apoapsis.delta = ((ascentData[delta+1].Apoapsis.clamp - ascentData[delta].Apoapsis.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Q.delta = ((ascentData[delta+1].Q.clamp - ascentData[delta].Q.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Periapsis.delta = ((ascentData[delta+1].Periapsis.clamp - ascentData[delta].Periapsis.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].Inclination.delta = ((ascentData[delta+1].Inclination.clamp - ascentData[delta].Inclination.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].StageFuel.delta = ((ascentData[delta+1].StageFuel.clamp - ascentData[delta].StageFuel.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].TotalFuel.delta = ((ascentData[delta+1].TotalFuel.clamp - ascentData[delta].TotalFuel.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].DstDownrange.delta = ((ascentData[delta+1].DstDownrange.clamp - ascentData[delta].DstDownrange.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].DstTraveled.delta = ((ascentData[delta+1].DstTraveled.clamp - ascentData[delta].DstTraveled.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].AoA.delta = ((ascentData[delta+1].AoA.clamp - ascentData[delta].AoA.clamp) / ascentFPS) / ascentData[0].LogInterval.clamp;
          ascentData[delta].LogInterval.delta = (ascentData[0].LogInterval.clamp / ascentFPS) / ascentData[0].LogInterval.clamp;
        }
      }
      
      // track if our delay is increasing or decreasing
      lastDiff = diff;          
          
      // update all the telemetry fields
      if (ascentStartTime >= 0) { $("#launchMET").html(formatTime(Math.abs((telemetryUT + delta) - launchUT), false)); }
      velocity += ascentData[delta].Velocity.delta;
      if (velocity > 1000) {
        $("#velocity").html(numeral(velocity/1000).format('0.000') + "km/s");
      } else {
        $("#velocity").html(numeral(velocity).format('0.000') + "m/s");
      }
      $("#throttle").html(numeral((throttle += ascentData[delta].Throttle.delta) * 100).format('0.00'));
      $("#thrust").html(numeral(thrust += ascentData[delta].Thrust.delta).format('0.000'));
      $("#mass").html(numeral(mass += ascentData[delta].Mass.delta).format('0.000'));
      $("#pitch").html(numeral(pitch += ascentData[delta].Pitch.delta).format('0.00'));
      $("#roll").html(numeral(roll += ascentData[delta].Roll.delta).format('0.00'));
      $("#heading").html(numeral(heading += ascentData[delta].Heading.delta).format('0.00'));
      
      // calculating TWR using effective thrust based on the pitch of the rocket and also the gravity at the time
      // referenced from http://wiki.kerbalspaceprogram.com/wiki/Thrust-to-weight_ratio
      gravity += ascentData[delta].Gravity.delta;
      $("#twr").html(numeral(thrust/(mass * gravity)).format('0.000'));
      
      // effective thrust removed from calculations as per reccomendation on KSP forums:
      // http://forum.kerbalspaceprogram.com/threads/138156-seeking-clarification-on-Effective-Thrust-calculation-for-TWR-from-Wiki?p=2272787&viewfull=1#post2272787
      // cos() takes radians you eeeediot!!
      // adjPitch = 90-pitch;
      // if (pitch < 0) { adjPitch = 0; }
      // var Feff = thrust * Math.cos(adjPitch * .017453292519943295);

      altitude += ascentData[delta].Altitude.delta;
      if (altitude > 1000) {
        $("#altitude").html(numeral(altitude/1000).format('0.000') + "km");
      } else {
        $("#altitude").html(numeral(altitude).format('0.000') + "m");
      }
      apoapsis += ascentData[delta].Apoapsis.delta;
      if (altitude > 1000) {
        $("#apoapsis").html(numeral(apoapsis/1000).format('0.000') + "km");
      } else {
        $("#apoapsis").html(numeral(apoapsis).format('0.000') + "m");
      }
      
      // if Q is 0 then we are out of the atmosphere and should begin paying attention to our periapsis
      Q += ascentData[delta].Q.delta;
      periapsis += ascentData[delta].Periapsis.delta;
      if (Q <= 0) {
        $("#QPeCaption").html("Periapsis:");
        if (Math.abs(periapsis) > 1000) {
          $("#QPe").html(numeral(periapsis/1000).format('0.000') + "km");
        } else {
          $("#QPe").html(numeral(periapsis).format('0.000') + "m");
        }
      } else {
        $("#QPeCaption").html("Dynamic Pressure (Q):");
        if (Q >= 1) {
          $("#QPe").html(numeral(Q).format('0.000') + "kPa");
        } else {
          $("#QPe").html(numeral(Q*1000).format('0.000') + "Pa");
        }
      }
      $("#inclination").html(numeral(inclination += ascentData[delta].Inclination.delta).format('0.000') + "&deg;");
      
      // adjust the bars showing the current fuel status
      var Gwidth = 206 * (stageFuel += ascentData[delta].StageFuel.delta);
      var Rwidth = 206 - Gwidth;
      $('#stageGreen').attr("width", Gwidth);
      $('#stageRed').attr("width", Rwidth);
      $('#stageFuel').html(numeral(stageFuel*100).format('0.00') + "%");
      Gwidth = 206 * (totalFuel += ascentData[delta].TotalFuel.delta);
      Rwidth = 206 - Gwidth;
      $('#totalGreen').attr("width", Gwidth);
      $('#totalRed').attr("width", Rwidth);
      $('#totalFuel').html(numeral(totalFuel*100).format('0.00') + "%");
      
      dstDownrange += ascentData[delta].DstDownrange.delta;
      if (dstDownrange > 1000) {
        $("#downrange").html(numeral(dstDownrange/1000).format('0,0.000') + "km");
      } else {
        $("#downrange").html(numeral(dstDownrange).format('0.000') + "m");
      }
      dstTraveled += ascentData[delta].DstTraveled.delta;
      if (dstTraveled > 1000) {
        $("#traveled").html(numeral(dstTraveled/1000).format('0,0.000') + "km");
      } else {
        $("#traveled").html(numeral(dstTraveled).format('0.000') + "m");
      }
      $("#aoa").html(numeral(aoa += ascentData[delta].AoA.delta).format('0.00'));
      
      // only perform the following if playing, so we can update everything when paused and seeking
      if (!bAscentPaused) { 

        // update the delta value as we work towards the next telemetry entry
        ascentDelta += ascentData[delta].LogInterval.delta;
        
        // if we have reached the end of the playback, stop and allow the map to be manipulated again, give options for user to reset & seek
        if (ascentDelta >= ascentData.length) {
          $("#telemData").html("Reset Telemetry");
          $("#seekForward").attr("src", "seekForward.png");
          $("#seekBack").attr("src", "seekBack.png");
          map.dragging.enable();
          map.touchZoom.enable();
          map.doubleClickZoom.enable();
          map.scrollWheelZoom.enable();
          map.boxZoom.enable();
          $(".leaflet-control-zoom").fadeToggle();
          bAscentPaused = true;
          
          // run a post-launch survey if it is enabled
          if (getParameterByName("survey")) { surveyURL = "https://docs.google.com/forms/d/1MDVK2hC7AXgOI_XXzBBxIB7xw0No-AdxC4bbyUUY0Uc/viewform?" + 
            "entry.186889309=" + OSName + 
            "&entry.1648505583=" + browserDeets + 
            "&entry.1805542433=" + is_touch_device() + 
            "&entry.615008840=" + formatTime(maxDiff/1000, true) + 
            "&entry.2054414267=" + iterpolationTime + 
            "&entry.526407492=" + launchVideo.currentSrc.slice(launchVideo.currentSrc.lastIndexOf(".")+1) + 
            "&entry.1188224461=" + bMetaDataCallback + 
            "&entry.727360894=" + currentTimeLoad + 
            "&entry.1846932672=" + bWentFullscreen + 
            "&entry.1928928792=" + minimizeChoice + 
            "&entry.1790986671=" + videoLoadTime + 
            "&entry.667865474=" + formatTime(timeOffset/1000, false) + 
            "&entry.1780703514=" + bVideoLoaded + 
            "&entry.270402597=" + launchVideo.readyState + 
            "&entry.676247940=" + percentLoaded + 
            "&entry.347156140=" + duration + 
            "&entry.1104133842=" + ascentDelta + 
            "&entry.934368621=" + launchVideo.textTracks.length + 
            "&entry.569001242=" + ascentFPS + 
            "&entry.181114524=" + lowestFPS + 
            "&entry.828457361=" + bTimeDilation + 
            "&entry.1280394113=" + bTimeRecovered;
            $("#msgPostLaunch").fadeIn();
          }

        // if we still have some playback left, call ourselves again to keep things rolling
        } else {
        
          // ensure timer accuracy, even catches up when tab is unfocused!
          // http://www.sitepoint.com/creating-accurate-timers-in-javascript/
          diff = ((new Date().getTime()) - ascentStartTime) - (ascentDelta*1000);
          if (maxDiff < diff) { maxDiff = diff; }

          // check if we are running behind regularly
          if (!bTimeDilation && diff > 1000/ascentFPS && diff > lastDiff) {
            perfHit++;
            if (perfHit == perfThreshold) {
              if (bTimeRecovered) { recovery++; }
              $("#timeDilationTip").html("Performance is not optimal @ " + ascentFPS + "fps<br>Data is behind by " + formatTime(diff/1000, true));
              $("#telemData").css("color", "orange");
              bTimeDilation = true;
            }
          }
          
          // have we recovered from a time dilation event?
          if (diff <= 1000/ascentFPS) {
            if (bTimeDilation) { bTimeRecovered = true; }
            $("#timeDilationTip").html("Data feed is nominal @ " + ascentFPS + "fps");
            $("#telemData").css("color", "green");
            bTimeDilation = false;
          }
          
          // in a stroke of elegance, pass ourselves the whole number delta value so we can use it for array referencing straight away
          setTimeout(ascentUpdater, (1000/ascentFPS) - diff, Math.floor(ascentDelta), false); 
        }
      }
    }

    // JQuery setup
    $(document).ready(function(){
    
      // run a post-launch survey if we are entering this event from a live launch
      if (getParameterByName('surveyURL')) { $("#msgPostLaunch").fadeIn(); }
      
      // gets rid of the survey dialog
      $("#msgPostLaunchDismiss").click(function(){
        $("#msgPostLaunch").fadeOut();
      });

      // launches the post launch survey
      $("#msgPostLaunchSurvey").click(function(){
        $("#msgPostLaunch").fadeOut();
        if (getParameterByName('surveyURL')) { window.open(getParameterByName('surveyURL').replace(/\|/g, "&")); }
        else if (surveyURL) { window.open(surveyURL); }
      });
      
      // shows the map again after it was hidden to show static orbits
      $("#img").click(function(){
        if (bDrawMap && bMapRender) { $("#map").fadeToggle(); }
      });
      
      // does away with the notification for orbital plot length
      $("#msgObtPdDismiss").click(function(){
        $("#msgObtPd").fadeToggle();
      });
      
      // does away with the notification for orbital plot length and reloads the page to render full orbits
      // if this is a touchscreen then user can't see tooltip, may not know the implications of the option, so warn them with an alert
      $("#msgObtPdRender").click(function(){
        if (is_touch_device()) {
          if (!confirm("Are you sure you wish to render 3 full orbits?")) {
            $("#msgObtPd").fadeToggle();
            return;
          }
        }
        window.location.href = window.location.href + "&fullorbit=y";
      });

      // upon selection of a new list item, take the user to that event
      // unless that event is a future node/event, in which case show the node if possible or event
      // again, touchscreen users can't see tooltip so display as an alert message instead
      $("#prevEvent")
        .change(function () {
          if ($("#prevEvent").val().length) { window.location.href = $("#prevEvent").val(); }
        })
        .change();
      $("#nextEvent")
        .change(function () {
          if ($("#nextEvent").val().length) { 
            if ($("#nextEvent").val() == "node") { 
              if (is_touch_device()) { setTimeout(function() { alert($("#nextNode").html().replace(/<br>/g, "\n")); }, 50); }
              if (!bNodeRefreshCheck && nodeMark) { nodeMark.openPopup(); }
              document.getElementById('nextEvent').selectedIndex = 0;
            } else {
              window.location.href = $("#nextEvent").val(); 
            }
          }
        })
        .change();
      
      // does away with the notification for future maneuver node
      $("#msgNode").click(function(){
        $("#msgNode").fadeToggle();
      });
      
      // does away with the flight tracker introduction box 
      $("#close").click(function(){
        $("#intro").fadeToggle();
      });
      
      // does away with the notification for upcoming launch
      // currently not used in favor of a confirm dialog
      $("#msgLaunch").click(function(){
        $("#msgLaunch").fadeToggle();
      });

      // begins loading video data on mobile devices
      // makes user aware of video data size
      $("#videoStatus").click(function(){
        if (is_touch_device() && !videoLoadTime) { 
          switch (launchVideo.currentSrc.slice(launchVideo.currentSrc.lastIndexOf(".")+1)) {
          case "mp4":
            strMessage = "Launch video filesize: " + mp4Size + "MB";
            break;
          case "webm":
            strMessage = "Launch video filesize: " + webmSize + "MB";
            break;
          case "ogg":
            strMessage = "Launch video filesize: " + oggSize + "MB";
          }
          strMessage += "\nVideo not required for streaming experience. Click okay to load video or cancel to refuse";
          if (confirm(strMessage)) {
            launchVideo.load(); 
            videoLoadTime = new Date().getTime();
            $("#videoStatus").html("&nbsp;&nbsp;&nbsp;&nbsp;<span id='loadText' style='cursor: help; border-bottom: 1px dotted white;' class='tip-update' data-tipped-options=\"inline: 'videoTip'\">Spinning up hamster wheels...</span>");

            // Spin.js for loading spinner
            // http://fgnass.github.io/spin.js/
            spinner = new Spinner({lines:9, length:9, width:8, radius:12, scale:0.25, corners:1, color:'#FFFFFF', opacity:0.25, rotate:0, direction: 1, speed: 1, trail: 60, fps: 20, zIndex: 2e9, className: 'spinner', top: '50%', left: '50%', shadow: false, hwaccel: false, position: 'absolute'}).spin(document.getElementById('spinner'));
          }
        }
      });
      
      // shows/hides the sketchfab icon
      $("#mainwrapper").hover(function(){
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabBlank").fadeToggle();
      });
      
      // empty non-obscuring replacement used when the sketchfab icon is hidden to let the user show it while the info box is scrolled up
      $("#sketchfabBlank").hover(function(){
        $("#sketchfabBlank").css("display", "none");
      }, function(){});
      
      // shows/hides the sketchfab text
      // upon fade completion, container is resized for proper hover detection
      $("#sketchfabImg").hover(function(){
        $("#sketchfabButton").css("width", "95px");
        $("#sketchfabTxt").fadeToggle();
        }, function(){
        $("#sketchfabTxt").fadeToggle(function(){
          $("#sketchfabButton").css("width", "40px");
        });
      });
      
      // show the sketchfab model viewer over top the 2D image
      // does not start the viewer - have asked about API functions
      // https://help.sketchfab.com/hc/en-us/articles/203509907-Share-Embed-Online?page=1#comment_202609356
      $("#sketchfabImg").click(function(){
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabModel").fadeToggle();
        $("#sketchfabReturn").fadeToggle();
      });

      // hide the sketchfab model viewer
      // does not stop the viewer - have asked about API functions
      $("#sketchfabReturn").click(function(){
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabModel").fadeToggle();
        $("#sketchfabReturn").fadeToggle();
      });

      // hide the sketchfab text after a second so people see it first
      setTimeout(function () { 
        $("#sketchfabTxt").fadeToggle(function(){
            $("#sketchfabBUtton").css("width", "40px");
          });
      }, 1000);
      
      // controls the playback of telemetry data when viewing a past launch
      $("#telemData").click(function(){
        switch ($("#telemData").html()) {
        case "Reset Telemetry":
        
          // reset variables, clean up the map plot, reset data window display by calling ascentUpdater()
          launchCountdown = 0;
          ascentDelta = 0;
          $("#timeDilationTip").html("Click to begin playback");
          $("#telemData").css("color", "black");
          $("#telemData").html("Play Telemetry");
          $("#captionMET").html("Launch in: ");
          ascentTrack.setLatLngs([]);
          ascentUpdater(Math.floor(ascentDelta), true);
          $("#videoStatus").fadeIn();
          $("#videoCameraName").fadeOut();
          $("#ascentStatus").fadeIn();
          $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
          break;
          
        case "Pause Telemetry":
        
          // re-enable all map functions and seek ability, pause playback
          $("#seekForward").attr("src", "seekForward.png");
          $("#seekBack").attr("src", "seekBack.png");
          bAscentPaused = true;
          $("#telemData").html("Play Telemetry");
          $("#timeDilationTip").html("Click to begin playback");
          Tipped.refresh(".tip-update");
          $("#telemData").css("color", "black");
          map.dragging.enable();
          map.touchZoom.enable();
          map.doubleClickZoom.enable();
          map.scrollWheelZoom.enable();
          map.boxZoom.enable();
          $(".leaflet-control-zoom").fadeToggle();
          if (bVideoLoaded) { launchVideo.pause(); }
          break;
          
        case "Play Telemetry":
        
          // disable all map functions and seek ability, resume/start playback
          $("#seekForward").attr("src", "seekForwardDisable.png");
          $("#seekBack").attr("src", "seekBackDisable.png");
          bAscentPaused = false;
          if (ascentDelta > 0) {
          
            // it's important to make note of our start time so we can keep the playback in sync
            ascentStartTime = new Date().getTime() - (ascentDelta*1000);
            ascentUpdater(Math.floor(ascentDelta), false);
          }
          $("#telemData").html("Pause Telemetry");
          $("#timeDilationTip").html("Data feed is nominal @ " + ascentFPS + "fps");
          Tipped.refresh(".tip-update");
          $("#telemData").css("color", "green");
          map.dragging.disable();
          map.touchZoom.disable();
          map.doubleClickZoom.disable();
          map.scrollWheelZoom.disable();
          map.boxZoom.disable();
          $(".leaflet-control-zoom").fadeToggle();
          if ($("#mainwrapper").css("display") == "none" && bVideoLoaded) { launchVideo.play(); }
          perfHit = 0;
          bTimeDilation = false;
          bTimeRecovered = false;
          break;
        }
      });

      // seek controls for telemetry playback - work when paused only
      // seek time can be set in URL via "&seek=30" and is in seconds
      $("#seekBack").click(function(){
        
        // can't use if disabled
        if ($("#seekBack").attr("src").search("seekBack.png") != -1) {

          // are we into our telemetry data?
          if (ascentDelta > 0) {
          
            // turn back the time and check whether we are still in our telemetry data
            ascentDelta -= seekTime;
            if (ascentDelta < 0) 
            { 
              
              // we're before the start of telemetry data, which also means we're before launch. Maybe even before the pre-launch event time
              launchCountdown = Math.floor((telemetryUT - getParameterByName('ut')) + ascentDelta);
              if (launchCountdown < 0) { launchCountdown = 0; }
              ascentDelta = 0;
              ascentStartTime = -1;
              ascentIntervalElapse = 0;
              $("#captionMET").html("Launch in: ");
              $("#launchMET").html(formatTime(launchUT - ((getParameterByName('ut')*1) + launchCountdown), false));
            }
            
            // rebuild the map plot if we still have positive ascentDelta, then update data window values
            ascentTrack.setLatLngs([]);
            for (x=0; x<=ascentDelta; x++) {
              ascentTrack.spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]);
            }
            ascentUpdater(Math.floor(ascentDelta), true);
          } else {
          
            // we're still prior to telemetry data so back up launch countdown but no further than the start of this event time
            launchCountdown -= seekTime;
            if (launchCountdown < 0) { launchCountdown = 0; }
            $("#launchMET").html(formatTime(launchUT - ((getParameterByName('ut')*1) + launchCountdown), false));
          }
          
          // is there a launch video we need to keep in sync and is it ready?
          if (bVideoLoaded) {
          
            // seek to the proper video point if possible and show/hide as necessary
            if (ascentDelta > 0 && ascentDelta < vidAscentLength) {
              launchVideo.currentTime = (telemetryUT - videoStartUT) + ascentDelta;
              $("#mainwrapper").fadeOut();
              $("#videoCameraName").fadeIn();
            } else if (ascentDelta == 0 && launchCountdown >= 0) {
              if (launchCountdown >= videoStartUT - getParameterByName('ut')) {  
                launchVideo.currentTime = Math.abs((videoStartUT - getParameterByName('ut')) - launchCountdown);
                $("#mainwrapper").fadeOut();
                $("#videoCameraName").fadeIn();
              } else {
                $("#mainwrapper").fadeIn();
                $("#videoStatus").fadeIn();
                $("#videoCameraName").fadeOut();
                $("#ascentStatus").fadeIn();
                $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
              }
            }
          }
          
          // update playback control as needed
          if ($("#telemData").html() == "Reset Telemetry") { $("#telemData").html("Play Telemetry"); }
        }
      });
      $("#seekForward").click(function(){
      
        // can't use if disabled
        if ($("#seekForward").attr("src").search("seekForward.png") != -1) {

          // either we are in our ascent data or coming out of prelaunch
          if (ascentDelta > 0) {
            ascentDelta += seekTime;
            
            // don't let user seek past the end of telemetry data
            if (ascentDelta >= ascentData.length) 
            {
              ascentDelta = ascentData.length - 1;
              
              // we should be able to just add to whatever existing plot, but again leaflet is being touchy so just redo the whole thing
              ascentTrack.setLatLngs([]);
              for (x=0; x<=ascentDelta; x++) {
                ascentTrack.spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]);
              }
              $("#telemData").html("Reset Telemetry");
            }
            ascentUpdater(Math.floor(ascentDelta), true);
            
          // we're still counting down to launch, check to see if we've jumped over into telemetry
          } else {
            launchCountdown += seekTime;
            if (launchCountdown >= telemetryUT - getParameterByName('ut')) 
            {
              ascentStartTime = 0;
              ascentDelta = launchCountdown - (telemetryUT - getParameterByName('ut'));
              for (x=Math.floor(ascentDelta); x<Math.floor(ascentDelta)+seekTime; x++) {
                ascentTrack.spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]);
              }
              $("#captionMET").html("MET: ");
              ascentUpdater(Math.floor(ascentDelta), true);
            } else {
         
              // don't wait for our 1 second tick to update the countdown clock
              $("#launchMET").html(formatTime(launchUT - ((getParameterByName('ut')*1) + launchCountdown), false));       
            }
          }
          
          // is there a launch video we need to keep in sync and is it ready?
          if (bVideoLoaded) {
          
            // seek to the proper video point if possible and show/hide as necessary
            if (ascentDelta > 0) {
              if (ascentDelta < vidAscentLength) {
                launchVideo.currentTime = (telemetryUT - videoStartUT) + ascentDelta;
              } else {
                $("#mainwrapper").fadeIn();
                $("#videoCameraName").fadeOut();
                $("#ascentStatus").fadeIn();
              }
            } else if (ascentDelta == 0 && launchCountdown > 0) {
              if (launchCountdown >= videoStartUT - getParameterByName('ut')) {  
                $("#mainwrapper").fadeOut();
                $("#videoStatus").fadeOut();
                $("#videoCameraName").fadeIn();
                launchVideo.currentTime = Math.abs((videoStartUT - getParameterByName('ut')) - launchCountdown);
              } else {
                $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
              }
            }
          }
        }
      });

      // behavior of tooltips depends on the device
      if (is_touch_device()) {
        var showOpt = 'click';
      } else {
        var showOpt = 'mouseenter';
      }
 
      // create all the tooltips using Tipped.js - http://www.tippedjs.com/
      // separate class for updating tooltips so they don't mess with any static ones set to show over mouse cursor
      Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
      Tipped.create('.tip-update', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
    });
  </script>	
</head>
<body style="padding: 0; margin: 0;"  onbeforeunload='resetLists()'>

<!-- 
CRAFT DATABASE INFORMATION
==========================

Planets recordset contains all planets in the Kerbol system, each given a name and assigned a unique ID. Can include any additional planets, not just stock
This also contains all details needed for calculating orbital plots

Moons recordset contains all moons in the Kerbol system, each given a name and assigned a unique ID. Their reference field links them to the planet they orbit.
Like planets there can be additional moons besides stock
This also contains all details needed for calculating orbital plots

Crafts recordset contains data on crafts within certain SOIs
See the menu creation code later on for details on the recordset
-->

<%
'open craft database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\dbCrafts.mdb"
Dim connBodies
Set connBodies = Server.CreateObject("ADODB.Connection")
sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connBodies.Open(sConnection2)

'create the tables
set rsPlanets = Server.CreateObject("ADODB.recordset")
set rsMoons = Server.CreateObject("ADODB.recordset")
set rsCrafts = Server.CreateObject("ADODB.recordset")

'query the data, ensure that bookmarking is enabled
rsPlanets.open "select * from planets", connBodies, 1, 1
rsMoons.open "select * from moons", connBodies, 1, 1
rsCrafts.open "select * from crafts", connBodies, 1, 1
%>

<!-- 
VESSEL DATABASE INFORMATION
===========================

Craft Data recordset contains various general information about the vessel that is always displayed with every update.
Craft Resources recordset contains information on vessel resources, types and weight.
Flight Data recordset contains orbital information for when the craft is in space.
Crew Manifest recordset contains information on any astronauts currently aboard.
Craft Comms recordset contains information on any communications equipment aboard.
Ascent Data recordset contains telemetry information for vessel ascent to orbit after launch. (usage not required)
New Ascent Data recordset contains telemetry information for vessel ascent to orbit after launch that is streamed via interpolation. Should not exist if Ascent Data table is present
Flightplan recordset contains maneuver node data that can be displayed on the dynamic map if it occurs along the rendered orbit (usage not required)

All recordsets can be updated independently. If you add a record to Craft Data, you do not have to add a corresponding UT record to all the other recordsets

See the various recordset display code sections below for further details.
-->

<%
'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\db" & request.querystring("db") & ".mdb"
Dim connCraft, sConnection
Set connCraft = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connCraft.Open(sConnection)

'create the tables
set rsCraft = Server.CreateObject("ADODB.recordset")
set rsOrbit = Server.CreateObject("ADODB.recordset")
set rsCrew = Server.CreateObject("ADODB.recordset")
set rsResources = Server.CreateObject("ADODB.recordset")
set rsComms = Server.CreateObject("ADODB.recordset")
set rsAscent = Server.CreateObject("ADODB.recordset")
set rsNewAscent = Server.CreateObject("ADODB.recordset")
set rsFlightplan = Server.CreateObject("ADODB.recordset")

'query the data
rsCraft.open "select * from [craft data]", connCraft, 2
rsResources.open "select * from [craft resources]", connCraft, 2
rsOrbit.open "select * from [flight data]", connCraft, 2
rsCrew.open "select * from [crew manifest]", connCraft, 2
rsComms.open "select * from [craft comms]", connCraft, 2

'determine if this DB has tables older databases may not contain
set adoxConn = CreateObject("ADOX.Catalog")  
adoxConn.activeConnection = connCraft  
bAscentData = false 
bNewAscentData = false
bFlightplan = false 
for each table in adoxConn.tables 
  if lcase(table.name) = "ascent data" then 
    bAscentData = true 
  elseif lcase(table.name) = "new ascent data" then 
    bNewAscentData = true 
  elseif lcase(table.name) = "flightplan" then 
    bFlightplan = true
  end if 
next

'trying to open a recordset that does not exist will kill the page
if bAscentData then rsAscent.open "select * from [ascent data]", connCraft, 2
if bNewAscentData then rsNewAscent.open "select * from [new ascent data]", connCraft, 2
if bFlightplan then rsFlightplan.open "select * from flightplan", connCraft, 2

'check to see if this database supports fields not found in older databases
'http://stackoverflow.com/questions/16474210/detect-if-a-names-field-exists-in-a-record-set
bDstTraveled = true
bNodeLink = true
b3DView = true

on error resume next
test = rsCraft.fields("DistanceTraveled").name
If Err <> 0 Then bDstTraveled = false
Err.Clear

test = rsCraft.fields("NodeLink").name
If Err <> 0 Then bNodeLink = false
Err.Clear

test = rsCraft.fields("3DView").name
If Err <> 0 Then b3DView = false
Err.Clear

'revert to normal error checking
On Error GoTo 0 

'calculate the time in seconds since epoch 0 when the game started
UT = datediff("s", "16-Feb-2014 00:00:00", now())

'affects the base UT that is used for some areas that ignore dbUT
if request.querystring("deltaut") then
  UT = UT + request.querystring("deltaut")
end if
 
'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
response.write("<script>")
response.write("var bPastUT = false;")
response.write("</script>")
passcode = false
bPastUT = false
if request.querystring("ut") then
  'convert the text string into a number
  dbUT = request.querystring("ut") * 1
  
  'do not allow people to abuse the UT query to peek ahead 
  'a passcode query is required when requesting a UT entry later than the current UT
  if dbUT > UT then
    passcode = true
    if request.querystring("pass") <> "2725" then 
      'passcode incorrect or not supplied. Revert back to current UT
      dbUT = UT
      passcode = false
    end if
  end if
else
  dbUT = UT
end if

'starting from the end, work back to find the first record earlier than or equal to the UT we are looking for
if not rsCraft.eof then
  rsCraft.MoveLast
  do until rsCraft.fields.item("id") <= dbUT
    rsCraft.MovePrevious
  Loop
end if

'check if the actual UT is not greater than the next record, or if there even is a next record. 
'this tells us whether we have returned to the current-time entry from a past entry, and UT should be used in place of dbUT
'adding the code below created a weird bug where movenext/prev would not work properly when looking back to current time - see Last Update area for more
'ignore this when viewing a future event past current UT
rsCraft.movenext
if not rsCraft.eof then
  if not passcode then
    if UT < rsCraft.fields.item("id") then
      dbUT = UT
    else
      'dbUT remains in effect, make note so js also knows this is not the current time
      response.write("<script>")
      response.write("var bPastUT = true;")
      response.write("</script>")
      bPastUT = true
    end if
  end if
else
  dbUT = UT
end if
rsCraft.moveprevious
'regardless of previous outcomes, moving forward all recordset quieries should be made via dbUT
%>

<!-- Ascent data interpolation -->

<%
'set vb/js flags for whether or not we have ascent data to load and are in an ascent state right now
response.write("<script>")
response.write("var bAscentActive = false;")
response.write("var telemetryUT = 0;")
bAscentActive = false
vidLength = 0
if bNewAscentData then
  if not rsNewAscent.bof then

    'debug info
    interpStart = now()
    
    'a ~ symbol in this field is telling us we have an ascent underway during this event
    if left(rsCraft.fields.item("imgDataCode"),1) = "~" then
      response.write("var bAscentActive = true;")
      bAscentActive = true
      
      'reload this page if the options are not displayed
      'http://snipplr.com/view/6618/getting-full-urlpath-with-asp/
      if len(request.querystring("fps")) = 0 or len(request.querystring("seek")) = 0 then 
        response.redirect "http://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING") & "&fps=30&seek=30"
      end if
    
      'get the time of the launch (not the time telemetry begins!)
      response.write("launchUT = " & datediff("s", "16-Feb-2014 00:00:00", rsCraft.fields.item("LaunchDate")) & ";")

      'load all the initial values from the first entry
      telemetryUT = rsNewAscent.fields.item("id")
      response.write("var telemetryUT = " & rsNewAscent.fields.item("id") & ";")
      response.write("var velocity = " & rsNewAscent.fields.item("velocity") & ";")
      response.write("var thrust = " & rsNewAscent.fields.item("thrust") & ";")
      response.write("var mass = " & rsNewAscent.fields.item("mass") & ";")
      response.write("var altitude = " & rsNewAscent.fields.item("altitude") & ";")
      response.write("var apoapsis = " & rsNewAscent.fields.item("apoapsis") & ";")
      response.write("var inclination = " & rsNewAscent.fields.item("inclination") & ";")
      response.write("var throttle = " & rsNewAscent.fields.item("throttle") & ";")
      response.write("var Q = " & rsNewAscent.fields.item("Q") & ";")
      response.write("var periapsis = " & rsNewAscent.fields.item("periapsis") & ";")
      response.write("var stageFuel = " & rsNewAscent.fields.item("stageFuel") & ";")
      response.write("var totalFuel = " & rsNewAscent.fields.item("totalFuel") & ";")
      response.write("var dstDownrange = " & rsNewAscent.fields.item("dstDownrange") & ";")
      response.write("var dstTraveled = " & rsNewAscent.fields.item("dstTraveled") & ";")
      response.write("var pitch = " & rsNewAscent.fields.item("pitch") & ";")
      response.write("var roll = " & rsNewAscent.fields.item("roll") & ";")
      response.write("var heading = " & rsNewAscent.fields.item("heading") & ";")
      response.write("var gravity = " & rsNewAscent.fields.item("gravity") & ";")
      response.write("var aoa = " & rsNewAscent.fields.item("aoa") & ";")

      'get the FPS from the querystring setting (default 30)
      ascentFPS = request.querystring("fps")
      response.write("var ascentFPS = " & request.querystring("fps") & ";")
      
      'check if we have a custom seek time otherwise use default
      if request.querystring("seek") then
        seekTime = request.querystring("seek")
      else
        seekTime = 30
      end if
      response.write("var seekTime = " & seekTime & ";")
      
      'now interpolate the difference between the data
      'funny story - originally arrays were first() and second(), which caused a Type Mismatch error when I tried to use the time function response.write(Second(Now()))
      'ok not so funny - it was a pain in the ass to track down and fix!!
      response.write("var ascentData = [];")
      dim before(18)
      dim after(18)
      do until rsNewAscent.eof
      
        'get all the numerical data from this record
        before(0) = rsNewAscent.fields.item("Velocity")
        before(1) = rsNewAscent.fields.item("Thrust")
        before(2) = rsNewAscent.fields.item("Mass")
        before(3) = rsNewAscent.fields.item("Altitude")
        before(4) = rsNewAscent.fields.item("Apoapsis")
        before(5) = rsNewAscent.fields.item("Inclination")
        before(6) = rsNewAscent.fields.item("Q")
        before(7) = rsNewAscent.fields.item("Periapsis")
        before(8) = rsNewAscent.fields.item("StageFuel")
        before(9) = rsNewAscent.fields.item("TotalFuel")
        before(10) = rsNewAscent.fields.item("DstDownrange")
        before(11) = rsNewAscent.fields.item("DstTraveled")
        before(12) = rsNewAscent.fields.item("AoA")
        before(13) = rsNewAscent.fields.item("Pitch")
        before(14) = rsNewAscent.fields.item("Roll")
        before(15) = rsNewAscent.fields.item("Heading")
        before(16) = rsNewAscent.fields.item("ID")
        before(17) = rsNewAscent.fields.item("Throttle")
        before(18) = rsNewAscent.fields.item("Gravity")
        
        'now get all the data from the next record
        rsNewAscent.movenext
        if rsNewAscent.eof then exit do
        after(0) = rsNewAscent.fields.item("Velocity")
        after(1) = rsNewAscent.fields.item("Thrust")
        after(2) = rsNewAscent.fields.item("Mass")
        after(3) = rsNewAscent.fields.item("Altitude")
        after(4) = rsNewAscent.fields.item("Apoapsis")
        after(5) = rsNewAscent.fields.item("Inclination")
        after(6) = rsNewAscent.fields.item("Q")
        after(7) = rsNewAscent.fields.item("Periapsis")
        after(8) = rsNewAscent.fields.item("StageFuel")
        after(9) = rsNewAscent.fields.item("TotalFuel")
        after(10) = rsNewAscent.fields.item("DstDownrange")
        after(11) = rsNewAscent.fields.item("DstTraveled")
        after(12) = rsNewAscent.fields.item("AoA")
        after(13) = rsNewAscent.fields.item("Pitch")
        after(14) = rsNewAscent.fields.item("Roll")
        after(15) = rsNewAscent.fields.item("Heading")
        after(16) = rsNewAscent.fields.item("ID")
        after(17) = rsNewAscent.fields.item("Throttle")
        after(18) = rsNewAscent.fields.item("Gravity")
        rsNewAscent.moveprevious

        'get the change in values from one entry to the next & also what is in remaining fields
        'values stored is the fraction needed to achieve the change in value over the time between log data given a certain FPS
        '(after(x) - before(x)) = Data Delta - amount of change between the two values
        '(after(16) - before(16)) = Time Delta - number of seconds between telemetry updates
        '(Data Delta / FPS) / Time Delta = fraction to add every frame to move value across entire range of data delta
        'same concept used for LogInterval so that it takes several seconds to add up to 1 second when needed
        'store the base value as the clamp to ensure accuracy
        response.write("velocityData = {delta:" & ((after(0) - before(0)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Velocity") & "};")
        response.write("thrustData = {delta:" & ((after(1) - before(1)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Thrust") & "};")
        response.write("massData = {delta:" & ((after(2) - before(2)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Mass") & "};")
        response.write("altitudeData = {delta:" & ((after(3) - before(3)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Altitude") & "};")
        response.write("apData = {delta:" & ((after(4) - before(4)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Apoapsis") & "};")
        response.write("incData = {delta:" & ((after(5) - before(5)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Inclination") & "};")
        response.write("qData = {delta:" & ((after(6) - before(6)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Q") & "};")
        response.write("peData = {delta:" & ((after(7) - before(7)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Periapsis") & "};")
        response.write("stageFuelData = {delta:" & ((after(8) - before(8)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("StageFuel") & "};")
        response.write("totalFuelData = {delta:" & ((after(9) - before(9)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("TotalFuel") & "};")
        response.write("downrangeData = {delta:" & ((after(10) - before(10)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("DstDownrange") & "};")
        response.write("traveledData = {delta:" & ((after(11) - before(11)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("DstTraveled") & "};")
        response.write("aoaData = {delta:" & ((after(12) - before(12)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("AoA") & "};")
        response.write("pitchData = {delta:" & ((after(13) - before(13)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Pitch") & "};")
        response.write("rollData = {delta:" & ((after(14) - before(14)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Roll") & "};")
        response.write("hdgData = {delta:" & ((after(15) - before(15)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Heading") & "};")
        response.write("logData = {delta:" & ((after(16) - before(16)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & after(16) - before(16) & "};")
        response.write("throttleData = {delta:" & ((after(17) - before(17)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Throttle") & "};")
        response.write("gData = {delta:" & ((after(18) - before(18)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsNewAscent.fields.item("Gravity") & "};")
        
        'add the interpolated data to the array along with data that requires no interpolation and is only accessed once per interval
        response.write("ascentData.push({Velocity: velocityData, Thrust: thrustData, Mass: massData, Altitude: altitudeData, Apoapsis: apData, Inclination: incData, Q: qData, Periapsis: peData, StageFuel: stageFuelData, TotalFuel: totalFuelData, DstDownrange: downrangeData, DstTraveled: traveledData, AoA: aoaData, Pitch: pitchData, Roll: rollData, Heading: hdgData, LogInterval: logData, Throttle: throttleData, Gravity: gData, AoAWarn: '" & rsNewAscent.fields.item("AoAWarn") & _
                        "', Event: '" & rsNewAscent.fields.item("Event") & _
                        "', Lat: " & rsNewAscent.fields.item("Lat") & _
                        ", Lon: " & rsNewAscent.fields.item("Lon") & _
                        ", FPS: " & ascentFPS & _
                        ", CommLost: " & lcase(rsNewAscent.fields.item("CommLost")) & _
                        ", Video: " & lcase(rsNewAscent.fields.item("Video")) & _
                        ", Tweet: '" & rsNewAscent.fields.item("Tweet") & _
                        "', Camera: '" & rsNewAscent.fields.item("Camera") & _
                        "', Image: '" & rsNewAscent.fields.item("Image") & "'});")
       
        'update length of launch video
        if rsNewAscent.fields.item("video") then vidLength = vidLength + 1
        rsNewAscent.movenext
      loop
    end if
    
    'debug info
    response.write("var iterpolationTime = formatTime(" & datediff("s", interpStart, now()) & ", true);")
  end if
end if

'video true/false ends 1 sec before actual end so it can fade out, so add a second if needed
if vidLength > 0 then vidLength = vidLength + 1
response.write("var vidAscentLength = " & vidLength & ";")
response.write("</script>")

'assign the launch date, but - 
'if we are viewing this record as a past event and the launch for this record was scrubbed,
'the launch time for this record is no longer valid for Mission Elapsed Time calculation
'so we need to look ahead for the actual launch time, which was one without a scrub
tzero = true
fromdate = rsCraft.fields.item("LaunchDate")
if request.querystring("ut") and rsCraft.fields.item("Scrub") then
  bkmark = 0
  
  'do not search past the end of the recordset or the current UT
  'we do not need people to know the actual launch time if that event has not occured yet
  tzero = false
  do while rsCraft.fields.item("id") < UT and not rsCraft.eof
    bkmark = bkmark - 1
    rsCraft.movenext
    if not rsCraft.fields.item("Scrub") then 
      fromdate = rsCraft.fields.item("LaunchDate")
      
      'inform user that displayed time for this record is not accurate
      msg = "Actual launch time:<br>" & rsCraft.fields.item("LaunchDateUTC") & " UTC<br>"
      tzero = true
      exit do
    end if
  loop
  
  'return the cursor to the proper record
  rsCraft.move bkmark
end if
    
'calculate the time since the start of the mission
'this field could be blank if a new entry was created in Craft Data after a scrub with no new launch time
if not isnull(rsCraft.fields.item("LaunchDate")) then 
  origMET = datediff("s", fromdate, now())
else
  origMET = 0
end if

'is it prior to or after launch?
'save the original MET for use with JS update
if origMET <= 0 then
  MET = origMET * -1
  msg = msg & "Mission yet to launch<br>T-"
else
  MET = origMET
  msg = msg & "Mission ongoing<br>MET: "
end if

'redo the message entirely if the mission is over
if not isnull(rsCraft.fields.item("EndTime")) and UT >= rsCraft.fields.item("EndTime") then
  msg = rsCraft.fields.item("EndMsg") & "<br>MET: "
  MET = datediff("s", rsCraft.fields.item("LaunchDate"), rsCraft.fields.item("EndDate"))
end if

'convert from seconds to yy:ddd:hh:mm:ss
years = 0
days = 0
hours = 0
minutes = 0
missionMET = ""

if MET >= 86400 then
  days = int(MET / 86400)
  MET = MET - (days * 86400)
  missionMET = days & "d, "
end if

if days >= 365 then
  years = int(days / 365)
  days = days - (years * 365)
  missionMET = years & "y " & days & "d, "
end if

if MET >= 3600 then
  hours = int(MET / 3600)
  MET = MET - (hours * 3600)
  missionMET = missionMET & hours & "h "
end if

if MET >= 60 then
  minutes = int(MET / 60)
  MET = MET - (minutes * 60)
  missionMET = missionMET & minutes & "m "
end if

if MET > 0 then
  seconds = MET
  missionMET = missionMET & round(seconds,2) & "s"
end if

'we need to compose the pop-up text for a variety of situations
datestamp = "UTC"
if isnull(rsCraft.fields.item("LaunchDate")) or not tzero then

  'launch has been scrubbed but a new launch time has not yet been announced
  launchmsg = "To Be Determined"
  if isnull(rsCraft.fields.item("LaunchDate")) then	datestamp = ""
else

  'launch is a go!
  launchmsg = msg & missionMET
end if 

'make note of whether this mission has ended or not, to disable tooltip updates
'any of the 3 end mission fields will do, all will be filled out if mission is over
'note also we should not update if there is no time to update
bUpdateMET = true
if not isnull(rsCraft.fields.item("EndTime")) or launchmsg = "To Be Determined" or not tzero then bUpdateMET = false
%>

<!-- 
FLIGHTPLAN FIELDS
=================

UT - the time in seconds from 0 epoch at which this maneuver should be visible on the map
ExecuteUT - the time in seconds from 0 epoch at which this maneuver node occurs
Prograde - m/s movement along the prograde vector
Normal - m/s movement along the normal vector
Radial - m/s movement along the radial vector
Total - total amount of delta-v required for maneuver
-->

<%
'determine if we have an upcoming maneuver node and save that data to js
response.write("<script>")
response.write("var bUpcomingNode = false;")
response.write("var nodeUT = 0;")
if bFlightplan then 

  'find the record that works for this time
  if not rsFlightplan.bof then
    rsFlightplan.movelast
    do until rsFlightplan.bof
      if rsFlightplan.fields.item("ut") <= dbUT then exit do
      rsFlightplan.MovePrevious
    Loop
    
    'if we found one, pass along the data to js for us to use later
    if not rsFlightplan.bof then
      if rsFlightplan.fields.item("executeut") > dbUT then
        response.write("var bUpcomingNode = true;")
        response.write("var nodeUT = " & rsFlightplan.fields.item("executeut") & ";")
        response.write("var nodePrograde = " & rsFlightplan.fields.item("prograde") & ";")
        response.write("var nodeNormal = " & rsFlightplan.fields.item("normal") & ";")
        response.write("var nodeRadial = " & rsFlightplan.fields.item("radial") & ";")
        response.write("var nodeTotal = " & rsFlightplan.fields.item("total") & ";")
        response.write("</script>")
      end if
    end if
  end if
end if
response.write("</script>")
  
'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
  response.write("<div style='width: 100%; overflow: hidden;'>")
else
  response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if

'determine if this craft has a 3D model available to view and if so, make available the controls to see it
if b3DView then
  if not isNull(rsCraft.fields.item("3DView")) then
    response.write("<div id='sketchfabButton' style='z-index: 115; width: 95px; font-family: sans-serif; color: white; position: absolute; height: 40px; top: 58px; left: 10px; '><img id='sketchfabImg' src='sketchfab.png' style='cursor: pointer; padding-left: 5px; padding-top: 5px;'> <span id='sketchfabTxt'>3D View</span></div>")
    response.write("<div id='sketchfabBlank' style='z-index: 115; width: 40px; font-family: sans-serif; color: white; position: absolute; height: 40px; top: 58px; left: 10px; display: none; '></div>")
    response.write("<div id='sketchfabModel' style='z-index: 113; width: 530px; position: absolute; height: 385px; top: 58px; left: 10px; display: none;'><iframe width='525' height='380' src='https://sketchfab.com/models/" & rsCraft.fields.item("3DView") & "/embed?autospin=0.2&amp;preload=1' frameborder='0' allowfullscreen mozallowfullscreen='true' webkitallowfullscreen='true' onmousewheel=''></iframe></div>")
    response.write("<div id='sketchfabReturn' style='width: 30px; height: 30px; z-index: 115; font-family: sans-serif; position: absolute; top: 58px; left: 422px; display: none; '><img src='return.png' width='19' style='cursor: pointer; padding-left: 5px; padding-top: 6px;' class='tip' data-tipped-options=""size: 'medium', position: 'bottom'"" title='Back to 2D view<br>Does not stop viewer!'></div>")
  end if
end if

'do we need to load up a launch video?
response.write("<script>bLaunchVideo = false;</script>")
if bAscentActive then
  rsNewAscent.movefirst
  if rsNewAscent.fields.item("Video") then
  
    'build the video object and hide it below the description box until it is ready to show
    response.write("<script>var bLaunchVideo = true;</script>")
    response.write("<div id='videoContainer' style='z-index: -2; width: 525; background-color: black; position: absolute; height: 380px; top: 58px; left: 10px; '>")
    response.write("<video id='video' preload='auto' width='525' height='380'>")
    response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.mp4' type='video/mp4'>")
    response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.webm' type='video/webm' >")
    response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.ogv' type='video/ogg; codecs=""theora, vorbis""'/>")
    response.write("</video>")
    response.write("</div>")
    
    'various text status areas
    response.write("<div id='videoTip' style='display: none'>Please be patient while video data loads</div>")
    response.write("<div id='videoStatus' style='z-index: 111; font-family: sans-serif; color: white; position: absolute; top: 61px; left: 14px; '>&nbsp;&nbsp;&nbsp;&nbsp;<span id='loadText' style='cursor: help; border-bottom: 1px dotted white;' class='tip-update' data-tipped-options=""inline: 'videoTip'""></span></div>")
    response.write("<div id='spinner' style='width: 15px; height: 20px; z-index: 111; font-family: sans-serif; color: white; position: absolute; top: 61px; left: 14px; '></div>")
    response.write("<div id='videoCameraName' style='z-index: 110; display: none; font-family: sans-serif; color: white; position: absolute; top: 61px; right: 613px; '></div>")
  end if
end if
%>

<script>
// remove the "loading page"
$("html").css("cursor", "default");
$("html").css("background-image", "none");

// is there a launch video we need to setup?
var spinner;
var vidLength;
var videoStartUT;
var currentTimeLoad;
var minimizeChoice = "none";
var bMetaDataCallback = false;
var bVideoLoading = false;
var bVideoLoaded = false;
var bWentFullscreen = false;
var bAskedMinimize = false;
var loadTextIndex = 0;
var launchCountdown = 0;
var videoLoadTime;
var duration = 0;
var percentLoaded = 0;
if (bLaunchVideo) {
  var launchVideo = document.querySelector('#video');
  
  // we're autoloading video
  if(!is_touch_device()) {
    videoLoadTime = new Date().getTime();
  }
  
  // if this is a live event we need to make sure we start buffering the video at the current point in the countdown/MET
  // do this in the callback for getting metadata so we can get duration and set position
  if (!bPastUT) {
    launchVideo.onloadedmetadata = function() {
      bMetaDataCallback = true;
      vidLength = Math.round(launchVideo.duration);
      videoStartUT = telemetryUT + vidAscentLength - vidLength;
      if (ascentDelta > 0 && ascentDelta < vidAscentLength) {
        launchVideo.currentTime = (telemetryUT - videoStartUT) + ascentDelta;
      } else if (videoStartUT - <%response.write dbUT%> < 0) {
        launchVideo.currentTime = Math.abs(videoStartUT - <%response.write dbUT%>);
      }
      currentTimeLoad = launchVideo.currentTime;
    }; 
  }
  
  // if we detect a fullscreen event, let user decide between video or data if they exit
  launchVideo.addEventListener('webkitbeginfullscreen', function() { 
    if (!bWentFullscreen) { alert("Captioning is available to see countdown status. We tried all means to get captions to show when video goes fullscreen. If anyone knows how to do this, please let us know in the post-launch survey!"); }
    bWentFullscreen = true; 
  }, false);
  launchVideo.addEventListener('webkitendfullscreen', function() { 
    if (!bPastUT && !launchVideo.ended && confirm("You can only watch this video in fullscreen mode\nClick OK to stay with video until " + formatTime(vidLength - (launchUT - videoStartUT), false) + " after launch or Cancel to stay with only data telemetry")) {
      launchVideo.play();
      minimizeChoice = "video";
    } else {
      minimizeChoice = "data";
      $("#mainwrapper").fadeIn();
      $("#videoStatus").fadeOut();
      $("#videoCameraName").fadeOut();
      $("#ascentStatus").fadeIn();
    }
  }, false);

  // if the video is over and went fullscreen we need to disable it so data telemetry can be seen
  launchVideo.onended = function() {
    if (bWentFullscreen) { 
      $("#video")[0].webkitExitFullScreen(); 
      $("#mainwrapper").fadeIn();
      $("#videoStatus").fadeOut();
      $("#videoCameraName").fadeOut();
      $("#ascentStatus").fadeIn();
    }
  };
  
  // update the load status tooltip based on whether this is a past or live launch
  if (!bPastUT) {
    $("#videoTip").append("<br>If you are late to the launch, video may not load in time for live feed");
  } else {
    $("#videoTip").append("<br>If video fails to finish loading, refresh page");
  }

  // funny loading text
  var loadText = [  {percent: 3, text: "Initializing KSC link..."},
                    {percent: 7, text: "Generating spooky action..."},
                    {percent: 15, text: "Collapsing quantum wave..."},
                    {percent: 20, text: "Handshaking with KSC..."},
                    {percent: 25, text: "Receiving video data (10%)..."},
                    {percent: 35, text: "Receiving video data (25%)..."},
                    {percent: 50, text: "Receiving video data (40%)..."},
                    {percent: 60, text: "Receiving video data (70%)..."},
                    {percent: 70, text: "Receiving video data (85%)..."},
                    {percent: 80, text: "Receiving video data (95%)..."},
                    {percent: 90, text: "Stabilizing entanglement..."},
                    {percent: 95, text: "Finalizing video feed..."}];

  // Initial load state
  // video will not auto-load on mobile devices and most tablets
  if (is_touch_device()) {
    $("#videoStatus").html("<span id='loadText' style='cursor: help; border-bottom: 1px dotted white;'>Tap here to load video</span>");
  } else {
    $("#loadText").html("Spinning up hamster wheels...");

    // Spin.js for loading spinner
    // http://fgnass.github.io/spin.js/
    spinner = new Spinner({lines:9, length:9, width:8, radius:12, scale:0.25, corners:1, color:'#FFFFFF', opacity:0.25, rotate:0, direction: 1, speed: 1, trail: 60, fps: 20, zIndex: 2e9, className: 'spinner', top: '50%', left: '50%', shadow: false, hwaccel: false, position: 'absolute'}).spin(document.getElementById('spinner'));
  }
  
  // notify tick function to monitor video loading
  bVideoLoading = true;
}
</script>

<!-- area for displaying text with JQuery for debugging purposes -->
<div id="debug" style="position: absolute; top: 38px; left: 0px;"></div>

<!-- used to inform user of launch ascent status -->
<div id='ascentStatus' style='background-color:black; z-index: 10; font-family: sans-serif; text-align: center; color: white; position: absolute; width: 525px; top: 414px; left: 10px; '></div>

<!-- used to inform user of launch telemetry status -->
<div id="linkdown" style="visibility: hidden; font-family: sans-serif; z-index: 105; color: red; position: absolute; top: 573px; left: 300px;"><center><h1>Telemetry Link Lost</h1><h2>Stand by...</h2></center></div>

<!-- used to inform user of upcoming launch -->
<div id='msgLaunch' style='cursor: pointer; font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 133px; width: 315px; padding: 0; margin: 0; position: absolute; top: 561px; left: 260px; display: none; background-color: gray;'><center><b>NOTICE</b><p>A launch is happening in &lt;2 minutes! Use the event timer on the right to head to the craft page to watch live launch telemetry!</p><p>Click to dismiss</p></center></div>

<!-- used to let user see progress of orbital data calculations -->
<div id='orbDataMsg' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 40px; width: 365px; padding: 0; margin: 0; position: absolute; top: 619px; left: 233px; display: none; background-color: gray;'><img id="progress" src="http://i.imgur.com/HszGFDA.png" width="0" height="40" style="position: absolute; z-index: 110;"><span style="font-size: 30px; position: absolute; z-index: 115; margin-left: 12px;">Calculating Orbital Data...</span></div>

<!-- used to inform user not all orbits were rendered to save time, gives option for full rendering -->
<div id='msgObtPd' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 133px; width: 415px; padding: 0; margin: 0; position: absolute; top: 561px; left: 210px; display: none; background-color: gray;'><center><b>NOTICE</b><p>This craft's orbital period is very long. For performance reasons, its full orbit was not rendered. Ap/Pe markings may be missing as a result.</p><p><span id="msgObtPdDismiss" style="cursor: pointer;" <% if not bMobileBrowser then response.write("class='tip' title='Close this message'") %>><b>Dismiss</b></span> | <span id="msgObtPdRender" style="cursor: pointer;" <% if not bMobileBrowser then response.write("class='tip' title='Show three full orbits'") %>><b>Render</b></span></p></center></div>

<!-- used to inform user of post-launch exit survey -->
<div id='msgPostLaunch' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 120px; width: 375px; padding: 0; margin: 0; position: absolute; top: 175px; left: 85px; display: none; background-color: gray;'><center><b>Thanks for watching!</b><br><br>You may open a brief survey with some auto-filled debug information to help us improve this feature<p><span id="msgPostLaunchDismiss" style="cursor: pointer;"><b>Dismiss</b></span> | <span id="msgPostLaunchSurvey" style="cursor: pointer;"><b>Survey</b></span></p></center></div>

<!-- used to inform user of upcoming node not yet being able to be shown -->
<div id='msgNode' style='cursor: pointer; font-family: z-index: 115; sans-serif; border-style: solid; border-width: 2px; height: 113px; width: 250px; padding: 0; margin: 0; position: absolute; top: 571px; left: 292px; display: none; background-color: gray;'><center><b>NOTICE</b><p>Future maneuver node is not yet visible along this orbital plot.</p><p>Click to dismiss</p></center></div>

<!-- create the page section for craft information -->
<div style="width: 840px; float: left;">

<!-- header for craft information section-->
<center>
<h3><%response.write rsCraft.fields.item("CraftName")%></h3>
<script>document.title = document.title + " - <%response.write rsCraft.fields.item("CraftName")%> (<%response.write rsCraft.fields.item("CraftDescTitle")%>)";</script>

<!-- main table for craft image, data fields and data display -->
<table style="width:100%">
<tr>
  <td>
  <table style="width:100%">
    <tr>

      <!-- 
      CRAFT DATA FIELDS
      =================

      ID - the time in seconds from 0 epoch at which this update occurs (UT)
      [RefreshRate] - Deprecated, js refresh-detection now used instead
      LaunchDateTerm - The text that will appear before the launch date UTC time (too many characters will cause text wrap)
      [launchDate] - the date/time of the launch in VBScript date expression format: dd-mmm-yyyy hh:mm:ss (local time)
      Scrub - whether this date will be invalidated by a scrubbed launch (True) or not (False). Consecutive scrubs okay
      [EndTime] - time in UT the mission ends (if included, must be included in every record)
      [EndDate] - time in VBScript date expression the mission ends (if included, must be included in every record)
      [EndMsg] - message to display in pop-up text over launch time to explain mission ending (if included, must be included in every record)
      CraftName - name of the craft to display at the top of the page
      CraftImg - URL that points to the 525x380 image of the craft showing its current state (configuration, SOI)
      CraftDescTitle - a short event description that will appear at the bottom of the craft image, at the top of the rollup text
      CraftDescContent - HTML code to fill in the rollup text box that appears when user hovers over the craft image
      LaunchDateUTC - the text that will appear for craft launch time, given in UTC with format mm/dd/yy @ hh:mm:ss
      LastUpdate - the text that will appear for most recent update, given in UTC with format mm/dd/yy @ hh:mm:ss
      [MissionReport] - URL link to the mission report (if included, must be included in every record)
      [MissionReportTitle] - text describing mission that appears in pop-up when hovered over link (if included, must be included in every record)
      [NextEventTitle] - text that appears with the Scheduled Event list option if a future event is scheduled
      [ImgDataCode] - HTML that shows an image infographic below the craft information in an area of 760x380. Special formatting is also recognized
      [DistanceTraveled] - the total (not change in) distance (in km) the spacecraft has traveled since launch
      [NodeLink] - the UT of a future maneuver node (in Flightplan recordset!) that this description talks about, so the user can find it easier on the map if it is visible
      [3DView] - whether or not this craft at this state has a 3D sketchfab model that can be displayed. Holds the model URL embed reference number
      -->
      
      <!-- CSS slide-up caption image box -->
      <td style="width:64%">
        <div id="mainwrapper">
          <%
          'do not show the info box during an ascent state, just the image
          if bAscentActive then
            response.write("<img id='image-1' src='" & rsCraft.fields.item("CraftImg") & "'/>")
          else
            response.write("<div id='box-1' class='box'>")
            response.write("<img id='image-1' src='" & rsCraft.fields.item("CraftImg") & "'/>")
            response.write("<span class='caption simple-caption'>")
            
            'added the ^^ to hopefully make it more obvious to people that more informtion is available
            response.write("<center><b>^^ Craft Information - <span id='event'>" & rsCraft.fields.item("CraftDescTitle") & "</span> ^^</b></center>")
            response.write rsCraft.fields.item("CraftDescContent")
            response.write("</span>")
            response.write("</div>")
          end if
          %>
        </div>
      </td>

      <!-- information box for orbital data, ascent data, resources, crew, etc -->
      <td style="width:36%"  valign="top">
        <table border="1" style="width:100%;">

          <!-- start time -->
          <%
          'only display this table row if there is not an active ascent in progress
          if not bAscentActive then 
            response.write("<tr>")
            response.write("<td>")
            response.write("<b>" & rsCraft.fields.item("LaunchDateTerm") & ":</b> ")
            
            'this tooltip can be dynamically updated
            response.write("<div id='met' style='display: none'>" & launchmsg & "</div>")
            
            response.write("<span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'met'"">")
            response.write("<u>" & rsCraft.fields.item("LaunchDateUTC") & " " & datestamp & "</u>")
            response.write("</span>")
            response.write("</td>")
            response.write("</tr>")
          end if
          %>
          
          <!-- 
          FLIGHT DATA FIELDS
          ==================
          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          [Avg Velocity] - the average velocity (calculated from Ap/Pe velocities) of the craft along *current trajectory* (i.e. hyperbolic)
          [VelocityPe] - the speed of the craft at lowest point along current trajectory
          [VelocityAp] - the speed of the craft at highest point along current trajectory
          [Periapsis] - the altitude, in km, of lowest point along current trajectory
          [Apoapsis] - the altitude, in km, of highest point along current trajectory
          [Eccentricity] - eccentricity value of the current trajectory
          [inclination] - inclination value of the current trajectory in degrees
          [Orbital Period] - number of seconds to complete one orbit
          [SMA] - semi-major axis of the current trajectory. Required only for real-time orbital display
          [RAAN] - right ascension of ascending node of the current trajectory. Required only for real-time orbital display
          [Arg] - argument of periapsis of the current trajectory. Required only for real-time orbital display
          [Mean] - mean anomaly of the current trajectory. Required only for real-time orbital display
          [Eph] - UT at which the previous Keplerian properties are valid. Not to be confused with the ID, which is the UT of the update. Required only for real-time orbital display
          
          NOTE: fields can be text, but there should be NO commas included in any of these values. Numbers will be formatted via ASP/JS
          -->
               
          <%
          'check if we have any orbital data to display
          response.write("<script>bOrbitalDataRefresh = false;</script>")
          if not rsOrbit.eof then
          
            'point to the relevant record for this UT
            rsOrbit.MoveLast
            do until rsOrbit.fields.item("id") <= dbUT
              rsOrbit.MovePrevious
              if rsOrbit.bof then exit do
            Loop
            
            'check if this is the last record, if not then we need to schedule an update
            rsOrbit.MoveNext
            if not rsOrbit.eof then
              response.write("<script>")
              response.write("bOrbitalDataRefresh = true;")
              response.write("orbitalDataRefreshUT = " & rsOrbit.fields.item("id") & ";")
              response.write("</script>")
            end if
            rsOrbit.MovePrevious
            
            'only execute further if we found a record earlier than this UT
            'print out all fields, check for and handle any blank records
            if not rsOrbit.bof then
              response.write("<tr><td><b><span style='cursor:help' class='tip' title='Periapsis: ")
              if isnull(rsOrbit.fields.item("VelocityPe")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("VelocityPe")*1, 3)
                response.write("km/s")
              end if
              response.write("<br>Apoapsis: ")
              if isnull(rsOrbit.fields.item("VelocityAp")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("VelocityAp")*1, 3)
                response.write("km/s")
              end if
              
              'technically this could be calculated, but useful to have as a reference w/o needing to
              response.write("'><u>Avg Velocity</u><span>:</b> ")
              if isnull(rsOrbit.fields.item("Avg Velocity")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Avg Velocity")*1, 3)
                response.write("km/s")
              end if
              response.write("</td></tr><tr><td><b>Periapsis:</b> ")
              if isnull(rsOrbit.fields.item("Periapsis")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Periapsis")*1, 3)
                response.write("km")
              end if
              response.write("</td></tr><tr><td><b>Apoapsis:</b> ")
              if isnull(rsOrbit.fields.item("Apoapsis")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Apoapsis")*1, 3)
                response.write("km")
              end if
              response.write("</td></tr><tr><td><b>Eccentricity:</b> ")
              if isnull(rsOrbit.fields.item("Eccentricity")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Eccentricity")*1, 6)
              end if
              response.write("</td></tr><tr><td><b>Inclination:</b> ")
              if isnull(rsOrbit.fields.item("Inclination")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Inclination")*1, 3)
                response.write("&deg;")
              end if
              response.write("</td></tr><tr><td><b>Orbital Period:</b> ")
              if isnull(rsOrbit.fields.item("Orbital Period")) then
                response.write("<u><span style='cursor:help' class='tip' title='Lack of orbital period means craft is on a hyperbolic/SOI-crossing trajectory<br>Ap/Pe refer to the lowest and highest points of the current trajectory'>N/A</span></u>")
              else
              
                'convert from seconds to yy:ddd:hh:mm:ss
                years = 0
                days = 0
                hours = 0
                minutes = 0
                period = rsOrbit.fields.item("Orbital Period")
                ydhms = ""

                if period >= 86400 then
                  days = int(period / 86400)
                  period = period - (days * 86400)
                  ydhms = days & "d, "
                end if

                if days >= 365 then
                  years = int(days / 365)
                  days = days - (years * 365)
                  ydhms = years & "y " & days & "d, "
                end if

                if period >= 3600 then
                  hours = int(period / 3600)
                  period = period - (hours * 3600)
                  ydhms = ydhms & hours & "h "
                end if

                if period >= 60 then
                  minutes = int(period / 60)
                  period = period - (minutes * 60)
                  ydhms = ydhms & minutes & "m "
                end if

                if period > 0 then
                  seconds = period
                  ydhms = ydhms & round(seconds,2) & "s"
                end if
                response.write("<u><span style='cursor:help' class='tip' title='" & ydhms & "'>")
                response.write formatnumber(rsOrbit.fields.item("Orbital Period")*1, 2)
                response.write("s")
                response.write("</span></u>")
              end if
              response.write("</td></tr>")
            end if
          end if
          %>
          
          <!-- 
          ASCENT DATA FIELDS
          ==================

          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          Velocity - the current *orbital* velocity of the craft, in km/s
          TWR - the current acceleration of the craft, in Gs
          Altitude - the current altitude of the craft above sea level in km
          Apoapsis - the current apokee of the craft in km
          Inclination - the current inclination of the craft in degrees
          Mass - the current mass of the craft in tonnes
          [Q] - the current Q, or aerodynamic pressure, of the craft in pascals (using FAR). When omitted, such as out of the atmosphere, Periapsis is used instead
          [Periapsis] - current perikee of the craft in km. If omitted, Q field must be used
          SolidFuel - the % of solid fuel propellant remaining (total or per-stage is up to user) from 0-1
          LiquidFuel - the % of liquid fuel propellant remaining (and thus equal to remaining oxidizer) from 0-1
          DstDownrange - the distance the rocket has traveled over land from the launch point in km (using VOID)
          DstTraveled - the distance the rocket has traveled along its flight path from the launch point in km (using Persistent Trails)
          Lat - current latitude of the vessel, in degrees
          Lon - current longitude of the vessel, in degrees
          -->
          
          <%
          'check if we have any ascent data to display
          'this data is only displayed if the ascent table is included in the database
          'and also only for records that are prior to UT of the first orbital table record
          if bAscentData then
            if not rsAscent.eof then
            
              'point to the relevant record for this UT
              rsAscent.MoveLast
              do until rsAscent.fields.item("id") <= dbUT
                rsAscent.MovePrevious
                if rsAscent.bof then exit do
              Loop
          
              'only execute further if we found a record earlier than this UT
              'and only if this record is older than the orbital data
              'and only if we have data
              if not rsAscent.bof and rsOrbit.bof and not isnull(rsAscent.fields.item("Velocity")) then
                response.write("<tr><td><b>Velocity:</b> ")
                response.write rsAscent.fields.item("Velocity")
                response.write("km/s (")
                response.write rsAscent.fields.item("TWR")
                response.write(" TWR)")

                response.write("</td></tr><tr><td><b>Altitude:</b> ")
                response.write rsAscent.fields.item("Altitude")
                response.write("km")

                response.write("</td></tr><tr><td><b>Apoapsis:</b> ")
                response.write rsAscent.fields.item("Apoapsis")
                response.write("km")
                
                'when Q is omitted (due to lack of atmosphere), Periapsis is displayed instead
                if isnull(rsAscent.fields.item("Q")) then
                  response.write("</td></tr><tr><td><b>Periapsis:</b> ")
                  response.write rsAscent.fields.item("Periapsis")
                  response.write("km")
                else
                  response.write("</td></tr><tr><td><b>Atmo Press (Q):</b> ")
                  response.write rsAscent.fields.item("Q")
                  response.write("Pa")
                end if

                response.write("</td></tr><tr><td><b>Inclination:</b> ")
                response.write rsAscent.fields.item("Inclination")
                response.write("&deg;")

                response.write("</td></tr><tr><td><b>Total Mass:</b> ")
                response.write rsAscent.fields.item("Mass")
                response.write("t")

                'calculate the length of the status bars, which is created by combining two solid-color 16x16 images
                'the green image is stretched the percentage of the remaining fuel, red fills in the rest
                percent = rsAscent.fields.item("SolidFuel") * 1
                Gwidth = 162*percent
                Rwidth = 162-Gwidth
                response.write("</td></tr><tr><td><b>Solid Fuel: </b>")
                response.write("<img src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
                response.write("<img src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")
                percent = rsAscent.fields.item("LiquidFuel") * 1
                Gwidth = 155*percent
                Rwidth = 155-Gwidth
                response.write("</td></tr><tr><td><b>Liquid Fuel:</b> ")
                response.write("<img src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
                response.write("<img src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")

                response.write("</td></tr><tr><td><b>Distance Downrange:</b> ")
                response.write rsAscent.fields.item("DstDownrange")
                response.write("km")

                response.write("</td></tr><tr><td><b>Distance Traveled:</b> ")
                response.write rsAscent.fields.item("DstTraveled")
                response.write("km")

                response.write("</td></tr>")
              end if
            end if
          end if
          %>
          
          <!-- 
          NEW ASCENT DATA FIELDS
          ======================
          
          First record should contain the launch UT and initial values for all fields.
          DO NOT VARY the interval between logged data records - except when using the CommLost field

          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          Heading - the current heading, in degrees
          Pitch - the current pitch, in degrees - also used to calculate TWR
          Roll - the current roll, in degrees
          DstTraveled - the distance the rocket has traveled along its flight path from the launch point, in m
          StageFuel - the amount of fuel remaining in the current stage, in fractional percent
          TotalFuel - the amount of fuel remaining in the entire vessel, in fractional percent
          Q - the current dynamic pressure of the craft in kilopascals. Used until its value reaches 0
          Mass - the mass of the entire vehicle, in tonnes
          AoA - the current angle if attack, in degrees
          Altitude - the current altitude of the craft above sea level, in m
          Lat - current latitude of the vessel, in degrees
          Lon - current longitude of the vessel, in degrees
          Apoapsis - the current apokee of the craft, in m
          Periapsis - current perikee of the craft in m. Not used until the Q value reaches 0
          Inclination - the current inclination of the craft, in degrees
          Velocity - the current *orbital* velocity of the craft, in m/s
          Thrust - the current thrust produced by all engines, in kN
          Gravity - the current level of gravity, used to calculate TWR
          DstDownrange - the distance the rocket has traveled over land from the launch point, in m
          Throttle - the current throttle setting of the craft, in whole percent
          [AoAWarn] - text:color combo for stalls, sideslips, etc. If omitted, a default "nominal:green" string is used
          Video - True if there is a video feed for this entry, false otherwise
          [Camera] - The name of the camera capturing the footage
          [CommLost]* - used to show a break in telemetry data
          Event - string describing the current status (meco, booster sep, etc). If omitted, no change to text
          Image - URL of img to depict current status. If omitted, no change to image
          [Tweet] - if present, this text will be tweeted during a *live* launch. Telemetry playbacks will not send tweets
          
          *currently not implemented
          -->
          
          <%

          'check if we have any ascent data to display
          if bAscentActive then
            
            'point to the relevant record for this UT so we can initialize table fields
            rsNewAscent.MoveLast
            do until rsNewAscent.fields.item("id") <= dbUT
              rsNewAscent.MovePrevious
              
              'we could be before the launch time, in which case just load up the initial values
              if rsNewAscent.bof then 
                rsNewAscent.MoveFirst
                exit do
              end if
            Loop
            
            'we might still be counting down from whenever, or we might be launched
            launchUT = datediff("s", "16-Feb-2014 00:00:00", rsCraft.fields.item("LaunchDate"))
            if dbUT - launchUT < 0 then
              response.write("<tr><td><b id='captionMET'>Launch in:</b> <span id='launchMET'>")
            else
              response.write("<tr><td><b id='captionMET'>MET:</b> <span id='launchMET'>")
            end if
            
            'convert from seconds to mm:ss
            minutes = 0
            ms = ""
            launchMET = abs(dbUT - launchUT)
            if launchMET >= 60 then
              minutes = int(launchMET / 60)
              launchMET = launchMET - (minutes * 60)
              ms = ms & minutes & "m "
            end if

            if launchMET >= 0 then
              seconds = launchMET
              if seconds < 10 then
                ms = ms & "0" & round(seconds) & "s"
              else
                ms = ms & round(seconds) & "s"
              end if
            end if
            response.write ms
            response.write ("</span></td></tr>")
            
            response.write("<tr><td><b>Velocity:</b> <span id='velocity'>")
            if rsNewAscent.fields.item("Velocity") > 1000 then
              response.write formatnumber(rsNewAscent.fields.item("Velocity") / 1000, 3)
              response.write("km/s</span> (Throttle @ <span id='throttle'>")
            else
              response.write formatnumber(rsNewAscent.fields.item("Velocity"), 3)
              response.write("m/s</span> (Throttle @ <span id='throttle'>")
            end if
            response.write formatnumber(rsNewAscent.fields.item("Throttle") * 100, 2)
            response.write("</span>%)</td></tr>")

            response.write("<tr><td><b>Total Thrust:</b> <span id='thrust'>")
            response.write formatnumber(rsNewAscent.fields.item("Thrust"), 3)
            response.write("</span>kN @ <span id='twr'>")
            
            'calculating TWR using gravity at the time
            'referenced from http://wiki.kerbalspaceprogram.com/wiki/Thrust-to-weight_ratio
            response.write formatnumber(rsNewAscent.fields.item("Thrust")/((rsNewAscent.fields.item("Mass") * 1000) * rsNewAscent.fields.item("Gravity")), 3)
            response.write("</span> TWR</td></tr>")
            
            response.write("<tr><td><b>Altitude:</b> <span id='altitude'>")
            if rsNewAscent.fields.item("Altitude") > 1000 then
              response.write formatnumber(rsNewAscent.fields.item("Altitude") / 1000, 3)
              response.write("km")
            else
              response.write formatnumber(rsNewAscent.fields.item("Altitude"), 3)
              response.write("m")
            end if
            response.write("</span></td></tr>")

            response.write("<tr><td><b>Apoapsis:</b> <span id='apoapsis'>")
            if rsNewAscent.fields.item("Apoapsis") > 1000 then
              response.write formatnumber(rsNewAscent.fields.item("Apoapsis") / 1000, 3)
              response.write("km")
            else
              response.write formatnumber(rsNewAscent.fields.item("Apoapsis"), 3)
              response.write("m")
            end if
            response.write("</span></td></tr>")
            
            'when Q is omitted (due to lack of atmosphere), Periapsis is displayed instead
            if rsNewAscent.fields.item("Q") <= 0 then
              response.write("<tr><td><b id='QPeCaption'>Periapsis:</b> <span id='QPe'>")
              if rsNewAscent.fields.item("Periapsis") > 1000 then
                response.write formatnumber(rsNewAscent.fields.item("Periapsis") / 1000, 3)
                response.write("km")
              else
                response.write formatnumber(rsNewAscent.fields.item("Periapsis"), 3)
                response.write("m")
              end if
            else
              response.write("<tr><td><b id='QPeCaption'>Dynamic Pressure (Q):</b> <span id='QPe'>")
              if rsNewAscent.fields.item("Q") >= 1 then
                response.write formatnumber(rsNewAscent.fields.item("Q"), 3)
                response.write("kPa")
              else
                response.write formatnumber(rsNewAscent.fields.item("Q")*1000, 3)
                response.write("Pa")
              end if
            end if
            response.write("</span></td></tr>")

            response.write("<tr><td><b>Inclination:</b> <span id='inclination'>")
            response.write formatnumber(rsNewAscent.fields.item("Inclination"), 3)
            response.write("&deg;")
            response.write("</span></td></tr>")

            response.write("<tr><td><b>Total Mass:</b> <span id='mass'>")
            response.write formatnumber(rsNewAscent.fields.item("Mass"), 3)
            response.write("</span>t</td></tr>")

            'calculate the length of the status bars, which is created by combining two solid-color 16x16 images
            'the green image is stretched the percentage of the remaining fuel, red fills in the rest
            percent = rsNewAscent.fields.item("StageFuel") * 1
            Gwidth = 206*percent
            Rwidth = 206-Gwidth
            response.write("<tr><td><b>Stage Fuel: </b>")
            response.write("<span id='stageFuel' style='position: absolute; z-index: 120; margin-left: 80px;'>" & formatNumber(percent * 100, 2) & "%</span>") 
            response.write("<img id='stageGreen' src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
            response.write("<img id='stageRed' src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")
            response.write("</td></tr>")
            percent = rsNewAscent.fields.item("TotalFuel") * 1
            Gwidth = 206*percent
            Rwidth = 206-Gwidth
            response.write("<tr><td><b>Total Fuel:</b>&nbsp;&nbsp;&nbsp;")
            response.write("<span id='totalFuel' style='position: absolute; z-index: 120; margin-left: 80px;'>" & formatNumber(percent * 100, 2) & "%</span>") 
            response.write("<img id='totalGreen' src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
            response.write("<img id='totalRed' src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")
            response.write("</td></tr>")

            response.write("<tr><td><b>Distance Downrange:</b> <span id='downrange'>")
            if rsNewAscent.fields.item("DstDownrange") > 1000 then
              response.write formatnumber(rsNewAscent.fields.item("DstDownrange") / 1000, 3)
              response.write("km")
            else
              response.write formatnumber(rsNewAscent.fields.item("DstDownrange"), 3)
              response.write("m")
            end if
            response.write("</span></td></tr>")

            response.write("<tr><td><b>Distance Traveled:</b> <span id='traveled'>")
            if rsNewAscent.fields.item("DstTraveled") > 1000 then
              response.write formatnumber(rsNewAscent.fields.item("DstTraveled") / 1000, 3)
              response.write("km")
            else
              response.write formatnumber(rsNewAscent.fields.item("DstTraveled"), 3)
              response.write("m")
            end if
            response.write("</span></td></tr>")

            response.write("<tr><td><b>Angle of Attack:</b> <span id='aoa'>")
            response.write formatnumber(rsNewAscent.fields.item("AoA"), 2)
            response.write("</span>&deg; [")
            if isnull(rsNewAscent.fields.item("AoAWarn")) then
              response.write("<span id='aoawarn' style='color: green'>Nominal</span>")
            else
              response.write rsNewAscent.fields.item("AoAWarn")
              strText = mid(rsNewAscent.fields.item("AoAWarn"), 1, instr(rsNewAscent.fields.item("AoAWarn"), ":")-1)
              strColor = mid(rsNewAscent.fields.item("AoAWarn"), instr(rsNewAscent.fields.item("AoAWarn"), ":")+1)
              response.write("<span id='aoawarn' style='color: ")
              response.write strColor
              response.write("'>")
              response.write strText
              response.write("</span>")
            end if
            response.write("]</td></tr>")

            response.write("<tr><td><b>Pitch:</b> <span id='pitch'>")
            response.write formatnumber(rsNewAscent.fields.item("Pitch"), 2)
            response.write("</span>&deg; | <b>Roll:</b> <span id='roll'>")
            response.write formatnumber(rsNewAscent.fields.item("Roll"), 2)
            response.write("</span>&deg; | <b>Heading:</b> <span id='heading'>")
            response.write formatnumber(rsNewAscent.fields.item("Heading"), 2)
            response.write("</span>&deg;")
            response.write("</td></tr>")
  
            'add a status text area for telemetry feed signal
            'was originally just something to keep map from popping up when craft image hides and no longer takes up space
            'then realized it could be used to show time dilation
            if not bPastUT then
              response.write("<div id='timeDilationTip' style='display: none'>Data feed is nominal @ " & ascentFPS & "fps</div>")
              response.write("<tr><td><center>Telemetry Data Status: <b><u><span id='telemData' class='tip-update' data-tipped-options=""position: 'bottom', inline: 'timeDilationTip'"" style='color: green; cursor: help;'>Connected</span></u></b></center>")
              response.write("</td></tr>")
            end if
            
            'sets video captions if we have any
            'so thankful JQuery requests to non-existent controls fails gracefully
            response.write("<script>")
            response.write("$('#ascentStatus').html('Current Status: " & rsNewAscent.fields.item("Event") & "');")
            response.write("$('#videoCameraName').html('" & rsNewAscent.fields.item("Camera") & "');")
            response.write("</script>")
          end if
          %>
          
          <!-- 
          CREW MANIFEST FIELDS
          ====================

          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          Hide - should be used to remove this data from display to allow room for ascent data
          CrewName# - the name of the crew member to appear in pop-up text for crew icon
          CrewRoster# - the URL of the crew member's roster page

          Adding additional CN#/CR# field pairs will create additional crew members listed for the vessel

          CN/CR fields can be extended as much as needed, maintaining the paired values. They do not need to be named CN2/CR2, CN3/CR3 etc. 
          They do not need to contain a value, so long as any empty fields are at the end of a continuous run of field pairs
          -->
          
          <%
          'check if we have crew data to display
          if not rsCrew.eof then
          
            'point to the relevant record for this ut
            rsCrew.movelast
            do until rsCrew.fields.item("id") <= dbUT
              rsCrew.MovePrevious
              if rsCrew.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and only if it is not hidden (when showing ascent data, to save space)
            bShow = false
            if not rsCrew.bof then 
              bShow = true
              if bAscentData or bNewAscentData then
                if rsCrew.fields.item("Hide") then bShow = false
              end if
            end if
            
            if bShow then
              response.write("<tr><td><b>Crew:</b> ")

              'if we have an ascent table, adjust column start position
              'because older databases will not have the "Hide" field
              col = 1
              if bAscentData or bNewAscentData then col = 2
              
              'iterate through crew data, two fields for each crew member, until we hit an empty field
              'if that empty field is right at the start, no crew are aboard
              for x = col to rsCrew.fields.count - 1 step 2
                if isnull(rsCrew.fields.item(x)) then 
                  if x = col then response.write("None")
                  exit for
                end if
                
                'if needed, when clicking over to a crew roster close out the pop-up window so it is not left open and forgotten
                if request.querystring("popout") then
                  closemsg = "onclick='window.close()'"
                else 
                  closemsg = ""
                end if
                
                response.write("<span class='tip' title='")
                response.write rsCrew.fields.item(x)
                response.write("'><a " & closemsg & " target='_blank' href='")
                response.write rsCrew.fields.item(x+1)
                response.write("'><img src='http://www.kerbalspace.agency/Flights/favicon.ico'></a></span> ")
              next
              response.write("</td></tr>")
            else
            
              'handles a special case scenario... I do not recall exactly what
              if bShow then response.write("<tr><td><b>Crew:</b> None</td></tr>")
            end if
          end if
          %>
          
          <!-- 
          CRAFT RESOURCES FIELDS
          ======================

          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          Hide - should be used to remove this data from display to allow room for ascent data
          DeltaV - the total amount of delta-v remaining for the craft, in km/s
          TotalMass - the mass of the entire craft, including resources, in tonnes
          ResourceMass - the mass of all resources aboard the ship that have it, in tonnes
          ResourceName# - the name of a resource that corresponds to a PNG image file on the server
          ResourceTitle# - the text that will appear when the resource image is hovered over

          Adding additional RN#/RT# field pairs will create additional resources listed for the vessel

          RN/RT fields can be extended as much as needed, maintaining the paired values. They do not need to be named RN2/RT2, RN3/RT3 etc. 
          They do not need to contain a value, so long as any empty fields are at the end of a continuous run of field pairs               
          -->
          
          <%
          'check if we have resource data to display
          if not rsResources.eof then
          
            'point to the relevant record for this ut
            rsResources.movelast
            do until rsResources.fields.item("id") <= dbUT
              rsResources.MovePrevious
              if rsResources.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and only if it is not hidden (when showing ascent data, to save space)
            bShow = false
            if not rsResources.bof then 
              bShow = true
              if bAscentData or bNewAscentData then
                if rsResources.fields.item("Hide") then bShow = false
              end if
            end if
            
            if bShow then
              response.write("<tr><td><b><span style='cursor:help' class='tip' title='Total &Delta;v: ")
              if isnull(rsResources.fields.item("DeltaV")) then 
                response.write "0"
              else
                response.write rsResources.fields.item("DeltaV")
              end if
              response.write("km/s<br>Total mass: ")
              response.write rsResources.fields.item("TotalMass")
              response.write("t<br>Resource mass: ")
              if isnull(rsResources.fields.item("ResourceMass")) then 
                response.write "0"
              else
                response.write formatnumber(rsResources.fields.item("ResourceMass"), 3)
              end if
              response.write("t'><u>Resources</u><span>:</b> ")
              
              'if we have an ascent table, adjust column start position
              'because older databases will not have the "Hide" field
              col = 4
              if bAscentData or bNewAscentData then col = 5

              'iterate through resource data, two fields for each resource, until we hit an empty field
              'if that empty field is right at the start, no resources are aboard
              for x = col to rsResources.fields.count - 1 step 2
                if isnull(rsResources.fields.item(x)) then 
                  if x = col then response.write "None"
                  exit for
                end if
                response.write("<span style='cursor:help' class='tip' title='")
                
                'prior to using Tipped.js for tooltips a newline character was used for line breaks. This needs to be replaced
                str = replace(rsResources.fields.item(x+1), "&#013;", "<br>")
                response.write str
                response.write("'><img src='http://www.kerbalspace.agency/Flights/")
                response.write rsResources.fields.item(x)
                response.write(".png'></span> ")
              next
              response.write("</td></tr>")
            end if
          end if
          %>
          
          <!-- 
          CRAFT COMMS FIELDS
          ==================

          ID - the time in seconds from 0 epoch at which this change occurs (UT)
          Hide - should be used to remove this data from display to allow room for ascent data
          [SignalDelay] - if using RemoteTech, max possible signal delay for this time is reported in seconds
          CommType# - the name of a comm unit that corresponds to a PNG image file on the server
          CommDesc# - the text that will appear when the comm image is hovered over

          Adding additional CT#/CD# field pairs will create additional comm units listed for the vessel

          CT/CD fields can be extended as much as needed, maintaining the paired values. They do not need to be named CT2/CD2, CT3/CD3 etc. 
          They do not need to contain a value, so long as any empty fields are at the end of a continuous run of field pairs               
          -->
          
          <%
          'check if we have comms data to display
          if not rsComms.eof then
          
            'point to the relevant record for this ut
            rsComms.movelast
            do until rsComms.fields.item("id") <= dbUT
              rsComms.MovePrevious
              if rsComms.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and only if it is not hidden (when showing ascent data, to save space)
            bShow = false
            if not rsComms.bof then 
              bShow = true
              if bAscentData or bNewAscentData then
                if rsComms.fields.item("Hide") then bShow = false
              end if
            end if

            if bShow then
              response.write("<tr><td><b><span style='cursor:help' class='tip' title='Signal delay (max): ")
              
              'can leave signal delay field empty if RT not installed
              'or when connected direct to mission control prior to launch or when no connection is present
              if isnull(rsComms.fields.item("SignalDelay")) then
                response.write "N/A"
              else
              
                 'convert from seconds to yy:ddd:hh:mm:ss
                years = 0
                days = 0
                hours = 0
                minutes = 0
                period = rsComms.fields.item("SignalDelay")
                ydhms = ""

                if period >= 86400 then
                  days = int(period / 86400)
                  period = period - (days * 86400)
                  ydhms = days & "d, "
                end if

                if days >= 365 then
                  years = int(days / 365)
                  days = days - (years * 365)
                  ydhms = years & "y " & days & "d, "
                end if

                if period >= 3600 then
                  hours = int(period / 3600)
                  period = period - (hours * 3600)
                  ydhms = ydhms & hours & "h "
                end if

                if period >= 60 then
                  minutes = int(period / 60)
                  period = period - (minutes * 60)
                  ydhms = ydhms & minutes & "m "
                end if

                if period > 0 then
                  seconds = period
                  ydhms = ydhms & seconds & "s"
                end if
                response.write ydhms
              end if
              response.write("'><u>Comms</u><span>:</b> ")

              'if we have an ascent table, adjust column start position
              'because older databases will not have the "Hide" field
              col = 2
              if bAscentData or bNewAscentData then col = 3
              
              'iterate through comms data, two fields for each comm unit, until we hit an empty field
              'if that empty field is right at the start, no comms are aboard
              for x = col to rsComms.fields.count - 1 step 2
                if isnull(rsComms.fields.item(x)) then 
                  if x = col then response.write "None"
                  exit for
                end if 
                response.write("<span style='cursor:help' class='tip' title='")
                
                'prior to using Tipped.js for tooltips a newline character was used for line breaks. This needs to be replaced
                str = replace(rsComms.fields.item(x+1), "&#013;", "<br>")
                response.write str
                response.write("'><img src='http://www.kerbalspace.agency/Flights/")
                response.write rsComms.fields.item(x)
                response.write(".png'></span> ")
              next
              response.write("</td></tr>")
            end if
          end if
          %>
          
          <!-- Last Update data -->

          <%
          'look for the proper record again
          rsCraft.MoveLast
          do until rsCraft.fields.item("id") <= dbUT
            rsCraft.MovePrevious
          Loop
          
          'we need dummy values to assign to js later regardless of whether they are needed or not
          dstTraveled = 0
          bEstDst = false

          'not able to create this table row if an active ascent is underway
          if not bAscentActive then 
            response.write("<tr><td><b>Last Update:</b> ")
            
           if bDstTraveled then
           
              'field can be left empty, such as prior to or during launch
              if not isnull(rsCraft.fields.item("DistanceTraveled")) then
                strAccDst = "Total Distance Traveled as of Last Update: " & formatnumber(rsCraft.fields.item("DistanceTraveled")*1, 0) & "km"

                'only estimate distance if we are the last record or the current record for the current time
                'rover check is for until I decide how to handle updating rover travel distances
                rsCrafts.find("db='" & request.querystring("db") & "'")
                if isnull(rsCraft.fields.item("EndMsg")) then
                  rsCraft.movenext
                  if rsCrafts.fields.item("Type") <> "rover" then
                    if rsCraft.eof then
                      bEstDst = true
                    else
                      if rsCraft.fields.item("id") > UT then
                        bEstDst = true
                      end if
                    end if
                  end if
                  rsCraft.moveprevious
                end if

                'string starts empty. If we have nothing more to add, nothing more will show in tooltip
                strEstDst = ""
                if bEstDst then
                  if not isnull(rsOrbit.fields.item("Avg Velocity")) then
                    strEstDst = "<br>Estimated Current Total Distance Traveled: "
                    prevUT = rsCraft.fields.item("id")
                    
                    'distance is estimated based on the average speed
                    dstTraveled = round((rsCraft.fields.item("DistanceTraveled")*1) + (rsOrbit.fields.item("Avg Velocity") * (UT - prevUT)))
                    strEstDst = strEstDst & FormatNumber(dstTraveled, 0) & "km"
                  end if
                end if
                rsCrafts.movefirst

                response.write("<div id='distance' style='display: none'>" & strAccDst & strEstDst & "</div>")
                response.write("<span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'distance'""><u>")
                response.write(rsCraft.fields.item("LastUpdate") & " UTC")
                response.write("</u></span>")
              else
                response.write(rsCraft.fields.item("LastUpdate") & " UTC")
              end if
            else
              response.write(rsCraft.fields.item("LastUpdate") & " UTC")
            end if
            response.write("</td></tr>")
          end if
          %>
          
          <!-- Mission Event/Telemetry playback controls -->

          <%
          
          'look for the proper record again
          rsCraft.MoveLast
          do until rsCraft.fields.item("id") <= dbUT
            rsCraft.MovePrevious
          Loop
          
          'only show if this is a past event or not an active ascent
          response.write("<script>var bNextEventRefresh = false;</script>")
          if not bAscentActive or len(request.querystring("ut")) then
            response.write("<tr><td><center>")
            
            url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
            
            'there a previous event?
            response.write("<select id='prevEvent' style='width: 53px'>")
            response.write("<option value='' selected='selected'>Prev Event(s)</option>")
            
            'fill out the list with descriptions of all previous events
            bkmark = 1
            rsCraft.moveprevious
            do until rsCraft.bof
              bkmark = bkmark + 1
              response.write("<option value='" & url & "&ut=" & rsCraft.fields.item("id") & "'>" & rsCraft.fields.item("CraftDescTitle") & "</option>")
              rsCraft.moveprevious
            loop
            
            'return the pointer to original record
            rsCraft.move bkmark
            
            'if we did not go back any, then we have nothing to go back to
            if bkmark = 1 then
              response.write("<script>$('#prevEvent').attr('disabled', 'disabled');</script>")
            end if
            response.write("</select>&nbsp;")

            'what we show between the event lists depends on whether an ascent is underway or not
            if not bAscentActive then
            
              'whether we need to close the window when going to an external link
              close = " "
              if request.querystring("popout") then close = " onclick='window.close()' "
              
              'what is the current status of the mission?
              if not isnull(rsCraft.fields.item("MissionReport")) then
                response.write("<span class='tip' title='")
                response.write rsCraft.fields.item("MissionReportTitle")
                response.write("'><b><a" & close & "target='_blank' href='")
                response.write rsCraft.fields.item("MissionReport")
                response.write("'>Mission Report</a></b></span> ")
              elseif UT >= rsCraft.fields.item("EndTime") then
                response.write("<b><span class='tip' title='Mission report coming soon<br>Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Concluded</a></span></b> ")
              else
                response.write("<b><span class='tip' title='Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Ongoing</a></span></b> ")
              end if
            else
            
              'this will only happen when a page loads so the telemetry stream will always be paused
              'buffer the controls with whitespace to make it less clumsy to use touchscreens
              response.write("&nbsp;&nbsp;<img id='seekBack' src='seekBack.png' style='cursor:pointer' class='tip' title='Back " & seekTime & "s'>&nbsp;&nbsp;&nbsp;")
              response.write("<div id='timeDilationTip' style='display: none'>Click to begin playback</div>")
              response.write("<u><b><span id='telemData' style='cursor:pointer' class='tip-update' data-tipped-options=""position: 'bottom', inline: 'timeDilationTip'"">Play Telemetry</span></b></u>")
              response.write("&nbsp;&nbsp;&nbsp;<img id='seekForward' src='seekForward.png' style='cursor:pointer' class='tip' title='Forward " & seekTime & "s'>&nbsp;&nbsp;&nbsp;")
            end if
            
            'is there a future event we can click to?
            response.write("<select id='nextEvent' style='width: 53px'>")
            response.write("<option value='' selected='selected'>Next Event(s)</option>")
            
            'fill out the list with descriptions of all future events - unless we hit one that takes place ahead of our current time
            bkmark = -1
            rsCraft.movenext
            do until rsCraft.eof
              if UT > rsCraft.fields.item("id") then
                bkmark = bkmark - 1
                response.write("<option value='" & url & "&ut=" & rsCraft.fields.item("id") & "'>" & rsCraft.fields.item("CraftDescTitle") & "</option>")
                rsCraft.movenext
              else
                exit do
              end if
            loop
            
            'if we did not go foward any, then we have nothing to go forward to - unless it is an event later than our current time
            if bkmark = -1 then

              'if we have more records, that means a future event is coming. Save to js so page will auto-update when next event arrives
              'this means page auto-updates will only occur when looking at the last available event
              if not rsCraft.eof then
                response.write("<script>")
                response.write("var bNextEventRefresh = true;")
                response.write("var nextEventUT = " & rsCraft.fields.item("id") & ";")
                response.write("</script>")
              end if
              rsCraft.moveprevious
              bkmark = 0
              
              'if there is a scheduled event show it, but only if we are looking at the event before it, not further in the past
              if not isNull(rsCraft.fields.item("NextEventTitle")) then 
              
                'create a dynamic tooltip that can be updated if it turns out there is a maneuver node that goes with this description
                response.write("<option value='node' class='tip-update' data-tipped-options=""inline: 'nextNode', position: 'left'"" title = '"& rsCraft.fields.item("CraftDescTitle") & "'>Scheduled Event</option>")
                response.write("</select>&nbsp;")
                response.write("<div id='nextNode' style='display: none'>" & rsCraft.fields.item("NextEventTitle") & "</div>")
                response.write("<script>$('#nextEvent').prop('disabled', false);</script>")
              else
                response.write("</select>&nbsp;")
                response.write("<script>$('#nextEvent').prop('disabled', true);</script>")
              end if
            end if
            
            'return the pointer to original record
            rsCraft.move bkmark
            response.write("</center></td></tr>")
          
          'for an active ascent, which does not show the prev/next dropdowns, we still need to get the next event
          elseif bAscentActive then
            rsCraft.movenext
            response.write("<script>")
            response.write("var bNextEventRefresh = true;")
            response.write("var nextEventUT = " & rsCraft.fields.item("id") & ";")
            response.write("</script>")
            rsCraft.moveprevious
          end if
          %>
          
        </table>
      </td>
    </tr>
  </table>
  </td>
  
<!-- visualization field for orbits, locations, paths, etc -->
</tr>
  <%
  str = rsCraft.fields.item("ImgDataCode")

  'if there is a ~ symbol then this is an new ascent state, if there is nothing it is an older ascent version, but both need a dynamic map area
  if left(str,1) = "~" or isnull(rsCraft.fields.item("ImgDataCode")) then
    MapState = "ascent"
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px;'></div> </td> </tr>")
    bMapOrbit = false
    
    'extract the sizes of the various ascent videos if they exist
    if len(str) then
      response.write("<script>")
      response.write("var mp4Size = " & mid(str, 2, instr(str, "|")-2) & ";")
      response.write("var webmSize = " & mid(str, instr(str, "|")+1, len(str)-(instrrev(str, "|")-1)) & ";")
      response.write("var oggSize = '" & right(str, len(str)-instrrev(str, "|")) & "';")
      response.write("</script>")
    end if

  'if there is a @ symbol this is a pre-launch state
  elseif left(str,1) = "@" then
    MapState = "prelaunch"
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px;'></div> </td> </tr>")
    
    'extract the launch location and name and save for js use later
    response.write("<script>")
    response.write("var launchLat = " & mid(str, 2, instr(str, ":")-2) & ";")
    response.write("var launchLon = " & mid(str, instr(str, ":")+1, instr(str, "|")-(instr(str, ":")+1)) & ";")
    response.write("var launchsite = '" & mid(str, instr(str, "|")+1, len(str)) & "';")
    response.write("</script>")
    
  'if there is a ! symbol this is an orbital state
  elseif left(str,1) = "!" then
    MapState = "orbit"
    
    'do not create the real-time map unless orbital data is up to date
    'this means we are either at the last record or the next record has a UT greater than the present
    bMapOrbit = false
    rsOrbit.movenext
    if rsOrbit.eof then
      bMapOrbit = true
    else
      if rsOrbit.fields.item("id") > UT then 
        bMapOrbit = true
      end if
    end if
    rsOrbit.moveprevious
    
    'we assume no dynamic map and adjust message as required
    mapMsg = "<br>Dynamic view not available - old orbital data loaded"
    if bMapOrbit then
      mapMsg = "<br>Click for dynamic view"
      
      'create the dynamic map area
      response.write("<div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px; position: absolute; top: 451px; left: 0px; visibility: hidden;'></div>")
      
      'special notice box to be used when directing anyone here who possibly is unfamiliar with the concept of @KSA_MissionCtrl
      if request.querystring("intro") = "y" then
        response.write("<div id='intro' style='font-family: sans-serif; border-style: solid; border-width: 2px; height: 727px; width: 670px; padding: 0; position: absolute; z-index: 101; margin: 0; top: 50px; left: 100px; visibility: visible; background-color: gray;'><b>The Significance of the Orbital Plotting Feature</b><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>The main concept of the Kerbal Space Agency is that the game time is locked to real time (in this case Eastern Time US). The game was begun on Feb 16th, 2014 - which meant that on Year 1, Day 1 @ 13:45:00 it was 1:45pm EST on 2/16/14. Tweets that appear on @KSA_MissionCtrl reflect this, showing up when events actually happen at certain times in the game. So the ability for people to come here and see a spacecraft's orbital trajectory and current position isn't just some fancy gimmick for show. The events transpiring via @KSA_MissionCtrl are now more immersive than ever. If a launch is scheduled to occur beneath the orbit of a satellite, anyone looking at the track of that satellite at launch time would see its #1 orbit over KSC. In the future, maneuver nodes will be shown on the map as well, for starters.</p><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>To better see the link between game and Flight Tracker, here's an image with the relevant bits correlated by color. Again, the game began on 2/16/14, so a game time of Year 2, Day 99 corresponds to 5/25/15. Likewise, the game time of 20:37:04 corresponds to a real-world time of 8:37:04pm EST. You can see that the flight tracker and game data match within a reasonable error of margin.</p><a target='_blank' href='http://i.imgur.com/fTgODPx.png'><img src='http://i.imgur.com/fTgODPxl.png'></a><p><span id='close' style='cursor: pointer;'>Thanks for reading! Click here to close this box</span><br><a target='_blank' href='https://github.com/Gaiiden/FlightTracker'>Source on Github</a></p></div>")
      end if
    end if
    
    'check to see if this has coordinates for a static dynamic display for bodies that have no map data
    if instr(str, "[") then
      if mapMsg = "<br>Click for dynamic view" then mapMsg = ""
      response.write("<tr> <td> <center> <span id='img' style='cursor:help'><img src='" & mid(str, 2, instr(str, "|")) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Ecliptic View" & mapMsg & "'>&nbsp;<img src='" & mid(str, instr(str, "|")+1, 30) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Polar View" & mapMsg & "'></span> </center> </td> </tr>")
      
      if bMapOrbit then
        response.write("<div id='orbData' style='display: none; text-align: left; padding: 2px; font-family: sans-serif; font-size: 14px; border: 2px solid gray;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: " & mid(str, instr(str, "[")+1, instr(str, ",") - instr(str, "[") -1) & "px; left: " & mid(str, instr(str, ",")+1, len(str) - instr(str, ",") -1) & "px;'></div>")
      end if
    else
    
      'this is one of 3 specific formats that the static orbital display will use
      'the other two static display types are for hyperbolic orbits, which are not yet supported so they fall under the "old data" category
      response.write("<tr> <td> <center> <span id='img' style='cursor:help'><img src='" & mid(str, 2, instr(str, "|")) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Ecliptic View" & mapMsg & "'>&nbsp;<img src='" & mid(str, instr(str, "|")+1) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Polar View" & mapMsg & "'></span> </center> </td> </tr>")
    end if
    
  'old data, just spit it out
  'but make any titles compatible with new Tipped tooltips
  else
    MapState = "none"
    response.write replace(replace(rsCraft.fields.item("ImgDataCode"), "title", "class='tip' data-tipped-options=""target: 'mouse'"" title"), "&#013;", "<br>")
  end if
  %>
</table>

<!-- footer links for craft information section-->
<span style="font-family:arial;color:black;font-size:12px;">
<%
'build the basic URL then add any included server variables that should be saved across pages
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")
vars = "?db=" & request.querystring("db")
if request.querystring("ut") then vars = vars & "&ut=" & request.querystring("ut")
if request.querystring("pass") then vars = vars & "&pass=" & request.querystring("pass")
if len(request.querystring("filter")) then vars = vars & "&filter=" & request.querystring("filter")

closemsg = ""
if request.querystring("popout") then	closemsg = "onclick='window.close()'"
response.write("<a " & closemsg & " target='_blank' href='http://bit.ly/KSAHomePage'>KSA Historical Archives</a>")
response.write(" | <a " & closemsg & " target='_blank' href='http://bit.ly/-FltTrk'>Flight Tracker Source on Github</a>")

'creates a pop-out window the user can move around
if not request.querystring("popout") then
  url = "http://www.kerbalspace.agency/Flights/redirect.asp"
  vars = vars & "&popout=true"
  response.write(" | ")
  response.write("<a target='_blank' href='" & url & vars & "'>Open in Popout Window</a>")
end if
%>
</span>
</center>
</div>

<!-- craft menu section -->
<div style="margin-left: 845px; font: 12pt normal Arial, sans-serif;"> 

<!-- craft menu header -->
<%
if request.querystring("filter") = "inactive" then
  response.write("<center><h3>Inactive Vessels<span style='cursor: help;' class='tip' data-tipped-options=""position: 'bottomright', maxWidth: 250"" title='Some older craft not compatible with the database display will require a popout window. Please allow popups. Some vessels prior to 10/20/14 were not tracked & instead link to their mission dispatches'><sup>*</sup></span></h3></center>")
else
  response.write("<center><h3>Active Vessels</h3></center>")
end if
%>

<!-- menu tree -->
<!-- yes, this method is very brute-force and not overly efficient but load times don't seem visibly affected to bother optimizing -->

<!-- 
CRAFT FIELDS
============

ID - a unique number, used only for the database record. Can be anything as long as it's unique
[DB] - the name of the database containing the craft information, minus the "db" prefix
[Popout] - link to open craft data in a popout, required for older craft. Can also open external site if no craft data is available (for a mission report, for example)
Vessel - the printed name of the vessel to appear in the menu tree
Type - the name of a vessel description that corresponds to a PNG image file on the server, should match all in-game types (Ship, Probe, Debris, etc)
Desc - a description of the vessel that will appear as pop-up text when the link is hovered over. Can be long, pop-up will not overflow page elements
[Collection] - the ID for a twitter collection created in Tweetdeck and made into a widget
UT# - the time in seconds from 0 epoch (UT) at which the vessel is within this SOI. A value of -1 moves vessel to the Inactive list. A value of -2 removes it from both Active & Inactive listings
Ref# - the unique planet or moon ID that identifies the SOI the vessel is within

Adding additional UT/Ref field pairs will cause the vessel to move from one SOI to another as the UT for that transition is passed

UT/Ref fields can be extended as much as needed, maintaining the paired values. They do not need to be named UT2/Ref2, UT3/ref3 etc. 
They do not need to contain a value, so long as any empty fields are at the end of a continuous run of field pairs

MOON/PLANET FIELDS
==================

ID - the reference number vessels use to determine what SOI they are within at a certain time. 0-49 for planets. 50+ for moons
Body - the name of the body
[Ref] - available and required only for moons, which links them to the planet that they orbit
Gm - the gravitaional constant for this body, taken from KSPTOT's bodies.ini file
Radius - the radius of the body, in km, taken from KSPTOT's bodies.ini file
RotPeriod - the rotaional period of the body, in seconds, taken from KSPTOT's bodies.ini file
RotIni - the amount the body is rotated at epoch 0, in degrees, taken from KSPTOT's bodies.ini file
AllowPlot - checked if this body is supported by KSP.Leaflet (everything except Jool, Kerbol and any custom bodies)
-->

<%
filters = Array("debris", "probe", "rover", "lander", "ship", "station", "base", "asteroid")

'start the tree
response.write("<ol class='tree'>")

'decide whether we are building a menu for active or inactive vessels
bEntry = false
if request.querystring("filter") = "inactive" then

  'we can add or remove the craft types to search for by modifying the previously-defined array above
  for each x in filters

    'look through all crafts in the table
    bVessels = false
    do while not rsCrafts.eof

      'stepping through each UT/Ref pair to find any entries for this UT
      'since we are starting from the earliest time, move forward until we hit a later one
      ref = -2
      for i = 7 to rsCrafts.fields.count - 1 step 2
        if rsCrafts.fields.item(i) <= UT then 
          ref = rsCrafts.fields.item(i+1)
        else
          exit for
        end if
      next

      'check if this is an inactive vessel or not
      'then check that this vessel belongs under this filter category
      if ref = -1 then
        if rsCrafts.fields.item("type") = x then
        
          'if this is the first vessel found for this filter, then create the category to list the vessel under
          if not bVessels then
            bVessels = true
            
            'convert the string to first character upper case
            letter = left(x, 1)
            letter = ucase(letter)
            title = letter & mid(x, 2, len(x)-1)
            response.write("<li> <label" & title & " for='" & title & "'>" & title & "</label" & title & "> <input type='checkbox' id='" & title & "' /> <ol>")
          end if
          
          'if there is no database then we need to resort to the popout or external link
          if isnull(rsCrafts.fields.item("db")) then
            response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "'target='_blank' href='"& rsCrafts.fields.item("popout") & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
          else

            'url string to attach databases to that preserves certain variables
            url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & rsCrafts.fields.item("db")
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
            response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
          end if
        end if
      end if
      
      'advance to the next record
      rsCrafts.movenext
    loop
    
    'only close off the category if entries were created
    'then re-rack the crafts for another search through
    if bVessels then response.write("</ol> </li>")
    rsCrafts.movefirst
  next
else

  'loop through all the planets
  do while not rsPlanets.eof
    
    'check for any moons of this planet
    bPlanet = false
    do while not rsMoons.eof
      if rsMoons.fields.item("ref") = rsPlanets.fields.item("id") then
        
        'stepping through each UT/Ref pair to find any entries for this UT
        'since we are starting from the earliest time, move forward until we hit a later one
        bVessels = false
        do while not rsCrafts.eof
          ref = -1
          for x = 7 to rsCrafts.fields.count - 1 step 2
            if rsCrafts.fields.item(x) <= UT then 
              ref = rsCrafts.fields.item(x+1)
            else
              exit for
            end if
          next

          'check for an active filter, otherwise ensure craft is selected by assigning craft type to the filter
          if request.querystring("filter") = "" then
            filterBy = rsCrafts.fields.item("type")
          else
            filterBy = request.querystring("filter")
          end if
          if filterBy = rsCrafts.fields.item("type") then
          
            'check if the craft that matches this UT is within the SOI of this moon
            if ref = rsMoons.fields.item("id") then

              'include the moon as a child of the planet if this is the first vessel found within its SOI
              if not bVessels then
              
                'include the planet in the tree if this has not yet been done
                if not bPlanet then
                  url = "http://www.kerbalspace.agency/Flights/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
                  if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
                  response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
                  bPlanet = true
                end if
                
                url = "http://www.kerbalspace.agency/Flights/body.asp?db=bodies&body=" & rsMoons.fields.item("body")
                if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
                response.write("<li><label for='" & rsMoons.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsMoons.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
                bVessels = true
              end if
              
              'include the craft as a child of the moon
              url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & rsCrafts.fields.item("db")
              if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
              if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
              response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 255, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
              bEntry = true
            end if
          end if
          
          'advance to the next craft
          rsCrafts.movenext
        loop
        
        'reset the craft record pointer for the next moon
        rsCrafts.movefirst
        
        'if we found vessels around moons, there is a tree we need to close off
        if bVessels then response.write("</ol> </li>")
      end if
      
      'advance to the next mooon
      rsMoons.movenext
    loop

    'set for the next loop through the next planet
    rsMoons.movefirst
    
    'time to look for any craft orbiting this planet
    'stepping through each UT/Ref pair to find any entries for this UT
    'since we are starting from the earliest time, move forward until we hit a later one
    do while not rsCrafts.eof
      ref = -1
      for x = 7 to rsCrafts.fields.count - 1 step 2
        if rsCrafts.fields.item(x) <= UT then 
          ref = rsCrafts.fields.item(x+1)
        else
          exit for
        end if
      next
      
      'check for an active filter, otherwise ensure craft is selected by assigning craft type to the filter
      if request.querystring("filter") = "" then
        filterBy = rsCrafts.fields.item("type")
      else
        filterBy = request.querystring("filter")
      end if
      if filterBy = rsCrafts.fields.item("type") then
      
        'check if the craft that matches this UT is within the SOI of this planet
        if ref = rsPlanets.fields.item("id") then
        
          'include the planet in the tree if this has not yet been done
          if not bPlanet then
            url = "http://www.kerbalspace.agency/Flights/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
            response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
            bPlanet = true
          end if
          
          'include the craft as a child of the planet
          url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & rsCrafts.fields.item("db")
          if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
          if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
          response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
          bEntry = true
        end if
      end if
      
      'advance to the next craft
      rsCrafts.movenext
    loop

    'if we found vessels around planets, there is a tree we need to close off
    'then re-rack the crafts and advance to the next planet
    if bPlanet then response.write("</ol>	</li>")
    rsCrafts.movefirst
    rsPlanets.movenext
  loop
  
  'let the user know if we did not find anything for this particular filter
  if not bEntry then response.write("<span style='margin-left: 70px'>No Vessels Found</a>")
end if
%>

<!-- adds a link to the crew roster to the end of the menu list 
<li> <labelRoster for='Roster'><a href="http://www.kerbalspace.agency/Roster/roster.asp?db=bob" style="text-decoration: none; color: black" class="tip" data-tipped-options="position: 'right'" title="Information on KSA astronauts">Crew Roster</a></labelRoster> </li>
coming in v3.1 -->
</ol>

<!-- menu filter options -->
<%
'build a URL to use for linking
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")

'decide what message to include beneath the menu tree
response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
if request.querystring("filter") = "inactive" then
  response.write("<b>Filter By:</b> <a href='" & url & "'>Active Vessels</a>")
else
  response.write("<b>Filter By:</b> ")
  if len(request.querystring("filter")) then response.write("<a href='" & url & "'>All</a> | ")
  
  'print out the available filters depending on what is defined
  for each x in filters
  
    'convert the string to first character upper case
    letter = left(x, 1)
    letter = ucase(letter)
    title = letter & mid(x, 2, len(x)-1)
    
    'do not link to an active filter
    if request.querystring("filter") <> x then
      response.write("<a href='" & url & "&filter=" & x & "'>" & title & "</a> | ")
    else
      response.write(title & " | ")
    end if
  next
  response.write("<a href='" & url & "&filter=inactive'>Inactive Vessels</a>")
end if
%>

<!-- 
EVENTS DATABASE INFORMATION
===========================

Launches recordset contains a list of all future launches that will be displayed on the clock
Maneuvers recordset contains a list of all future maneuvers that will be displayed on the clock

EVENTS FIELDS
=============

UT - the date at which this scheduled event will appear on the clock
CraftName - the name of the craft that will be performing this event
CraftLink - full URL link to the craft page
EventDate - date string in VBScript date format for the time of the event (in KSC local time!)
--> 

<%
'open database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\dbEvents.mdb"
Dim connEvent
Set connEvent = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connEvent.Open(sConnection)

'create the table
set rsLaunch = Server.CreateObject("ADODB.recordset")
set rsManeuver = Server.CreateObject("ADODB.recordset")

'query the data and pull up the UT closest to this one 
'check if recordset is empty first
rsLaunch.open "select * from Launches", connEvent, 1, 1
rsManeuver.open "select * from Maneuvers", connEvent, 1, 1
if not rsLaunch.eof then
  rsLaunch.find ("ut>" & UT)
  rsLaunch.moveprevious
end if
if not rsManeuver.eof then
  rsManeuver.find ("ut>" & UT)
  rsManeuver.moveprevious
end if
%>

<!-- clock and upcoming events -->
<p>
<table style="width: 100%; border: 1px solid #007FDB;	border-collapse: collapse; background-color: #77C6FF;">
  <tr>
    <td>
      <center>
      <b>Current Time @ KSC <span id="utc"></span></b><br>
      <span id='ksctime' style="font-size: 16px"></span>
      <br><br>
      <table border="0" style="width: 100%; border-collapse: collapse;">
        <tr>
          <td style="width: 50%; border-width: 1px; text-align: center; vertical-align: top; border-top-style: none; border-right-style: solid; border-bottom-style: none; border-left-style: none;">
            <b>Next Launch</b><br>
            <%
            'if we are at EOF there are no records yet
            'if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
            if rsLaunch.bof or rsLaunch.eof then
              response.write("<script>")
              response.write("var bLaunchCountdown = true;")
              response.write("var bFutureLaunch = false;")
              response.write("var nextLaunchSched = 0;")
              response.write("</script>")
              response.write("None Scheduled")
            else
              
              'if this launch was selected but has already gone off, then there are no more scheduled or they are too far ahead
              if datediff("s", rsLaunch.fields.item("EventDate"), now()) >= 0 then
                response.write("<script>")
                response.write("var bLaunchCountdown = false;")

                'if there is a future one to look for, let js know and update when it hits
                rsLaunch.movenext()
                if not rsLaunch.eof then
                  response.write("var bFutureLaunch = true;")
                  response.write("var nextLaunchSched = " & rsLaunch.fields.item("UT") & ";")
                else
                  response.write("var bFutureLaunch = false;")
                  response.write("var nextLaunchSched = 0;")
                end if
                response.write("</script>")
                response.write("None Scheduled")
                
              'this launch is displayable and upcoming, configure js variables for updating the countdown timer
              else
                response.write("<script>")
                response.write("var bLaunchCountdown = true;")
                response.write("var bFutureLaunch = false;")
                response.write("var nextLaunchSched = 0;")
                response.write("var launchSchedUT = " & datediff("s", rsLaunch.fields.item("EventDate"), now()) & ";")
                response.write("</script>")
                if not isnull(rsLaunch.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsLaunch.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                end if
                response.write(formatdatetime(rsLaunch.fields.item("EventDate")) & "<br>")
                response.write("<span id='tminuslaunch'></span>")
              end if
            end if
            %>
          </td>
          <td style="width: 50%; vertical-align: top;	text-align: center;">
            <b>Next Maneuver</b><br>
            <%
            'if we are at EOF there are no records yet
            'if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
            if rsManeuver.bof or rsManeuver.eof then
              response.write("<script>")
              response.write("var bManeuverCountdown = true;")
              response.write("var bFutureManeuver = false;")
              response.write("var nextManeuverSched = 0;")
              response.write("</script>")
              response.write("None Scheduled")
            else
              
              'if this maneuver was selected but has already gone off, then there are no more scheduled or they are too far ahead
              if datediff("s", rsManeuver.fields.item("EventDate"), now()) >= 0 then
                response.write("<script>")
                response.write("var bManeuverCountdown = false;")

                'if there is a future one to look for, let js know and update when it hits
                rsManeuver.movenext()
                if not rsManeuver.eof then
                  response.write("var bFutureManeuver = true;")
                  response.write("var nextManeuverSched = " & rsManeuver.fields.item("UT") & ";")
                else
                  response.write("var bFutureManeuver = false;")
                  response.write("var nextManeuverSched = 0;")
                end if
                response.write("</script>")
                response.write("None Scheduled")
                
              'this maneuver is displayable and upcoming, configure js variables for updating the countdown timer
              else
                response.write("<script>")
                response.write("var bManeuverCountdown = true;")
                response.write("var bFutureManeuver = false;")
                response.write("var nextManeuverSched = 0;")
                response.write("var maneuverUT = " & datediff("s", rsManeuver.fields.item("EventDate"), now()) & ";")
                response.write("var launchLink = '" & rsManeuver.fields.item("CraftLink") & "';")
                response.write("var launchCraft = '" & rsManeuver.fields.item("CraftName") & "';")
                response.write("</script>")
                if not isnull(rsManeuver.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsManeuver.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsManeuver.fields.item("CraftLink") & "'>" & rsManeuver.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsManeuver.fields.item("CraftLink") & "'>" & rsManeuver.fields.item("CraftName") & "</a><br>")
                end if
                response.write("<a href='" & rsManeuver.fields.item("CraftLink") & "&node=true'>" & rsManeuver.fields.item("CraftName") & "</a><br>")
                response.write(formatdatetime(rsManeuver.fields.item("EventDate")) & "<br>")
                response.write("<span id='tminusmaneuver'></span>")
              end if
            end if
            %>
          </td>
        </tr>
      </table>
      </center>
    </td>
  </tr>
</table>
</p>

<!-- twitter timeline display --> 
<%
'find the craft data we need for this vessel
rsCrafts.movefirst
rsCrafts.find("db='" & request.querystring("db") & "'")

'if we are watching a live launch, show the main twitter stream even if there is a mission timeline so it auto-updates with launch tweets
if bAscentActive and not len(request.querystring("ut")) then
  response.write("<p><a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
else
  
  'show the mission collection timeline if there is one available, or fall back to the main tweet stream
  if isnull(rsCrafts.fields.item("collection")) or rsCrafts.eof then 
    response.write("<p><a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
  else
    response.write("<p><a class='twitter-timeline' href='/KSA_MissionCtrl/timelines/598076346514984960' data-widget-id='" & rsCrafts.fields.item("collection") & "'>Mission Timeline</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
  end if
end if
%>

</span></div> </div>

<%
'get everything reset for use again
rsCrafts.movefirst
rsPlanets.movefirst
rsMoons.movefirst
%>

<!-- this script controls the real-time page elements, including the Leaflet map -->
<script>
  var mapState = "<%response.write MapState%>";
  var latlon = [];
  var orbitdata = [];
  var UT = <%response.write UT%>;

  if (mapState == "ascent") {

    // create the map with some custom options
    // details on Leaflet API can be found here - http://leafletjs.com/reference.html
    var map = new L.KSP.Map('map', {
      layers: [L.KSP.CelestialBody.KERBIN],
      center: [0,0],
      bodyControl: false,
      layersControl: false,
      zoomControl: true,
      scaleControl: true,
      minZoom: 0,
      maxZoom: 5,
    });

    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    // don't show until the mouse is over the map as otherwise it will just come up as undefined, hide when mouse is off the map
    if (!is_touch_device()) { 
      infoControl = new L.KSP.Control.Info();
      map.addControl(infoControl);
      $(".leaflet-control-info").css("display", "none");
      map.on('mouseover', function(e) {
        $(".leaflet-control-info").fadeIn();
      });
      map.on('mouseout', function(e) {
        $(".leaflet-control-info").fadeOut();
      });
    }

    // set craft icon, determined by the entry in the crafts database
    <%rsCrafts.find("db='" & request.querystring("db") & "'")%>
    var ship = L.icon({iconUrl: 'button_vessel_<%response.write rsCrafts.fields.item("Type")%>.png', iconSize: [16, 16]});
    <%rsCrafts.movefirst%>
    
    // is this old ascent data?
    if (<%response.write lcase(bAscentData)%>) {
      <%
      if bAscentData then
        if not rsAscent.bof then
        
          'we have already used ascent data so reset the record pointer
          rsAscent.movefirst
          latStart = rsAscent.fields.item("lat")
          lonStart = rsAscent.fields.item("lon")
          
          'draw the rocket path up to the current time
          i = 0
          do while rsAscent.fields.item("id") <= dbUT 
          
            'make sure the lat/lon data was not ommitted for some reason
            if not isnull(rsAscent.fields.item("lat")) and not isnull(rsAscent.fields.item("lon")) then
              response.write("latlon[" & i & "] = [" & rsAscent.fields.item("lat") & "," & rsAscent.fields.item("lon") & "];")
              i = i + 1
            end if
            
            'advance to the next record but exit the loop if that is beyond the last one
            rsAscent.movenext
            if rsAscent.eof then exit do
          loop
          
          'we need to back up to get the last location, which is where the craft marker will be placed after we draw the ground plot
          rsAscent.moveprevious
          response.write("ascentTrack = L.polyline(latlon, {smoothFactor: .25, clickable: false, color: '#00FF00', weight: 2, opacity: 1}).addTo(map);")
          response.write("L.marker([" & rsAscent.fields.item("lat") & "," & rsAscent.fields.item("lon") & "], {icon: ship, clickable: false}).addTo(map);")
      
          'fit the map to the path we drew
          response.write("map.fitBounds(ascentTrack.getBounds(), {maxZoom: 5});")
        end if
      end if
      %>
      
    // this is new ascent data
    } else {
      
      // keep the map locked to the ship if we are watching a current launch
      if (!bPastUT) {
        map.dragging.disable();
        map.touchZoom.disable();
        map.doubleClickZoom.disable();
        map.scrollWheelZoom.disable();
        map.boxZoom.disable();
        $(".leaflet-control-zoom").css("display", "none");
      }
      
      // is the ascent underway right now?
      // use the dbUT to stay compatible with look-back
      if (telemetryUT < <%response.write dbUT%>) {
        
        // we need to build the ground plot so far
        ascentDelta = <%response.write dbUT%> - telemetryUT;
        craft = L.marker([ascentData[0].Lat, ascentData[0].Lon], {icon: ship, clickable: false}).addTo(map);
        ascentTrack = L.polyline(craft.getLatLng(), {smoothFactor: .25, clickable: false, color: '#00FF00', weight: 2, opacity: 1}).addTo(map);
        for (i = 1; i < ascentDelta; i++) {
          ascentTrack.spliceLatLngs(0, 0, [ascentData[i].Lat, ascentData[i].Lon]);
        }

        // kick off the telemetry update loop
        bAscentPaused = false;
        ascentStartTime = new Date().getTime() - (ascentDelta*1000);
        ascentUpdater(Math.floor(ascentDelta), false); 
        
      // launch hasn't started yet, so just place the craft on the first coordinates, center the map on it
      } else {
        craft = L.marker([ascentData[0].Lat, ascentData[0].Lon], {icon: ship, clickable: false}).addTo(map);
        ascentTrack = L.polyline(craft.getLatLng(), {smoothFactor: .25, clickable: false, color: '#00FF00', weight: 2, opacity: 1}).addTo(map);
        map.setView(craft.getLatLng(), 5); 
      }
    }
  } else if (mapState == "prelaunch") {

    // create the map with some custom options
    // details on Leaflet API can be found here - http://leafletjs.com/reference.html
    var map = new L.KSP.Map('map', {
      layers: [L.KSP.CelestialBody.KERBIN],
      center: [0,0],
      bodyControl: false,
      layersControl: false,
      zoomControl: true,
      scaleControl: true,
      minZoom: 0,
      maxZoom: 5,
    });

    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    // don't show until the mouse is over the map as otherwise it will just come up as undefined, hide when mouse is off the map
    if (!is_touch_device()) { 
      infoControl = new L.KSP.Control.Info();
      map.addControl(infoControl);
      $(".leaflet-control-info").css("display", "none");
      map.on('mouseover', function(e) {
        $(".leaflet-control-info").fadeIn();
      });
      map.on('mouseout', function(e) {
        $(".leaflet-control-info").fadeOut();
      });
    }

    // set launchsite icon
    launchsiteIcon = L.icon({popupAnchor: [0, -43], iconUrl: 'markers-spacecenter.png', iconSize: [30, 40], iconAnchor: [15, 40], shadowUrl: 'markers-shadow.png', shadowSize: [35, 16], shadowAnchor: [10, 12]});
    
    // place the marker and build the information window for it, then center the map on it
    launchsiteMarker = L.marker([launchLat, launchLon], {icon: launchsiteIcon}).addTo(map);
    if (launchLat < 0) {
      cardinalLat = "S";
    } else {
      cardinalLat = "N";
    }
    if (launchLon < 0) {
      cardinalLon = "W";
    } else {
      cardinalLon = "E";
    }
    launchsiteMarker.bindPopup("<b>Launch Location</b><br>" + launchsite + "<br>[" + Math.abs(launchLat) + "&deg;" + cardinalLat + ", " + Math.abs(launchLon) + "&deg;" + cardinalLon + "]" , {closeButton: false});
    map.setView(launchsiteMarker.getLatLng(), 2); 
  
    // show the marker popup then hide it in 5s
    launchsiteMarker.openPopup(); 
    setTimeout(function () { 
      launchsiteMarker.closePopup(); 
    }, 5000);
    
  // we can have an orbital state that doesn't require a map, so check that the element was created
  } else if (mapState == "orbit" && $("#map").length) {
  
    // just dummy values in case the real values are not available to be retrieved from the database
    var gmu = 301.363211975;
    var sma = 1340.296;
    var ecc = 0.7178298;
    var inc = 1.57085636612117;
    var raan = 5.77553709561526;
    var arg = 4.71418317885574;
    var mean = 6.15350210776865;
    var eph = 37819923.931;
    var period = 17759.7;
    var ap = 0;
    var pe = 0;

    <%
    'get the record containing the information relative to this vessel
    'if we do not have an orbit to plot, we still need to fill out variables with some data so just use Du-SCAN. Could be any craft
    if bMapOrbit then
      rsCrafts.find("db='" & request.querystring("db") & "'")
    else
      rsCrafts.find("db='duscan'")
    end if
    
    'create a recordset copy of the moon/planet recordset depending on what is being orbited at this time
    'stepping through each UT/Ref pair to find any entries for this UT
    'since we are starting from the earliest time, move forward until we hit a later one
    for x = 7 to rsCrafts.fields.count - 1 step 2
      'first field is the UT, second field is the body reference #
      if rsCrafts.fields.item(x) <= UT then 
        ref = rsCrafts.fields.item(x+1)
      else
        exit for
      end if
    next

    'moons use 50 or greater for reference numbers
    if ref < 50 then
      set rsBody = rsPlanets.clone()
    else
      set rsBody = rsMoons.clone()
    end if
    
    'now get the specific body
    rsBody.find("id=" & ref)
    
    'some bodies are not supported by KSP.Leaflet and should not attempt to be drawn via the map
    response.write ("var bDrawMap = " & lcase(rsBody.fields.item("AllowPlot")) & ";")

    'set the initial Keplerian orbital elements & time & gravitaional parameter of the body
    'degrees converted to radians - (angle / 180) * Math.PI
    if bMapOrbit then

      'point to the relevant record for this UT
      rsOrbit.MoveLast
      do until rsOrbit.fields.item("id") <= dbUT
        rsOrbit.MovePrevious
        if rsOrbit.bof then exit do
      Loop
      response.write("var gmu = " & rsBody.fields.item("Gm") & ";")
      response.write("var sma = " & rsOrbit.fields.item("SMA") & ";")
      response.write("var ecc = " & rsOrbit.fields.item("Eccentricity") & ";")
      response.write("var inc = " & rsOrbit.fields.item("Inclination") * .017453292519943295 & ";")
      response.write("var raan = " & rsOrbit.fields.item("RAAN") * .017453292519943295 & ";")
      response.write("var arg = " & rsOrbit.fields.item("Arg") * .017453292519943295 & ";")
      response.write("var mean = " & rsOrbit.fields.item("Mean") * .017453292519943295 & ";")
      response.write("var eph = " & rsOrbit.fields.item("Eph") & ";")
      response.write("var period = " & rsOrbit.fields.item("Orbital Period") & ";")
    end if
    %>
    
    if (bDrawMap) {
    
      // craft icon, determined by the entry in the crafts database
      var ship = L.icon({
        iconUrl: 'button_vessel_<%response.write rsCrafts.fields.item("Type")%>.png',
        iconSize: [16, 16],
      });
      
      // Ap/Pe icons
      var apIcon = L.icon({
        iconUrl: 'ap.png',
        iconSize: [16, 16],
        iconAnchor: [8, 16]
      });
      var peIcon = L.icon({
        iconUrl: 'pe.png',
        iconSize: [16, 16],
        iconAnchor: [8, 16]
      });

      // create the map with some custom options
      var map = new L.KSP.Map('map', {
        layers: [L.KSP.CelestialBody.<%response.write ucase(rsBody.fields.item("Body"))%>],
        zoom: 1,
        center: [0,0],
        bodyControl: false,
        layersControl: false,
        scaleControl: true,
        minZoom: 0,
        maxZoom: 5
      });

      // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
      // leaflet.js was modified to remove the biome, slope and elevation data displays
      // don't show until the mouse is over the map as otherwise it will just come up as undefined, hide when mouse is off the map
      if (!is_touch_device()) { 
        infoControl = new L.KSP.Control.Info();
        map.addControl(infoControl);
        $(".leaflet-control-info").css("display", "none");
        map.on('mouseover', function(e) {
          $(".leaflet-control-info").fadeIn();
        });
        map.on('mouseout', function(e) {
          $(".leaflet-control-info").fadeOut();
        });
      }
    }
    
    // orbital calculations status bar
    $("#orbDataMsg").fadeIn();
    
    // compute 3 orbits max, or only up to a future maneuver node along one of those three orbits
    if (bUpcomingNode) {
      var endTime = UT + (nodeUT - UT);
    } else {
      var endTime = UT + (Math.round(period * 3));
    }
    var currUT = initialUT = UT;
    var showMsg = false;
    var n;
    
    // don't by default exceed 100,000s to ensure computation completes in a reasonable amount of time
    // however allow user to override this if they want
    if (getParameterByName('fullorbit').length) {
      var maxDeltaTime = -1;
    } else {
      var maxDeltaTime = 100000;
      if (endTime - currUT > maxDeltaTime) {
        endTime = UT + maxDeltaTime;
        
        // in cases where the orbital period exceeds 100,000s we should inform the user the whole orbit is not being plotted
        // this is handled when the map is shown (see beginning of file)
        if (period > maxDeltaTime) { showMsg = true; }
      }
    }
    
    // this function will continually call itself to batch-run orbital calculations and not completely lock up the browser
    (function orbitalCalc() {
      for (x=0; x<=1500; x++) {
      
        //////////////////////
        // computeMeanMotion() <-- refers to a function in KSPTOT code: https://github.com/Arrowstar/ksptot
        //////////////////////
        
        // adjust for motion since the time of this orbit
        n = Math.sqrt(gmu/(Math.pow(Math.abs(sma),3)));
        var newMean = mean + n * (currUT - eph);
        
        ////////////////
        // solveKepler()
        ////////////////
        
        var EccA = -1;
        if (newMean < 0 || newMean > 2*Math.PI) {
          // expanded AngleZero2Pi() function
          // abs(mod(real(Angle),2*pi));
          // javascript has a modulo operator, but it doesn't work the way we need. Or something
          // so using the mod() function implementation from Math.js: x - y * floor(x / y)
          newMean = Math.abs(newMean - (2*Math.PI) * Math.floor(newMean / (2*Math.PI)));
        }
        
        if (Math.abs(newMean - 0) < 1E-8) {
          EccA = 0;
        } else if (Math.abs(newMean - Math.PI) < 1E-8 ) {
          EccA = Math.PI;
        }	
        
        /////////////
        // keplerEq()
        /////////////
        
        // since there is no function return to break ahead of this statement, test if variable was modified
        if (EccA == -1) {
          var En  = newMean;
          var Ens = En - (En-ecc*Math.sin(En) - newMean)/(1 - ecc*Math.cos(En));
          while ( Math.abs(Ens-En) > 1E-10 ) {
            En = Ens;
            Ens = En - (En - ecc*Math.sin(En) - newMean)/(1 - ecc*Math.cos(En));
          }
          EccA = Ens;
        }
        
        ///////////////////////////////
        // computeTrueAnomFromEccAnom()
        ///////////////////////////////
        
        var upper = Math.sqrt(1+ecc) * Math.tan(EccA/2);
        var lower = Math.sqrt(1-ecc);
        
        // expanded AngleZero2Pi() function
        // abs(mod(real(Angle),2*pi));
        // javascript has a modulo operator, but it doesn't work the way we need. Or something
        // so using the mod() function implementation from Math.js: x - y * floor(x / y)
        var tru = Math.abs((Math.atan2(upper, lower) * 2) - (2*Math.PI) * Math.floor((Math.atan2(upper, lower) * 2) / (2*Math.PI)));
        
        ///////////////////////////
        // getStatefromKepler_Alg()
        ///////////////////////////
        
        <%
        'reset these variables in case they were modified on the last run through
        if bMapOrbit then
          response.write("raan = " & rsOrbit.fields.item("RAAN") * .017453292519943295 & ";")
          response.write("arg = " & rsOrbit.fields.item("Arg") * .017453292519943295 & ";")
        end if
        %>

        // Special Case: Circular Equitorial
        if(ecc < 1E-10 && (inc < 1E-10 || Math.abs(inc-Math.PI) < 1E-10)) {
          var l = raan + arg + tru;
          tru = l;
          raan = 0;
          arg = 0;
        }

        // Special Case: Circular Inclined
        if(ecc < 1E-10 && inc >= 1E-10 && Math.abs(inc-Math.PI) >= 1E-10) {
          var u = arg + tru;
          tru = u;
          arg = 0.0;
        }

        // Special Case: Elliptical Equitorial
        if(ecc >= 1E-10 && (inc < 1E-10 || Math.abs(inc-Math.PI) < 1E-10)) {
          raan = 0;
        }

        var p = sma*(1-(Math.pow(ecc,2)));
        
        // vector/matrix operations handled by Sylvester - http://sylvester.jcoglan.com/
        var rPQW = $V([p*Math.cos(tru) / (1 + ecc*Math.cos(tru)),
                       p*Math.sin(tru) / (1 + ecc*Math.cos(tru)),
                       0]);
                      
        var vPQW = $V([-Math.sqrt(gmu/p)*Math.sin(tru),
                       Math.sqrt(gmu/p)*(ecc + Math.cos(tru)),
                       0]);
        
        var TransMatrix = $M([
          [Math.cos(raan)*Math.cos(arg)-Math.sin(raan)*Math.sin(arg)*Math.cos(inc), -Math.cos(raan)*Math.sin(arg)-Math.sin(raan)*Math.cos(arg)*Math.cos(inc), Math.sin(raan)*Math.sin(inc)],
          [Math.sin(raan)*Math.cos(arg)+Math.cos(raan)*Math.sin(arg)*Math.cos(inc), -Math.sin(raan)*Math.sin(arg)+Math.cos(raan)*Math.cos(arg)*Math.cos(inc), -Math.cos(raan)*Math.sin(inc)],
          [Math.sin(arg)*Math.sin(inc), Math.cos(arg)*Math.sin(inc), Math.cos(inc)]
        ]);
        
        var rVect = TransMatrix.multiply(rPQW);
        var vVect = TransMatrix.multiply(vPQW);	
        
        /////////////////////
        // getBodySpinAngle()
        /////////////////////
        
        var rotPeriod = <%response.write rsBody.fields.item("RotPeriod")%>;
        var bodySpinRate = 2*Math.PI/rotPeriod;

        // converted to radians
        var rotInit = <%response.write rsBody.fields.item("RotIni")%> * .017453292519943295; 
        
        // expanded AngleZero2Pi() function
        // abs(mod(real(Angle),2*pi));
        // javascript has a modulo operator, but it doesn't work the way we need. Or something
        // so using the mod() function implementation from Math.js: x - y * floor(x / y)
        var angle = rotInit + bodySpinRate*currUT;
        var spinAngle = Math.abs(angle - (2*Math.PI) * Math.floor(angle / (2*Math.PI)));

        //////////////////////////////////////
        // getFixedFrameVectFromInertialVect()
        //////////////////////////////////////

        var R = $M([
          [Math.cos(spinAngle), -Math.sin(spinAngle), 0],
          [Math.sin(spinAngle), Math.cos(spinAngle), 0],
          [0, 0, 1]
        ]);
          
        R = R.transpose();
        var rVectECEF = R.multiply(rVect);

        //////////////////////////////////
        // getLatLongAltFromInertialVect()
        //////////////////////////////////

        // 2-norm or Euclidean norm of vector
        var rNorm = Math.sqrt(rVectECEF.e(1) * rVectECEF.e(1) + rVectECEF.e(2) * rVectECEF.e(2) + rVectECEF.e(3) * rVectECEF.e(3));
        
        // convert to degrees from radians - angle / Math.PI * 180
        // expanded AngleZero2Pi() function
        // abs(mod(real(Angle),2*pi));
        // javascript has a modulo operator, but it doesn't work the way we need. Or something
        // so using the mod() function implementation from Math.js: x - y * floor(x / y)
        var longitude = (Math.abs(Math.atan2(rVectECEF.e(2),rVectECEF.e(1)) - (2*Math.PI) * Math.floor(Math.atan2(rVectECEF.e(2),rVectECEF.e(1)) / (2*Math.PI)))) * 57.29577951308232;
        var latitude = (Math.PI/2 - Math.acos(rVectECEF.e(3)/rNorm)) * 57.29577951308232;
        var alt = rNorm - <%response.write rsBody.fields.item("Radius")%>;
        var vel = Math.sqrt(gmu*(2/rNorm - 1/sma));
        
        // convert the lon to proper coordinates (-180 to 180)
        if (longitude >= 180) { longitude -= 360; }
        
        // store all the derived values and advance to the next second
        latlon.push({lat: latitude, lng: longitude});
        orbitdata.push({alt: alt, vel: vel});
        currUT++;
        
        // update the progress bar
        $('#progress').css("width", (365 * (latlon.length/(endTime-initialUT))));

        // exit the batch prematurely if we've reached the end of our needed calculations
        if (currUT > endTime) { break; }
      }
      
      // move on to render orbits to the map if we've finished our calculations
      // otherwise call ourselves again in 1ms for another round
      if (currUT > endTime) {
        renderMap(initialUT); 
      } else {
        setTimeout(orbitalCalc, 1);
      }

    })();
  }
  
  // determine our offset between js and vb time, which can vary from 10-15 seconds
  // time offset is in favor of vb time, as majority of time stamps are done with dateDiff()
  var d = new Date();
  if (d.getSeconds() < <%response.write(Second(Now()))%>) {
    var timeOffset = ((d.getSeconds() + 60) - <%response.write(Second(Now()))%>) * 1000;
  } else {
    var timeOffset = (d.getSeconds() - <%response.write(Second(Now()))%>) * 1000;
  }
  d.setTime(d.getTime() - timeOffset);
	  		
  // keep various things updated by calling this function every second
  var startDate = Math.floor(d.getTime() / 1000);
  var strMsg = "<%response.write msg%>";
  var MET = <%response.write origMET%>;
  var bUpdateMET = <%response.write lcase(bUpdateMET)%>;
  var bEstDst = <%response.write lcase(bEstDst)%>;
  var strAccDst = "<%response.write strAccDst%>";
  var dstTraveled = <%response.write dstTraveled%>;
  var tickStartTime = new Date().getTime();
  var tickDelta = 0;
  var eventCaption;
  var camCaption;
  <%
    if not isnull(rsOrbit.fields.item("Avg Velocity")) and not rsOrbit.bof then
      response.write("var avgSpeed = " & rsOrbit.fields.item("Avg Velocity") & ";")
    else
      response.write("var avgSpeed = 0;")
    end if
  %>

  // no longer using setInterval, as suggested via
  // http://stackoverflow.com/questions/6685396/execute-the-first-time-the-setinterval-without-delay
  (function tick() {
  
    // get the difference in time since the page load and use that to find the right data
    var dd = new Date();
    dd.setTime(dd.getTime() - timeOffset);
    var currDate = Math.floor(dd.getTime() / 1000);
    var now = currDate - startDate;

    // build a string to use upon hitting a refresh trigger
    // this gets rid of any UT time when viewing the current event from a past one to ensure that the latest data is loaded
    var urlReload = "http://<%response.write Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")%>?db=" + getParameterByName('db');
    if (getParameterByName("filter")) { urlReload += "&filter=" + getParameterByName("filter"); }
    if (getParameterByName("popout")) { urlReload += "&popout=" + getParameterByName("popout"); }

    // check if we need to refresh the page
    // did our orbital plot run out? (except for when it runs out after a maneuver node)
    if (bDrawMap && now >= latlon.length && $('#tminusmaneuver').html() != "Maneuver Executed") {
      window.location.href = urlReload;
    }
    
    // can we now draw our maneuver node?
    if (bDrawMap && bNodeRefreshCheck && nodeUT - UT < maxDeltaTime) {
      window.location.href = urlReload;
    }

    // have we reached the next update? Check only happens if viewing the present record
    // if this is a live launch, present the user with a survey option including data from this launch stream
    if (bNextEventRefresh && UT >= nextEventUT) {
      if (!bPastUT && bAscentActive) { 
        surveyURL = "&surveyURL=https://docs.google.com/forms/d/1MDVK2hC7AXgOI_XXzBBxIB7xw0No-AdxC4bbyUUY0Uc/viewform?" + 
          "entry.186889309=" + OSName + 
          "|entry.1648505583=" + browserDeets + 
          "|entry.1805542433=" + is_touch_device() + 
          "|entry.615008840=" + formatTime(maxDiff/1000, true) + 
          "|entry.2054414267=" + iterpolationTime + 
          "|entry.526407492=" + launchVideo.currentSrc.slice(launchVideo.currentSrc.lastIndexOf(".")+1) + 
          "|entry.1188224461=" + bMetaDataCallback + 
          "|entry.727360894=" + currentTimeLoad + 
          "|entry.1846932672=" + bWentFullscreen + 
          "|entry.1928928792=" + minimizeChoice + 
          "|entry.1790986671=" + videoLoadTime + 
          "|entry.667865474=" + formatTime(timeOffset/1000, false)+ 
          "|entry.1780703514=" + bVideoLoaded + 
          "|entry.270402597=" + launchVideo.readyState + 
          "|entry.676247940=" + percentLoaded + 
          "|entry.347156140=" + duration + 
          "|entry.1104133842=" + ascentDelta + 
          "|entry.934368621=" + launchVideo.textTracks.length + 
          "|entry.569001242=" + ascentFPS + 
          "|entry.181114524=" + lowestFPS + 
          "|entry.828457361=" + bTimeDilation + 
          "|entry.1280394113=" + bTimeRecovered; 
        urlReload += surveyURL;
      }
      window.location.href = urlReload;
    }
    
    // have we reached a new scheduled launch posting?
    if (bFutureLaunch && UT >= nextLaunchSched) {
      window.location.href = urlReload;
    }
    
    // have we reached a new scheduled maneuver posting?
    if (bFutureManeuver && UT >= nextManeuverSched) {
      window.location.href = urlReload;
    }
    
    // is there new orbital data to calculate?
    if (bOrbitalDataRefresh && !bPastUT && UT >= orbitalDataRefreshUT) {
      window.location.href = urlReload;
    }
    
    // update orbital data if needed
    if (mapState == "orbit") {

      // update our cardinal directions if either a dynamic map or overlay is active
      // make sure we don't overstep array bounds if a maneuver went off and left us waiting for an update
      if ((bDrawMap || $("#orbData").length) && now < latlon.length) {
        if (latlon[now].lat < 0) {
          cardinalLat = "S";
        } else {
          cardinalLat = "N";
        }
        if (latlon[now].lng < 0) {
          cardinalLon = "W";
        } else {
          cardinalLon = "E";
        }
      }
      
      // make sure dynamic map is rendered before we bother updating it
      if (bDrawMap && bMapRender) {

        // only update if a maneuver node hasn't executed and rendered all this invalid
        // number formatting done with Numeral.js - http://numeraljs.com/
        if (!bNodeExecution) {
        
          // update craft position and popup content
          craft.setLatLng(latlon[now]);
          $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinalLat);
          $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinalLon);
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + "km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + "km/s");
          
          // update the Ap/Pe marker popup content
          $('#apTime').html("Time to Apoapsis<br>" + formatTime(apTime-now), false);
          $('#peTime').html("Time to Periapsis<br>" + formatTime(peTime-now), false);
          
          // update maneuver node popup content
          if (bUpcomingNode) { $('#nodeTime').html("Time to Maneuver<br>" + formatTime((nodeUT - initialUT)-now), false); }

          // update our Ap/Pe times if we've passed one by just adding on the orbital period
          // remove the marker entirely if it's past the end of the current plot
          if (now > apTime && apTime >= 0) {
            apTime += Math.round(period);
            if (apTime <= latlon.length) {
              apMark.setLatLng(latlon[apTime]);
            } else {
              map.removeLayer(apMark);
              apTime = -1; 
            }
          }
          if (now > peTime && peTime >= 0) {
            peTime += Math.round(period);
            if (peTime <= latlon.length) {
              peMark.setLatLng(latlon[peTime]);
            } else {
              map.removeLayer(peMark);
              peTime = -1; 
            }
          }
          
          // check if there was a maneuver node that went off
          // if it did, remove the node, stop updating the craft marker & show/update the popup
          if (bUpcomingNode && !bNodeExecution && (nodeUT - initialUT)-now <= 0) {
            map.removeLayer(nodeMark);
            bNodeExecution = true;
            craft.unbindPopup();
            craft.bindPopup("<center>Maneuver node executed<br>Awaiting new orbital data<br>Standy, page will auto update</center>", {closeButton: false});
            craft.openPopup();
          }	
        }
        
      // we have an orbital overlay to update, no dynamic map content
      } else if ($("#orbData").length) {
        $('#orbData').html(
          "Lat: " + numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinalLat + "<br>" +
          "Lng: " + numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinalLon + "<br>" +
          "Alt: " + numeral(orbitdata[now].alt).format('0,0.000') + "km" + "<br>" +
          "Vel: " + numeral(orbitdata[now].vel).format('0,0.000') + "km/s" + "<br>" +
          "Time to Ap: " + formatTime(apTime-now, false) + "<br>" +
          "Time to Pe: " + formatTime(peTime-now, false));
          
        // show the orbital data if it is hidden, when it's been calculated
        if ($('#orbData').css("display") == "none" && bMapRender) { $('#orbData').fadeToggle(); }
      }
    }
    
    // update MET/countdown clock if needed
    // this function is called immediately on page load, so all ++ operations should be performed second
    if (bUpdateMET) {
      $("#met").html(strMsg + formatTime(Math.abs(MET), false));
      MET++;
    }
    
    // update the estimated distance if needed
    if (bEstDst) {
      $("#distance").html(strAccDst + "<br>Estimated Current Total Distance Traveled: " + numeral(dstTraveled + (now * avgSpeed)).format('0,0') + "km");
    }
    
    // update the clock and any accompanying countdowns
    $('#ksctime').html(dd.toLocaleDateString() + ' ' + Date.toTZString(dd, 'E'));
    if (bLaunchCountdown) {
      
      // if this page isn't the craft that is launching (compare the db names), and we've reached 5min mark, notify user
      // also test for a case where we are on the same craft page, but looking at an older event (unless its the event prior to launch)
      if (Math.abs(launchSchedUT) == 300) {
        strDB = launchLink.substr(strDB.search("=")+1)
        if (strDB.localeCompare(getParameterByName('db')) != 0 || (strDB.localeCompare(getParameterByName('db')) && bPastUT && !bNextEventRefresh)) {
          //$("#msgLaunch").fadeToggle(); <-- keep around in case ppl complain they don't like the flight tracker stealing focus with a dialog prompt
          if (confirm(launchCraft + " is launching in 2mins!\nClick OK to view the launch, or Cancel to remain on this page")) {
            window.location.href = launchLink;
          }
        }
      }
      
      // only count down if there is something to countdown
      if (launchSchedUT < 0) {
        $('#tminuslaunch').html(formatTime(Math.abs(launchSchedUT), false));
        launchSchedUT++;
      }
      else {
        $('#tminuslaunch').html("LIFTOFF!!");
        bLaunchCountdown = false;
      }
    }
    if (bManeuverCountdown) {

      // only count down if thete is something to countdown
      if (maneuverUT < 0) {
        $('#tminusmaneuver').html(formatTime(Math.abs(maneuverUT), false));
        maneuverUT++;
      }
      else {
        $('#tminusmaneuver').html("Maneuver Executed");
        bManeuverCountdown = false;
      }
    }
    
    // update all dynamic tooltips
    Tipped.refresh(".tip-update");
    
    // do we have current streaming ascent data to track?
    if (bAscentActive) {
    
      // update the countdown if needed
      // launch is currently a live event
      if (!bPastUT) {
      
        // update the launch timer
        if (UT < telemetryUT) { 
          $("#launchMET").html(formatTime(launchUT - UT, false)); 
        }

        // kick off the telemetry when we reach the start of data
        if (UT == telemetryUT) { 
          ascentStartTime = new Date().getTime();
          bAscentPaused = false;
          ascentUpdater(Math.floor(ascentDelta), false); 
        }
        
        // update and monitor the launch video display
        if (bVideoLoaded) {
        
          // decide when to kick off the video, otherwise update the countdown
          if (videoStartUT == UT) {
            $("#mainwrapper").fadeOut();
            $("#videoCameraName").fadeIn();
            $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE");
            $("#videoStatus").css("top", "59px");
            launchVideo.play();
          } else if (videoStartUT > UT) {
            $("#videoStatus").html("Video feed begins in: " + formatTime(videoStartUT - UT, false));
          }

          // keep the video in sync up until telemetry begins, at which point it shouldn't have enough time to go out of sync
          if (!launchVideo.paused && UT + launchCountdown < telemetryUT) { 
            launchVideo.currentTime = Math.abs((videoStartUT - UT) - launchCountdown); 
          }
        }

      // past launch telemetry is being reviewed
      } else {
        if ((getParameterByName('ut')*1) + launchCountdown < telemetryUT) { 
          $("#launchMET").html(formatTime(launchUT - ((getParameterByName('ut')*1) + launchCountdown), false)); 
        }
        if ((getParameterByName('ut')*1) + launchCountdown == telemetryUT) { 
          ascentStartTime = new Date().getTime();
          ascentUpdater(Math.floor(ascentDelta), false); 
        }

        // update and monitor the launch video display
        if (bVideoLoaded && !bAscentPaused) {
        
          // decide when to kick off the video, otherwise update the countdown
          if ((videoStartUT - getParameterByName('ut')) - launchCountdown == 0) {
            $("#mainwrapper").fadeOut();
            $("#videoStatus").fadeOut();
            $("#videoCameraName").fadeIn();
            launchVideo.play();
          } else if (launchCountdown > 0) {
            $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
          }

          // keep the video in sync up until telemetry begins, at which point it shouldn't have enough time to go out of sync
          if (!launchVideo.paused && (getParameterByName('ut')*1) + launchCountdown < telemetryUT) { 
            launchVideo.currentTime = Math.abs((videoStartUT - getParameterByName('ut')) - launchCountdown); 
          }
        }

        // manually tick up the launch countdown so it decreases
        if (!bAscentPaused) { launchCountdown++; }
      }
    }
    
    // abort the video loading process if we're watching a live event and have passed the end of the video
    if (!bPastUT && UT >= telemetryUT + vidAscentLength  && !bVideoLoaded) {
      bVideoLoading = false;
      $("#spinner").fadeOut();
      $("#videoStatus").html("Live video feed expired<br>Video available after launch");
      setTimeout(function() { $("#videoStatus").fadeOut(); }, 10000);
    }

    // video loading progress to check?
    if (bVideoLoading) {
    
      // not bothering with event function because often cached video would skip the metadata callback
      if (launchVideo.readyState >= 3) {

        // we have enough data to get the video length and determine at what point it begins play back
        if (!vidLength && !videoStartUT) {
          vidLength = Math.round(launchVideo.duration);
          videoStartUT = telemetryUT + vidAscentLength - vidLength;
        }
     
        // if we've not done it already, add caption track - mainly because most mobile devices play fullscreen video only
        // despite being said it is supported by mobile Safari v7, it's really not
        // https://developer.mozilla.org/en-US/docs/Web/API/Web_Video_Text_Tracks_Format#Compatibility
        if (!launchVideo.textTracks.length && (browserDeets.search("Safari") == -1 || (browserDeets.search("Safari") >= 0 && majorVersion > 7))) {
          eventCaption = launchVideo.addTextTrack('captions', 'event', 'en-US');
          camCaption = launchVideo.addTextTrack('captions', 'camera', 'en-US');
          
          // add camera up until launch (this will need to be refactored if camera switches happen before launch)
          cue = new VTTCue(0, launchUT - videoStartUT - 0.001, ascentData[0].Camera);
          cue.line = 1;
          camCaption.addCue(cue);
          
          for (x=0; x<(launchUT - videoStartUT) + vidAscentLength; x++) {
            if (launchUT - (videoStartUT + x) > 0) {
              cue = new VTTCue(x, x + 0.999, 'T-' + formatTime(launchUT - (videoStartUT + x), false));
              cue.line = -2;
              eventCaption.addCue(cue);
            } else {
              cue = new VTTCue(x, x + 0.999, ascentData[(x - (launchUT - videoStartUT)) + (launchUT - telemetryUT)].Event);
              cue.line = -2;
              eventCaption.addCue(cue);
              cue = new VTTCue(x, x + 0.999, ascentData[(x - (launchUT - videoStartUT)) + (launchUT - telemetryUT)].Camera);
              cue.line = 1;
              camCaption.addCue(cue);
            }
          }
        }
           
        // check how much has been buffered
        // even if we jump late into the video and start buffering from there, duration will still match video length
        duration = 0;
        for (x=0; x<launchVideo.buffered.length; x++) {
          duration += launchVideo.buffered.end(x);
        }
        
        // update the status text
        percentLoaded = Math.round(100*(duration - launchVideo.currentTime)/(vidLength - launchVideo.currentTime));
        if (percentLoaded >= loadText[loadTextIndex].percent) {
          $("#loadText").html(loadText[loadTextIndex].text);
          if (loadTextIndex < loadText.length-1) { loadTextIndex++; }
        }

        // have we buffered all our video?
        if (duration >= launchVideo.duration) {
          bVideoLoading = false;
          bVideoLoaded = true;
          spinner.stop();
          videoLoadTime = formatTime((new Date().getTime() - videoLoadTime)/1000, true).replace(" ", "+");
          
          // decide whether to show the video countdown or the video itself
          if (ascentDelta > 0) {
          
            // we're still within the video playback range
            if (ascentDelta < vidAscentLength) {
            
              // set the video position to the current time and update/hide the status depending on whether this is a live launch or not
              launchVideo.currentTime = (telemetryUT - videoStartUT) + ascentDelta;
              $("#mainwrapper").fadeOut();
              $("#videoCameraName").fadeIn();
              if (!bPastUT) {
                $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE");
                $("#videoStatus").css("top", "59px");
                launchVideo.play();
              } else {
                $("#videoStatus").fadeOut();
                if (!bAscentPaused) { launchVideo.play(); }
              }
              
            // we're outside the playback range, this can only trigger on past events so user has seeked/played ahead
            } else {
              $("#videoStatus").html("Previous video data ready");
              setTimeout(function() { $("#videoStatus").fadeOut(); }, 3000);
            }
            
          // prior to telemetry data
          } else if (ascentDelta == 0 && launchCountdown >= 0) {
          
            // decide what value to use for the current time
            if (bPastUT) {
              refUT = getParameterByName('ut');
            } else {
              refUT = UT;
            }
            
            // do we need to cut to the video or show the countdown timer?
            if (launchCountdown >= videoStartUT - refUT) {  
              $("#mainwrapper").fadeOut();
              $("#videoCameraName").fadeIn();
              launchVideo.currentTime = Math.abs((videoStartUT - refUT) - launchCountdown);
              if (bPastUT) { 
                $("#videoStatus").fadeOut();
                if (!bAscentPaused) { launchVideo.play(); }
              } else {
                $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE");
                $("#videoStatus").css("top", "59px");
                launchVideo.play();
              }
            } else {
              $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - refUT) - launchCountdown, false));
            }
          }
        }
      }
    }

    // update the UT now that no other calculations depend on it being static
    UT++;

    // ensure timer accuracy, even catch up if browser slows tab in background
    // http://www.sitepoint.com/creating-accurate-timers-in-javascript/
    diff = (new Date().getTime() - tickStartTime) - tickDelta;
    tickDelta += 1000;
    setTimeout(tick, 1000 - diff);
  })();
</script>

<%
'clean up all previous connections
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
set adoxConn = nothing  
connEvent.Close
Set connEvent = nothing
%>

</body>
</html>