<!DOCTYPE html>

<!-- code/comments not formatted for word wrap -->

<%
'default to the main system overview if no body parameters supplied
if request.querystring("db") = "" then response.redirect "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbol-System"
%>

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/ajoNdn8.png" />

  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  
  <!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
  <link rel="stylesheet" type="text/css" href="../jslib/tipped.css" />
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto:900" />
  <link rel="stylesheet" type="text/css" href="https://unpkg.com/leaflet@0.5.1/dist/leaflet.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.ksp-src.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.label.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/iosbadge.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/Control.FullScreen.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.groupedlayercontrol.min.css" />

  <!-- JS libraries -->
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.5.1/leaflet-src.js"></script>
  <script type="text/javascript" src="../jslib/proj4js-combined.js"></script>
  <script type="text/javascript" src="../jslib/proj4leaflet.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.ksp-src.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.src.js"></script>
  <script type="text/javascript" src="../jslib/tipped.js"></script>
  <script type="text/javascript" src="../jslib/numeral.min.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.label.js"></script>
  <script type="text/javascript" src="../jslib/iosbadge.js"></script>
  <script type="text/javascript" src="../jslib/Control.FullScreen.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.groupedlayercontrol.min.js"></script>

  <script>
    // gets values for URL parameters of the same name and returns them in an array
    // http://stackoverflow.com/questions/22209307/how-to-get-multiple-parameters-with-same-name-from-a-url-in-javascript
    function getQueryParams(name) {
      qs = location.search;

      var params = [];
      var tokens;
      var re = /[?&]?([^=]+)=([^&]*)/g;

      while (tokens = re.exec(qs))
      { 
        if (decodeURIComponent(tokens[1]) == name)
        params.push(decodeURIComponent(tokens[2]));
      }

      return params;
    }
  
    // small helper function to make sure number calculated is not greater than a certain value
    function maxCalc(eq, val) {
      if (Math.abs(eq) > Math.abs(val)) { return val; } else { return eq; }
    }
    
    // get our platform properties
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

    // checks for cookies being enabled
    // http://stackoverflow.com/questions/2167310/how-to-show-a-message-only-if-cookies-are-disabled-in-browser
    function checkCookies() {
      var cookieEnabled = (navigator.cookieEnabled) ? true : false;
      if (typeof navigator.cookieEnabled == "undefined" && !cookieEnabled)
      { 
        document.cookie="testcookie";
        cookieEnabled = (document.cookie.indexOf("testcookie") != -1) ? true : false;
      }
      return (cookieEnabled);
    }

    // cookie scripts from http://www.w3schools.com/js/js_cookies.asp
    function setCookie(cname, cvalue, bset) {
      var d = new Date();
      var expires;
      
      // if true, the cookie is set for 5 years. If false, the cookie is deleted
      if (bset) { var exdays = 1825; }
      else { var exdays = 0; }
      d.setTime(d.getTime() + (exdays*24*60*60*1000));
      if (exdays) { expires = "expires="+d.toUTCString(); }
      else { expires = "expires=Thu, 18 Dec 2013 12:00:00 UTC"; }
      document.cookie = cname + "=" + cvalue + "; " + expires +"; path=/";
    }
    function getCookie(cname) {
      var name = cname + "=";
      var ca = document.cookie.split(';');
      console.log(ca);
      for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
      }
      return "";
    }
    
    // checks if this is a first-time visitor and acts accordingly
    var bNewUser = false;
    function checkVisitor() {
      if (checkCookies()) {
        var user = getCookie("username");
        if (user == "") {
          setCookie("username", "kerbal", true);
          bNewUser = true;
        }
      }
    }
    
    // for retrieving URL query strings
    // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    function getParameterByName(name) {
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
          results = regex.exec(location.search);
      return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }		
    
    // determine whether this is a touchscreen device for proper tooltip handling
    // http://ctrlq.org/code/19616-detect-touch-screen-javascript
    function is_touch_device() {
     return (('ontouchstart' in window)
          || (navigator.MaxTouchPoints > 0)
          || (navigator.msMaxTouchPoints > 0));
    }
    
    // take an amount of time in seconds and convert it to years, days, hours, minutes and seconds
    // leave out any values that are not necessary (0y, 0d won't show, for example)
    // give seconds to 5 significant digits if precision is true
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

    // this function will continually call itself to batch-run orbital calculations and not completely lock up the browser
    // used by the surface map to calculate ground plots
    function orbitalCalc() {
      if (endTime < 0) {
        
        // compute 1 orbit, or only up to a future maneuver node
        if (bodyCrafts[currCraft].Node >= 0) {
          if (bodyCrafts[currCraft].Node > 0) {
            endTime = currUT + (bodyCrafts[currCraft].Node - currUT);
            if (endTime - currUT > bodyCrafts[currCraft].ObtPd) { endTime = currUT + Math.round(bodyCrafts[currCraft].ObtPd); }
          } else {
            endTime = currUT + 1;
          }
        } else {
          endTime = currUT + Math.round(bodyCrafts[currCraft].ObtPd);
        }
        
        // don't by default exceed 100,000s to ensure computation completes in a reasonable amount of time
        var maxDeltaTime = 100000;
        if (endTime - currUT > maxDeltaTime) {
          endTime = currUT + maxDeltaTime;
          
          // in cases where the orbital period exceeds 100,000s we should inform the user the whole orbit is not being plotted
          if (bodyCrafts[currCraft].ObtPd > maxDeltaTime) { bTruncOrbit = true; }
        }
        
        // handle SOI escape orbits
        if (bodyCrafts[currCraft].ObtPd < 0) { endTime = Math.abs(bodyCrafts[currCraft].ObtPd); }
      }
      
      // calculate plots in batches of 1500 (each plot represents a second)
      for (x=0; x<=1500; x++) {
      
        //////////////////////
        // computeMeanMotion() <-- refers to a function in KSPTOT code: https://github.com/Arrowstar/ksptot
        //////////////////////
        
        // adjust for motion since the time of this orbit
        n = Math.sqrt(gmu/(Math.pow(Math.abs(bodyCrafts[currCraft].SMA),3)));
        var newMean = bodyCrafts[currCraft].Mean + n * (currUT - bodyCrafts[currCraft].Eph);

        ////////////////
        // solveKepler()
        ////////////////
        
        var EccA = -1;
        if (bodyCrafts[currCraft].Ecc < 1) {
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
            var Ens = En - (En-bodyCrafts[currCraft].Ecc*Math.sin(En) - newMean)/(1 - bodyCrafts[currCraft].Ecc*Math.cos(En));
            while (Math.abs(Ens-En) > 1E-10) {
              En = Ens;
              Ens = En - (En - bodyCrafts[currCraft].Ecc*Math.sin(En) - newMean)/(1 - bodyCrafts[currCraft].Ecc*Math.cos(En));
            }
            EccA = Ens;
          }
        
        // hyperbolic orbit
        } else {
          if (Math.abs(newMean - 0) < 1E-8) {
            EccA = 0;
          } else {
            
            ////////////////
            // keplerEqHyp()
            ////////////////
            
            if (bodyCrafts[currCraft].Ecc < 1.6) {
              if ((-Math.PI < newMean && newMean < 0) || newMean > Math.PI) {
                H = newMean - bodyCrafts[currCraft].Ecc;
              } else {
                H = newMean + bodyCrafts[currCraft].Ecc;
              }
            } else {
              if (bodyCrafts[currCraft].Ecc < 3.6 && Math.abs(newMean) > Math.PI) {
                H = newMean - Math.sign(newMean) * bodyCrafts[currCraft].Ecc;
              } else {
                H = newMean/(bodyCrafts[currCraft].Ecc - 1);
              }
            }
            
            Hn = newMean;
            Hn1 = H;
            while (Math.abs(Hn1 - Hn) > 1E-10) {
              Hn = Hn1;
              Hn1 = Hn + (newMean - bodyCrafts[currCraft].Ecc * Math.sinh(Hn) + Hn) / (bodyCrafts[currCraft].Ecc * Math.cosh(Hn) - 1);
            }
            
            EccA = Hn1;
          }
        }
        
        ///////////////////////////////
        // computeTrueAnomFromEccAnom()
        // computeTrueAnomFromHypAnom()
        ///////////////////////////////
        
        if (bodyCrafts[currCraft].Ecc < 1) {
          var upper = Math.sqrt(1+bodyCrafts[currCraft].Ecc) * Math.tan(EccA/2);
          var lower = Math.sqrt(1-bodyCrafts[currCraft].Ecc);

          // expanded AngleZero2Pi() function
          // abs(mod(real(Angle),2*pi));
          // javascript has a modulo operator, but it doesn't work the way we need. Or something
          // so using the mod() function implementation from Math.js: x - y * floor(x / y)
          var tru = Math.abs((Math.atan2(upper, lower) * 2) - (2*Math.PI) * Math.floor((Math.atan2(upper, lower) * 2) / (2*Math.PI)));
        } else {
          var upper = Math.sqrt(bodyCrafts[currCraft].Ecc+1) * Math.tanh(EccA/2);
          var lower = Math.sqrt(bodyCrafts[currCraft].Ecc-1);
          var tru = Math.atan2(upper, lower) * 2;
        }
        
        ///////////////////////////
        // getStatefromKepler_Alg()
        ///////////////////////////
        
        var raan = bodyCrafts[currCraft].RAAN;
        var arg = bodyCrafts[currCraft].Arg;

        // Special Case: Circular Equitorial
        if(bodyCrafts[currCraft].Ecc < 1E-10 && (bodyCrafts[currCraft].Inc < 1E-10 || Math.abs(bodyCrafts[currCraft].Inc-Math.PI) < 1E-10)) {
          var l = raan + arg + tru;
          tru = l;
          raan = 0;
          arg = 0;
        }

        // Special Case: Circular Inclined
        if(bodyCrafts[currCraft].Ecc < 1E-10 && bodyCrafts[currCraft].Inc >= 1E-10 && Math.abs(bodyCrafts[currCraft].Inc-Math.PI) >= 1E-10) {
          var u = arg + tru;
          tru = u;
          arg = 0.0;
        }

        // Special Case: Elliptical Equitorial
        if(bodyCrafts[currCraft].Ecc >= 1E-10 && (bodyCrafts[currCraft].Inc < 1E-10 || Math.abs(bodyCrafts[currCraft].Inc-Math.PI) < 1E-10)) {
          raan = 0;
        }

        var p = bodyCrafts[currCraft].SMA*(1-(Math.pow(bodyCrafts[currCraft].Ecc,2)));
        
        // vector/matrix operations handled by Sylvester - http://sylvester.jcoglan.com/
        var rPQW = $V([p*Math.cos(tru) / (1 + bodyCrafts[currCraft].Ecc*Math.cos(tru)),
                       p*Math.sin(tru) / (1 + bodyCrafts[currCraft].Ecc*Math.cos(tru)),
                       0]);
        var vPQW = $V([-Math.sqrt(gmu/p)*Math.sin(tru),
                       Math.sqrt(gmu/p)*(bodyCrafts[currCraft].Ecc + Math.cos(tru)),
                       0]);
        var TransMatrix = $M([
          [Math.cos(raan)*Math.cos(arg)-Math.sin(raan)*Math.sin(arg)*Math.cos(bodyCrafts[currCraft].Inc), -Math.cos(raan)*Math.sin(arg)-Math.sin(raan)*Math.cos(arg)*Math.cos(bodyCrafts[currCraft].Inc), Math.sin(raan)*Math.sin(bodyCrafts[currCraft].Inc)],
          [Math.sin(raan)*Math.cos(arg)+Math.cos(raan)*Math.sin(arg)*Math.cos(bodyCrafts[currCraft].Inc), -Math.sin(raan)*Math.sin(arg)+Math.cos(raan)*Math.cos(arg)*Math.cos(bodyCrafts[currCraft].Inc), -Math.cos(raan)*Math.sin(bodyCrafts[currCraft].Inc)],
          [Math.sin(arg)*Math.sin(bodyCrafts[currCraft].Inc), Math.cos(arg)*Math.sin(bodyCrafts[currCraft].Inc), Math.cos(bodyCrafts[currCraft].Inc)]
        ]);

        var rVect = TransMatrix.multiply(rPQW);
        var vVect = TransMatrix.multiply(vPQW);	

        /////////////////////
        // getBodySpinAngle()
        /////////////////////
        
        var bodySpinRate = 2*Math.PI/rotPeriod;

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
        var alt = rNorm - radius;
        var vel = Math.sqrt(gmu*(2/rNorm - 1/bodyCrafts[currCraft].SMA));
        
        // convert the lon to proper coordinates (-180 to 180)
        if (longitude >= 180) { longitude -= 360; }
        
        // store all the derived values and advance to the next second
        bodyCrafts[currCraft].Obt.push({Lat: latitude, Lng: longitude, Alt: alt, Vel: vel});
        currUT++;
        
        // exit the batch prematurely if we've reached the end of our needed calculations or if we just hit the atmosphere
        if ((currUT > endTime) || (alt <= bodiesCatalog[currBodyIndex].AtmoHeight)) { return true; }
      }
      
      // let the calling function know if we've completed all orbital calculations or not
      if (currUT > endTime) {
        return true; 
      } else {       
        return false;
      }
    }
    
    // controls drawing of all the orbital plots and markers for the various craft orbiting over this surface
    var pathPopup = null;
    function renderLayers() {
    
      // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
      var craftIcon = L.icon({
        iconUrl: 'button_vessel_' + types[currType].toLowerCase() + '.png',
        iconSize: [16, 16],
      });
      bodyCrafts[currCraft].Craft = L.marker([bodyCrafts[currCraft].Obt[0].Lat, bodyCrafts[currCraft].Obt[0].Lng], {icon: craftIcon, zIndexOffset: 100});

      // make it so we can tell what vessel this marker belongs to later on
      bodyCrafts[currCraft].Craft._myId = currCraft;
      
      // create the popup text and bind it to the marker
      strHTML = "<table style='border: 0px; border-collapse: collapse;'><tr><td style='vertical-align: top; width: 200px;'>";
      strHTML += "<img src='" + bodyCrafts[currCraft].Img + "' width='200px'>";
      if (bodyCrafts[currCraft].Type != "Moon") {
        strHTML += "<i><p>&quot;" + bodyCrafts[currCraft].Desc + "&quot;</p></i>";
        strHTML += "<p><a href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" + bodyCrafts[currCraft].DB + "'>View Craft Page</a></p>";
      }
      strHTML += "</td><td style='vertical-align: top;'><h1>" + bodyCrafts[currCraft].Name + "</h1><b>Current Orbital Data</b><p>";
      if (bodyCrafts[currCraft].Obt[0].Lat < 0) {
        cardinalLat = "S";
      } else {
        cardinalLat = "N";
      }
      if (bodyCrafts[currCraft].Obt[0].Lng < 0) {
        cardinalLon = "W";
      } else {
        cardinalLon = "E";
      }
      strHTML += "Lat: <span id='lat" + bodyCrafts[currCraft].DB + "'>" + numeral(bodyCrafts[currCraft].Obt[0].Lat).format('0.0000') + "&deg;" + cardinalLat + "</span><br>";
      strHTML += "Lng: <span id='lng" + bodyCrafts[currCraft].DB + "'>" + numeral(bodyCrafts[currCraft].Obt[0].Lng).format('0.0000') + "&deg;" + cardinalLon + "</span><br>";
      strHTML += "Alt: <span id='alt" + bodyCrafts[currCraft].DB + "'>" + numeral(bodyCrafts[currCraft].Obt[0].Alt).format('0,0.000') + " km</span><br>";
      strHTML += "Vel: <span id='vel" + bodyCrafts[currCraft].DB + "'>" + numeral(bodyCrafts[currCraft].Obt[0].Vel).format('0,0.000') + " km/s</span><br>";
      if (bodyCrafts[currCraft].ObtPd > 0) {
        strHTML += "Orbital period: " + formatTime(bodyCrafts[currCraft].ObtPd, true);
      } else {
        strHTML += "Orbital period: N/A";
      }
      if (bTruncOrbit) {
        bTruncOrbit = false;
        strHTML += "<br>(Orbital period is too long to render full orbit)";
      }
      if (bodyCrafts[currCraft].Node > 0 && bodyCrafts[currCraft].Node - UT < bodyCrafts[currCraft].Obt.length) {
        strHTML += "<br>Upcoming Maneuver:<br><span id='nodeTime" + bodyCrafts[currCraft].DB + "'>" + formatTime(bodyCrafts[currCraft].Node - UT, false) + "</span>";
      } else if (bodyCrafts[currCraft].Node == 0) {
        strHTML += "<br>Maneuver Underway";
      }
      if (bodyCrafts[currCraft].ObtPd < 0) {
        strHTML += "<br>Upcoming SOI Exit:<br><span id='soiTime" + bodyCrafts[currCraft].DB + "'>" + formatTime(Math.abs(bodyCrafts[currCraft].ObtPd) - UT, false) + "</span>";
      }
      strHTML += "</p></td></tr></table>";
      bodyCrafts[currCraft].Craft.bindPopup(strHTML, {closeButton: false, maxWidth: 500});
      
      // add this marker to the current layer being collected for rendering
      overlays[currType].addLayer(bodyCrafts[currCraft].Craft);
      
      // draw the orbital path
      var coord = 0;
      while (coord < bodyCrafts[currCraft].Obt.length) {
        var path = [];
        while (coord < bodyCrafts[currCraft].Obt.length) {
        
          // create a new array entry for this location, then advance the array counter
          path.push({lat: bodyCrafts[currCraft].Obt[coord].Lat, lng: bodyCrafts[currCraft].Obt[coord].Lng});
          coord++;

          // detect if we've crossed off the edge of the map and need to cut the orbital line
          // compare this lng to the prev and if it changed from negative to positive or vice versa, we hit the edge  
          // (check if the lng is over 100 to prevent detecting a sign change while crossing the meridian)
          if (coord < bodyCrafts[currCraft].Obt.length) {
            if (((bodyCrafts[currCraft].Obt[coord].Lng < 0 && bodyCrafts[currCraft].Obt[coord-1].Lng > 0) && Math.abs(bodyCrafts[currCraft].Obt[coord].Lng) > 100) || ((bodyCrafts[currCraft].Obt[coord].Lng > 0 && bodyCrafts[currCraft].Obt[coord-1].Lng < 0) && Math.abs(bodyCrafts[currCraft].Obt[coord].Lng) > 100)) { break; }
          }
        }
        
        // create the path for this orbit
        // line color does not match label color in the case of moons
        if (bodyCrafts[currCraft].Type != "Moon") {
          bodyCrafts[currCraft].Paths.push(L.polyline(path, {smoothFactor: 1.25, clickable: true, color: colors[currType], weight: 3, opacity: 1}));
        } else {
          bodyCrafts[currCraft].Paths.push(L.polyline(path, {smoothFactor: 1.25, clickable: true, color: bodyCrafts[currCraft].Color, weight: 3, opacity: 1}));
        }
        
        // make it so we can tell what vessel this line belongs to later on
        bodyCrafts[currCraft].Paths[bodyCrafts[currCraft].Paths.length-1]._myId = currCraft;
        
        // add this line to the current layer being collected for rendering
        overlays[currType].addLayer(bodyCrafts[currCraft].Paths[bodyCrafts[currCraft].Paths.length-1]);
        
        // callback function that opens the popup that was bound to the marker that is following this line
        bodyCrafts[currCraft].Paths[bodyCrafts[currCraft].Paths.length-1].on('click', function(e) {
          bodyCrafts[e.target._myId].Craft.openPopup();
        });
      }

      // atmo entry?
      if (bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Alt <= bodiesCatalog[currBodyIndex].AtmoHeight) {
        
        // create the icon for our atmo entry point, taken from the Squad asset file
        var atmoEntryIcon = L.icon({
          iconUrl: 'soientry.png',
          iconSize: [16, 12],
          iconAnchor: [9, 6]
        });
        
        // add the icon to the map
        atmoMark = L.marker([bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lat, bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lng], {icon: atmoEntryIcon});
        overlays[currType].addLayer(atmoMark);

        // save the craft ID so we can open its popup when the node marker is clicked
        atmoMark._myId = currCraft;
        atmoMark.on('click', function(e) {
          bodyCrafts[e.target._myId].Craft.openPopup();
        });
      }

      // check if we have an upcoming or active maneuver node, check that it can be drawn along our orbit and do so if possible
      if (bodyCrafts[currCraft].Node >= 0) {
      
        // create the icon for our maneuver node, taken from the Squad asset file
        var nodeIcon = L.icon({
          iconUrl: 'node.png',
          iconSize: [16, 16],
          iconAnchor: [8, 8]
        });
          
        // upcoming node. Make sure it is visible along this plot
        if (bodyCrafts[currCraft].Node > 0 && bodyCrafts[currCraft].Node - UT < bodyCrafts[currCraft].Obt.length) {

          // add the icon to the map 
          nodeMark = L.marker([bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lat, bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lng], {icon: nodeIcon});
          overlays[currType].addLayer(nodeMark);
          
          // save the craft ID so we can open its popup when the node marker is clicked
          nodeMark._myId = currCraft;
          nodeMark.on('click', function(e) {
            bodyCrafts[e.target._myId].Craft.openPopup();
          });
          
        // active node
        } else if (bodyCrafts[currCraft].Node == 0) {
        
          // add the icon to the map 
          nodeMark = L.marker([bodyCrafts[currCraft].Obt[0].Lat, bodyCrafts[currCraft].Obt[0].Lng], {icon: nodeIcon, clickable: false}).addTo(map);
        }
      }
      
      // SOI exit event?
      if (bodyCrafts[currCraft].ObtPd < 0) {
      
        // create the icon for our exit marker, taken from the Squad asset file
        var SOIExitIcon = L.icon({
          iconUrl: 'soiexit.png',
          iconSize: [16, 12],
          iconAnchor: [9, 6]
        });
        
        // add the icon to the map and create the information popup for it
        SOIMark = L.marker([bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lat, bodyCrafts[currCraft].Obt[bodyCrafts[currCraft].Obt.length-1].Lng], {icon: SOIExitIcon});
        overlays[currType].addLayer(SOIMark);
        
        // save the craft ID so we can open its popup when the node marker is clicked
        SOIMark._myId = currCraft;
        SOIMark.on('click', function(e) {
          bodyCrafts[e.target._myId].Craft.openPopup();
        });
      }
      
      // reset data needed for the next calculation and declare vessel loaded
      currUT = initialUT;
      endTime = -1;
      bodyCrafts[currCraft].Loaded = true;
    }

    // callback function that renders a single orbit for a single vessel
    function renderVesselOrbit() {
      if (orbitalCalc()) {
        renderLayers();
        currCraft = -1;
      } else {
        setTimeout(renderVesselOrbit, 1);
      }
    }
    
    // callback function that renders a single orbit for multiple vessels when initially loading the surface map
    var bCraftAdded = false;
    var showLayers = getParameterByName("layers").toLowerCase().split(','); 
    function renderVesselsOrbit() {

      // loop through all orbiting vessel types and all craft for each type
      if (currType < types.length) {
        if (currCraft < bodyCrafts.length) {
        
          // check if this craft matches the current type of vessel we are looking to render as a group
          if (bodyCrafts[currCraft].Type == types[currType]) {
            bCraftAdded = true;
            
            // call calculation batches to determine the craft ground plot, render it when it is ready
            if (orbitalCalc()) {
              renderLayers();
              bodyCrafts[currCraft].Layer = currType;
              currCraft++;
            } 
            setTimeout(renderVesselsOrbit, 1);
            
          // skip this craft and invalidate endTime to signal its availablity for use with renderVesselOrbit()
          } else {
            currCraft++;
            endTime = -1;
            setTimeout(renderVesselsOrbit, 1);
          }
          
        // we've run out of crafts to look at, so remove the temporary layer and add the group of paths/markers we just created, if any
        } else {
          layerControl.removeLayer(plzWait);
          if (bCraftAdded) {
          
            // probe green needs better contrast for map vs. layer control so diff shades of green for plot vs. text
            if (types[currType] == "Probe") {
              var txtColor = probeTxtClr;
            } else {
              var txtColor = colors[currType];
            }
            layerControl.addOverlay(overlays[currType], "<img src='button_vessel_" + types[currType] + ".png' width='10px' style='vertical-align: 1px;'> <span style='color: " + txtColor + ";'>" + types[currType] + "</span>", "Orbital Plots");
            bCraftAdded = false;
            
            // if there is a layers URL variable, see if any of the layer names match this one and show it if so
            if (showLayers.length) {
              for (l=0; l<showLayers.length; l++) {
                if (types[currType].toLowerCase() == showLayers[l]) { overlays[currType].addTo(map); }
              }
            }
          }
          
          // if there are more types to look at, update & reset to prep for the next group
          if (currType < types.length) {
            plzWait = L.layerGroup();
            layerControl.addOverlay(plzWait, "Loading orbits...", "Orbital Plots");
            overlays.push(L.layerGroup());
            currType++;
            currCraft = 0;
            setTimeout(renderVesselsOrbit, 1);
          }
        }
        
      // we've run out of types to look at
      // remove the temp layer and invalidate currCraft to signal its availablity for use with renderVesselOrbit()
      } else { 
        layerControl.removeLayer(plzWait); 
        currCraft = -1;
      }
    }

    // searches the catalog for any moons of the current body and appends them to the vessel list for rendering
    function findMoons() {

      // don't bother checking if currBodyIndex was never assigned
      if (!currBodyIndex) { return false; }
      
      // does this planet even have moons?
      if (!bodiesCatalog[currBodyIndex].Moons.length) { return false; }

      // ok, we have moons - locate them and save their orbital data
      for (x=0; x<bodyObtData.length; x++) {
        if (bodiesCatalog[currBodyIndex].Moons.includes(bodyObtData[x].Body)) {
          bodyCrafts.push({Type: "Moon",
                          DB: bodyObtData[x].Body,
                          Name: bodyObtData[x].Body,
                          Img: bodiesCatalog[x].Image,
                          Ecc: bodyObtData[x].Ecc,
                          Inc: bodyObtData[x].Inc * .017453292519943295, 
                          SMA: bodyObtData[x].SMA,
                          RAAN: bodyObtData[x].RAAN * .017453292519943295,
                          Arg: bodyObtData[x].Arg * .017453292519943295,
                          Mean: bodyObtData[x].Mean * .017453292519943295,
                          ObtPd: parseFloat(bodiesCatalog[x].ObtPeriod),
                          Eph: 0,
                          Node: -1,
                          Color: bodyObtData[x].Color,
                          Orbits: 0,
                          Layer: -1,
                          Obt: [],
                          Loaded: false,
                          Paths: [],
                          Craft: ''});
        }
      }
      return true;
    }
    
    // set up for AJAX requests
    // http://www.w3schools.com/ajax/
    var ajaxCraftData;
    var ajaxUpdate;
    if (window.XMLHttpRequest) {
      ajaxCraftData = new XMLHttpRequest();
      ajaxUpdate = new XMLHttpRequest();
    } else {
      // code for IE6, IE5
      ajaxCraftData = new ActiveXObject("Microsoft.XMLHTTP");
      ajaxUpdate = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    // don't allow AJAX to cache data, which mainly screws up requests for updated vessel times for notifications
    $.ajaxSetup({ cache: false });  
    
    // handle requests for current craft information, used to display rich tooltip content
    var bodyCrafts = [];
    var craftQuery = [];
    ajaxCraftData.onreadystatechange = function() {
      if (ajaxCraftData.readyState == 4 && ajaxCraftData.status == 200) {
        if (ajaxCraftData.responseText== "!") {
          console.log("bad request sent!");
        } else {
        
          // seperate the various craft that were returned by the request and parse them individually
          // first value is not a craft! Start at index 1
          crafts = ajaxCraftData.responseText.split("|");
          for (x=1; x<crafts.length; x++) {
            craftInfo = crafts[x].split(";");
            var craftIndex;
            
            // find the associated craft in the compiled catalog that contains additional data
            // could really just include this in the AJAX response
            for (craftIndex=0; craftIndex<craftsCatalog.length; craftIndex++) {
              if (craftInfo[0] == craftsCatalog[craftIndex].DB) { break; }
            }
            
            // create the HTML for the tooltip that describes the craft details
            strHTML = "<table style='border: 0px; border-collapse: collapse;'><tr><td style='vertical-align: top; width: 256px;'>";
            if (craftInfo[1] != 'null') {
              strHTML += "<img src='" + craftInfo[1] + "' width='256px'>";
            } else {
              strHTML += "<img src='nada.png' width='256px'>";
            }
            strHTML += "<i><p>&quot;" + craftsCatalog[craftIndex].Desc.replace(/'/g, "&#39;") + "&quot;</p></i></td>";
            strHTML += "<td style='vertical-align: top;'><h1>" + craftsCatalog[craftIndex].Name + "</h1><b>Orbital Data</b><p>";
            strHTML += "Apoapsis: " + craftInfo[2] + " m<br>";
            strHTML += "Periapsis: " + craftInfo[3] + " m<br>";
            strHTML += "Eccentricity: " + craftInfo[4] + "<br>";
            strHTML += "Inclination: " + craftInfo[5] + "&deg;<br>";
            strHTML += "Orbital period: " + craftInfo[6] + "<br>";
            strHTML += "Orbital velocity: " + craftInfo[7] + " m/s</p><p><b>Craft Data</b></p><p>";
            strHTML += craftInfo[8] + ": " + craftInfo[9] + "<br>";
            strHTML += "MET: " + craftInfo[10] + "<br>";
            letter = craftsCatalog[craftIndex].Type.substr(0,1);
            letter = letter.toUpperCase();
            strType = letter + craftsCatalog[craftIndex].Type.substr(1,craftsCatalog[craftIndex].Type.length-1);
            strHTML += "Designator: " + strType + "<br>";
            strHTML += "Mass: " + craftInfo[11] + " t<br>";
            strHTML += "Resource Mass: " + craftInfo[12] + "<br>";
            strHTML += "DeltaV: " + craftInfo[13] + "<br>";
            strHTML += "Crew: " + craftInfo[14] + "<br>";
            if (craftInfo[16] > 0.002) {
              strHTML += "Signal Delay: " + formatTime(craftInfo[16], true) + "<br>";
            } else if (craftInfo[16] == 0) {
              strHTML += "Signal Delay: N/A<br>";
            } else {
              strHTML += "Signal Delay: <0.002s<br>";
            }
            strHTML += "Last Updated: " + craftInfo[15] + "</p></td></tr></table>";
            
            // search for multiple instances of the craft represented on the orbital diagram to assign the content to
            $("area").each(function(index) {
            
              // we have to hack our own tooltips in other browsers so only redo the title attribute in Firefox
              if (browserName == "Firefox") {
                if ($(this ).attr("title") == "#" + craftsCatalog[craftIndex].DB) { $(this).attr("title", strHTML); }
                
              // for other browsers we are going to move the data to the alt tag so it doesn't create a tooltip
              // and we can use it to plug the data into a dynamic tooltip attached to a div that moves over the cursor location
              } else {
                if ($(this ).attr("title") == "#" + craftsCatalog[craftIndex].DB) { 
                  $(this).attr("title", ""); 
                  $(this).attr("alt", strHTML); 
                }
              }
            });
            
            // save data for loading the ground map, don't allow dupes and don't allow non-orbiting vessels (tests for valid SMA)
            if (!isNaN(craftInfo[21])) {
              var testCount = 0;
              for (; testCount<bodyCrafts.length; testCount++) {
                if (bodyCrafts[testCount].DB == craftsCatalog[craftIndex].DB) { break; }
              }
              if (testCount == bodyCrafts.length && craftInfo[18] != "null") {
                bodyCrafts.push({Type: strType,
                                DB: craftsCatalog[craftIndex].DB,
                                Img: craftInfo[1],
                                Desc: craftsCatalog[craftIndex].Desc.replace(/'/g, "&#39;"),
                                Name: craftsCatalog[craftIndex].Name,
                                Node: parseInt(craftInfo[17]),
                                Ecc: parseFloat(craftInfo[18]),
                                Inc: parseFloat(craftInfo[19]) * .017453292519943295, // OMG forgetting to convert to rad is a mistake made too often
                                ObtPd: parseFloat(craftInfo[20]),
                                SMA: parseFloat(craftInfo[21]),
                                RAAN: parseFloat(craftInfo[22]) * .017453292519943295,
                                Arg: parseFloat(craftInfo[23]) * .017453292519943295,
                                Mean: parseFloat(craftInfo[24]) * .017453292519943295,
                                Eph: parseFloat(craftInfo[25]),
                                Orbits: 0,
                                Layer: -1,
                                Obt: [],
                                Loaded: false,
                                Paths: [],
                                Craft: ''});
              }
            }
          }
          
          // behavior of the tooltip depends on the device
          if (is_touch_device()) {
            var showOpt = 'click';
          } else {
            var showOpt = 'mouseenter';
          }

          // create all the tooltips using Tipped.js - http://www.tippedjs.com/
          Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
          Tipped.create('.tip-update', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
                    
          // load the orbits for the surface map, if there is one
          // http://stackoverflow.com/questions/5219105/javascript-parsing-a-string-boolean-value
          var hasSurfaceMap = crafts[0] == 'true';
          if (hasSurfaceMap) {
            findMoons();
            renderVesselsOrbit();
          }
        }
      }
    };
  
    // handle requests for update information to show notification badges
    ajaxUpdate.onreadystatechange = function() {
      if (ajaxUpdate.readyState == 4 && ajaxUpdate.status == 200) {

        // separate the craft and crew strings and parse them
        updates = ajaxUpdate.responseText.split("|");
        crafts = updates[0].split(":");
        crew = updates[1].split(":");

        // parse & handle all craft instances
        for (x=0; x<crafts.length; x++) {
          if (crafts[x] != "null" && crafts[x] != "") {
            craftInfo = crafts[x].split(";");
            
            // check if this craft was already viewed before
            if (getCookie(craftInfo[0])) {
            
              // if there was a change to any of its records, tally up the amount
              // add a badge to the craft menu item, and also the planet (and moon if required) it is orbiting
              if (parseInt(getCookie(craftInfo[0])) < parseInt(craftInfo[1])) {
                $("#" + craftInfo[0]).iosbadge({ theme: 'red', size: 20, content: 'Update',  position: 'top-left' });
                $("#" + craftInfo[2]).iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
                if (craftInfo[3] != "null") { $("#" + craftInfo[3]).iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' }); }
              }
            } else {
            
              // this is a new craft - but if it's also a new user's first visit then no point notifying them
              if (bNewUser) {
                setCookie(craftInfo[0], craftInfo[1], true);
              } else {
                $("#" + craftInfo[0]).iosbadge({ theme: 'red', size: 20, content: 'New',  position: 'top-left' });
                $("#" + craftInfo[2]).iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
                if (craftInfo[3] != "null") { $("#" + craftInfo[3]).iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' }); }
              }
            }
          }
        }
        
        // parse & handle all crew instances
        for (x=0; x<crew.length; x++) {
          kerbalInfo = crew[x].split(";");
          if (getCookie(kerbalInfo[0])) {
            if (parseInt(getCookie(kerbalInfo[0])) < parseInt(kerbalInfo[1])) {

              // tally up the changes to show on the menu item that links to the Crew Roster
              $("#crewRoster").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
            }
          } else {
            if (bNewUser) {
              setCookie(kerbalInfo[0], kerbalInfo[1], true);
            } else {
              $("#crewRoster").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
            }
          }
        }
      }
    };

    // JQuery setup
    var bCreateTips = true;
    $(document).ready(function(){
      
      // support for image map tooltips with Tipped outside of Firefox
      $("area").hover(function() { 
      
        // HTML data is stashed in the alt attribute so other browsers don't show their own tooltip
        if (browserName != "Firefox" && $(this).attr("alt") && $(this).attr("alt") != "map") { 
          $("#mapTipData").html($(this).attr("alt"));
          
          // get the coordinate data for the area and size/center the div around it
          // div containing image map is below the title header, so offset must be applied
          // div containing all content is left-margin: auto to center on page, so offset must be applied
          areaCenter = $(this).attr("coords").split(",");
          $("#mapTip").css("width", parseInt(areaCenter[2])*2);
          $("#mapTip").css("height", parseInt(areaCenter[2])*2);
          $("#mapTip").css("top", parseInt(areaCenter[1])+47-parseInt(areaCenter[2]));
          $("#mapTip").css("left", parseInt(areaCenter[0])+$("#mainContent").position().left-parseInt(areaCenter[2]));

          // if we need to link to another page
          if (!$(this).attr("href")) {
            $("#mapTip").css("cursor", "default");
          } else {
            $("#mapTip").attr("href", $(this).attr("href"));
            $("#mapTip").css("cursor", "pointer");
          }
          $("#mapTip").show();
        }
      }, function() {
      
        // called once the div is shown atop this
        Tipped.refresh(".tip-update");
      });

      // Non-Firefox only - click through to a link on the image map
      $("#mapTip").click(function() { 
        if (browserName != "Firefox" && $("#mapTip").css("cursor") == "pointer") { window.location.href = $("#mapTip").attr("href"); }
      });
      
      // check every <area> tag on the page for body/craft rich content tooltip insertions
      $("area").each(function( index ) {
      
        // this tooltip should hold body data, which remains static so just pull from the DB single entry
        // this could all be wrapped up into its own AJAX call as well
        if ($(this ).attr("title").substr(0,1) == "%") {
          strBodyName = $(this ).attr("title").substr(1,$(this ).attr("title").length-1);
          strHTML = "<table style='border: 0px; border-collapse: collapse;'><tr><td style='vertical-align: top; width: 256px;'>";
          var bodyIndex;
          for (bodyIndex=0; bodyIndex<bodiesCatalog.length; bodyIndex++) {
            if (strBodyName == bodiesCatalog[bodyIndex].Name) { break; }
          }
          strHTML += "<img src='" + bodiesCatalog[bodyIndex].Image + "'>";
          strHTML += "<i><p>&quot;" + bodiesCatalog[bodyIndex].Desc + "&quot;</p></i><p><b>- Kerbal Astronomical Society</b></p></td>";
          strHTML += "<td style='vertical-align: top;'><h1>" + bodiesCatalog[bodyIndex].Name + "</h1><b>Orbital Data</b>";
          strHTML += "<p>Apoapsis: " + bodiesCatalog[bodyIndex].Ap + " m<br>";
          strHTML += "Periapsis: " + bodiesCatalog[bodyIndex].Pe + " m<br>";
          strHTML += "Eccentricity: " + bodiesCatalog[bodyIndex].Ecc + "<br>";
          strHTML += "Inclination: "+ bodiesCatalog[bodyIndex].Inc + "&deg;<br>";
          strHTML += "Orbital period: " + formatTime(bodiesCatalog[bodyIndex].ObtPeriod, false) + "<br>";
          strHTML += "Orbital velocity: " + bodiesCatalog[bodyIndex].ObtVel + " m/s</p><p><b>Physical Data</b></p>";
          strHTML += "<p>Equatorial radius: " + numeral(bodiesCatalog[bodyIndex].EqRad*1000).format('0,0') + " m<br>";
          strHTML += "Mass: " + bodiesCatalog[bodyIndex].Mass + "x10 kg<br>";
          strHTML += "Density: " + bodiesCatalog[bodyIndex].Mass + " kg/m<sup>3</sup><br>";
          gravity = bodiesCatalog[bodyIndex].SurfaceG.split(":");
          strHTML += "Surface gravity: " + gravity[0] + " m/s<sup>2</sup> <i>(" + gravity[1] + " g)</i><br>";
          strHTML += "Escape velocity: " + bodiesCatalog[bodyIndex].EscapeVel + " m/s<br>";
          strHTML += "Rotational period: " + formatTime(bodiesCatalog[bodyIndex].SolDay, true) + "<br>";
          strHTML += "Atmosphere: " + bodiesCatalog[bodyIndex].Atmo + "</p>";
          if (bodiesCatalog[bodyIndex].Moons) { strHTML += "<p><b>Moons</b></p><p>" + bodiesCatalog[bodyIndex].Moons + "</p>"; }
          strHTML += "</td></tr></table>";
          
          // we have to hack our own tooltips in other browsers so only redo the title attribute in Firefox
          if (browserName == "Firefox") {
            $(this ).attr("title", strHTML);
            
          // for other browsers we are going to move the data to the alt tag so they don't create a tooltip
          // and we can use it to plug the data into a dynamic tooltip attached to a div that moves over the cursor location
          } else {
            $(this).attr("title", ""); 
            $(this).attr("alt", strHTML); 
          }
          
          // if this tag doesn't have an href attribute, don't let people think there is a link to click through to
          if (!$(this).attr("href")) { $(this).css("cursor", "default"); }
          
        // this tooltip should hold craft data. Craft data can change often, so we need to AJAX query the latest record
        // hold off on initializing the tooltips until the AJAX request is completed
        } else if ($(this).attr("title").substr(0,1) == "#") {
          $(this).attr("href", "http://www.kerbalspace.agency/Tracker/craft.asp?db=" + $(this).attr("title").substr(1, $(this).attr("title").length));
          bCreateTips = false;
        }
      });      
        
      // check every <img> tag on the page
      $("img").each(function( index ) {
      
        // check for a surface map link and make it able to show the surface map
        if ($(this).attr("usemap") && $(this).attr("usemap") == "#map") {
          $(this).attr("id", "orbitImg");
        }
      });
      
      // create the tooltips if we're not waiting on an AJAX request for any craft details  
      if (bCreateTips) {
      
        // behavior of the tooltip depends on the device
        if (is_touch_device()) {
          var showOpt = 'click';
        } else {
          var showOpt = 'mouseenter';
        }
        
        // create all the tooltips using Tipped.js - http://www.tippedjs.com/
        Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
        Tipped.create('.tip-update', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
      }
         
      // check on cookies
      if (checkCookies()) {
        checkVisitor();
        if (bNewUser) {
          // display a welcome dialog with link to the Wiki
          $('#intro').fadeIn();
        }
      }
      
      // remove welcome message
      $('#dismissIntro').click(function() { $('#intro').fadeOut(); });

      // determines whether the area on the image map that was clicked is for the surface map and shows/hides elements as appropriate
      // http://stackoverflow.com/questions/2409836/how-to-set-cursor-style-to-pointer-for-links-without-hrefs
      $("map[name=map] area").click(function () {
        if ($(this).attr('alt') == "map") {
          $("#map").css("visibility", "visible");
          $("#close").css("visibility", "visible");
          $("#kscflags").css("visibility", "visible");
          $("#orbitImg").css("display", "none");
          $("#mapholder").css("display", "block");
          $("#key").css("visibility", "hidden");
          $("#utc").css("visibility", "hidden");
        }
      });

      // open new windows for related website entries/flickr photos
      $("#tagData").click(function () {
        window.open("http://www.kerbalspace.agency/?tag=" + tagData.replace(/ /g, "-"));
        window.open("https://www.flickr.com/search/?user_id=kerbal_space_agency&tags=" + tagData + "&view_all=1");
      });

      // close button for surface map, hides either map or KSC image depending on situation
      $("#close").click(function(){
        if ($("#map").css("visibility") == "visible")
        {
          // hack for other browsers because hiding the map for some reason no longer makes the tooltip <div> accessible
          // so just reload the page, minus the show map flag if it is included
          if (browserName != "Firefox") { window.location.href = window.location.href.replace("&map=true", ""); }
          $("#map").css("visibility", "hidden");
          $("#close").css("visibility", "hidden");
          $("#kscflags").css("visibility", "hidden");
          $("#orbitImg").css("display", "block");
          $("#key").css("visibility", "visible");
          $("#utc").css("visibility", "visible");
          $("#mapholder").css("display", "none");
        }
        else if ($("#map").css("visibility") == "hidden")
        {
          $("#map").css("visibility", "visible");
          $("#kscflags").css("visibility", "visible");
          $("#mapholder").css("display", "block");
          $("#kscflagsimg").css("display", "none");
          $(".leaflet-control-info").fadeOut();
          $(".leaflet-control-zoom").fadeOut();
          $(".leaflet-control-layers").fadeOut();
        }
      });

      // http://stackoverflow.com/questions/3442322/jquery-checkbox-event-handling
      $('#remindLaunch').click(function() {
        
        // $this will contain a reference to the checkbox   
        var $this = $(this);
        if ($this.is(':checked')) {
        
          // if the user doesn't have cookies enabled, warn them of the consequences
          if (!checkCookies()) { 
            $('#launchWarn').fadeIn(); 
          } else {
            setCookie("launchReminder", launchCraft, true);
          }
          bLaunchRemind = true;
        } else {
        
          // nevermind! clear out any cookie warning and the cookie itself
          $('#launchWarn').fadeOut();
          bLaunchRemind = false;
          if (checkCookies()) { setCookie("launchReminder", launchCraft, false); }
        }
      });
      $('#remindManeuver').click(function() {
        var $this = $(this);
        if ($this.is(':checked')) {
          if (!checkCookies()) { 
            $('#maneuverhWarn').fadeIn(); 
          } else {
            setCookie("maneuverReminder", maneuverCraft, true);
          }
          bManeuverRemind = true;
        } else {
          $('#maneuverWarn').fadeOut();
          bManeuverRemind = false;
          if (checkCookies()) { setCookie("maneuverReminder", maneuverCraft, false); }
        }
      });
      
      // remove the cookie warnings
      $('#launchWarn').click(function() { $('#launchWarn').fadeOut(); });
      $('#maneuverWarn').click(function() { $('#maneuverWarn').fadeOut(); });
      
      // load straight to the map?
      if (getParameterByName("map")) { 
        $("#map").css("visibility", "visible");
        $("#close").css("visibility", "visible");
        $("#orbitImg").css("display", "none");
        $("#mapholder").css("display", "block");
        $("#key").css("visibility", "hidden");
        $("#utc").css("visibility", "hidden");
      }

      // load straight to a map location?
      if (getParameterByName("center")) {
        $("#map").css("visibility", "visible");
        $("#orbitImg").css("display", "none");
        $("#close").css("visibility", "visible");
        $("#mapholder").css("display", "block");
        $("#key").css("visibility", "hidden");
        $("#utc").css("visibility", "hidden");
        mapLocation = getParameterByName("center").split(",");
        map.setView([mapLocation[0], mapLocation[1]], 3);
      }
      
      // load a map pin and caption?
      if (getParameterByName("loc")) {
        $("#map").css("visibility", "visible");
        $("#orbitImg").css("display", "none");
        $("#close").css("visibility", "visible");
        $("#mapholder").css("display", "block");
        $("#key").css("visibility", "hidden");
        $("#utc").css("visibility", "hidden");
        
        // get all pin locations and iterate through them
        mapLocationMulti = getQueryParams("loc");
        for (index = 0; index < mapLocationMulti.length; index++) {
          mapLocation = mapLocationMulti[index].split(",");
          map.setView([mapLocation[0], mapLocation[1]], 2);
          if (mapLocation.length > 2) {
            var pin = L.marker([mapLocation[0], mapLocation[1]]).bindPopup(mapLocation[2], {closeButton: false}).addTo(map);
            
            // only pop up if a single pin is being placed
            if (mapLocationMulti.length == 1) { pin.openPopup(); }
          } else {
            L.marker([mapLocation[0], mapLocation[1]], {clickable: false}).addTo(map);
          }
        }
      }
    });

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
      } else {
        off+= 60;
        label= '5';
      }

      //add the adjusted offset to the date and get the hours and minutes:
      d.setUTCMinutes(d.getUTCMinutes()+off);
      h= d.getUTCHours();
      m= d.getUTCMinutes();
      if(h> 12) h-= 12;
      else if(h!== 12) pm= 'am';
      if(h== 0) h= 12;
      if(m<10) m= '0'+m;
      
      // include a leading 0 if needed
      s = d.getUTCSeconds();
      if (d.getUTCSeconds() < 10) {
        s = "0" + s;
      }

      //return a string:
      $("#offset").html("(UTC -" + label + ")");
      var str= short_months[d.getUTCMonth()]+' '+d.getUTCDate()+', ';
      return h+':'+m+':' +s+ ' '+pm.toUpperCase();
    }
  </script>	
</head>
<body style="padding: 0; margin: 0; font-family: sans-serif;">

<!-- 
BODIES DATABASE LOAD
====================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbbodies
-->

<%
'calculate the time in seconds since epoch 0 when the game started
UT = datediff("s", "13-Sep-2016 00:00:00", now())

'open database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\db" & request.querystring("db") & ".mdb"
Dim connCraft, sConnection
Set connCraft = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connCraft.Open(sConnection)

'create the table
set rsBody = Server.CreateObject("ADODB.recordset")

'affects the base UT that is used for some areas that ignore dbUT
if request.querystring("deltaut") then
  UT = UT + request.querystring("deltaut")
end if

'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
if request.querystring("ut") then

  'convert the text string into a number
  dbUT = request.querystring("ut") * 1
  
  'do not allow people to abuse the UT query to peek ahead 
  'a passcode query is required for when requesting a UT entry later than the current UT
  if dbUT > UT then
    if request.querystring("pass") <> "2725" then 
    
      'passcode incorrect or not supplied. Revert back to current UT
      dbUT = UT
    else
      UT = request.querystring("ut") * 1
    end if
  end if
else
  dbUT = UT
end if
'regardless of previous outcomes, moving forward all recordset quieries should be made via dbUT

'query the data and pull up the UT closest to this one 
rsBody.open "select * from " & replace(request.querystring("body"), "-", ""), connCraft, 1, 1
rsBody.find ("ut>" & dbUT)
rsBody.moveprevious

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
  response.write("<div id='mainContent' style='width: 100%; overflow: hidden;'>")
else
  response.write("<div id='mainContent' style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if
%>

<!-- area for surface map display if this body supports it -->
<div id='map' class='map' style='z-index: 50; padding: 0; margin: 0; height: 840px; width: 840px; position: absolute; top: 50px; left: 0px; visibility: hidden;'></div>

<!-- special notice box for new users to the site -->
<div id='intro' style='font-family: sans-serif; border-style: solid; border-width: 2px; height: 177px; width: 370px; padding: 0; position: absolute; z-index: 301; margin: 0; top: 330px; left: 240px; background-color: gray; display: none'><center><b>Welcome to the Flight Tracker & Crew Roster!</b><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>Here you can learn everything there is to know about the astronauts & vessels involved in our space program. We highly suggest <a target="_blank" href="https://github.com/Gaiiden/FlightTracker/wiki">visiting the wiki</a> for detailed instructions on how to use the many features to be found herein.<p><span id='dismissIntro' style='cursor: pointer;'>Click here to dismiss</span><p style='font-size: 14px; text-align: center;'><span style="cursor: help; text-decoration: underline; text-decoration-style: dotted" class='tip' data-tipped-options="maxWidth: 300" title="The KSA uses cookies stored on your computer via the web browser to enable certain features of the website. It does not store tracking information nor use any third party cookies for analytics or other data gathering. The website's core functionality will not be affected should cookies be disabled, at the expense of certain usability features.">Cookie Use Policy</span></p></center></div>

<!-- hidden div that is set to contain data to show in tooltip -->
<div id='mapTipData' style='display: none'></div>

<!-- hidden div with dynamic tooltip for use to display over image maps outside of Firefox -->
<div id="mapTip" style="position: absolute; display: none; z-index: 9999999;" class='tip-update' data-tipped-options="inline: 'mapTipData', target: 'mouse', spinner: false, behavior: 'hide', detach: false"></div>

<!-- create the page section for body information -->
<div style="position: relative; width: 840px; float: left;">

<!-- header for body information section with tag link to show related website entries/flickr photos -->
<center>
<h3>
<%
response.write(replace(request.querystring("body"), "-", " "))

'if this is a "system" then grab only the name of the body. Assumes the title is "[body] System"
if instr(request.querystring("body"), "System") > 0 then
  header = split(request.querystring("body"), " ")
  tag = header(0)
else
  tag = request.querystring("body")
end if
  
response.write("&nbsp;<img class='tip' id='tagData' data-tipped-options=""position: 'righttop'"" style='margin-bottom: 10px; cursor: pointer;' title='view all tagged archive entries & flickr images' src='http://www.blade-edge.com/Tracker/tag.png'><script>var tagData='" & lcase(tag) & "';</script>")
%>
</h3>

<script>
// add the body name to the page title
document.title = document.title + " - <%response.write(replace(request.querystring("body"), "-", " "))%>";
</script>

<%
'image map data for the system
'image maps created via http://summerstyle.github.io/summer/
'tooltips added via replace function so code itself can be copied and used straight from image map editor
'however only let these be created into Tipped tooltips when using Firefox otherwise they will not work
strContent = Request.ServerVariables("HTTP_USER_AGENT")
if instr(strContent, "Firefox") > 0 then
  response.write(replace(rsBody.fields.item("HTML"), "title", "class='tip' data-tipped-options=""target: 'mouse', behavior: 'hide'"" title"))
else
  response.write rsBody.fields.item("HTML")
end if
%>

<!-- anchor to pull down page when scrolling through body diagrams -->
<a name="top">

<!-- 
hack used to allow collapse of orbital image and still display footer text below dynamic map, 
as Leaflet map doesn't play nice with the 'display' CSS property
-->
<img src="mapholder.png" style="display: none; z-index: -1;" id="mapholder">

<!-- the Key and Timestamp boxes, displayed according to position data from the database -->
<%
if not isnull(rsBody.fields.item("Key")) then
  response.write("<table id='key' style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; " & rsBody.fields.item("Key") & "'><tr><td style='font-size: 10px;'><b>Orbit Color Key</b><br><span style='color: red;'>Debris</span><br><span style='color: green;'>Communications</span><br><span style='color: magenta;'>Station</span><br><span style='color: blue;'>Probe</span><br><span style='color: #33CCFF;'>Ship</span><br><span style='color: brown;'>Asteroid</span></td></tr></table>")
end if
if not isnull(rsBody.fields.item("UTCPos")) then 
  response.write("<table id='utc' style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; " & rsBody.fields.item("UTCPos") & "'><tr><td style='font-size: 10px;'>Positions shown as of " & rsBody.fields.item("UTC") & "</td></tr></table>")
end if
%>

<!-- map close button -->
<img id="close" src="close.png" class='tip' data-tipped-options="position: 'left', offset: {y:-6}" title="Close" style="cursor: pointer; z-index: 10; position: absolute; top: 27px; right: 5px; visibility: hidden;" />

<!-- 
MAPS DATABASE LOAD
==================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbmaps
-->

<%
'open database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\dbMaps.mdb"
Dim connMaps, sConnectionMaps
Set connMaps = Server.CreateObject("ADODB.Connection")
sConnectionMaps = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connMaps.Open(sConnectionMaps)

'create the table and load latest data from the recordset matching this body
'this is done only for body pages, not system pages
set rsMaps = Server.CreateObject("ADODB.recordset")
if rsBody.fields.item("Map") then
  rsMaps.open "select top 1 * from " & request.querystring("body") & " where UT <= " & dbUT & " order by UT desc", connMaps, 1, 1
else
  rsMaps.open "select top 1 * from Kerbin where UT <= " & dbUT & " order by UT desc", connMaps, 1, 1
end if

'special case for KSC flags when viewing Kerbin
'creates link for showing flags as well as image map for flag sites
if not isnull(rsMaps.fields.item("KSC")) then
  response.write rsMaps.fields.item("KSC")
end if
%>

<!-- Forward/Back time buttons -->

<%
'currently, the ability to page between UT is only available for Kerbol, as it is updated at a constant rate
if instr(request.querystring("body"), "Kerbol-System") then
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
  
  'going forward/back a week or day?
  if instr(request.querystring("body"), "Inner") then
    timeSpan = "day"
  else
    timeSpan = "week"
  end if
  
  'determine if we need a Prev button
  if rsBody.AbsolutePosition > 1 then
    rsBody.moveprevious
    response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 57px; left: 10px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Back one " & timeSpan & "' href='" & url & "&ut=" & rsBody.fields.item("UT") + 1 & "#top'><<</a></td></tr></table>")
    rsBody.movenext
  end if
  
  'determine if we need a Next button
  if rsBody.AbsolutePosition < rsBody.recordcount then
    rsBody.movenext
    if rsBody.fields.item("UT") < UT then
      response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 57px; left: 40px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Forward one " & timeSpan & "' href='" & url & "&ut=" & rsBody.fields.item("UT") & "#top'>>></a></td></tr></table>")
    end if
  end if
end if
%>

<!-- footer links-->

<span style="font-family:arial;color:black;font-size:12px;">
<p>
<a target='_blank' href='http://www.kerbalspace.agency'>KSA Home Page</a> | Orbit rendering: <a target='_blank' href="http://bit.ly/KSPTOT">KSPTOT</a> | Image mapping: <a target='_blank' href="http://summerstyle.github.io/summer/">Summer Image Map Creator</a> | <a href='https://github.com/Gaiiden/FlightTracker/wiki/Flight-Tracker-Documentation'>Flight Tracker Wiki</a>
</p>
</span>
</center>
</div>

<!-- craft menu section -->

<div style="margin-left: 845px; font: 12pt normal Arial, sans-serif;"> 

<!-- craft menu header -->

<%
if request.querystring("filter") = "inactive" then
  response.write("<center><h3>Inactive Vessels</h3></center>")
else
  response.write("<center><h3>Active Vessels</h3></center>")
end if
%>

<!-- menu tree -->
<!-- yes, this method is very brute-force and not overly efficient but load times don't seem visibly affected to bother optimizing -->

<!-- 
CATALOG DATABASE LOAD
=====================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbcatalog
-->

<%
'calculate the time in seconds since epoch 0 when the game started
'we need to reset dbUT in case an earlier time was used to access past body map data
dbUT = datediff("s", "13-Sep-2016 00:00:00", now())

'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
if request.querystring("ut") then

  'convert the text string into a number
  dbUT = request.querystring("ut") * 1
  
  'do not allow people to abuse the UT query to peek ahead 
  'a passcode query is required for when requesting a UT entry later than the current UT
  if dbUT > UT then
    if request.querystring("pass") <> "2725" then 
    
      'passcode incorrect or not supplied. Revert back to current UT
      dbUT = datediff("s", "13-Sep-2016 00:00:00", now())
    else
      UT = request.querystring("ut") * 1
    end if
  end if
else
  dbUT = UT
end if


'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\dbCatalog.mdb"
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

'do a check right away to see if any craft exist before we mess with the recordset pointer
bCraftExist = true
if rsCrafts.eof or rsCrafts.bof then bCraftExist = false

'the various types of vessels that can be shown in the menu tree
filters = Array("debris", "probe", "rover", "lander", "ship", "station", "base", "asteroid")

'start the tree
response.write("<ol class='tree'>")

'decide whether we are building a menu for active or inactive vessels
bEntry = false
bInactiveVessels = false
bKerbolUsed = false
if request.querystring("filter") = "inactive" then

  'we can add or remove the craft types to search for by modifying the previously-defined array above
  for each x in filters

    'look through all crafts in the table
    bInactiveVessels = false
    do while not rsCrafts.eof

      'parse all the SOIs this craft has/will be in and find the one it is in currently
      ref = -2
      locations = split(rsCrafts.fields.item("SOI"), "|")
      for each loc in locations
        values = split(loc, ";")
        if values(0)*1 <= dbUT then 
          ref = values(1)*1
        end if
      next 

      'check if this is an inactive vessel or not
      'then check that this vessel belongs under this filter category
      if ref = -1 then
        if rsCrafts.fields.item("type") = x then
        
          'if this is the first vessel found for this filter, then create the category to list the vessel under
          if not bInactiveVessels then
            bInactiveVessels = true
            
            'convert the string to first character upper case
            letter = left(x, 1)
            letter = ucase(letter)
            title = letter & mid(x, 2, len(x)-1)
            response.write("<li> <label" & title & " for='" & title & "'>" & title & "</label" & title & "> <input type='checkbox' id='" & title & "' /> <ol>")
          end if
          
          'add the craft under this vessel type
          response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db") & "&filter=inactive'>" & rsCrafts.fields.item("vessel") & "</a></li>")
          end if
        end if
      rsCrafts.movenext
    loop
    
    'only close off the category if entries were created
    'then re-rack the crafts for another search through for a new type
    if bInactiveVessels then response.write("</ol> </li>")
    rsCrafts.movefirst
  next
else

  'loop through all the planets
  do while not rsPlanets.eof
    
    'check for any moons of this planet
    bPlanet = false
    do while not rsMoons.eof
      if rsMoons.fields.item("ref") = rsPlanets.fields.item("id") then
        bVessels = false
        do while not rsCrafts.eof

          'parse all the SOIs this craft has/will be in and find the one it is in currently
          ref = -1
          locations = split(rsCrafts.fields.item("SOI"), "|")
          for each loc in locations
            values = split(loc, ";")
            if values(0)*1 <= dbUT then 
              ref = values(1)*1
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
                
                  'ensure that some URL variables are not lost in the link
                  url = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
                  if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                  if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
                  response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show System overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsPlanets.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
                  bPlanet = true
                end if
                
                url = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=" & rsMoons.fields.item("body")
                if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
                response.write("<li><label for='" & rsMoons.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsMoons.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsMoons.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
                bVessels = true
              end if
              
              'include the craft as a child of the moon
              url = "http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db")
              if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
              if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
              response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 255, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & rsCrafts.fields.item("vessel") & "&nbsp;&nbsp;<span id='" & rsCrafts.fields.item("db") & "' style='position: relative;'></span></a></li>")
              bEntry = true
              
              'if this craft is orbiting around the body currently being viewed, it will probably need a rich tooltip to be displayed
              if instr(request.querystring("body"), rsMoons.fields.item("Body")) then
                response.write("<script>craftQuery.push('" & rsCrafts.fields.item("db") & "');</script>")
              end if
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
    'parse all the SOIs this craft has/will be in and find the one it is in currently
    do while not rsCrafts.eof
      ref = -1
      locations = split(rsCrafts.fields.item("SOI"), "|")
      for each loc in locations
        values = split(loc, ";")
        if values(0)*1 <= dbUT then 
          ref = values(1)*1
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
            if rsPlanets.fields.item("body") = "Kerbol" then bKerbolUsed = true
            url = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
              response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show System overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsPlanets.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
            bPlanet = true
          end if
          
          'include the craft as a child of the planet
          url = "' href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db")
          if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
          if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
            response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & url & "'>" & rsCrafts.fields.item("vessel") & "&nbsp;&nbsp;<span id='" & rsCrafts.fields.item("db") & "' style='position: relative;'></span></a></li>")
          bEntry = true
              
          'if this craft is orbiting around the body currently being viewed, it will probably need a rich tooltip to be displayed
          if instr(request.querystring("body"), rsPlanets.fields.item("Body")) then
            response.write("<script>craftQuery.push('" & rsCrafts.fields.item("db") & "');</script>")
          end if
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
end if

'let the user know if we did not find anything for this particular filter
if not bEntry and request.querystring("filter") <> "inactive" then
  response.write("<span style='margin-left: 70px'>No Vessels Found</a>")
end if

'also check that if we did not find a ship for Kerbol, we should add that for a way back to the system overview if taken straight to a body overview
if not bKerbolUsed and request.querystring("filter") <> "inactive" then 
  url = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbol-System"
  if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
  if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
    response.write("<li> <label for='Kerbol'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show System overview' href='" & url & "'>Kerbol</a>&nbsp;&nbsp;<span id='Kerbol' style='position: relative;'></span></label> <input type='checkbox' id='' /> </li>")
end if
%>

<!-- adds a link to the crew roster to the end of the menu list -->
<li> <labelRoster for='Roster'><a href="http://www.kerbalspace.agency/Roster/roster.asp" style="text-decoration: none; color: black" class="tip" data-tipped-options="position: 'right'" title="Information on KSA astronauts">Crew Roster</a>&nbsp;&nbsp;<span id='crewRoster' style='position: relative;'></span></labelRoster> </li>
</ol>

<!-- menu filter options -->

<%
'build a URL to use for linking, preserving certain URL variables
'but only if there are craft found
if bEntry or bInactiveVessels then 
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
  if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")

  'decide what filter types to include beneath the menu tree
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
  
'in case no craft are found but the user wants to return to active vessel listing
elseif len(request.querystring("filter")) then
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
  if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
  response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
  response.write("<b>Filter By:</b> <a href='" & url & "'>Active Vessels</a>")
  
'check that there are craft, but if none were found then they must be inactive. Provide link to inactive filter
'NOTE: this assumes that there are inactive vessels!
elseif bCraftExist then
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
  if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
  response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
  response.write("<b>Filter By:</b> <a href='" & url & "&filter=inactive'>Inactive Vessels</a>")
end if
%>

<!-- Catalog of body data for tooltip reference -->

<%
'build our JS catalog
'this could all be replaced with an AJAX call for the body tooltips
rsCrafts.movefirst
rsPlanets.movefirst
rsMoons.movefirst

response.write("<script>var craftsCatalog = []; var bodiesCatalog = []; var bodyObtData = [];")
do while not rsCrafts.eof
  ref = -1
  locations = split(rsCrafts.fields.item("SOI"), "|")
  for each loc in locations
    values = split(loc, ";")
    if values(0)*1 <= dbUT then 
      ref = values(1)*1
    end if
  next 
  if ref >= 0 then
    response.write("craftsCatalog.push({DB: '" & rsCrafts.fields.item("DB") & _
                    "', Name: '" & rsCrafts.fields.item("Vessel") & _
                    "', Type: '" & rsCrafts.fields.item("Type") & _
                    "', Desc: """ & rsCrafts.fields.item("Desc") & """});")
  end if
  rsCrafts.movenext
loop

'skip the sun
rsPlanets.movenext
do while not rsPlanets.eof
  response.write("bodiesCatalog.push({Image: '" & rsPlanets.fields.item("Image") & _
                  "', Name: '" & rsPlanets.fields.item("Body") & _
                  "', Desc: """ & rsPlanets.fields.item("Desc") & _
                  """, Ap: '" & rsPlanets.fields.item("Ap") & _
                  "', Pe: '" & rsPlanets.fields.item("Pe") & _
                  "', Ecc: '" & rsPlanets.fields.item("Ecc") & _
                  "', Inc: '" & rsPlanets.fields.item("Inc") & _
                  "', ObtPeriod: " & rsPlanets.fields.item("ObtPeriod") & _
                  ", ObtVel: '" & rsPlanets.fields.item("ObtVel") & _
                  "', EqRad: " & rsPlanets.fields.item("Radius") & _
                  ", Mass: '" & rsPlanets.fields.item("Mass") & _
                  "', Density: '" & rsPlanets.fields.item("Density") & _
                  "', SurfaceG: '" & rsPlanets.fields.item("SurfaceG") & _
                  "', EscapeVel: '" & rsPlanets.fields.item("EscapeVel") & _
                  "', SolDay: '" & rsPlanets.fields.item("RotPeriod") & _
                  "', Atmo: '" & rsPlanets.fields.item("Atmo") & _
                  "', AtmoHeight: " & rsPlanets.fields.item("AtmoHeight") & _
                  ", Moons: '" & rsPlanets.fields.item("Moons") & "'});")
  response.write("bodyObtData.push({Body: '" & rsPlanets.fields.item("Body") & _
                  "', Gm: " & rsPlanets.fields.item("Gm") & _
                  ", Period: " & rsPlanets.fields.item("RotPeriod") & _
                  ", SolDay: " & rsPlanets.fields.item("SolarDay") & _
                  ", Rotation: " & rsPlanets.fields.item("RotIni") & _
                  ", Radius: " & rsPlanets.fields.item("Radius") & "});")                  
  rsPlanets.movenext
loop
do while not rsMoons.eof
  response.write("bodiesCatalog.push({Image: '" & rsMoons.fields.item("Image") & _
                  "', Name: '" & rsMoons.fields.item("Body") & _
                  "', Desc: """ & rsMoons.fields.item("Desc") & _
                  """, Ap: '" & rsMoons.fields.item("Ap") & _
                  "', Pe: '" & rsMoons.fields.item("Pe") & _
                  "', Ecc: '" & rsMoons.fields.item("Ecc") & _
                  "', Inc: '" & rsMoons.fields.item("Inc") & _
                  "', ObtPeriod: " & rsMoons.fields.item("ObtPeriod") & _
                  ", ObtVel: '" & rsMoons.fields.item("ObtVel") & _
                  "', EqRad: " & rsMoons.fields.item("Radius") & _
                  ", Mass: '" & rsMoons.fields.item("Mass") & _
                  "', Density: '" & rsMoons.fields.item("Density") & _
                  "', SurfaceG: '" & rsMoons.fields.item("SurfaceG") & _
                  "', EscapeVel: '" & rsMoons.fields.item("EscapeVel") & _
                  "', SolDay: '" & rsMoons.fields.item("RotPeriod") & _
                  "', Atmo: '" & rsMoons.fields.item("Atmo") & _
                  "', AtmoHeight: " & rsMoons.fields.item("AtmoHeight") & _
                  ", Moons: '" & rsMoons.fields.item("Moons") & "'});")
  response.write("bodyObtData.push({Body: '" & rsMoons.fields.item("Body") & _
                  "', Gm: " & rsMoons.fields.item("Gm") & _
                  ", Period: " & rsMoons.fields.item("RotPeriod") & _
                  ", SolDay: " & rsMoons.fields.item("SolarDay") & _
                  ", Rotation: " & rsMoons.fields.item("RotIni") & _
                  ", Ecc: " & rsMoons.fields.item("Ecc") & _
                  ", Inc: " & rsMoons.fields.item("Inc") & _
                  ", RAAN: " & rsMoons.fields.item("RAAN") & _
                  ", Arg: " & rsMoons.fields.item("Arg") & _
                  ", SMA: " & rsMoons.fields.item("SMA") & _
                  ", Mean: " & rsMoons.fields.item("Mean") & _
                  ", Color: '#" & rsMoons.fields.item("Color") & _
                  "', Radius: " & rsMoons.fields.item("Radius") & "});")                  
  rsMoons.movenext
loop
response.write("</script>")
%>

<!-- 
EVENTS DATABASE LOAD
====================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbevents
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
      <b>Current Time @ KSC <span id="offset"></span></b><br>
      <span id='ksctime' style="font-size: 16px"></span>
      <br /><br />
      <table border="0" style="width: 100%; border-collapse: collapse;">
        <tr>
          <td style="width: 50%; border-width: 1px; text-align: center; vertical-align: top; border-top-style: none; border-right-style: solid; border-bottom-style: none; border-left-style: none;">
            <b>Next Launch</b><br />
            <%
            'if we are at EOF there are no records yet
            'if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
            if rsLaunch.bof or rsLaunch.eof then
              response.write("<script>")
              response.write("var bLaunchCountdown = true;")
              response.write("var bFutureLaunch = false;")
              response.write("var nextLaunchSched = 0;")
              response.write("var launchLink = '';")
              response.write("var launchCraft = '';")
              response.write("var launchSchedUT = -1;")
              response.write("</script>")
              response.write("None Scheduled")
            else
              
              'has this launch has gone off already?
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
                response.write("var launchCraft = '" & rsLaunch.fields.item("CraftName") & "';")
                response.write("var launchLink = '" & rsLaunch.fields.item("CraftLink") & "';")
                response.write("</script>")
                
                'add a tooltip to give the user more details if available
                if not isnull(rsLaunch.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsLaunch.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                end if
                
                'print out the launch details and give the user the option to have the site remind them about it
                response.write(formatdatetime(rsLaunch.fields.item("EventDate")) & "<br />")
                response.write("<span id='tminuslaunch'></span>")
                response.write("<br /><div id='launchDiv'><input type='checkbox' id='remindLaunch'> <span class='tip' data-tipped-options=""maxWidth: 150"" title='Checking this box will cause the browser to alert you 5 minutes before the event' style='cursor: default; vertical-align: 2px;'>Remind Me</span> <img id='launchWarn' style='display: none; vertical-align: 1px; cursor: help;' src='warning-icon.png' class='tip' data-tipped-options=""maxWidth: 150"" title='You do not have cookies enabled, which means this setting will not be saved between pages/sessions. Click to dismiss'></div>")
              end if
            end if
            %>
          </td>
          <td style="width: 50%; vertical-align: top;	text-align: center;">
            <b>Next Maneuver</b><br />
            <%
            'if we are at EOF there are no records yet
            'if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
            if rsManeuver.bof or rsManeuver.eof then
              response.write("<script>")
              response.write("var bManeuverCountdown = true;")
              response.write("var bFutureManeuver = false;")
              response.write("var nextManeuverSched = 0;")
              response.write("var maneuverLink = '';")
              response.write("var maneuverCraft = '';")
              response.write("var maneuverUT = -1;")
              response.write("</script>")
              response.write("None Scheduled")
            else
                
              'has this maneuver has gone off already?
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
                response.write("var maneuverLink = '" & rsManeuver.fields.item("CraftLink") & "';")
                response.write("var maneuverCraft = '" & rsManeuver.fields.item("CraftName") & "';")
                response.write("</script>")
                
                'add a tooltip to give the user more details if available
                if not isnull(rsManeuver.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsManeuver.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsManeuver.fields.item("CraftLink") & "&node=true'>" & rsManeuver.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsManeuver.fields.item("CraftLink") & "&node=true'>" & rsManeuver.fields.item("CraftName") & "</a><br>")
                end if
                
                'print out the maneuver details and give the user the option to have the site remind them about it
                response.write(formatdatetime(rsManeuver.fields.item("EventDate")) & "<br />")
                response.write("<span id='tminusmaneuver'></span>")
                response.write("<br /><div id='maneuverDiv'><input type='checkbox' id='remindManeuver'> <span class='tip' data-tipped-options=""maxWidth: 150"" title='Checking this box will cause the browser to alert you 5 minutes before the event' style='cursor: default; vertical-align: 2px;'>Remind Me</span> <img id='maneuverWarn' style='display: none; vertical-align: 1px; cursor: help;' src='warning-icon.png' class='tip' data-tipped-options=""maxWidth: 150"" title='You do not have cookies enabled, which means this setting will not be saved between pages/sessions. Click to dismiss'></div>")
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

<!-- this will display the recent tweets from @KSA_MissionCtrl --> 
<P><center><a href="https://twitter.com/KSA_MissionCtrl" class="twitter-follow-button" data-show-count="true">Follow @KSA_MissionCtrl</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script></center>
<a class="twitter-timeline" href="https://twitter.com/KSA_MissionCtrl" data-widget-id="598711760149852163" height="700" data-chrome="noheader">Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>  </p>
</span></div> </div>

<!-- Setting up known map layers -->

<script>
  // don't run this script if we don't have any maps on this body
  var currUT = initialUT = UT = <%response.write UT%>;
  if (<%response.write(lcase(rsBody.fields.item("Map")))%>) 
  {
  
    // create the map with some custom options
    // details on Leaflet API can be found here - http://leafletjs.com/reference.html
    var map = new L.KSP.Map('map', {
      center: [0,0],
      bodyControl: false,
      layersControl: false,
      scaleControl: true,
      minZoom: 0,
      maxZoom: 5,
      zoom: 2,
      fullscreenControl: true,
      fullscreenControlOptions: {
        position: 'topleft'
      }
    });

    // define the icons for the various layer markers
    var flagIcon = L.icon({
      iconUrl: 'button_vessel_flag.png',
      iconSize: [16, 16],
    });
    var POIIcon = L.icon({
      popupAnchor: [0, -43], 
      iconUrl: 'poi.png', 
      iconSize: [30, 40], 
      iconAnchor: [15, 40], 
      shadowUrl: 'markers-shadow.png', 
      shadowSize: [35, 16], 
      shadowAnchor: [10, 12]
    });
    var anomalyIcon = L.icon({
      popupAnchor: [0, -43], 
      iconUrl: 'anomaly.png', 
      iconSize: [30, 40], 
      iconAnchor: [15, 40], 
      shadowUrl: 'markers-shadow.png', 
      shadowSize: [35, 16], 
      shadowAnchor: [10, 12]
    });
    var labelIcon = L.icon({
      iconUrl: 'label.png',
      iconSize: [10, 10],
    });
    var sunIcon = L.icon({
      iconUrl: 'sun.png',
      iconSize: [16, 16],
      iconAnchor: [8, 8]
    });
    
    // check for any available base map layers and add as necessary
    var layerControl = L.control.groupedLayers().addTo(map);
    var bBaseAdded = false;
    var slopeInfo = false;
    var elevInfo = false;
    var biomeInfo = false;
    if (<%if rsBody.fields.item("Map") then response.write(lcase(rsMaps.fields.item("Satellite"))) else response.write("false")%>) {
    layerControl.addBaseLayer(
      L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE,
        L.KSP.TileLayer.DEFAULT_URL,
        L.KSP.CRS.EPSG4326, {
          body: getParameterByName("body").toLowerCase(),
          style: "sat"
        }
      ).addTo(map), "Satellite");
      bBaseAdded = true;
    }
    else if (<%if rsBody.fields.item("Map") then response.write(lcase(rsMaps.fields.item("Aerial"))) else response.write("false")%>) {
    layerControl.addBaseLayer(
      L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE,
        L.KSP.TileLayer.DEFAULT_URL,
        L.KSP.CRS.EPSG4326, {
          body: getParameterByName("body").toLowerCase(),
          style: "sat"
        }
      ).addTo(map), "Aerial");
      bBaseAdded = true;
    }

    // currently only the relief map can be body-agnostic as it uses a universal legend
    if (<%if rsBody.fields.item("Map") then response.write(lcase(rsMaps.fields.item("Slope"))) else response.write("false")%>) {
      slopeInfo = true;
      var slopeBase = L.KSP.tileLayer(
        L.KSP.TileLayer.TYPE_COLORRELIEF,
        L.KSP.TileLayer.DEFAULT_URL,
        L.KSP.CRS.EPSG4326, {
          body: getParameterByName("body").toLowerCase(),
          style: "slope",
          legend: L.KSP.Legend.SLOPE
        }
      )
      layerControl.addBaseLayer(slopeBase, "Slope");
      
      // in case our default layer of satellite or aerial terrain was not included, make this the base, otherwise only show if told
      if (!bBaseAdded || getParameterByName("base").toLowerCase() == "slope") {
        slopeBase.addTo(map);
        bBaseAdded = true;
      }
    }
    
    if (<%if rsBody.fields.item("Map") then response.write(lcase(rsMaps.fields.item("Terrain"))) else response.write("false")%>) {
      elevInfo = true;
      switch(getParameterByName("body").toLowerCase()) {
        case "kerbin":
          var reliefBase = L.KSP.tileLayer(
            L.KSP.TileLayer.TYPE_COLORRELIEF,
            L.KSP.TileLayer.DEFAULT_URL,
            L.KSP.CRS.EPSG4326, {
              body: "kerbin",
              style: "color",
              legend: {
                "6800 m" : "#FFFFFF",
                "6000 m" : "#E6E1E1",
                "4000 m" : "#C39B87",
                "2000 m" : "#B97855",
                "1000 m" : "#B99B6E",
                "600 m" : "#5A825A",
                "200 m" : "#1E784B",
                "50 m" : "#0A6437",
                "0 m" : "#004120",
                "-500 m" : "#0F4B9B",
                "-100 m" : "#1E6E9B"
              }
            }
          )
          layerControl.addBaseLayer(reliefBase, "Color Relief");
          break;
      }
      if (!bBaseAdded || getParameterByName("base").toLowerCase() == "relief") {
        reliefBase.addTo(map);
        bBaseAdded = true;
      }
    }
    
    if (<%if rsBody.fields.item("Map") then response.write(lcase(rsMaps.fields.item("Biome"))) else response.write("false")%>) {
      biomeInfo = true;
      switch(getParameterByName("body").toLowerCase()) {
        case "kerbin":
          var biomeBase = L.KSP.tileLayer(
            L.KSP.TileLayer.TYPE_COLORRELIEF,
            L.KSP.TileLayer.DEFAULT_URL,
            L.KSP.CRS.EPSG4326, {
              body: "kerbin",
              style: "biome",
              legend: {
                "Water" : "#00245E",
                "Shores" : "#B5D3D1",
                "Grasslands" : "#4BAC00",
                "Highlands" : "#1C7800",
                "Mountains" : "#824600",
                "Deserts" : "#CCB483",
                "Badlands" : "#FCD037",
                "Tundra" : "#89FA91",
                "Ice Caps" : "#FEFEFE"
              }
            }
          );
          layerControl.addBaseLayer(biomeBase, "Biome");
          break;
      }
      if (!bBaseAdded || getParameterByName("base").toLowerCase() == "biome") {
        biomeBase.addTo(map);
        bBaseAdded = true;
      }
    }
    
    // add the legend control to the map - will be automatically displayed by activating a base layer that uses it
    map.addControl(new L.KSP.Control.Legend());

    // loop through all flag records and place them on the map with their info boxes
    if (!<%if rsBody.fields.item("Map") then response.write lcase(isnull(rsMaps.fields.item("Flags"))) else response.write("true")%>) {
      var strFlagData = "<%if rsBody.fields.item("Map") then response.write rsMaps.fields.item("Flags")%>";
      var flagData = strFlagData.split("|");
      var flagMarker;
      var layerFlags = L.layerGroup();
      for (x=0; x<flagData.length; x++) {
        var flag = flagData[x].split(";");
        
        // special case for a flag placed at KSC that allows user to show map of flags placed around the space center
        if (flag[3] == "KSC") {
          flagMarker = L.marker([flag[0],flag[1]], {icon: flagIcon, zIndexOffset: 100}).bindLabel("View KSC Flags", {className: 'labeltext'});
          flagMarker.on('click', function(e) {
            $("#map").css("visibility", "hidden");
            $("#kscflags").css("visibility", "hidden");
            $("#mapholder").css("display", "none");
            $("#kscflagsimg").css("display", "block");
          });
        } else {
          flagMarker = L.marker([flag[0],flag[1]], {icon: flagIcon, zIndexOffset: 100});
          flagMarker.bindPopup("<b>" + flag[3] + "</b><br />" + flag[4] + "<br />" + flag[6] + "<br />" + numeral(flag[2]/1000).format('0.000') + "km<br /><br />&quot;" + flag[5] + "&quot;<br /><br /><a target='_blank' href='" + flag[7] + "'>" + flag[8] + "</a>", {closeButton: false});
        }
        layerFlags.addLayer(flagMarker);

        // set the ID to make the map click function ignore this popup and add it to the map
        flagMarker._myId = -1;
      }
      
      // add the layer to the map and if it is asked for in the URL variable show it immediately
      layerControl.addOverlay(layerFlags, "<img src='button_vessel_flag.png' width='10px' style='vertical-align: 1px;'> Flags", "Ground Markers");
      if (showLayers.length) {
        for (l=0; l<showLayers.length; l++) {
          if ("flags" == showLayers[l]) { layerFlags.addTo(map); }
        }
      }
    }
    
    // loop through all POI records and place them on the map with their info boxes
    if (!<%if rsBody.fields.item("Map") then response.write lcase(isnull(rsMaps.fields.item("POI"))) else response.write("true")%>) {
      var strPOIData = "<%if rsBody.fields.item("Map") then response.write rsMaps.fields.item("POI")%>";
      var POIData = strPOIData.split("|");
      var POIMarker;
      var layerPOI = L.layerGroup();
      for (x=0; x<POIData.length; x++) {
        var POI = POIData[x].split(";");
        POIMarker = L.marker([POI[0],POI[1]], {icon: POIIcon, zIndexOffset: 100});
        strHTML = "<b>" + POI[3] + "</b><br>" + numeral(POI[2]/1000).format('0.000') + " km";
        if (POI[4] != "null") { strHTML += "<p>" + POI[4] + "</p>"; }
        POIMarker.bindPopup(strHTML, {closeButton: false});
        layerPOI.addLayer(POIMarker);
        POIMarker._myId = -1;
      }
      layerControl.addOverlay(layerPOI, "<img src='poi.png' width='10px' style='vertical-align: 1px;'> Points of Interest", "Ground Markers");
      if (showLayers.length) {
        for (l=0; l<showLayers.length; l++) {
          if ("poi" == showLayers[l]) { layerPOI.addTo(map); }
        }
      }
    }
    
    // loop through all anomaly records and place them on the map with their info boxes
    if (!<%if rsBody.fields.item("Map") then response.write lcase(isnull(rsMaps.fields.item("Anomalies"))) else response.write("true")%>) {
      var strAnomalyData = "<%if rsBody.fields.item("Map") then response.write rsMaps.fields.item("Anomalies")%>";
      var anomalyData = strAnomalyData.split("|");
      var anomalyMarker;
      var layerAnomalies = L.layerGroup();
      for (x=0; x<anomalyData.length; x++) {
        var anomaly = anomalyData[x].split(";");
        anomalyMarker = L.marker([anomaly[0],anomaly[1]], {icon: anomalyIcon, zIndexOffset: 100});
        strHTML = "<b>";
        if (anomaly[3] != "null") { strHTML += anomaly[3]; } else { strHTML += "Unkown Anomaly"; }
        strHTML += "</b><br>" + numeral(anomaly[2]/1000).format('0.000') + " km";
        anomalyMarker.bindPopup(strHTML, {closeButton: false});
        layerAnomalies.addLayer(anomalyMarker);
        anomalyMarker._myId = -1;
      }
      layerControl.addOverlay(layerAnomalies, "<img src='anomaly.png' width='10px' style='vertical-align: 1px;'> Anomalies", "Ground Markers");
      if (showLayers.length) {
        for (l=0; l<showLayers.length; l++) {
          if ("anomalies" == showLayers[l]) { layerAnomalies.addTo(map); }
        }
      }
    }
    
    // loop through all label records and place them on the map with their info boxes
    if (!<%if rsBody.fields.item("Map") then response.write lcase(isnull(rsMaps.fields.item("Labels"))) else response.write("true")%>) {
      var strLabelData = "<%if rsBody.fields.item("Map") then response.write rsMaps.fields.item("Labels")%>";
      var labelData = strLabelData.split("|");
      var labelMarker;
      var layerLabels = L.layerGroup();
      for (x=0; x<labelData.length; x++) {
        var label = labelData[x].split(";");
        labelMarker = L.marker([label[0],label[1]], {icon: labelIcon, zIndexOffset: 100}).bindLabel(label[2], {className: 'labeltext'});
        layerLabels.addLayer(labelMarker);
        labelMarker._myId = -1;
        
        // zoom the map all the way in and center on this marker when clicked
        labelMarker.on('click', function(e) {
          map.setView(e.target.getLatLng(), 5);
        });
      }
      layerControl.addOverlay(layerLabels, "<img src='label.png' style='vertical-align: 1px;'> Labels", "Ground Markers");
      if (showLayers.length) {
        for (l=0; l<showLayers.length; l++) {
          if ("labels" == showLayers[l]) { layerLabels.addTo(map); }
        }
      }
    }
    
    // get the data of the body being orbited, only needs to be done once
    var currBodyIndex;
    for (x=0; x< bodyObtData.length; x++) {
      if (bodyObtData[x].Body == getParameterByName("body")) { 
        currBodyIndex = x;
        var gmu = bodyObtData[x].Gm; 
        var rotPeriod = bodyObtData[x].Period;
        var rotInit = bodyObtData[x].Rotation * .017453292519943295; 
        var radius = bodyObtData[x].Radius;
      }
    }

    // create the sun/terminator
    var layerSolar = L.layerGroup();
    var sunMarker;
    var terminatorW = null;
    var terminatorE = null;
    
    // start by determining the current position of the sun given the body's degree of initial rotation and rotational period
    currRot = -bodyObtData[currBodyIndex].Rotation - (((UT / bodyObtData[currBodyIndex].SolDay) % 1) * 360);
    if (currRot < -180) { currRot += 360; }
    
    // place the sun marker
    sunMarker = L.marker([0,currRot], {icon: sunIcon, clickable: false});
    layerSolar.addLayer(sunMarker);
    
    // draw the terminators
    // terminators draw if there is room, extending as much as 180 degrees or to the edge of the map
    if (currRot - 90 > -180) {
      terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true});
      layerSolar.addLayer(terminatorW);
    }
    if (currRot + 90 < 180) {
      terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true});
      layerSolar.addLayer(terminatorE);
    }
    
    // add to the layer selection control
    // check if we should show this on load
    layerControl.addOverlay(layerSolar, "<img src='sun.png' width='10px' style='vertical-align: 1px;'> Sun/Terminator", "Ground Markers");
    if (showLayers.length) {
      for (l=0; l<showLayers.length; l++) {
        if ("sun" == showLayers[l]) { layerSolar.addTo(map); }
      }
    }

    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    // show controls only when the cursor is over the map
    if (!is_touch_device()) { 
      infoControl = new L.KSP.Control.Info({
          elevInfo: elevInfo,
          biomeInfo: biomeInfo,
          slopeInfo: slopeInfo
        });
      map.addControl(infoControl);
      $(".leaflet-control-info").css("display", "none");
      map.on('mouseover', function(e) {
        $(".leaflet-control-info").fadeIn();
        $(".leaflet-control-zoom").fadeIn();
        $(".leaflet-control-layers").fadeIn();
      });
      map.on('mouseout', function(e) {
        $(".leaflet-control-info").fadeOut();
        $(".leaflet-control-zoom").fadeOut();
        $(".leaflet-control-layers").fadeOut();
      });
    }
    
    // if the popup was opened for a vessel, change all its lines to yellow and render them atop the rest
    map.on('popupopen', function(e) {
      if (e.popup._source._myId >= 0) {
        for (p=0; p<bodyCrafts[e.popup._source._myId].Paths.length; p++) {
          bodyCrafts[e.popup._source._myId].Paths[p].setStyle({color: '#ffff00', weight: 5});
          bodyCrafts[e.popup._source._myId].Paths[p].bringToFront();
        }
      }
    });
   
    // if the popup was closed for a vessel, return its lines back to the proper color for its type
    map.on('popupclose', function(e) {
      if (e.popup._source._myId >= 0) {
        for (p=0; p<bodyCrafts[e.popup._source._myId].Paths.length; p++) {
          if (bodyCrafts[e.popup._source._myId].Type == "Moon") {
            bodyCrafts[e.popup._source._myId].Paths[p].setStyle({color: bodyCrafts[e.popup._source._myId].Color, weight: 3});
          } else {
            bodyCrafts[e.popup._source._myId].Paths[p].setStyle({color: colors[bodyCrafts[e.popup._source._myId].Layer], weight: 3});
          }
        }
      }
    });
   
    // hide map controls after 3 seconds if the user cursor isn't over the map
    setTimeout(function() {
      if (!$('#map').is(":hover")) { 
        $(".leaflet-control-info").fadeOut();
        $(".leaflet-control-zoom").fadeOut();
        $(".leaflet-control-layers").fadeOut();
     }
    }, 3000);
    
    // set up variables for adding vessels to the dynamic map
    var bTruncOrbit = false;
    var n;
    var types = ["Debris", "Probe", "Ship", "Station", "Asteroid", "Moon"];
    var colors = ["#ff0000", "#00FF00", "#0000ff", "#ff00ff", "#996633", "#000000"];
    var probeTxtClr = "#008000";
    var overlays = [L.layerGroup()];
    var currType = 0;
    var currCraft = 0;
    var endTime = -1;
    var plzWait = L.layerGroup();
    layerControl.addOverlay(plzWait, "Loading orbits...", "Orbital Plots");
    
    // wait for an AJAX callback or JQuery setup to begin loading orbital data
  }

  // take the tally created during the menu build and send out a request for information on the craft orbiting this body
  if (craftQuery.length) {
    var strURL = "craftinfo.asp?crafts=" + craftQuery.toString() + "&surfaceMap=<%response.write(lcase(rsBody.fields.item("Map")))%>&ut=" + UT;
    ajaxCraftData.open("GET", strURL, true);
    ajaxCraftData.send();
  } else {
  
    // load the orbits for the surface map, if there is one
    if (<%response.write(lcase(rsBody.fields.item("Map")))%>) {
      findMoons();
      renderVesselsOrbit();
    }
  }
  
  // if the user has cookies enabled, check to see if there are any notifications to display
  if (checkCookies()) {
    ajaxUpdate.open("GET", "update.asp", true);
    ajaxUpdate.send();
  }
</script>

<!-- ^^ AJAX data calls ^^ -->

<!-- update the clock and page -->

<script>

  // check cookies, if available, to see if we have any reminders to look out for
  var bLaunchRemind = false;
  var bManeuverRemind = false;
  if (checkCookies()) {
    if (bLaunchCountdown && getCookie("launchReminder") == launchCraft) {
      bLaunchRemind = true;
      $('#remindLaunch').prop('checked', true);
    }
    if (bManeuverCountdown && getCookie("maneuverReminder") == maneuverCraft) {
      bManeuverRemind = true;
      $('#remindManeuver').prop('checked', true);
    }
  }

  // js and vb can vary from 10-15 or more seconds
  // time is in favor of vb time, as majority of time stamps are done with dateDiff()
  // 1473739200000 ms = 9/13/16 00:00:00
  var d = new Date();
  d.setTime(1473739200000 + (UT * 1000));
  
  // called every second to update page data
  var startDate = Math.floor(d.getTime() / 1000);
  var tickStartTime = new Date().getTime();
  var tickDelta = 0;
  (function tick() {
    var dd = new Date();
    dd.setTime(1473739200000 + (UT * 1000));
    var currDate = Math.floor(dd.getTime() / 1000);
    
    // update the sun/terminator if a surface map is loaded
    if (<%response.write(lcase(rsBody.fields.item("Map")))%>) {
    
      // update the sun marker
      currRot = -bodyObtData[currBodyIndex].Rotation - (((UT / bodyObtData[currBodyIndex].SolDay) % 1) * 360);
      if (currRot < -180) { currRot += 360; }
      sunMarker.setLatLng([0,currRot]);
      
      // draw/update/remove the terminators
      if (currRot - 90 > -180) {
        if (!terminatorW) {
          terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true});
          layerSolar.addLayer(terminatorW);
        } else {
          terminatorW.setBounds([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]]);
        }
      } else if ((currRot - 90 < -180) && (terminatorW)) {
        map.removeLayer(terminatorW);
        terminatorW = null;
      }
      if (currRot + 90 < 180) {
        if (!terminatorE) {
          terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true});
          layerSolar.addLayer(terminatorW);
        } else {
          terminatorE.setBounds([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]]);
        }
      } else if ((currRot + 90 > 180) && (terminatorE)) {
        map.removeLayer(terminatorE);
        terminatorE = null;
      }
    }
    
    // update the vessels that are currently loaded and rendered
    for (x=bodyCrafts.length-1; x>=0; x--) {
      if (bodyCrafts[x].Loaded) {
      
        // now depends on how many times the vessel has had its orbit redrawn
        var now = (currDate - startDate) - (Math.round(bodyCrafts[x].ObtPd) * bodyCrafts[x].Orbits);
        
        // don't update if there's no more orbit to update on
        if (now < bodyCrafts[x].Obt.length) {
          
          // get the cardinal direction of the lat/lng coordinates
          if (bodyCrafts[x].Obt[now].Lat < 0) {
            cardinalLat = "S";
          } else {
            cardinalLat = "N";
          }
          if (bodyCrafts[x].Obt[now].Lng < 0) {
            cardinalLon = "W";
          } else {
            cardinalLon = "E";
          }
          
          // update all the dynamic text included in the marker popup as well as the position of the marker itself
          bodyCrafts[x].Craft.setLatLng([bodyCrafts[x].Obt[now].Lat, bodyCrafts[x].Obt[now].Lng]);
          $('#lat' + bodyCrafts[x].DB).html(numeral(bodyCrafts[x].Obt[now].Lat).format('0.0000') + "&deg;" + cardinalLat);
          $('#lng' + bodyCrafts[x].DB).html(numeral(bodyCrafts[x].Obt[now].Lng).format('0.0000') + "&deg;" + cardinalLon);
          $('#alt' + bodyCrafts[x].DB).html(numeral(bodyCrafts[x].Obt[now].Alt).format('0,0.000') + " km");
          $('#vel' + bodyCrafts[x].DB).html(numeral(bodyCrafts[x].Obt[now].Vel).format('0,0.000') + " km/s");
          if (bodyCrafts[x].Node > 0 && bodyCrafts[x].Node - UT < bodyCrafts[x].Obt.length && bodyCrafts[x].Node - UT >= 0) {
            $('#nodeTime' + bodyCrafts[x].DB).html(formatTime(bodyCrafts[x].Node - UT, false));
          }
          if (bodyCrafts[x].ObtPd < 0) {
            $('#soiTime' + bodyCrafts[x].DB).html(formatTime(Math.abs(bodyCrafts[x].ObtPd) - UT, false));
          }
          
        // put in a request to render a new orbit, can only do one at a time, when currCraft is not being used
        // re-render only if a maneuver node, SOI exit or atmo interface is not on this plot
        } else if (bodyCrafts[x].Node < 0 && bodyCrafts[x].ObtPd > 0 && bodyCrafts[x].Obt[bodyCrafts[x].Obt.length-1].Alt > bodiesCatalog[currBodyIndex].AtmoHeight) {
          if (currCraft < 0) { 
          
            // reset/update variables and clear path data before sending out the callback to render a new orbit
            currCraft = x; 
            currType = bodyCrafts[x].Layer;
            currUT = UT;
            bodyCrafts[x].Orbits++;
            bodyCrafts[x].Obt = [];
            overlays[bodyCrafts[x].Layer].removeLayer(bodyCrafts[x].Craft);
            for (p=0; p<bodyCrafts[x].Paths.length; p++) {
              overlays[bodyCrafts[x].Layer].removeLayer(bodyCrafts[x].Paths[p]);
            }
            bodyCrafts[x].Paths = [];
            renderVesselOrbit();
          }
        }
      }
    }
    
    // update the clock and any accompanying countdowns
    $('#ksctime').html(dd.toLocaleDateString() + ' ' + Date.toTZString(dd, 'E'));
    if (bLaunchCountdown) {
      
      // remind the user a launch is coming up if they want it
      if (Math.abs(launchSchedUT) == 300 && bLaunchRemind) {
        if (confirm(launchCraft + " is launching in 5mins!\nClick OK to view the craft, or Cancel to remain on this page")) {
          window.location.href = launchLink;
        }
        
        // delete the cookie and uncheck the reminder box
        $('#remindLaunch').prop('checked', false);
        bLaunchRemind = false;
        if (checkCookies()) { setCookie("launchReminder", maneuverCraft, false); }
      }
      
      // don't let the user set a reminder if it's too close to the event
      if (Math.abs(launchSchedUT) <= 300 && $('#launchDiv').css("display") != "none") { $('#launchDiv').fadeOut(); }
      
      // only count down if thete is something to countdown
      if (launchSchedUT < 0) {
        $('#tminuslaunch').html(formatTime(launchSchedUT, false));
        launchSchedUT++;
      }
      else {
        $('#tminuslaunch').html("LIFTOFF!!");
        bLaunchCountdown = false;
      }
    }
    if (bManeuverCountdown) {
      if (Math.abs(maneuverUT) == 300 && bManeuverRemind) {
        if (confirm(maneuverCraft + " is executing a maneuver in 5mins!\nClick OK to view the craft, or Cancel to remain on this page")) {
          window.location.href = maneuverLink;
        }
        $('#remindManeuver').prop('checked', false);
        bManeuverRemind = false;
        if (checkCookies()) { setCookie("maneuverReminder", maneuverCraft, false); }
      }
      if (Math.abs(maneuverUT) <= 300 && $('#maneuverDiv').css("display") != "none") { $('#maneuverDiv').fadeOut(); }
      if (maneuverUT < 0) {
        $('#tminusmaneuver').html(formatTime(maneuverUT, false));
        maneuverUT++;
      }
      else {
        $('#tminusmaneuver').html("Maneuver Executed");
        bManeuverCountdown = false;
      }
    }
    
    // have we reached a new scheduled event?
    if (bFutureLaunch && UT >= nextLaunchSched) {
      location.reload(true);
    }
    if (bFutureManeuver && UT >= nextManeuverSched) {
      location.reload(true);
    }
    
    // increase the current time elapsed since epoch 0
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
if rsBody.fields.item("Map") then
  connMaps.Close
  Set connMaps = nothing
end if
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
connEvent.Close
Set connEvent = nothing
%>

</body>
</html>