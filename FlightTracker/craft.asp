<!DOCTYPE html>

<!-- code/comments not formatted for word wrap -->

<%
'jump to the body overview if no craft db is specified
if request.querystring("db") = "" then response.redirect "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbol-System"

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

'check for FPS cookie
fpsCookie = Request.Cookies("FPS")
if len(fpsCookie) = 0 then fpsCookie = 30
%>

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/Yol0Gf0.png" />
  
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

  <!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto:900" />
  <link rel="stylesheet" type="text/css" href="https://unpkg.com/leaflet@0.5.1/dist/leaflet.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.ksp-src.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.label.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/tipped.css" />
  <link href="http://vjs.zencdn.net/5.0.2/video-js.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="../jslib/iosbadge.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.rrose.css" />

  <!-- JS libraries -->
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.5.1/leaflet-src.js"></script>
  <script type="text/javascript" src="../jslib/proj4js-combined.js"></script>
  <script type="text/javascript" src="../jslib/proj4leaflet.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.ksp-src.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.src.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.label.js"></script>
  <script type="text/javascript" src="../jslib/numeral.min.js"></script>
  <script type="text/javascript" src="../jslib/tipped.js"></script>
  <script type="text/javascript" src="../jslib/codebird.js"></script>  
  <script type="text/javascript" src="../jslib/spin.min.js"></script>  
  <script type="text/javascript" src="../jslib/iosbadge.js"></script>
  <script type="text/javascript" src="../jslib/leaflet.rrose-src.js"></script>

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
    // small helper function to make sure number calculated is not greater than a certain value
    function maxCalc(eq, val) {
      if (Math.abs(eq) > Math.abs(val)) { return val; } else { return eq; }
    }
    
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
    
    // this function will continually call itself to batch-run orbital calculations and not completely lock up the browser
    function orbitalCalc() {
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
        if (ecc < 1) {
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
            while (Math.abs(Ens-En) > 1E-10) {
              En = Ens;
              Ens = En - (En - ecc*Math.sin(En) - newMean)/(1 - ecc*Math.cos(En));
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
            
            if (ecc < 1.6) {
              if ((-Math.PI < newMean && newMean < 0) || newMean > Math.PI) {
                H = newMean - ecc;
              } else {
                H = newMean + ecc;
              }
            } else {
              if (ecc < 3.6 && Math.abs(newMean) > Math.PI) {
                H = newMean - Math.sign(newMean) * ecc;
              } else {
                H = newMean/(ecc - 1);
              }
            }
            
            Hn = newMean;
            Hn1 = H;
            while (Math.abs(Hn1 - Hn) > 1E-10) {
              Hn = Hn1;
              Hn1 = Hn + (newMean - ecc * Math.sinh(Hn) + Hn) / (ecc * Math.cosh(Hn) - 1);
            }
            
            EccA = Hn1;
          }
        }
        
        ///////////////////////////////
        // computeTrueAnomFromEccAnom()
        // computeTrueAnomFromHypAnom()
        ///////////////////////////////
        
        if (ecc < 1) {
          // (1+ecc) or (ecc+1) ???
          var upper = Math.sqrt(1+ecc) * Math.tan(EccA/2);
          var lower = Math.sqrt(1-ecc);
         
          // expanded AngleZero2Pi() function
          // abs(mod(real(Angle),2*pi));
          // javascript has a modulo operator, but it doesn't work the way we need. Or something
          // so using the mod() function implementation from Math.js: x - y * floor(x / y)
          var tru = Math.abs((Math.atan2(upper, lower) * 2) - (2*Math.PI) * Math.floor((Math.atan2(upper, lower) * 2) / (2*Math.PI)));
        } else {
          var upper = Math.sqrt(ecc+1) * Math.tanh(EccA/2);
          var lower = Math.sqrt(ecc-1);
          var tru = Math.atan2(upper, lower) * 2;
        }
        
        ///////////////////////////
        // getStatefromKepler_Alg()
        ///////////////////////////
        
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
        var alt = rNorm - bodRad;
        var vel = Math.sqrt(gmu*(2/rNorm - 1/sma));
        
        // convert the lon to proper coordinates (-180 to 180)
        if (longitude >= 180) { longitude -= 360; }
        
        // store all the derived values and advance to the next second
        latlon.push({lat: latitude, lng: longitude});
        orbitdata.push({alt: alt, vel: vel});
        currUT++;
        
        // update the progress bar
        $('#progress').css("width", (365 * (latlon.length/(endTime-initialUT))));
        
        // if we've just hit the atmosphere, end the calculations early
        if (alt <= atmoHeight) { currUT = endTime + 1; }

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
    }

    // this function will continually call itself to batch-run orbital calculations and not completely lock up the browser
    // this is used to calculate a single orbit for a second vessel or future orbital path
    var latlon2 = [];
    var orbitdata2 = [];
    function orbitalCalc2() {
      for (x=0; x<=1500; x++) {
      
        //////////////////////
        // computeMeanMotion() <-- refers to a function in KSPTOT code: https://github.com/Arrowstar/ksptot
        //////////////////////
        
        // adjust for motion since the time of this orbit
        n = Math.sqrt(gmu/(Math.pow(Math.abs(sma2),3)));
        var newMean = mean2 + n * (currUT - eph2);

        ////////////////
        // solveKepler()
        ////////////////
        
        var EccA = -1;
        if (ecc2 < 1) {
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
            var Ens = En - (En-ecc2*Math.sin(En) - newMean)/(1 - ecc2*Math.cos(En));
            while (Math.abs(Ens-En) > 1E-10) {
              En = Ens;
              Ens = En - (En - ecc2*Math.sin(En) - newMean)/(1 - ecc2*Math.cos(En));
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
            
            if (ecc2 < 1.6) {
              if ((-Math.PI < newMean && newMean < 0) || newMean > Math.PI) {
                H = newMean - ecc2;
              } else {
                H = newMean + ecc2;
              }
            } else {
              if (ecc2 < 3.6 && Math.abs(newMean) > Math.PI) {
                H = newMean - Math.sign(newMean) * ecc2;
              } else {
                H = newMean/(ecc2 - 1);
              }
            }
            
            Hn = newMean;
            Hn1 = H;
            while (Math.abs(Hn1 - Hn) > 1E-10) {
              Hn = Hn1;
              Hn1 = Hn + (newMean - ecc2 * Math.sinh(Hn) + Hn) / (ecc2 * Math.cosh(Hn) - 1);
            }
            
            EccA = Hn1;
          }
        }
        
        ///////////////////////////////
        // computeTrueAnomFromEccAnom()
        // computeTrueAnomFromHypAnom()
        ///////////////////////////////
        
        if (ecc2 < 1) {
          var upper = Math.sqrt(1+ecc2) * Math.tan(EccA/2);
          var lower = Math.sqrt(1-ecc2);
         
          // expanded AngleZero2Pi() function
          // abs(mod(real(Angle),2*pi));
          // javascript has a modulo operator, but it doesn't work the way we need. Or something
          // so using the mod() function implementation from Math.js: x - y * floor(x / y)
          var tru = Math.abs((Math.atan2(upper, lower) * 2) - (2*Math.PI) * Math.floor((Math.atan2(upper, lower) * 2) / (2*Math.PI)));
        } else {
          var upper = Math.sqrt(ecc2+1) * Math.tanh(EccA/2);
          var lower = Math.sqrt(ecc2-1);
          var tru = Math.atan2(upper, lower) * 2;
        }
        
        ///////////////////////////
        // getStatefromKepler_Alg()
        ///////////////////////////
        
        // Special Case: Circular Equitorial
        if(ecc2 < 1E-10 && (inc2 < 1E-10 || Math.abs(inc2-Math.PI) < 1E-10)) {
          var l = raan2 + arg2 + tru;
          tru = l;
          raan2 = 0;
          arg2 = 0;
        }

        // Special Case: Circular Inclined
        if(ecc2 < 1E-10 && inc2 >= 1E-10 && Math.abs(inc2-Math.PI) >= 1E-10) {
          var u = arg2 + tru;
          tru = u;
          arg2 = 0.0;
        }

        // Special Case: Elliptical Equitorial
        if(ecc2 >= 1E-10 && (inc2 < 1E-10 || Math.abs(inc2-Math.PI) < 1E-10)) {
          raan2 = 0;
        }

        var p = sma2*(1-(Math.pow(ecc2,2)));
        
        // vector/matrix operations handled by Sylvester - http://sylvester.jcoglan.com/
        var rPQW = $V([p*Math.cos(tru) / (1 + ecc2*Math.cos(tru)),
                       p*Math.sin(tru) / (1 + ecc2*Math.cos(tru)),
                       0]);
        var vPQW = $V([-Math.sqrt(gmu/p)*Math.sin(tru),
                       Math.sqrt(gmu/p)*(ecc2 + Math.cos(tru)),
                       0]);
        var TransMatrix = $M([
          [Math.cos(raan2)*Math.cos(arg2)-Math.sin(raan2)*Math.sin(arg2)*Math.cos(inc2), -Math.cos(raan2)*Math.sin(arg2)-Math.sin(raan2)*Math.cos(arg2)*Math.cos(inc2), Math.sin(raan2)*Math.sin(inc2)],
          [Math.sin(raan2)*Math.cos(arg2)+Math.cos(raan2)*Math.sin(arg2)*Math.cos(inc2), -Math.sin(raan2)*Math.sin(arg2)+Math.cos(raan2)*Math.cos(arg2)*Math.cos(inc2), -Math.cos(raan2)*Math.sin(inc2)],
          [Math.sin(arg2)*Math.sin(inc2), Math.cos(arg2)*Math.sin(inc2), Math.cos(inc2)]
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
        var alt = rNorm - bodRad;
        var vel = Math.sqrt(gmu*(2/rNorm - 1/sma));
        
        // convert the lon to proper coordinates (-180 to 180)
        if (longitude >= 180) { longitude -= 360; }
        
        // store all the derived values and advance to the next second
        latlon2.push({lat: latitude, lng: longitude});
        orbitdata2.push({alt: alt, vel: vel});
        currUT++;
        
        // exit the batch prematurely if we've reached the end of our needed calculations or if we just hit the atmosphere
        if ((currUT > endTime) || (alt <= atmoHeight)) { return true; }
      }
      
      // let the calling function know if we've completed all orbital calculations or not
      if (currUT > endTime) {
        return true; 
      } else {
        return false;
      }
    }
    
    // render the orbit line and markers for a second orbit, or second vessel
    var strRender;
    var rvMarker;
    var nodePath;
    var positionPopup2 = L.popup({closeButton: true});
    var timePopup = null;
    var nodeObtPopup = null;
    function renderSecondPath() {
    
      // calculate the orbit this craft will be on after a maneuver node is executed
      if (strRender == "node") {
        if (orbitalCalc2()) {

          // draw the orbital path with a dotted line
          var coord = 0;
          while (coord < latlon2.length) {
            var path = [];
            while (coord < latlon2.length) {
            
              // create a new array entry for this location, then advance the array counter
              path.push(latlon2[coord]);
              coord++;
              
              // detect if we've crossed off the edge of the map and need to cut the orbital line
              // compare this lng to the prev and if it changed from negative to positive or vice versa, we hit the edge  
              // (check if the lng is over 100 to prevent detecting a sign change while crossing the meridian)
              if (coord < latlon2.length) {
                if (((latlon2[coord].lng < 0 && latlon2[coord-1].lng > 0) && Math.abs(latlon2[coord].lng) > 100) || ((latlon2[coord].lng > 0 && latlon2[coord-1].lng < 0) && Math.abs(latlon2[coord].lng) > 100)) { break; }
              }
            }
            
            // create the path for this orbit
            nodePath = L.polyline(path, {smoothFactor: 1.25, clickable: true, color: '#ff9900', dashArray: '5,5', weight: 3, opacity: 1}).addTo(map);
            
            // identify this orbital line
            nodePath.on('mouseover mousemove', function(e) {
              if (nodeObtPopup) { map.closePopup(nodeObtPopup); }
              nodeObtPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
              nodeObtPopup.setLatLng(e.latlng);
              nodeObtPopup.setContent("Post-node Orbit");
              nodeObtPopup.openOn(map);
            });
            
            // remove the mouseover popup
            nodePath.on('mouseout', function(e) {
              if (nodeObtPopup) { map.closePopup(nodeObtPopup); }
              nodeObtPopup = null;
            });
          }
          
          // atmo entry?
          if (orbitdata2[orbitdata2.length-1].alt <= atmoHeight) {
            
            // create the icon for our atmo entry point, taken from the Squad asset file
            var atmoEntryIcon = L.icon({
              iconUrl: 'soientry.png',
              iconSize: [16, 12],
              iconAnchor: [9, 6]
            });
            
            // provide the full date and time of the event
            atmoUTC = new Date();
            atmoUTC.setTime((startDate + latlon2.length + latlon.length) * 1000);
            hrs = atmoUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = atmoUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = atmoUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // add the icon to the map and create the information popup for it
            atmoMark = L.marker(latlon2[latlon2.length-1], {icon: atmoEntryIcon}).addTo(map);
            atmoMark.bindPopup("<center><span id='atmoEntryTime'>Time to Atmosphere<br>" + formatTime((latlon.length + latlon2.length + initialUT) - UT, false) + "</span><br>" + (atmoUTC.getUTCMonth() + 1) + '/' + atmoUTC.getUTCDate() + '/' + atmoUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</center>", {closeButton: true});

            // functions will make sure fresh data is loaded when the popup displays and not just when the update tick happens
            atmoMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#atmoEntryTime').html("Time to Atmosphere<br>" + formatTime((latlon.length + latlon2.length)-now, false));
            });
            atmoMark.on('popupopen', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#atmoEntryTime').html("Time to Atmosphere<br>" + formatTime((latlon.length + latlon2.length)-now, false));
            });
          }

          // SOI exit event?
          if (period2 < 0) {
          
            // create the icon for our SOI exit point, taken from the Squad asset file
            var SOIExitIcon = L.icon({
              iconUrl: 'soiexit.png',
              iconSize: [16, 12],
              iconAnchor: [9, 6]
            });
            
            // provide the full date and time of the event
            soiUTC = new Date();
            soiUTC.setTime((startDate + latlon2.length) * 1000);
            hrs = soiUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = soiUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = soiUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // add the icon to the map and create the information popup for it
            SOIMark = L.marker(latlon2[latlon2.length-1], {icon: SOIExitIcon}).addTo(map);
            SOIMark.bindPopup("<center><span id='SOIExitTime'>Time to SOI Exit<br>" + formatTime(Math.abs(period2) - UT, false) + "</span><br>" + (soiUTC.getUTCMonth() + 1) + '/' + soiUTC.getUTCDate() + '/' + soiUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</center>", {closeButton: true});

            // functions will make sure fresh data is loaded when the popup displays and not just when the update tick happens
            SOIMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period2) - initialUT)-now, false));
            });
            SOIMark.on('popupopen', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period2) - initialUT)-now, false));
            });
          }
        } else {
          setTimeout(renderSecondPath, 1);
        }
        
      // calculate the orbit of a second vessel, such as one being rendezvoused with
      } else if (strRender == "rv") {
        if (orbitalCalc2()) {

          // draw the orbital path as a solid line
          var coord = 0;
          while (coord < latlon2.length) {
            var path = [];
            while (coord < latlon2.length) {
            
              // create a new array entry for this location, then advance the array counter
              path.push(latlon2[coord]);
              coord++;
              
              // detect if we've crossed off the edge of the map and need to cut the orbital line
              // compare this lng to the prev and if it changed from negative to positive or vice versa, we hit the edge  
              // (check if the lng is over 100 to prevent detecting a sign change while crossing the meridian)
              if (coord < latlon2.length) {
                if (((latlon2[coord].lng < 0 && latlon2[coord-1].lng > 0) && Math.abs(latlon2[coord].lng) > 100) || ((latlon2[coord].lng > 0 && latlon2[coord-1].lng < 0) && Math.abs(latlon2[coord].lng) > 100)) { break; }
              }
            }
            
            // create the path for this orbit
            var line = L.polyline(path, {smoothFactor: 1.25, clickable: true, color: '#ff9900', weight: 3, opacity: 1}).addTo(map);
            
            // show the time and orbit for this position
            line.on('mouseover mousemove', function(e) {
              var index = 0;
              var margin = 0.1;
              
              // traverse the latlon array and get the diff between the current index and the location clicked
              // if it is smaller than the margin, stop. If the entire orbit is searched, increase the margin and try again
              while (true) {
                if (Math.abs(latlon2[index].lat - e.latlng.lat) < margin && Math.abs(latlon2[index].lng - e.latlng.lng) < margin) { break; }
                index++;
                if (index >= latlon2.length) {
                  index = 0;
                  margin += 0.1;
                }
              }
              
              // use the current index to advance the time ahead to when along the orbit was clicked
              var dd = new Date();
              dd.setTime((startDate + index) * 1000);

              // compose the popup HTML and place it on the cursor location then display it
              var hrs = dd.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              var mins = dd.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              var secs = dd.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
              timePopup.setLatLng(e.latlng);
              timePopup.setContent(dd.getUTCMonth() + 1 + '/' + dd.getUTCDate() + '/' + dd.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + ' UTC');
              timePopup.openOn(map);
            });
            
            // remove the mouseover popup
            line.on('mouseout', function(e) {
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = null;
            });
            
            // when clicking along this line, find the nearest data point to display for the user
            line.on('click', function(e) {
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = null;
              var index = 0;
              var margin = 0.1;
              
              // traverse the latlon array and get the diff between the current index and the location clicked
              // if it is smaller than the margin, stop. If the entire orbit is searched, increase the margin and try again
              while (true) {
                if (Math.abs(latlon2[index].lat - e.latlng.lat) < margin && Math.abs(latlon2[index].lng - e.latlng.lng) < margin) { break; }
                index++;
                if (index >= latlon2.length) {
                  index = 0;
                  margin += 0.1;
                }
              }
              
              // use the current index to advance the time ahead to when along the orbit was clicked
              var dd = new Date();
              dd.setTime((startDate + index) * 1000);

              // compose the popup HTML and place it on the cursor location then display it
              if (latlon2[index].lat < 0) {
                cardinalLat = "S";
              } else {
                cardinalLat = "N";
              }
              if (latlon2[index].lng < 0) {
                cardinalLng = "W";
              } else {
                cardinalLng = "E";
              }
              var hrs = dd.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              var mins = dd.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              var secs = dd.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              positionPopup2.setLatLng(latlon2[index]);
              positionPopup2.setContent(dd.getUTCMonth() + 1 + '/' + dd.getUTCDate() + '/' + dd.getUTCFullYear() + ' @ ' + hrs + ':' + mins + ':' + secs + ' UTC<br>Latitude: ' + numeral(latlon2[index].lat).format('0.0000') + '&deg;' + cardinalLat + '<br>Longitutde: ' + numeral(latlon2[index].lng).format('0.0000') + '&deg;' + cardinalLng + '<br>Altitude: ' + numeral(orbitdata2[index].alt).format('0,0.000') + " km<br>Velocity: " + numeral(orbitdata2[index].vel).format('0,0.000') + " km/s");
              positionPopup2.openOn(map);
            });
          }

          // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
          // put in some maximum default values since the JQuery update doesn't adjust the width of the popup
          // maintain certain URL variables when linking to another craft
          var ship = L.icon({iconUrl: 'button_vessel_' + rvType + '.png', iconSize: [16, 16]});
          rvMarker = L.marker(latlon2[0], {icon: ship, zIndexOffset: 100}).addTo(map);
          strURLvars = '';
          if (getParameterByName("filter").length) { strURLvars += "&filter=" & getParameterByName("filter"); }
          if (getParameterByName("popout").length) { strURLvars += "&popout=" & getParameterByName("popout"); }
          if (getParameterByName("pass").length) { strURLvars += "&pass=" & getParameterByName("pass"); }
          rvMarker.bindPopup("<b><a href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" + strRendezvousDB + strURLvars + "'>" + rvCraft + "</a></b><br>Lat: <span id='lat2'>-000.0000&deg;S</span><br>Lng: <span id='lng2'>-000.0000&deg;W</span><br>Alt: <span id='alt2'>000,000.000km</span><br>Vel: <span id='vel2'>000,000.000km/s</span>", {closeButton: true});
          
          // set up a listener for popup events so we can immediately update the information and not have to wait for the next tick event
          cardinal = "";
          rvMarker.on('click', function(e) {
            var dd = new Date();
            dd.setTime(1473739200000 + (UT * 1000));
            var currDate = Math.floor(dd.getTime() / 1000);
            var now = currDate - startDate;
            if (now < latlon2.length) {
              if (latlon2[now].lat < 0) {
                cardinal = "S";
              } else {
                cardinal = "N";
              }
              $('#lat2').html(numeral(latlon2[now].lat).format('0.0000') + "&deg;" + cardinal);
              if (latlon2[now].lng < 0) {
                cardinal = "W";
              } else {
                cardinal = "E";
              }
              $('#lng2').html(numeral(latlon2[now].lng).format('0.0000') + "&deg;" + cardinal);
              $('#alt2').html(numeral(orbitdata2[now].alt).format('0,0.000') + " km");
              $('#vel2').html(numeral(orbitdata2[now].vel).format('0,0.000') + " km/s");
            }
          });
          
          // let the tick function know this data needs to be updated
          bRV = true;
        } else {
          setTimeout(renderSecondPath, 1);
        }
      }
    }

    // once we've calculated all the orbital stuff needed, we can draw the map
    var craft;
    var cardinal;
    var nodeMark;
    var SOIMark;
    var sunMark;
    var apMark;
    var peMark;
    var apTime;
    var peTime;
    var bNodeExecution = false;
    var bNodeRefreshCheck = false;
    var bMapRender = false;
    var lines = [];
    var infoControl;
    var positionPopup = L.popup({offset: new L.Point(0,-1), closeButton: true, closeOnClick: false});
    var terminatorW = null;
    var terminatorE = null;
    function renderMap(localUT) {
    
      // check if we are using a dynamic map
      if (bDrawMap) {
        
        // render the terminator?
        if (solDay) {
        
          // start by determining the current position of the sun given the body's degree of initial rotation and rotational period
          currRot = -rotInitDeg - (((localUT / solDay) % 1) * 360);
          if (currRot < -180) { currRot += 360; }
          // create the icon for our sun marker
          var sunIcon = L.icon({
            iconUrl: 'sun.png',
            iconSize: [16, 16],
            iconAnchor: [8, 8]
          });
          
          // place the sun marker
          sunMark = L.marker([0,currRot], {icon: sunIcon, clickable: false}).addTo(map);

          // draw the terminators
          // terminators draw if there is room, extending as much as 180 degrees or to the edge of the map
          if (currRot - 90 > -180) {
            terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
          }
          if (currRot + 90 < 180) {
            terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
          }
        }
      }
      
      // how the rest of this function works depends on whether there is an active maneuver in progress at this time
      if (!bNodeExecution) {
      
        // find the times to Apoapsis and Periapsis
        // same code used for determining the change in mean since Eph
        // take into account hyperbolic/SOI escape orbits
        if (period > 0) {
          newMean = mean + n * (localUT - eph);
          if (newMean < 0 || newMean > 2*Math.PI) {
            newMean = Math.abs(newMean - (2*Math.PI) * Math.floor(newMean / (2*Math.PI)));
          }
          apTime = Math.round((Math.PI - newMean)/n);
          peTime = Math.round((Math.PI*2 - newMean)/n);
          
          // close to Ap/Pe we can get a negative value, so handle that by just adding the period
          if (apTime <= 0) { apTime += Math.round(period); }
          if (peTime <= 0) { peTime += Math.round(period); }
          
        // hyperbolic/SOI escape - do a check for ap/pe based on orbit info
        } else {
          
          // if altitude is increasing check for Ap
          if (orbitdata[0].alt < orbitdata[1].alt) {
            for (x=1; x<orbitdata.length-1; x++) {
              if (orbitdata[x].alt > orbitdata[x+1].alt) {
                apTime = x;
                break;
              }
            }
          }

          // if altitude is decreasing check for Pe
          if (orbitdata[0].alt > orbitdata[1].alt) {
            for (x=1; x<orbitdata.length-1; x++) {
              if (orbitdata[x].alt < orbitdata[x+1].alt) {
                peTime = x;
                break;
              }
            }
          }
        }
        
        // check if we are using a dynamic map
        if (bDrawMap) {
        
          // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
          // put in some maximum default values since the JQuery update doesn't adjust the width of the popup
          craft = L.marker(latlon[0], {icon: ship, zIndexOffset: 100}).addTo(map);
          craft.bindPopup("Lat: <span id='lat'>-000.0000&deg;S</span><br>Lng: <span id='lng'>-000.0000&deg;W</span><br>Alt: <span id='alt'>000,000.000km</span><br>Vel: <span id='vel'>000,000.000km/s</span>", {closeButton: true});
          
          // set up a listener for popup events so we can immediately update the information and not have to wait for the next tick event
          cardinal = "";
          craft.on('click', function(e) {
            var dd = new Date();
            dd.setTime(1473739200000 + (UT * 1000));
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
              $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + " km");
              $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + " km/s");
            }
          });
          
          // draw the orbital paths
          var coord = coordStart = 0;
          var colors = ['#00FF00', '#FF0000', '#FFFF00'];
          var pathNum = 0;
          while (coord < latlon.length) {
            var path = [];
            while (coord < latlon.length) {
            
              // cut the path if we've reached the end of an orbit
              if (period > 0 && coord/(pathNum+1) > period) {	break; }
              
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
            lines.push(L.polyline(path, {smoothFactor: 1.25, clickable: true, color: colors[pathNum], weight: 3, opacity: 1}).addTo(map));
            
            // save the beginning latlon index of this line to make it faster when searching for a data point by not having to look at all 3 orbits
            // also save the current orbit for mouse-over popup
            lines[lines.length-1]._myId = coordStart + " " + (pathNum+1);
            
            // show the time and orbit for this position
            lines[lines.length-1].on('mouseover mousemove', function(e) {
              var idStr = e.target._myId.split(" ");
              var index = parseInt(idStr[0]);
              var margin = 0.1;
              
              // traverse the latlon array and get the diff between the current index and the location clicked
              // if it is smaller than the margin, stop. If the entire orbit is searched, increase the margin and try again
              while (true) {
                if (Math.abs(latlon[index].lat - e.latlng.lat) < margin && Math.abs(latlon[index].lng - e.latlng.lng) < margin) { break; }
                index++;
                
                // be sure to account for running to the end of the current orbit if this is the 1st or 2nd or end of array if it is the 3rd
                if (index >= e.target._myId + Math.abs(period) || index >= latlon.length) {
                  index = parseInt(idStr[0]);
                  margin += 0.1;
                }
              }
              
              // use the current index to advance the time ahead to when along the orbit was clicked
              var dd = new Date();
              dd.setTime((startDate + index) * 1000);

              // compose the popup HTML and place it on the cursor location then display it
              var hrs = dd.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              var mins = dd.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              var secs = dd.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
              timePopup.setLatLng(e.latlng);
              timePopup.setContent("<center>Orbit #" + parseInt(idStr[1]) + "<br>" + (dd.getUTCMonth() + 1) + '/' + dd.getUTCDate() + '/' + dd.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + ' UTC</center>');
              timePopup.openOn(map);
            });
            
            // remove the mouseover popup
            lines[lines.length-1].on('mouseout', function(e) {
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = null;
            });
            
            // when clicking along this line, find the nearest data point to display for the user
            lines[lines.length-1].on('click', function(e) {
              map.closePopup(timePopup);
              timePopup = null;
              var idStr = e.target._myId.split(" ");
              var index = parseInt(idStr[0]);
              var margin = 0.1;
                
              // traverse the latlon array and get the diff between the current index and the location clicked
              // if it is smaller than the margin, stop. If the entire orbit is searched, increase the margin and try again
              while (true) {
                if (Math.abs(latlon[index].lat - e.latlng.lat) < margin && Math.abs(latlon[index].lng - e.latlng.lng) < margin) { break; }
                index++;
                
                // be sure to account for running to the end of the current orbit if this is the 1st or 2nd or end of array if it is the 3rd
                if (index >= e.target._myId + Math.abs(period) || index >= latlon.length) {
                  index = parseInt(idStr[0]);
                  margin += 0.1;
                }
              }

              // use the current index to advance the time ahead to when along the orbit was clicked
              var dd = new Date();
              dd.setTime((startDate + index) * 1000);

              // compose the popup HTML and place it on the cursor location then display it
              if (latlon[index].lat < 0) {
                cardinalLat = "S";
              } else {
                cardinalLat = "N";
              }
              if (latlon[index].lng < 0) {
                cardinalLng = "W";
              } else {
                cardinalLng = "E";
              }
              var hrs = dd.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              var mins = dd.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              var secs = dd.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              positionPopup.setLatLng(latlon[index]);
              positionPopup.setContent(dd.getUTCMonth() + 1 + '/' + dd.getUTCDate() + '/' + dd.getUTCFullYear() + ' @ ' + hrs + ':' + mins + ':' + secs + ' UTC<br>Latitude: ' + numeral(latlon[index].lat).format('0.0000') + '&deg;' + cardinalLat + '<br>Longitutde: ' + numeral(latlon[index].lng).format('0.0000') + '&deg;' + cardinalLng + '<br>Altitude: ' + numeral(orbitdata[index].alt).format('0,0.000') + " km<br>Velocity: " + numeral(orbitdata[index].vel).format('0,0.000') + " km/s");
              positionPopup.openOn(map);
            });
            
            // we're about to maybe start a new orbit, so update the starting location of the next line
            coordStart = coord;
            
            // check if we have completed an orbit, not just hit the end of the map
            // if it's a new orbit, advance to the next line color
            if (period > 0 && coord/(pathNum+1) > period) {	pathNum++; }
          }

          // atmo entry?
          if (orbitdata[orbitdata.length-1].alt <= atmoHeight) {
            
            // create the icon for our atmo entry point, taken from the Squad asset file
            var atmoEntryIcon = L.icon({
              iconUrl: 'soientry.png',
              iconSize: [16, 12],
              iconAnchor: [9, 6]
            });
            
            // provide the full date and time of the event
            atmoUTC = new Date();
            atmoUTC.setTime((startDate + latlon.length) * 1000);
            hrs = atmoUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = atmoUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = atmoUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // add the icon to the map and create the information popup for it
            atmoMark = L.marker(latlon[latlon.length-1], {icon: atmoEntryIcon}).addTo(map);
            atmoMark.bindPopup("<center><span id='atmoEntryTime'>Time to Atmosphere<br>" + formatTime((latlon.length + initialUT) - UT, false) + "</span><br>" + (atmoUTC.getUTCMonth() + 1) + '/' + atmoUTC.getUTCDate() + '/' + atmoUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</center>", {closeButton: true});

            // functions will make sure fresh data is loaded when the popup displays and not just when the update tick happens
            atmoMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#atmoEntryTime').html("Time to Atmosphere<br>" + formatTime((latlon.length)-now, false));
            });
            atmoMark.on('popupopen', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#atmoEntryTime').html("Time to Atmosphere<br>" + formatTime((latlon.length)-now, false));
            });
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
              
              // provide the full date and time of the event
              nodeUTC = new Date();
              nodeUTC.setTime((startDate + latlon.length) * 1000);
              hrs = nodeUTC.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              mins = nodeUTC.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              secs = nodeUTC.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
 
              // add the icon to the map and create the information popup for it
              nodeMark = L.marker(latlon[nodeUT - localUT], {icon: nodeIcon}).addTo(map);
              nodeMark.bindPopup("<center><span id='nodeTime'>Time to Maneuver<br>" + formatTime(nodeUT - localUT, false) + "</span><br>" + (nodeUTC.getUTCMonth() + 1) + '/' + nodeUTC.getUTCDate() + '/' + nodeUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</center><br>Prograde &Delta;v: " + numeral(nodePrograde).format('0.000') + " m/s<br>Normal &Delta;v: " + numeral(nodeNormal).format('0.000') + " m/s<br>Radial &Delta;v: " + numeral(nodeRadial).format('0.000') + " m/s<br>Total &Delta;v: " + numeral(nodeTotal).format('0.000') + " m/s", {closeButton: true});

              // update the tooltip text for the Next list
              // because touchscreen devices can't see tooltips, they will get an alert window
              if (is_touch_device()) {
                $("#nextNode").html($("#nextNode").html() + "<br>Click OK to show Maneuver Node");
              } else {
                $("#nextNode").html($("#nextNode").html() + "<br>Click to show Maneuver Node");
              }
              
              // render the new orbit if a rendevous craft is not provided
              // this is because if a rendezvous is planned for this maneuver, the orbit of that craft is what's being matched
              // convert to radians from degrees where needed
              if (!strRendezvousDB.length) {
                nodeData = nodeEndObt.split(";")
                ecc2 = parseFloat(nodeData[0]);
                inc2 = parseFloat(nodeData[1]) * .017453292519943295;
                period2 = parseFloat(nodeData[2]);
                sma2 = parseFloat(nodeData[3]);
                raan2 = parseFloat(nodeData[4]) * .017453292519943295;
                arg2 = parseFloat(nodeData[5]) * .017453292519943295;
                mean2 = parseFloat(nodeData[6]) * .017453292519943295;
                currUT = eph2 = parseFloat(nodeData[7]);
                if (period2 > 0) {
                  if (period2 > maxDeltaTime) { endTime = currUT + maxDeltaTime; }
                  else { endTime = currUT + period2; }
                } else {
                  endTime = Math.abs(period2);
                }
                strRender = "node";
                renderSecondPath();
              }
            }
            
            // if we can't yet draw the node, set a reminder to refresh the page when we can
            // update the tooltip text for the Next list
            else {
              bNodeRefreshCheck = true;
              $("#nextNode").html($("#nextNode").html() + "<br>Maneuver Node not yet visible");
            }
          }
          
          // some orbits may be too long to show Ap/Pe markers, so ensure that we can display them at all (also account for SOI exit)
          if (apTime < latlon.length) { 
            if (bDrawMap) {
            
              // let the user see the exact time of the event in addition to a countdown timer
              apUTC = new Date();
              apUTC.setTime((startDate + Math.abs(apTime)) * 1000);
              hrs = apUTC.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              mins = apUTC.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              secs = apUTC.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              
              // add the marker, assign its information popup and give it a callback for instant update when opened
              apMark = L.marker(latlon[apTime], {icon: apIcon}).addTo(map); 
              apMark.bindPopup("<center><span id='apTime'>Time to Apoapsis<br>" + formatTime(apTime, false) + "</span><br><span id='apDate'>" + (apUTC.getUTCMonth() + 1) + '/' + apUTC.getUTCDate() + '/' + apUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</span></center>", {closeButton: true});
              apMark.on('click', function(e) {
                var dd = new Date();
                dd.setTime(1473739200000 + (UT * 1000));
                var currDate = Math.floor(dd.getTime() / 1000);
                var now = currDate - startDate;
                $('#apTime').html("Time to Apoapsis<br>" + formatTime(apTime-now, false));
              });
            } else { apTime = -1; }
          }
          if (peTime < latlon.length) { 
            if (bDrawMap) {
              peUTC = new Date();
              peUTC.setTime((startDate + Math.abs(peTime)) * 1000);
              hrs = peUTC.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              mins = peUTC.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              secs = peUTC.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              peMark = L.marker(latlon[peTime], {icon: peIcon}).addTo(map); 
              peMark.bindPopup("<center><span id='peTime'>Time to Periapsis<br>" + formatTime(peTime, false) + "</span><br><span id='peDate'>" + (peUTC.getUTCMonth() + 1) + '/' + peUTC.getUTCDate() + '/' + peUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</span></center>", {closeButton: true});
              peMark.on('click', function(e) {
                var dd = new Date();
                dd.setTime(1473739200000 + (UT * 1000));
                var currDate = Math.floor(dd.getTime() / 1000);
                var now = currDate - startDate;
                $('#peTime').html("Time to Periapsis<br>" + formatTime(peTime-now, false));
              });
            } else { peTime = -1; }
          }
          
          // SOI exit event?
          if (period < 0) {
          
            // create the icon for our SOI exit event, taken from the Squad asset file
            var SOIExitIcon = L.icon({
              iconUrl: 'soiexit.png',
              iconSize: [16, 12],
              iconAnchor: [9, 6]
            });
            
            // let the user see the exact time of the event in addition to a countdown timer
            soiUTC = new Date();
            soiUTC.setTime((startDate + latlon.length) * 1000);
            hrs = soiUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = soiUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = soiUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // add the icon to the map and create the information popup for it
            SOIMark = L.marker(latlon[latlon.length-1], {icon: SOIExitIcon}).addTo(map);
            SOIMark.bindPopup("<center><span id='SOIExitTime'>Time to SOI Exit<br>" + formatTime(Math.abs(period) - localUT, false) + "</span><br>" + (soiUTC.getUTCMonth() + 1) + '/' + soiUTC.getUTCDate() + '/' + soiUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC</center>", {closeButton: true});

            // functions will make sure fresh data is loaded when the popup displays and not just when the update tick happens
            SOIMark.on('click', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period) - initialUT)-now, false));
            });
            SOIMark.on('popupopen', function(e) {
              var dd = new Date();
              dd.setTime(1473739200000 + (UT * 1000));
              var currDate = Math.floor(dd.getTime() / 1000);
              var now = currDate - startDate;
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period) - initialUT)-now, false));
            });
          }
          
          // now that the map is fully rendered, we can switch its hidden state from visibility to display so we can fade it in
          // otherwise with a display of none markers and orbits would not be able to render properly
          $('#map').css("display", "none");
          $('#map').css("visibility", "visible");
          $('#map').fadeToggle();
          $('#iconSurfaceMap').fadeToggle();
          $('#iconStaticObt').fadeToggle();
          
          // update the marker popup data now for when it is automatically shown
          var dd = new Date();
          dd.setTime(1473739200000 + (UT * 1000));
          var currDate = Math.floor(dd.getTime() / 1000);
          var now = currDate - startDate;

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
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + " km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + " km/s");

          // Show the craft info box. This lets people know it exists and also serves to bring the craft into view
          craft.openPopup(); 
        
          // remove the popup box for the craft position after 5 seconds, user can re-open it if they want to
          // also hide map icons if the cursor is not over them or the map. They come back when the user hovers over the map
          setTimeout(function () { 
          
            // for some reason closing the craft popup will freeze an orbital line popup unless it is not closed first
            if (timePopup) { map.closePopup(timePopup); }
            craft.closePopup();
            if (!$('#iconStaticObt').is(":hover") && !$('#iconSurfaceMap').is(":hover") && !$('#map').is(":hover")) { 
              $("#iconStaticObt").fadeOut();
              $("#iconSurfaceMap").fadeOut();
            }
            
            // open the maneuver node if we were sent here looking for it and it exists on the map
            if (getParameterByName('node') && bUpcomingNode && !bNodeRefreshCheck) { nodeMark.openPopup(); }
          }, 5000);
          
          // let user know if the maneuver node they were sent here to see is not yet visible on the rendered orbits
          if (getParameterByName('node') && bUpcomingNode && bNodeRefreshCheck) { $("#msgNode").fadeToggle(); }
          
          // let the user know orbital rendering has been cut short for faster page load
          // gives them the option to render full orbits now that they are asynchronously calculated
          if (showMsg && latlon.length >= maxDeltaTime) { $("#msgObtPd").fadeToggle(); }
          
        // no dynamic map, so setup static orbit info box
        } else {
          var dd = new Date();
          dd.setTime(1473739200000 + (UT * 1000));
          var currDate = Math.floor(dd.getTime() / 1000);
          var now = currDate - startDate;
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
          strHTML = "<b>Lat:</b> <span id='lat'>" + numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinalLat + "</span><br>" +
            "<b>Lng:</b> <span id='lng'>" + numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinalLon + "</span><br>" +
            "<b>Alt:</b> <span id='alt'>" + numeral(orbitdata[now].alt).format('0,0.000') + " km" + "</span><br>" +
            "<b>Vel:</b> <span id='vel'>" + numeral(orbitdata[now].vel).format('0,0.000') + " km/s" + "</span><br>";
          
          // SOI exit event?
          if (period < 0) {
          
            // let the user see the exact time of the event in addition to a countdown timer
            soiUTC = new Date();
            soiUTC.setTime((startDate + latlon.length) * 1000);
            hrs = soiUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = soiUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = soiUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // show this info in place of Ap/Pe timings
            strHTML += "<b>SOI Exit:</b><br>" + (soiUTC.getUTCMonth() + 1) + '/' + soiUTC.getUTCDate() + '/' + soiUTC.getUTCFullYear() + ' @ ' + hrs + ':' + mins + ':' + secs + " UTC<br><b>Time Remaining:</b><br><span id='soiTime'>" + formatTime(Math.abs(period) - localUT, false) + "</span>";

          // atmo entry?
          } else if (orbitdata[orbitdata.length-1].alt <= atmoHeight) {
            
            // let the user see the exact time of the event in addition to a countdown timer
            atmoUTC = new Date();
            atmoUTC.setTime((startDate + latlon.length) * 1000);
            hrs = atmoUTC.getUTCHours();
            if (hrs < 10) { hrs = '0' + hrs; }
            mins = atmoUTC.getUTCMinutes();
            if (mins < 10) { mins = '0' + mins; }
            secs = atmoUTC.getUTCSeconds();
            if (secs < 10) { secs = '0' + secs; }
            
            // show this info in place of Ap/Pe timings
            strHTML += "<b>Atmosperic Interface:</b><br>" + (atmoUTC.getUTCMonth() + 1) + '/' + atmoUTC.getUTCDate() + '/' + atmoUTC.getUTCFullYear() + ' @ ' + hrs + ':' + mins + ':' + secs + " UTC<br><b>Time Remaining:</b><br><span id='atmoTime'>" + formatTime((latlon.length + initialUT) - UT, false) + "</span>";

          // normal orbit, so include Ap/Pe
          } else {
            strHTML += "<b>Time to Ap:</b> <span id='apTime'>" + formatTime(apTime-now, false) + "</span><br>" +
            "<b>Time to Pe:</b> <span id='peTime'>" + formatTime(peTime-now, false) + "</span>";
          }

          // do we need to add maneuver data?
          if (bUpcomingNode) { 
          
            // place the maneuver details in a tooltip
            strDvDeets = "<b>Prograde &Delta;v:</b> " + numeral(nodePrograde).format('0.000') + "<br>" +
              "<b>Normal &Delta;v:</b> " + numeral(nodeNormal).format('0.000') + "<br>" +
              "<b>Radial &Delta;v:</b> " + numeral(nodeRadial).format('0.000');

            // add the maneuver overview
            strHTML += "<br><span id='boxUpdate'><b>Time to Maneuver:</b> " + formatTime(((nodeUT - initialUT)-now), false) + "</span><br>" +
              "<span class='tipNew' style='text-decoration: underline; text-decoration-style: dotted; cursor: pointer' title='" + strDvDeets + "'><b>Total &Delta;v:</b></span> " + numeral(nodeTotal).format('0.000');
            
            // need to give a delay before creating the tooltip
            setTimeout(function() {
              Tipped.create('.tipNew', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
            }, 500);
          }

          // update and show the orbital data
          $('#orbData').html(strHTML);
          $('#orbData').fadeIn();
        }

        // we can get rid of the loading status bar now
        $("#orbDataMsg").fadeOut();
        
        // let our update tick function know the map is now visible
        bMapRender = true;
    
        // with the map rendered, if a second vessel orbit needs to be shown we can start that process now
        if (strRendezvousDB.length) {
          var strURL = "orbitinfo.asp?db=" + strRendezvousDB;
          ajaxOrbitData.open("GET", strURL, true);
          ajaxOrbitData.send();
        }
        
      // active maneuver node being carried out
      } else {
      
        // check if we are using a dynamic map
        if (bDrawMap) {

          // remove any lines rendered previously and clear the array
          for (x=0; x<lines.length; x++) { map.removeLayer(lines[x]); }
          lines = [];

          // render this orbit
          var coord = 0;
          while (coord < latlon.length) {
            var path = [];
            while (coord < latlon.length) {
            
              // cut the path if we've reached the end of an orbit
              if (period > 0 && coord/(pathNum+1) > period) {	break; }
              
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
            lines.push(L.polyline(path, {smoothFactor: 1.25, clickable: false, color: "#00FF00", weight: 3, opacity: 1}).addTo(map));
          }
          
          // the map may not yet be visible if page was loaded during a maneuver
          if (!bMapRender) {
          
            // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
            // put in some maximum default values since the JQuery update doesn't adjust the width of the popup
            nodeTelemData = nodeTelem.split("|");
            if (UT - nodeUT < nodeTelemData.length) {
              data = nodeTelemData[UT - nodeUT].split(";");
              burnTime = formatTime(nodeEndUT - UT);
            } else {
              data = nodeTelemData[nodeTelemData.length - 1].split(";");
              burnTime = "00s";
            }
            craft = L.marker(latlon[0], {icon: ship, zIndexOffset: 100}).addTo(map);
            craft.bindPopup("Lat: <span id='lat'>" + numeral(data[11]).format('0.0000') + "&deg;S</span><br>Lng: <span id='lng'>" + numeral(data[12]).format('0.0000') + "&deg;W</span><br>Alt: <span id='alt'>" + numeral(data[14]).format('0,0.000') + " km</span><br>Vel: <span id='vel'>" + numeral(data[13]).format('0,0.000') + " km/s</span><br>&Delta;v Left: <span id='dv'>" + numeral(data[15]).format('0.000') + " km/s</span><br>Time Left: <span id='burnTime'>" + burnTime + "</span>", {closeButton: true});
            craft.openPopup();
            
            // split up the telemetry data and change the craft image to show burn in progress
            nodeTelemData = nodeTelem.split("|");
            if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
            if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }
            
            // we can get rid of the loading status bar now
            $("#orbDataMsg").fadeOut();

            // now that the map is fully rendered, we can switch its hidden state from visibility to display so we can fade it in
            // otherwise with a display of none markers and orbits would not be able to render properly
            $('#map').css("display", "none");
            $('#map').css("visibility", "visible");
            $('#map').fadeToggle();
            $('#iconSurfaceMap').fadeToggle();
            $('#iconStaticObt').fadeToggle();

            // render the end maneuver orbit
            // convert to radians from degrees where needed
            nodeData = nodeEndObt.split(";")
            ecc2 = parseFloat(nodeData[0]);
            inc2 = parseFloat(nodeData[1]) * .017453292519943295;
            period2 = parseFloat(nodeData[2]);
            sma2 = parseFloat(nodeData[3]);
            raan2 = parseFloat(nodeData[4]) * .017453292519943295;
            arg2 = parseFloat(nodeData[5]) * .017453292519943295;
            mean2 = parseFloat(nodeData[6]) * .017453292519943295;
            currUT = eph2 = parseFloat(nodeData[7]);
            if (period2 > maxDeltaTime) { endTime = currUT + maxDeltaTime; }
            else { endTime = currUT + period2; }
            strRender = "node";
            renderSecondPath();

            bMapRender = true;
          }
          
          // ready to go again
          bIdle = true;
          
        // set up static orbit info box
        } else {

          // get rid of the loading bar and setup the telemetry data
          $("#orbDataMsg").fadeOut();
          nodeTelemData = nodeTelem.split("|");
        
          // waiting for signal delay to run down?
          if (localUT - nodeUT <= sigDelay) {
            $("#orbData").html("<b>Maneuver in Progress</b><br><span id='boxUpdate'><b>Signal Delay:</b> " + formatTime(sigDelay - (localUT - nodeUT))) + "</span>";
          } else {
          
            // change the craft image to show burn in progress, 
            if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
            if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }
            
            // get the specific data points for this moment, if there is data
            if ((localUT - nodeUT) - sigDelay < nodeTelemData.length) {
              data = nodeTelemData[(localUT - nodeUT) - sigDelay].split(";");
              
              // update the data display orbital details 
              $("#obtAvgVel").html(numeral(data[0]).format('0,0.000'));
              $("#obtPe").html(numeral(data[1]).format('0,0.000'));
              $("#obtAp").html(numeral(data[2]).format('0,0.000'));
              $("#obtEcc").html(numeral(data[3]).format('0.000000'));
              $("#obtInc").html(numeral(data[4]).format('0,0.000'));
              $("#obtPd").html(numeral(data[5]).format('0,0.00') + "s");

              // update the craft data
              if (data[11] < 0) {
                cardinalLat = "S";
              } else {
                cardinalLat = "N";
              }
              if (data[12] < 0) {
                cardinalLon = "W";
              } else {
                cardinalLon = "E";
              }
              $('#orbData').html("<b>Lat:</b> " + numeral(data[11]).format('0.0000') + "&deg;" + cardinalLat + "<br>" +
                "<b>Lng:</b> " + numeral(data[12]).format('0.0000') + "&deg;" + cardinalLon + "<br>" +
                "<b>Alt:</b> " + numeral(data[14]).format('0,0.000') + " km" + "<br>" +
                "<b>Vel:</b> " + numeral(data[13]).format('0,0.000') + " km/s" + "<br>" +
                "<b>&Delta;v Left:</b> " + numeral(data[15]).format('0.000') + " km/s" + "<br>" +
                "<span id='boxUpdate'><b>Time Left:</b> " + formatTime(nodeEndUT - (localUT - sigDelay)) + "</span>");
            
            // maneuver is over - await update
            } else if ((localUT - nodeUT) - sigDelay >= nodeTelemData.length) {
              
              // we may not have even bothered with maneuver telem
              if (nodeTelemData.length > 0) {
                $("#orbData").html("Maneuver Completed!<br>Awaiting Update...");
              } else {
                $("#orbData").html("Maneuver in Progress<br>Awaiting Update...");
              }
            }
          }

          // show the orbital data
          $('#orbData').fadeIn();
        }
      }
    }
    
    // advance the values of ascent data while telemetry is playing or being seeked
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
    var lastCam;
    var ascentTracks = [];
    var ascentMarks = [];
    var ascentColors = ['#00FF00', '#FF0000', '#FFFF00', '#00FFFF', '#FF00FF', '#0000FF', '#800080', '#ffa500'];
    var ascentColorsIndex = -1;
    var ascentPopup = null;
    var noMarkBox = L.latLngBounds(L.latLng(0.1978, -74.8389), L.latLng(-0.3516, -74.2896));
    function ascentUpdater(delta, bForceUpdate) {

      // update the the mission timer caption
      if (telemetryUT + delta >= launchUT) { 
        $("#captionMET").html("MET: "); 
      } else {
        $("#captionMET").html("Launch in: "); 
      }
      
      // clamp data every interval, perform status updates, check performance
      if (delta - ascentIntervalElapse >= ascentData[0].LogInterval.clamp || bForceUpdate) {
      
        // data clamps to ensure accuracy over time
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

        // phase status update after lift off? Then update our line color and start a new line
        // don't do this if paused, the seek buttons will redraw the whole path
        if (!bForceUpdate && ascentData[delta].Phase && ascentData[delta].DstTraveled.clamp > 0) {  
          ascentColorsIndex++;
          if (ascentColorsIndex == ascentColors.length) { ascentColorsIndex = 0; }
          ascentTracks.push(L.polyline([], {smoothFactor: .25, clickable: true, color: ascentColors[ascentColorsIndex], weight: 2, opacity: 1}).addTo(map));
          ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[delta-1].Lat, ascentData[delta-1].Lon]);
          ascentTracks[ascentTracks.length-1]._myId = "<center>" + ascentData[delta].Phase + "</center>";
          ascentTracks[ascentTracks.length-1].on('mouseover mousemove', function(e) {
            ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
            ascentPopup.setLatLng(e.latlng);
            ascentPopup.setContent(e.target._myId);
            ascentPopup.openOn(map);
          });
          ascentTracks[ascentTracks.length-1].on('mouseout', function(e) {
            if (ascentPopup) { map.closePopup(ascentPopup); }
            ascentPopup = null;
          });
        }
        
        // if we are out of a bound area around KSC, add event markers to the plot
        // prior to this there's no point as they would just pile atop each other
        if (!noMarkBox.contains(craft.getLatLng()) && !bForceUpdate && ascentData[delta].EventMark) {
          var labelIcon = L.icon({
            iconUrl: 'label.png',
            iconSize: [10, 10],
          });
          ascentMarks.push(L.marker([ascentData[delta].Lat, ascentData[delta].Lon], {icon: labelIcon}).addTo(map));
          ascentMarks[ascentMarks.length-1]._myId = ascentData[delta].EventMark + ";" + ascentData[delta].Lat + ";" + ascentData[delta].Lon;
          ascentMarks[ascentMarks.length-1].on('mouseover mousemove', function(e) {
          
            // hack to get around leaflet error of not being able to get Lat/Lng from callback e.latlng
            data = e.target._myId.split(";")
            ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
            ascentPopup.setLatLng([data[1], data[2]]);
            ascentPopup.setContent(data[0]);
            ascentPopup.openOn(map);
          });
          ascentMarks[ascentMarks.length-1].on('mouseout', function(e) {
            if (ascentPopup) { map.closePopup(ascentPopup); }
            ascentPopup = null;
          });
        }
        
        // reposition the craft marker and create/add to the line
        // for some reason, using addLatLng() produced an intractible error, so using spliceLatLngs() instead *shrug*
        craft.setLatLng([ascentData[delta].Lat, ascentData[delta].Lon]);
        if (!bForceUpdate && ascentTracks.length) { ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, craft.getLatLng()); }

        // reposition the map if the craft has moved out of the current view
        if (ascentTracks.length && !map.getBounds().contains(ascentTracks[ascentTracks.length-1].getBounds())) { map.fitBounds(ascentTracks[ascentTracks.length-1].getBounds(), {maxZoom: 5}); }

        // update the craft image/event & video captions
        $('#image-1').attr("src", ascentData[delta].Image);
        $('#event').html(ascentData[delta].Event);
        $('#ascentStatus').html("Current Status: " + ascentData[delta].Event);
        $('#videoCameraName').html(ascentData[delta].Camera);
        
        // sync the video on camera changes
        if (lastCam != ascentData[delta].Camera) {
          lastCam = ascentData[delta].Camera;
          launchVideo.currentTime = telemetryUT - videoStartUT + delta;
        }

        // display text for the AoA warning otherwise print a nominal report
        if (ascentData[delta].AoAWarn.length > 0) {
          $("#aoawarn").html(ascentData[delta].AoAWarn.substr(0, ascentData[delta].AoAWarn.search(":")));
          $("#aoawarn").css("color", ascentData[delta].AoAWarn.substr(ascentData[delta].AoAWarn.search(":")+1));
        } else {
          $("#aoawarn").html("Nominal");
          $("#aoawarn").css("color", "green");
        }
        
        // send a tweet?
        // make sure it's only mission control sending the tweets not everybody!
        // also check that this is a live launch not a replay
        if (ascentData[delta].Tweet.length > 0 && getCookie('missionctrl') && !bPastUT) {
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
        // end it 3s prior to end of video because of Freemake watermark at the end
        if (bVideoLoaded && vidAscentLength - delta < 3) {
          $("#mainwrapper").fadeIn();
          $("#videoStatus").fadeOut();
          $("#videoCameraName").fadeOut();
          $("#ascentStatus").fadeIn();
        }
        
        // reset performance hits, less than the threshold per interval isn't worrisome
        perfHit = 0;
        
        // debug data for survey
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
        $("#velocity").html(numeral(velocity/1000).format('0.000') + " km/s");
      } else {
        $("#velocity").html(numeral(velocity).format('0.000') + " m/s");
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
        $("#altitude").html(numeral(altitude/1000).format('0.000') + " km");
      } else {
        $("#altitude").html(numeral(altitude).format('0.000') + " m");
      }
      apoapsis += ascentData[delta].Apoapsis.delta;
      if (apoapsis > 1000) {
        $("#apoapsis").html(numeral(apoapsis/1000).format('0.000') + " km");
      } else {
        $("#apoapsis").html(numeral(apoapsis).format('0.000') + " m");
      }
      
      // if Q is 0 then we are out of the atmosphere and should begin paying attention to our periapsis
      Q += ascentData[delta].Q.delta;
      periapsis += ascentData[delta].Periapsis.delta;
      if (Q <= 0) {
        $("#QPeCaption").html("Periapsis:");
        if (Math.abs(periapsis) > 1000) {
          $("#QPe").html(numeral(periapsis/1000).format('0.000') + " km");
        } else {
          $("#QPe").html(numeral(periapsis).format('0.000') + " m");
        }
      } else {
        $("#QPeCaption").html("Dynamic Pressure (Q):");
        if (Q >= 1) {
          $("#QPe").html(numeral(Q).format('0.000') + " kPa");
        } else {
          $("#QPe").html(numeral(Q*1000).format('0.000') + " Pa");
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
        $("#downrange").html(numeral(dstDownrange/1000).format('0,0.000') + " km");
      } else {
        $("#downrange").html(numeral(dstDownrange).format('0.000') + " m");
      }
      dstTraveled += ascentData[delta].DstTraveled.delta;
      if (dstTraveled > 1000) {
        $("#traveled").html(numeral(dstTraveled/1000).format('0,0.000') + " km");
      } else {
        $("#traveled").html(numeral(dstTraveled).format('0.000') + " m");
      }
      $("#aoa").html(numeral(aoa += ascentData[delta].AoA.delta).format('0.00'));
      
      // only perform the following if playing, so we can update everything else when paused and seeking
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
          if (getParameterByName("survey")) { surveyURL = "https://docs.google.com/forms/d/1LC3e6xfWMzux8NvQQAurJpF6kdIvYZYtH4tTNNaamEg/viewform?" + 
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
            "&entry.667865474=" + formatTime(0, false) + 
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
          
          // save the final FPS for use in future launches
          // only save performance for live launches, which can't be paused to allow FPS to improve
          if (checkCookies() && !bPastUT) { setCookie("FPS", ascentFPS, true); }

        // if we still have some playback left, call ourselves again to keep things rolling
        } else {
        
          // ensure timer accuracy, even catches up when tab is unfocused!
          // http://www.sitepoint.com/creating-accurate-timers-in-javascript/
          diff = ((new Date().getTime()) - ascentStartTime) - (ascentDelta*1000);
          if (maxDiff < diff) { maxDiff = diff; }

          // check if we are running behind regularly and if it happens long enough cut the FPS
          if (!bTimeDilation && diff > 1000/ascentFPS && diff > lastDiff) {
            perfHit++;
            if (perfHit == perfThreshold) {
              if (bTimeRecovered) { recovery++; }
              $("#telemFPS").html("@ " + ascentFPS + " FPS");
              bTimeDilation = true;
            }
          }
          
          // have we recovered from a time dilation event?
          if (diff <= 1000/ascentFPS) {
            if (bTimeDilation) { bTimeRecovered = true; }
            $("#telemFPS").html("@ " + ascentFPS + " FPS");
            $("#telemData").css("color", "green");
            bTimeDilation = false;
          }
          
          // in a stroke of elegance, pass ourselves the whole number delta value so we can use it for array referencing straight away
          setTimeout(ascentUpdater, (1000/ascentFPS) - diff, Math.floor(ascentDelta), false); 
        }
      }
    }

    // set up for AJAX requests
    // http://www.w3schools.com/ajax/
    var ajaxOrbitData;
    var ajaxUpdate;
    var ajaxParts;
    if (window.XMLHttpRequest) {
      ajaxOrbitData = new XMLHttpRequest();
      ajaxUpdate = new XMLHttpRequest();
      ajaxParts = new XMLHttpRequest();
    } else {
      // code for IE6, IE5
      ajaxOrbitData = new ActiveXObject("Microsoft.XMLHTTP");
      ajaxUpdate = new ActiveXObject("Microsoft.XMLHTTP");
      ajaxParts = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    // don't allow AJAX to cache data, which mainly screws up requests for updated vessel times for notifications
    $.ajaxSetup({ cache: false });  

    // handle requests for rendezvous craft information
    var sma2;
    var ecc2;
    var inc2;
    var raan2;
    var arg2;
    var mean2;
    var eph2;
    var period2;
    var bRV = false;
    var rvType;
    var rvCraft;
    ajaxOrbitData.onreadystatechange = function() {
      if (ajaxOrbitData.readyState == 4 && ajaxOrbitData.status == 200) {
        if (ajaxOrbitData.responseText == "!") {
          console.log("bad request sent!");
        } else {

          // separate and assign the various values returned by the request
          // convert to radians from degrees where needed
          rvData = ajaxOrbitData.responseText.split(";")
          ecc2 = parseFloat(rvData[0]);
          inc2 = parseFloat(rvData[1]) * .017453292519943295; 
          period2 = parseFloat(rvData[2]);
          sma2 = parseFloat(rvData[3]);
          raan2 = parseFloat(rvData[4]) * .017453292519943295;
          arg2 = parseFloat(rvData[5]) * .017453292519943295;
          mean2 = parseFloat(rvData[6]) * .017453292519943295;
          eph2 = parseFloat(rvData[7]);
          rvCraft = rvData[8];
          rvType = rvData[9];
          currUT = initialUT;
          
          // render the orbit
          if (period2 > maxDeltaTime) { endTime = currUT + maxDeltaTime; }
          else { endTime = currUT + period2; }
          strRender = "rv";
          renderSecondPath();
        }
      }
    };

    // handle request for part information
    var craftParts = [];
    var showOpt;
    ajaxParts.onreadystatechange = function() {
      if (ajaxParts.readyState == 4 && ajaxParts.status == 200) {
        if (ajaxParts.responseText == "!") {
          console.log("bad request sent!");
        } else {
        
          // separate and assign the various values returned by the request
          parts = ajaxParts.responseText.split("|");

          // check every <area> tag on the page for parts rich content tooltip insertions
          $("area").each(function( index ) {
            if ($(this ).attr("title").substr(0,1) == "&") {
              strPartName = $(this ).attr("title").substr(1,$(this ).attr("title").length-1);

              // find and assign the part information
              for (x=0; x<parts.length; x++) {
                part = parts[x].split("~");
                if (part[0] == strPartName) { 

                  // we have to hack our own tooltips in other browsers so only redo the title attribute in Firefox
                  if (browserName == "Firefox") {
                    $(this).attr("title", part[1]);
                    
                  // for other browsers we are going to move the data to the alt tag so they don't create a tooltip
                  // and we can use it to plug the data into a dynamic tooltip attached to a div that moves over the cursor location
                  } else {
                    $(this).attr("title", ""); 
                    $(this).attr("alt", part[1]);
                  }
                  break; 
                }
              }
            }
          });
          
          // Non-Firefox support for image map tooltips
          // check every <area> tag on the page for any title data remaining from custom part data not taken from the database
          $("area").each(function( index ) {
            if (browserName != "Firefox" && $(this).attr("title")) {
              $(this).attr("alt", $(this).attr("title")); 
              $(this).attr("title", ""); 
            }
          });      
              // now we can go ahead and create the page tooltips
          // behavior of tooltips depends on the device
          if (is_touch_device()) {
            showOpt = 'click';
          } else {
            showOpt = 'mouseenter';
          }
     
          // create all the tooltips using Tipped.js - http://www.tippedjs.com/
          // separate class for updating tooltips so they don't mess with any static ones set to show over mouse cursor
          Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
          Tipped.create('.tip-update', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
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
    var bStaticObt = false;
    var bDescOpen = false;
    var bArrowHvrOff = false;
    var craftImgIndex = 0;
    var craftImgs = [];
    var craftCaption = "";
    var bTipShow = false;
    $(document).ready(function(){
    
      // hide the craft overlay, do this after load so ppl see it and go to bring it back
      setTimeout(function(){ if (!$('#mainwrapper').is(":hover")) $("#craftImgOverlay" + craftImgIndex).fadeOut(1000); }, 1000);
      
      // adjust positioning of some elements in non-Firefox browsers
      if (browserName != "Firefox") { $("#map").css("top", parseInt($("#map").css("top")) - 5); }
      
      // Non-Firefox support for image map tooltips with Tipped
      $("area").hover(function() { 

        // HTML data is stashed in the alt attribute so other browsers don't show their own tooltip
        if (browserName != "Firefox" && $(this).attr("alt")) { 
          $("#mapTipData").html($(this).attr("alt"));
          
          // get the coordinate data for the area and size/center the div around it
          // div containing image map is below the title header, so offset must be applied
          // div containing all content is left-margin: auto to center on page, so offset must be applied
          areaCenter = $(this).attr("coords").split(",");
          $("#mapTip").css("width", parseInt(areaCenter[2])*2);
          $("#mapTip").css("height", parseInt(areaCenter[2])*2);
          $("#mapTip").css("top", parseInt(areaCenter[1])+$("#mainwrapper").position().top-parseInt(areaCenter[2]));
          $("#mapTip").css("left", parseInt(areaCenter[0])+$("#mainwrapper").position().left+$("#mainContent").position().left-parseInt(areaCenter[2]));
          $("#mapTip").show();
        }
      }, function() {
      
        // called once the div is shown atop this
        Tipped.refresh(".tip-update");
      });
  
      // set flag to tell main image that tooltip is or is no longer visible
      $("#mapTip").hover(function() { 
        bTipShow = true;
      }, function() {
        bTipShow = false;
      });

      // tell site to set cookie that allows tweets to be sent by this user
      if (getParameterByName('missionctrl')) { setCookie('missionctrl', true, true); }
    
      // give user option for a post-launch survey if we are entering this event from a live launch
      if (getParameterByName('surveyURL')) { $("#msgPostLaunch").fadeIn(); }
      
      // gets rid of the survey dialog
      $("#msgPostLaunchDismiss").click(function(){
        $("#msgPostLaunch").fadeOut();
      });

      // launches the post launch survey, re-including proper URL variable symbol
      $("#msgPostLaunchSurvey").click(function(){
        $("#msgPostLaunch").fadeOut();
        if (getParameterByName('surveyURL')) { window.open(getParameterByName('surveyURL').replace(/\|/g, "&")); }
        else if (surveyURL) { window.open(surveyURL); }
      });
      
      // shows the map again after it was hidden to show static orbits
      $("#img").click(function(){
        if (bDrawMap && bMapRender) { 
          $("#map").fadeIn(); 
          $("#iconStaticObt").fadeIn();
          $("#iconSurfaceMap").fadeIn();
          $(".leaflet-control-info").fadeIn();
          $(".leaflet-control-zoom").fadeIn();
          
          // prevent the hover event from triggering for the map icons during the fade transition
          setTimeout(function() { bStaticObt = false; }, 500);
        }
      });
      
      // open new windows for related website entries/flickr photos
      $("#tagData").click(function () {
        window.open("http://www.kerbalspace.agency/?tag=" + tagData.replace(/\.| /g, "-"));
        window.open("https://www.flickr.com/search/?user_id=kerbal_space_agency&tags=" + tagData.replace(/-|\.| /g, "") + "&view_all=1");
      });

      // does away with the notification for orbital plot length
      $("#msgObtPdDismiss").click(function(){
        $("#msgObtPd").fadeToggle();
      });

      // hides the map to show static data
      $("#iconStaticObt").click(function(){
        $("#map").fadeOut();
        $("#iconStaticObt").fadeOut();
        $("#iconSurfaceMap").fadeOut();
        
        // prevent the hover event from triggering for the map icons during the fade transition
        bStaticObt = true;
      });
  
      // scrolls resource icons left and right, re-assigning their images and captions
      $("#prevRes").click(function(){
        resIndex--;
        if (resIndex < 0) { resIndex = 0; }
        for (x=0; x<5; x++) {  
          $("#resImg" + x).attr("src", resources[resIndex+x].Img + ".png");
          $("#resImg" + x).fadeIn();
          
          // caption may need modifying if electric charge icon is used
          if (resources[resIndex+x].Img.toLowerCase() == "electriccharge") {
            $("#resTip" + x).html(resources[resIndex+x].Title + solarOutputStr);
          } else {
            $("#resTip" + x).html(resources[resIndex+x].Title);
          }
        }
      });
      $("#nextRes").click(function(){
        resIndex++;
        if (resIndex == resources.length-4) { resIndex = resources.length-5; }
        for (x=0; x<5; x++) {  
          $("#resImg" + x).attr("src", resources[resIndex+x].Img + ".png");
          $("#resImg" + x).fadeIn();
          
          // caption may need modifying if electric charge icon is used
          if (resources[resIndex+x].Img.toLowerCase() == "electriccharge") {
            $("#resTip" + x).html(resources[resIndex+x].Title + solarOutputStr);
          } else {
            $("#resTip" + x).html(resources[resIndex+x].Title);
          }
        }
      });
      
      // scroll up the craft description text when the header is clicked
      $("#craftDesc").click(function(){
        if (!bDescOpen) {
          $("#craftDesc").css("transform", "translateY(-380px)");
          $("#craftDesc").css("cursor", "default");
          $("#craftLeft").css("display", "none");
          $("#craftRight").css("display", "none");
          $("#craftImgOverlay" + craftImgIndex).css("display", "none");
          $("#mapTip").hide();
          bDescOpen = true;
        }
      });

      // handle mousing off the map when hovering over the mouse icons
      $("#iconStaticObt").hover(function(){}, function(){
        setTimeout(function() {
        
          // after a short delay, ensure cursor isn't just now over the map or the other icon before hiding all map controls
          if (!$('#map').is(":hover") && !$('#iconSurfaceMap').is(":hover")) { 
            $("#iconStaticObt").fadeOut();
            $("#iconSurfaceMap").fadeOut();
            $(".leaflet-control-info").fadeOut();
            $(".leaflet-control-zoom").fadeOut();
          }
        }, 50);
      });
      $("#iconSurfaceMap").hover(function(){}, function(){
        setTimeout(function() {
          if (!$('#map').is(":hover") && !$('#iconStaticObt').is(":hover")) { 
            $("#iconStaticObt").fadeOut();
            $("#iconSurfaceMap").fadeOut();
            $(".leaflet-control-info").fadeOut();
            $(".leaflet-control-zoom").fadeOut();
          }
        }, 50);
      });
      
      // takes user to detailed surface map for layer views and flags and such on the current orbited body
      $("#iconSurfaceMap").click(function(){
        window.location.href = $(this).attr("href");
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
      // unless that event is a future node/event, in which case show the node if possible
      // again, touchscreen users can't see tooltip so display as an alert message instead if future event
      $("#prevEvent")
        .change(function () {
          if ($("#prevEvent").val().length) { window.location.href = $("#prevEvent").val(); }
        });
      $("#nextEvent")
        .change(function () {          
          if ($("#nextEvent").val().length) { 
            if ($("#nextEvent").val() == "node") { 
            
              // event description is formatted for HTML, have to change line break if showing as an alert dialog
              // alert dialog is shown for mobile devices and non-Firefox browsers that can't see the tooltip on hover
              if (is_touch_device() || browserName != "Firefox") { 
                setTimeout(function() { alert($("#nextNode").html().replace(/<br>/g, "\n")); }, 50); 
              }
              if (!bNodeRefreshCheck && nodeMark) { nodeMark.openPopup(); }
              document.getElementById('nextEvent').selectedIndex = 0;
            } else {
              window.location.href = $("#nextEvent").val(); 
            }
          }
        });
      
      // does away with the notification for future maneuver node
      $("#msgNode").click(function(){
        $("#msgNode").fadeToggle();
      });
      
      // does away with the flight tracker introduction box 
      $("#dismissIntro").click(function(){
        $("#intro").fadeToggle();
      });
      
      // does away with the notification for upcoming launch
      // currently not used in favor of a confirm dialog
      $("#msgLaunch").click(function(){
        $("#msgLaunch").fadeToggle();
      });

      // begins loading video data on mobile devices
      // makes mobile user aware of video data size
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
        
        // if the video is loaded, then the user has the option to show and hide it while it is playing
        // account for both live and archival playback
        else if ($("#videoStatus").html() == '<u style="text-decoration: underline; cursor: pointer">Hide video</u>')
        {
          $("#mainwrapper").fadeIn();
          $("#videoCameraName").fadeOut();
          $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Show video</u>");
        }
        else if ($("#videoStatus").html() == '<u style="text-decoration: underline; cursor: pointer">Show video</u>')
        {
          $("#mainwrapper").fadeOut();
          $("#videoCameraName").fadeIn();
          $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Hide video</u>");
        }
        else if ($("#videoStatus").html() == "<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Hide video</u>)")
        {
          $("#mainwrapper").fadeIn();
          $("#videoCameraName").fadeOut();
          $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Show video</u>)");
        }
        else if ($("#videoStatus").html() == "<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Show video</u>)")
        {
          $("#mainwrapper").fadeOut();
          $("#videoCameraName").fadeIn();
          $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Hide video</u>)");
        }
      });

      // shows/hides the sketchfab icon
      // changes craft description caption to prompt user to click for more info
      // shows/hides craft rotation arrows
      $("#mainwrapper").hover(function(){
        bArrowHvrOff = false;
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabBlank").fadeToggle();
        $("#captionCraft").html("Click Here for Details");
        if (craftImgs.length > 1) {
          $("#craftLeft").fadeIn();
          $("#craftRight").fadeIn();
        }
        $("#craftImgOverlay" + craftImgIndex).fadeIn();
      }, function(){
      
        // wait to give tooltips a chance to hide on mouseover before checking to see if we're actually off the image
        // also don't bother checking if the arrow hover off function already ran
        setTimeout(function() {
          if (!bTipShow && !$('#craftLeft').is(":hover") && !$('#craftRight').is(":hover") && !$('#mainwrapper').is(":hover") && !bArrowHvrOff) {
            $("#captionCraft").html(craftCaption);
            if (bDescOpen) {
              $("#craftDesc").css("cursor", "pointer");
              $("#craftDesc").css("transform", "translateY(0px)");
              bDescOpen = false;
            }
            $("#craftLeft").fadeOut();
            $("#craftRight").fadeOut();
            $("#craftImgOverlay" + craftImgIndex).fadeOut();
          }
          if (bArrowHvrOff) { bArrowHvrOff = false; }
        }, 250);
      });
      
      // shows engine/thruster activation during maneuvers
      $("#thrusterOverlay").hover(function(){
        bArrowHvrOff = false;
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabBlank").fadeToggle();
        $("#captionCraft").html("Click Here for Details");
        if (craftImgs.length > 1) {
          $("#craftLeft").fadeIn();
          $("#craftRight").fadeIn();
        }
        $("#craftImgOverlay" + craftImgIndex).fadeIn();
      }, function(){
      
        // wait to give tooltips a chance to hide on mouseover before checking to see if we're actually off the image
        // also don't bother checking if the arrow hover off function already ran
        setTimeout(function() {
          if (!$('#craftLeft').is(":hover") && !$('#craftRight').is(":hover") && !$('#mainwrapper').is(":hover") && !bArrowHvrOff) {
            $("#captionCraft").html(craftCaption);
            if (bDescOpen) {
              $("#craftDesc").css("cursor", "pointer");
              $("#craftDesc").css("transform", "translateY(0px)");
              bDescOpen = false;
            }
            $("#craftLeft").fadeOut();
            $("#craftRight").fadeOut();
            $("#craftImgOverlay" + craftImgIndex).fadeOut();
          }
          if (bArrowHvrOff) { bArrowHvrOff = false; }
        }, 250);
      });
      $("#engineOverlay").hover(function(){
        bArrowHvrOff = false;
        $("#sketchfabButton").fadeToggle();
        $("#sketchfabBlank").fadeToggle();
        $("#captionCraft").html("Click Here for Details");
        if (craftImgs.length > 1) {
          $("#craftLeft").fadeIn();
          $("#craftRight").fadeIn();
        }
        $("#craftImgOverlay" + craftImgIndex).fadeIn();
      }, function(){
      
        // wait to give tooltips a chance to hide on mouseover before checking to see if we're actually off the image
        // also don't bother checking if the arrow hover off function already ran
        setTimeout(function() {
          if (!$('#craftLeft').is(":hover") && !$('#craftRight').is(":hover") && !$('#mainwrapper').is(":hover") && !bArrowHvrOff) {
            $("#captionCraft").html(craftCaption);
            if (bDescOpen) {
              $("#craftDesc").css("cursor", "pointer");
              $("#craftDesc").css("transform", "translateY(0px)");
              bDescOpen = false;
            }
            $("#craftLeft").fadeOut();
            $("#craftRight").fadeOut();
            $("#craftImgOverlay" + craftImgIndex).fadeOut();
          }
          if (bArrowHvrOff) { bArrowHvrOff = false; }
        }, 250);
      });
      
      // rotates the craft image
      $("#craftLeft").click(function(){
        $("#craftImgOverlay" + craftImgIndex).css("display", "none");
        craftImgIndex++;
        if (craftImgIndex == craftImgs.length) { craftImgIndex = 0; }
        $("#image-1").attr("src", craftImgs[craftImgIndex].Normal);
        $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Normal);
        $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Normal);
        $("#craftImgOverlay" + craftImgIndex).css("display", "initial");
        $("#mapTip").hide();
      });
      $("#craftRight").click(function(){
        $("#craftImgOverlay" + craftImgIndex).css("display", "none");
        craftImgIndex--;
        if (craftImgIndex < 0) { craftImgIndex = craftImgs.length - 1; }
        $("#image-1").attr("src", craftImgs[craftImgIndex].Normal);
        $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Normal);
        $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Normal);
        $("#craftImgOverlay" + craftImgIndex).css("display", "initial");
        $("#mapTip").hide();
      });
      
      // ensures #mainwrapper returns to unhovered state in case mouse-off is too fast to register a mousover for #mainwrapper
      $("#craftLeft").hover(function(){}, function(){
        bArrowHvrOff = true;
        setTimeout(function() {
          if (!$('#craftLeft').is(":hover") && !$('#craftRight').is(":hover") && !$('#mainwrapper').is(":hover")) {
            $("#captionCraft").html(craftCaption);
            if (bDescOpen) {
              $("#craftDesc").css("cursor", "pointer");
              $("#craftDesc").css("transform", "translateY(0px)");
              bDescOpen = false;
            }
            $("#craftLeft").fadeOut();
            $("#craftRight").fadeOut();
            $("#craftImgOverlay" + craftImgIndex).fadeOut();
          }
        }, 50);
      });
      $("#craftRight").hover(function(){}, function(){
        bArrowHvrOff = true;
        setTimeout(function() {
          if (!$('#craftLeft').is(":hover") && !$('#craftRight').is(":hover") && !$('#mainwrapper').is(":hover")) {
            $("#captionCraft").html(craftCaption);
            if (bDescOpen) {
              $("#craftDesc").css("cursor", "pointer");
              $("#craftDesc").css("transform", "translateY(0px)");
              bDescOpen = false;
            }
            $("#craftLeft").fadeOut();
            $("#craftRight").fadeOut();
            $("#craftImgOverlay" + craftImgIndex).fadeOut();
          }
        }, 50);
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
          for (i=0; i<ascentTracks.length; i++) { map.removeLayer(ascentTracks[i]); }
          for (i=0; i<ascentMarks.length; i++) { map.removeLayer(ascentMarks[i]); }
          ascentTracks = [];
          ascentMarks = [];
          ascentColorsIndex = -1;
          ascentUpdater(Math.floor(ascentDelta), true);
          map.setView(craft.getLatLng(), 5);
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
        
        // can't use if disabled (check image name)
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
            for (i=0; i<ascentTracks.length; i++) { map.removeLayer(ascentTracks[i]); }
            for (i=0; i<ascentMarks.length; i++) { map.removeLayer(ascentMarks[i]); }
            ascentTracks = [];
            ascentMarks = [];
            ascentColorsIndex = -1;
            for (x=0; x<=ascentDelta; x++) {
              if (ascentData[x].Phase && ascentData[x].DstTraveled.clamp > 0) {  
                ascentColorsIndex++;
                if (ascentColorsIndex == ascentColors.length) { ascentColorsIndex = 0; }
                ascentTracks.push(L.polyline([], {smoothFactor: .25, clickable: true, color: ascentColors[ascentColorsIndex], weight: 2, opacity: 1}).addTo(map));
                ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x-1].Lat, ascentData[x-1].Lon]);
                ascentTracks[ascentTracks.length-1]._myId = "<center>" + ascentData[x].Phase + "</center>";
                ascentTracks[ascentTracks.length-1].on('mouseover mousemove', function(e) {
                  ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                  ascentPopup.setLatLng(e.latlng);
                  ascentPopup.setContent(e.target._myId);
                  ascentPopup.openOn(map);
                });
                ascentTracks[ascentTracks.length-1].on('mouseout', function(e) {
                  if (ascentPopup) { map.closePopup(ascentPopup); }
                  ascentPopup = null;
                });
              }
              if (ascentTracks.length) { ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]); }
              if (!noMarkBox.contains([ascentData[x].Lat, ascentData[x].Lon]) && ascentData[x].EventMark) {
                var labelIcon = L.icon({
                  iconUrl: 'label.png',
                  iconSize: [10, 10],
                });
                ascentMarks.push(L.marker([ascentData[x].Lat, ascentData[x].Lon], {icon: labelIcon}).addTo(map));
                ascentMarks[ascentMarks.length-1]._myId = ascentData[x].EventMark + ";" + ascentData[x].Lat + ";" + ascentData[x].Lon;
                ascentMarks[ascentMarks.length-1].on('mouseover mousemove', function(e) {
                  data = e.target._myId.split(";")
                  ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                  ascentPopup.setLatLng([data[1], data[2]]);
                  ascentPopup.setContent(data[0]);
                  ascentPopup.openOn(map);
                });
                ascentMarks[ascentMarks.length-1].on('mouseout', function(e) {
                  if (ascentPopup) { map.closePopup(ascentPopup); }
                  ascentPopup = null;
                });
              }
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
              if ($("#videoStatus").html() == '<u style="text-decoration: underline; cursor: pointer">Hide video</u>') {
                $("#mainwrapper").fadeOut();
                $("#videoCameraName").fadeIn();
              }
            } else if (ascentDelta == 0 && launchCountdown >= 0) {
              if (launchCountdown >= videoStartUT - getParameterByName('ut')) {  
                launchVideo.currentTime = Math.abs((videoStartUT - getParameterByName('ut')) - launchCountdown);
                if ($("#videoStatus").html() == '<u style="text-decoration: underline; cursor: pointer">Hide video</u>') {
                  $("#mainwrapper").fadeOut();
                  $("#videoCameraName").fadeIn();
                }
              } else {
                launchVideo.currentTime = 0;
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
      
        // can't use if disabled (check image name)
        if ($("#seekForward").attr("src").search("seekForward.png") != -1) {

          // either we are in our ascent data or coming out of prelaunch
          if (ascentDelta > 0) {
            ascentDelta += seekTime;
            
            // don't let user seek past the end of telemetry data
            if (ascentDelta >= ascentData.length) {
              ascentDelta = ascentData.length - 1;
              $("#telemData").html("Reset Telemetry");
            }
            
            // we should be able to just add to whatever existing plot, but again leaflet is being touchy so just redo the whole thing
            for (i=0; i<ascentTracks.length; i++) { map.removeLayer(ascentTracks[i]); }
            for (i=0; i<ascentMarks.length; i++) { map.removeLayer(ascentMarks[i]); }
            ascentTracks = [];
            ascentMarks = [];
            ascentColorsIndex = -1;
            for (x=0; x<=ascentDelta; x++) {
              if (ascentData[x].Phase && ascentData[x].DstTraveled.clamp > 0) {  
                ascentColorsIndex++;
                if (ascentColorsIndex == ascentColors.length) { ascentColorsIndex = 0; }
                ascentTracks.push(L.polyline([], {smoothFactor: .25, clickable: true, color: ascentColors[ascentColorsIndex], weight: 2, opacity: 1}).addTo(map));
                ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x-1].Lat, ascentData[x-1].Lon]);
                ascentTracks[ascentTracks.length-1]._myId = "<center>" + ascentData[x].Phase + "</center>";
                ascentTracks[ascentTracks.length-1].on('mouseover mousemove', function(e) {
                  ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                  ascentPopup.setLatLng(e.latlng);
                  ascentPopup.setContent(e.target._myId);
                  ascentPopup.openOn(map);
                });
                ascentTracks[ascentTracks.length-1].on('mouseout', function(e) {
                  if (ascentPopup) { map.closePopup(ascentPopup); }
                  ascentPopup = null;
                });
              }
              if (ascentTracks.length) { ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]); }
              if (!noMarkBox.contains([ascentData[x].Lat, ascentData[x].Lon]) && ascentData[x].EventMark) {
                var labelIcon = L.icon({
                  iconUrl: 'label.png',
                  iconSize: [10, 10],
                });
                ascentMarks.push(L.marker([ascentData[x].Lat, ascentData[x].Lon], {icon: labelIcon}).addTo(map));
                ascentMarks[ascentMarks.length-1]._myId = ascentData[x].EventMark + ";" + ascentData[x].Lat + ";" + ascentData[x].Lon;
                ascentMarks[ascentMarks.length-1].on('mouseover mousemove', function(e) {
                  data = e.target._myId.split(";")
                  ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                  ascentPopup.setLatLng([data[1], data[2]]);
                  ascentPopup.setContent(data[0]);
                  ascentPopup.openOn(map);
                });
                ascentMarks[ascentMarks.length-1].on('mouseout', function(e) {
                  if (ascentPopup) { map.closePopup(ascentPopup); }
                  ascentPopup = null;
                });
              }
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
                if (ascentData[x].Phase && ascentData[x].DstTraveled.clamp > 0) {  
                  ascentColorsIndex++;
                  if (ascentColorsIndex == ascentColors.length) { ascentColorsIndex = 0; }
                  ascentTracks.push(L.polyline([], {smoothFactor: .25, clickable: true, color: ascentColors[ascentColorsIndex], weight: 2, opacity: 1}).addTo(map));
                  ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x-1].Lat, ascentData[x-1].Lon]);
                  ascentTracks[ascentTracks.length-1]._myId = "<center>" + ascentData[x].Phase + "</center>";
                  ascentTracks[ascentTracks.length-1].on('mouseover mousemove', function(e) {
                    ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                    ascentPopup.setLatLng(e.latlng);
                    ascentPopup.setContent(e.target._myId);
                    ascentPopup.openOn(map);
                  });
                  ascentTracks[ascentTracks.length-1].on('mouseout', function(e) {
                    if (ascentPopup) { map.closePopup(ascentPopup); }
                    ascentPopup = null;
                  });
                }
                if (ascentTracks.length) { ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]); }
                if (!noMarkBox.contains([ascentData[x].Lat, ascentData[x].Lon]) && ascentData[x].EventMark) {
                  var labelIcon = L.icon({
                    iconUrl: 'label.png',
                    iconSize: [10, 10],
                  });
                  ascentMarks.push(L.marker([ascentData[x].Lat, ascentData[x].Lon], {icon: labelIcon}).addTo(map));
                  ascentMarks[ascentMarks.length-1]._myId = ascentData[x].EventMark + ";" + ascentData[x].Lat + ";" + ascentData[x].Lon;
                  ascentMarks[ascentMarks.length-1].on('mouseover mousemove', function(e) {
                    data = e.target._myId.split(";")
                    ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                    ascentPopup.setLatLng([data[1], data[2]]);
                    ascentPopup.setContent(data[0]);
                    ascentPopup.openOn(map);
                  });
                  ascentMarks[ascentMarks.length-1].on('mouseout', function(e) {
                    if (ascentPopup) { map.closePopup(ascentPopup); }
                    ascentPopup = null;
                  });
                }
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
                $("#videoCameraName").fadeIn();
                launchVideo.currentTime = Math.abs((videoStartUT - getParameterByName('ut')) - launchCountdown);
                $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Hide video</u>");
              } else {
                $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
              }
            }
          }
        }
      });

      // check every <area> tag on the page for parts rich content tooltip insertions
      $("area").each(function( index ) {
        if ($(this ).attr("title").substr(0,1) == "&") {
          strPartName = $(this ).attr("title").substr(1,$(this ).attr("title").length-1);

          // save for requesting the part data, don't allow dupes
          var testCount = 0;
          for (; testCount<craftParts.length; testCount++) {
            if (craftParts[testCount] == strPartName) { break; }
          }
          if (testCount == craftParts.length) {
            craftParts.push(strPartName);
          }
        }
      });
      
      // make the call for part data if we need it
      if (craftParts.length) {
        ajaxParts.open("GET", "parts.asp?parts=" + craftParts.toString(), true);
        ajaxParts.send();
        
      // no need to wait to create tooltips
      } else {
      
        // behavior of tooltips depends on the device
        if (is_touch_device()) {
          showOpt = 'click';
        } else {
          showOpt = 'mouseenter';
        }
   
        // create all the tooltips using Tipped.js - http://www.tippedjs.com/
        // separate class for updating tooltips so they don't mess with any static ones set to show over mouse cursor
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
        
        // update the craft cookie to the current time to clear any New/Update notifications
        setCookie(getParameterByName("db"), UT, true);
        
        // check to see if there are any update notifications to display
        ajaxUpdate.open("GET", "update.asp", true);
        ajaxUpdate.send();

        // check for an FPS variable in URL and if it doesn't match cookie, update it
        if (getParameterByName("fps") && getParameterByName("fps") != getCookie("FPS")) {
          setCookie("FPS", getParameterByName("fps"), true);
        }
      }
      
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
          if (checkCookies()) { setCookie("launchReminder", launchCraft, 0); }
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
          if (checkCookies()) { setCookie("maneuverReminder", maneuverCraft, 0); }
        }
      });
      
      // remove the cookie warnings
      $('#launchWarn').click(function() { $('#launchWarn').fadeOut(); });
      $('#maneuverWarn').click(function() { $('#maneuverWarn').fadeOut(); });
    });
  </script>	
</head>
<body style="padding: 0; margin: 0; font-family: sans-serif;"  onbeforeunload='resetLists()'>

<!-- 
VESSEL DATABASE LOAD
====================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbcraft-id
-->

<%
'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
on error resume next
db = "..\..\database\db" & request.querystring("db") & ".mdb"
Dim connCraft, sConnection
Set connCraft = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"

'attempt to access the database. If it is not found then try the archive
connCraft.Open(sConnection)
If Err <> 0 Then 
  if request.querystring("db") = "progenymk1-a" then
    response.redirect("http://www.kerbalspace.agency/Tracker/craft.asp?db=progenymk1-a1")
  else
    response.redirect("http://archive.kerbalspace.agency/archive/craft.asp?" & Request.ServerVariables("QUERY_STRING"))
  end if
end if
On Error GoTo 0

'create the tables
set rsCraft = Server.CreateObject("ADODB.recordset")
set rsOrbit = Server.CreateObject("ADODB.recordset")
set rsCrew = Server.CreateObject("ADODB.recordset")
set rsResources = Server.CreateObject("ADODB.recordset")
set rsComms = Server.CreateObject("ADODB.recordset")
set rsAscent = Server.CreateObject("ADODB.recordset")
set rsFlightplan = Server.CreateObject("ADODB.recordset")
set rsPorts = Server.CreateObject("ADODB.recordset")

'query the data
rsCraft.open "select * from [craft data]", connCraft, 2
rsResources.open "select * from [craft resources]", connCraft, 2
rsOrbit.open "select * from [flight data]", connCraft, 2
rsCrew.open "select * from [crew manifest]", connCraft, 2
rsComms.open "select * from [craft comms]", connCraft, 2
rsports.open "select * from [craft ports]", connCraft, 2
rsAscent.open "select * from [ascent data]", connCraft, 2
rsFlightplan.open "select * from flightplan", connCraft, 2

'determine if this DB has tables older databases may not contain
'not needed but kept for reference if required in the future
set adoxConn = CreateObject("ADOX.Catalog")  
adoxConn.activeConnection = connCraft  
for each table in adoxConn.tables 
  if lcase(table.name) = "ascent data" then 
  elseif lcase(table.name) = "flightplan" then 
  end if 
next
'trying to open a recordset that does not exist will kill the page

'check to see if this database supports fields not found in older databases
'not needed but kept for reference if required in the future 
'http://stackoverflow.com/questions/16474210/detect-if-a-names-field-exists-in-a-record-set

'calculate the time in seconds since epoch 0 when the game started
UT = datediff("s", "13-Sep-2016 00:00:00", now())

'affects the base UT that is used for some areas that ignore dbUT
if request.querystring("deltaut") then
  UT = UT + request.querystring("deltaut")
end if
 
'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
response.write("<script>var bPastUT = false;</script>")
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
    else
      UT = request.querystring("ut") * 1
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
'adding the code below created a weird bug where movenext/prev would not work properly when looking back to current time 
'see Last Update area for more
'ignore this when viewing a future event past current UT
rsCraft.movenext
if not rsCraft.eof then
  if not passcode then
    if UT < rsCraft.fields.item("id") then
      dbUT = UT
    else
    
      'dbUT remains in effect, make note so js also knows this is not the current time
      response.write("<script>var bPastUT = true;</script>")
      bPastUT = true
    end if
  end if
elseif not passcode then
  dbUT = UT
end if
rsCraft.moveprevious
'moving forward all recordset quieries should be made via dbUT
%>

<!-- 
CATALOG DATABASE LOAD
=====================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbcatalog
-->

<%
'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\database\dbCatalog.mdb"
Dim connCatalog
Set connCatalog = Server.CreateObject("ADODB.Connection")
sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connCatalog.Open(sConnection2)

'create the tables
set rsPlanets = Server.CreateObject("ADODB.recordset")
set rsMoons = Server.CreateObject("ADODB.recordset")
set rsCrafts = Server.CreateObject("ADODB.recordset")
set rsDistance = Server.CreateObject("ADODB.recordset")

'query the data, ensure that bookmarking is enabled
rsPlanets.open "select * from planets", connCatalog, 1, 1
rsMoons.open "select * from moons", connCatalog, 1, 1
rsCrafts.open "select * from crafts", connCatalog, 1, 1

'get the record containing the information relative to this vessel
rsCrafts.find("db='" & request.querystring("db") & "'")

if not rsCrafts.eof then 

  'parse all the SOIs this craft has/will be in and find the one it is in currently
  locations = split(rsCrafts.fields.item("SOI"), "|")
  for each loc in locations
    values = split(loc, ";")
    if values(0)*1 <= dbUT then 
      ref = values(1)*1
    end if
  next 
end if

'use Kerbin as a default
if ref < 0 then ref = 3

'create a recordset copy of the moon/planet recordset depending on what is being orbited at this time
'moons use 50 or greater for reference numbers
if ref < 50 then
  set rsBody = rsPlanets.clone()
else
  set rsBody = rsMoons.clone()
end if

'now get the specific body
rsBody.find("id=" & ref)
%>

<!-- Ascent data interpolation -->

<%
'set vb/js flags for whether or not we have ascent data to load and are in an ascent state right now
response.write("<script>")
response.write("var bAscentActive = false;")
response.write("var telemetryUT = 0;")
bAscentActive = false
vidLength = 0
if not rsAscent.bof then

  'debug info for survey data
  interpStart = now()
  
  'a ~ symbol in this field is telling us we have an ascent underway during this event
  if left(rsCraft.fields.item("imgDataCode"),1) = "~" then
    response.write("var bAscentActive = true;")
    bAscentActive = true
    
    'reload this page if the options are not included
    'http://snipplr.com/view/6618/getting-full-urlpath-with-asp/
    if len(request.querystring("fps")) = 0 or len(request.querystring("seek")) = 0 then 
      response.redirect "http://" & request.ServerVariables("SERVER_NAME") & request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING") & "&fps=" & fpsCookie & "&seek=30"
    end if
  
    'get the time of the launch (not the time telemetry begins!)
    response.write("launchUT = " & datediff("s", "16-Feb-2014 00:00:00", rsCraft.fields.item("LaunchDate")) & ";")

    'load all the initial values from the first entry
    telemetryUT = rsAscent.fields.item("id")
    response.write("var telemetryUT = " & rsAscent.fields.item("id") & ";")
    response.write("var velocity = " & rsAscent.fields.item("velocity") & ";")
    response.write("var thrust = " & rsAscent.fields.item("thrust") & ";")
    response.write("var mass = " & rsAscent.fields.item("mass") & ";")
    response.write("var altitude = " & rsAscent.fields.item("altitude") & ";")
    response.write("var apoapsis = " & rsAscent.fields.item("apoapsis") & ";")
    response.write("var inclination = " & rsAscent.fields.item("inclination") & ";")
    response.write("var throttle = " & rsAscent.fields.item("throttle") & ";")
    response.write("var Q = " & rsAscent.fields.item("Q") & ";")
    response.write("var periapsis = " & rsAscent.fields.item("periapsis") & ";")
    response.write("var stageFuel = " & rsAscent.fields.item("stageFuel") & ";")
    response.write("var totalFuel = " & rsAscent.fields.item("totalFuel") & ";")
    response.write("var dstDownrange = " & rsAscent.fields.item("dstDownrange") & ";")
    response.write("var dstTraveled = " & rsAscent.fields.item("dstTraveled") & ";")
    response.write("var pitch = " & rsAscent.fields.item("pitch") & ";")
    response.write("var roll = " & rsAscent.fields.item("roll") & ";")
    response.write("var heading = " & rsAscent.fields.item("heading") & ";")
    response.write("var gravity = " & rsAscent.fields.item("gravity") & ";")
    response.write("var aoa = " & rsAscent.fields.item("aoa") & ";")

    'get the FPS from the querystring setting (default 30)
    ascentFPS = request.querystring("fps")
    response.write("var ascentFPS = " & request.querystring("fps") & ";")
    
    'assign the seek time, given in seconds
    seekTime = request.querystring("seek")
    response.write("var seekTime = " & seekTime & ";")
    
    'now interpolate the difference between the data
    'funny story - originally arrays were named first() and second(), 
    'which caused a Type Mismatch error when I tried to use the time function response.write(Second(Now()))
    'ok not so funny - it was a pain in the ass to track down and fix!!
    response.write("var ascentData = [];")
    dim before(18)
    dim after(18)
    do until rsAscent.eof
    
      'get all the numerical data from this record
      before(0) = rsAscent.fields.item("Velocity")
      before(1) = rsAscent.fields.item("Thrust")
      before(2) = rsAscent.fields.item("Mass")
      before(3) = rsAscent.fields.item("Altitude")
      before(4) = rsAscent.fields.item("Apoapsis")
      before(5) = rsAscent.fields.item("Inclination")
      before(6) = rsAscent.fields.item("Q")
      before(7) = rsAscent.fields.item("Periapsis")
      before(8) = rsAscent.fields.item("StageFuel")
      before(9) = rsAscent.fields.item("TotalFuel")
      before(10) = rsAscent.fields.item("DstDownrange")
      before(11) = rsAscent.fields.item("DstTraveled")
      before(12) = rsAscent.fields.item("AoA")
      before(13) = rsAscent.fields.item("Pitch")
      before(14) = rsAscent.fields.item("Roll")
      before(15) = rsAscent.fields.item("Heading")
      before(16) = rsAscent.fields.item("ID")
      before(17) = rsAscent.fields.item("Throttle")
      before(18) = rsAscent.fields.item("Gravity")
      
      'now get all the numerical data from the next record, if there is no next record then exit the loop
      rsAscent.movenext
      if rsAscent.eof then exit do
      after(0) = rsAscent.fields.item("Velocity")
      after(1) = rsAscent.fields.item("Thrust")
      after(2) = rsAscent.fields.item("Mass")
      after(3) = rsAscent.fields.item("Altitude")
      after(4) = rsAscent.fields.item("Apoapsis")
      after(5) = rsAscent.fields.item("Inclination")
      after(6) = rsAscent.fields.item("Q")
      after(7) = rsAscent.fields.item("Periapsis")
      after(8) = rsAscent.fields.item("StageFuel")
      after(9) = rsAscent.fields.item("TotalFuel")
      after(10) = rsAscent.fields.item("DstDownrange")
      after(11) = rsAscent.fields.item("DstTraveled")
      after(12) = rsAscent.fields.item("AoA")
      after(13) = rsAscent.fields.item("Pitch")
      after(14) = rsAscent.fields.item("Roll")
      after(15) = rsAscent.fields.item("Heading")
      after(16) = rsAscent.fields.item("ID")
      after(17) = rsAscent.fields.item("Throttle")
      after(18) = rsAscent.fields.item("Gravity")
      rsAscent.moveprevious

      'get the change in values from one entry to the next & also what is in remaining fields
      'value stored is the fraction needed to achieve the change in value over the time between log data given a certain FPS
      '(after(x) - before(x)) = Data Delta - amount of change between the two values
      '(after(16) - before(16)) = Time Delta - number of seconds between telemetry updates
      '(Data Delta / FPS) / Time Delta = fraction to add every frame to move value across entire range of data delta
      'same concept used for LogInterval so that it takes several seconds to add up to 1 second when needed
      'store the base value as the clamp to ensure accuracy
      response.write("velocityData = {delta:" & ((after(0) - before(0)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Velocity") & "};")
      response.write("thrustData = {delta:" & ((after(1) - before(1)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Thrust") & "};")
      response.write("massData = {delta:" & ((after(2) - before(2)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Mass") & "};")
      response.write("altitudeData = {delta:" & ((after(3) - before(3)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Altitude") & "};")
      response.write("apData = {delta:" & ((after(4) - before(4)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Apoapsis") & "};")
      response.write("incData = {delta:" & ((after(5) - before(5)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Inclination") & "};")
      response.write("qData = {delta:" & ((after(6) - before(6)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Q") & "};")
      response.write("peData = {delta:" & ((after(7) - before(7)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Periapsis") & "};")
      response.write("stageFuelData = {delta:" & ((after(8) - before(8)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("StageFuel") & "};")
      response.write("totalFuelData = {delta:" & ((after(9) - before(9)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("TotalFuel") & "};")
      response.write("downrangeData = {delta:" & ((after(10) - before(10)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("DstDownrange") & "};")
      response.write("traveledData = {delta:" & ((after(11) - before(11)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("DstTraveled") & "};")
      response.write("aoaData = {delta:" & ((after(12) - before(12)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("AoA") & "};")
      response.write("pitchData = {delta:" & ((after(13) - before(13)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Pitch") & "};")
      response.write("rollData = {delta:" & ((after(14) - before(14)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Roll") & "};")
      response.write("hdgData = {delta:" & ((after(15) - before(15)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Heading") & "};")
      response.write("logData = {delta:" & ((after(16) - before(16)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & after(16) - before(16) & "};")
      response.write("throttleData = {delta:" & ((after(17) - before(17)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Throttle") & "};")
      response.write("gData = {delta:" & ((after(18) - before(18)) / ascentFPS) / (after(16) - before(16)) & ", clamp:" & rsAscent.fields.item("Gravity") & "};")
      
      'add the interpolated data to the array along with data that requires no interpolation and is only accessed once per interval
      response.write("ascentData.push({Velocity: velocityData, Thrust: thrustData, Mass: massData, Altitude: altitudeData, Apoapsis: apData, Inclination: incData, Q: qData, Periapsis: peData, StageFuel: stageFuelData, TotalFuel: totalFuelData, DstDownrange: downrangeData, DstTraveled: traveledData, AoA: aoaData, Pitch: pitchData, Roll: rollData, Heading: hdgData, LogInterval: logData, Throttle: throttleData, Gravity: gData, AoAWarn: '" & rsAscent.fields.item("AoAWarn") & _
                      "', Event: '" & rsAscent.fields.item("Event") & _
                      "', Lat: " & rsAscent.fields.item("Lat") & _
                      ", Lon: " & rsAscent.fields.item("Lon") & _
                      ", FPS: " & ascentFPS & _
                      ", CommLost: " & lcase(rsAscent.fields.item("CommLost")) & _
                      ", Video: " & lcase(rsAscent.fields.item("Video")) & _
                      ", Tweet: """ & rsAscent.fields.item("Tweet") & _
                      """, Camera: '" & rsAscent.fields.item("Camera") & _
                      "', Image: '" & rsAscent.fields.item("Image") & _
                      "', Phase: '" & rsAscent.fields.item("Phase") & _
                      "', EventMark: '" & rsAscent.fields.item("EventMark") & "'});")
     
      'update length of launch video during telemetry
      if rsAscent.fields.item("video") then vidLength = vidLength + 1
      rsAscent.movenext
    loop
  end if
  
  'debug info for survey data
  response.write("var iterpolationTime = formatTime(" & datediff("s", interpStart, now()) & ", true);")
end if
response.write("var vidAscentLength = " & vidLength+1 & ";")
response.write("</script>")
%>

<!-- setup for craft info text -->

<%
'assign the launch date, but - 
'if we are viewing this record as a past event and the launch for this record was scrubbed,
'the launch time for this record is no longer valid for Mission Elapsed Time calculation
'so we need to look ahead for the actual launch time, which was one without a scrub
tzero = true
fromdate = rsCraft.fields.item("LaunchDate")
actualdate = ""
if bPastUT and rsCraft.fields.item("Scrub") then
  bkmark = 0
  
  'do not search past the end of the recordset or the current UT
  'we do not need people to know the actual launch time if that event has not occured yet
  'basically search for the next unused update and if it has a new launch time, use it
  'otherwise if we hit the end of the recordset then that last entry must contain whatever launch time was actually used
  tzero = false
  rsCraft.movenext
  bkmark = bkmark - 1
  do 
    if rsCraft.eof then
      exit do
    elseif rsCraft.fields.item("id") > UT then
      if fromdate <> rsCraft.fields.item("LaunchDate") then exit do
    end if
    rsCraft.movenext
    bkmark = bkmark - 1
  loop
  
  rsCraft.moveprevious
  bkmark = bkmark + 1
  actualdate = rsCraft.fields.item("LaunchDate")

  'inform user that displayed time for this record is not accurate
  if datediff("s", actualdate, now()) > 0 then
    msg = "Actual launch time:<br>" & rsCraft.fields.item("LaunchDateUTC") & " UTC<br>"
  else
    msg = "New launch time:<br>" & rsCraft.fields.item("LaunchDateUTC") & " UTC<br>"
  end if 
  tzero = true
  
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

'is the mission over?
bUpdateMET = true
if not isnull(rsCraft.fields.item("MissionEnd")) then
  values = split(rsCraft.fields.item("MissionEnd"), ";")
  if UT >= values(0)*1 then
    bUpdateMET = false
    msg = msg & values(2) & "<br>MET: "
    if len(actualdate) then
      MET = datediff("s", actualdate, values(1))
    else
      MET = datediff("s", rsCraft.fields.item("LaunchDate"), values(1))
    end if
  else
  
    'is it prior to or after launch?
    if origMET <= 0 then
      MET = origMET * -1
      msg = msg & "Mission yet to launch<br>T-"
    else
      MET = origMET
      msg = msg & "Mission ongoing<br>MET: "
    end if
  end if
else

  'is it prior to or after launch?
  if origMET <= 0 then
    MET = origMET * -1
    msg = msg & "Mission yet to launch<br>T-"
  else
    MET = origMET
    msg = msg & "Mission ongoing<br>MET: "
  end if
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
'note also we should not update if there is no time to update
if launchmsg = "To Be Determined" or not tzero then bUpdateMET = false

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
  response.write("<div id='mainContent' style='width: 100%; overflow: hidden;'>")
else
  response.write("<div id='mainContent' style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if

'determine if this craft has a 3D model available to view and if so, make available the controls to see it
if not isNull(rsCraft.fields.item("3DView")) then
  response.write("<div id='sketchfabButton' style='z-index: 115; width: 95px; font-family: sans-serif; color: white; position: absolute; height: 40px; top: 58px; left: 10px; '><img id='sketchfabImg' src='sketchfab.png' style='cursor: pointer; padding-left: 5px; padding-top: 5px;'> <span id='sketchfabTxt'>3D View</span></div>")
  response.write("<div id='sketchfabBlank' style='z-index: 115; width: 40px; font-family: sans-serif; color: white; position: absolute; height: 40px; top: 58px; left: 10px; display: none; '></div>")
  response.write("<div id='sketchfabModel' style='z-index: 113; width: 530px; position: absolute; height: 385px; top: 58px; left: 10px; display: none;'><iframe width='525' height='380' src='https://sketchfab.com/models/" & rsCraft.fields.item("3DView") & "/embed?autospin=0.2&amp;preload=1' frameborder='0' allowfullscreen mozallowfullscreen='true' webkitallowfullscreen='true' onmousewheel=''></iframe></div>")
  response.write("<div id='sketchfabReturn' style='width: 30px; height: 30px; z-index: 115; font-family: sans-serif; position: absolute; top: 58px; left: 422px; display: none; '><img src='return.png' width='19' style='cursor: pointer; padding-left: 5px; padding-top: 6px;' class='tip' data-tipped-options=""size: 'medium', position: 'bottom'"" title='Back to 2D view<br>Does not stop viewer!'></div>")
end if

'do we need to load up a launch video?
response.write("<script>bLaunchVideo = false;</script>")
if bAscentActive then
  rsAscent.movefirst
  if rsAscent.fields.item("Video") then
  
    'build the video object and hide it below the description box until it is ready to show
    response.write("<script>var bLaunchVideo = true;</script>")
    response.write("<div id='videoContainer' style='z-index: -2; width: 525; background-color: black; position: absolute; height: 380px; top: 58px; left: 10px; '>")
    response.write("<video id='video' preload='auto' width='525' height='380'>")
    
    'Chrome is stupid and refuses to load anything but OGV so do not have other options if this is Chrome
    strContent = Request.ServerVariables("HTTP_USER_AGENT")
    if instr(strContent, "Chrome") = 0 then
      response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.mp4' type='video/mp4'>")
      response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.webm' type='video/webm' >")
    end if
    
    response.write("<source src='../media/ksa/" & request.querystring("db") & "/launch.ogv' type='video/ogg; codecs=""theora, vorbis""'/>")
    response.write("</video>")
    response.write("</div>")
    
    'various text status areas
    response.write("<div id='videoTip' style='display: none'>Please be patient while video data loads</div>")
    response.write("<div id='videoStatus' style='z-index: 211; font-family: sans-serif; color: white; position: absolute; top: 61px; left: 14px; '>&nbsp;&nbsp;&nbsp;&nbsp;<span id='loadText' style='cursor: help; border-bottom: 1px dotted white;' class='tip-update' data-tipped-options=""inline: 'videoTip'""></span></div>")
    response.write("<div id='spinner' style='width: 15px; height: 20px; z-index: 111; font-family: sans-serif; color: white; position: absolute; top: 61px; left: 14px; '></div>")
    response.write("<div id='videoCameraName' style='z-index: 110; display: none; font-family: sans-serif; color: white; position: absolute; top: 61px; right: 613px; '></div>")
  end if
end if
%>

<script>
// remove the "loading page" background now that the heavy data crunching (mainly ascent data if available) is done
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
      if (!launchVideo.ended) { minimizeChoice = "data"; }
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
                    {percent: 11, text: "Reticulating splines..."}, // couldn't resist
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

    // debug info for survey data
    videoLoadTime = new Date().getTime();
  }
  
  // notify tick function to monitor video loading
  bVideoLoading = true;
}
</script>

<!-- used to inform user of launch ascent status -->
<!-- not yet implemented -->
<div id='ascentStatus' style='background-color:black; z-index: 10; font-family: sans-serif; text-align: center; color: white; position: absolute; width: 525px; top: 414px; left: 10px; '></div>

<!-- used to inform user of launch telemetry status -->
<!-- not yet implemented -->
<div id="linkdown" style="visibility: hidden; font-family: sans-serif; z-index: 105; color: red; position: absolute; top: 573px; left: 300px;"><center><h1>Telemetry Link Lost</h1><h2>Stand by...</h2></center></div>

<!-- used to inform user of upcoming launch -->
<!-- deprecated for use of alert dialog but kept around in case alert dialog annoys too many people even though it's opt-in -->
<div id='msgLaunch' style='cursor: pointer; font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 133px; width: 315px; padding: 0; margin: 0; position: absolute; top: 561px; left: 260px; display: none; background-color: gray;'><center><b>NOTICE</b><p>A launch is happening in &lt;2 minutes! Use the event timer on the right to head to the craft page to watch live launch telemetry!</p><p>Click to dismiss</p></center></div>

<!-- used to let user see progress of orbital data calculations -->
<div id='orbDataMsg' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 40px; width: 365px; padding: 0; margin: 0; position: absolute; top: 619px; left: 233px; display: none; background-color: gray;'><img id="progress" src="http://i.imgur.com/HszGFDA.png" width="0" height="40" style="position: absolute; z-index: 110;"><span style="font-size: 30px; position: absolute; z-index: 115; margin-left: 12px;">Calculating Orbital Data...</span></div>

<!-- used to inform user not all orbits were rendered to save time, gives option for full rendering -->
<div id='msgObtPd' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 133px; width: 415px; padding: 0; margin: 0; position: absolute; top: 561px; left: 210px; display: none; background-color: gray;'><center><b>NOTICE</b><p>This craft's orbital period is very long. For performance reasons, its full orbit was not rendered. Ap/Pe markings may be missing as a result.</p><p><span id="msgObtPdDismiss" style="cursor: pointer;" <% if not bMobileBrowser then response.write("class='tip' title='Close this message'") %>><b>Dismiss</b></span> | <span id="msgObtPdRender" style="cursor: pointer;" <% if not bMobileBrowser then response.write("class='tip' title='Show three full orbits'") %>><b>Render</b></span></p></center></div>

<!-- used to inform user of post-launch exit survey -->
<div id='msgPostLaunch' style='font-family: sans-serif; z-index: 115; border-style: solid; border-width: 2px; height: 120px; width: 375px; padding: 0; margin: 0; position: absolute; top: 175px; left: 85px; display: none; background-color: gray;'><center><b>Thanks for watching!</b><br><br>You may open a brief survey with some auto-filled debug information to help us improve this feature<p><span id="msgPostLaunchDismiss" style="cursor: pointer;"><b>Dismiss</b></span> | <span id="msgPostLaunchSurvey" style="cursor: pointer;"><b>Survey</b></span></p></center></div>

<!-- used to inform user of upcoming node not yet being able to be shown -->
<div id='msgNode' style='cursor: pointer; font-family: z-index: 115; sans-serif; border-style: solid; border-width: 2px; height: 113px; width: 250px; padding: 0; margin: 0; position: absolute; top: 571px; left: 292px; display: none; background-color: gray;'><center><b>NOTICE</b><p>Future maneuver node is not yet visible along this orbital plot.</p><p>Click to dismiss</p></center></div>

<!-- special notice box for new users to the site -->
<div id='intro' style='font-family: sans-serif; border-style: solid; border-width: 2px; height: 177px; width: 370px; padding: 0; position: absolute; z-index: 301; margin: 0; top: 300px; left: 250px; background-color: gray; display: none'><center><b>Welcome to the Flight Tracker & Crew Roster!</b><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>Here you can learn everything there is to know about the astronauts & vessels involved in our space program. We highly suggest <a target="_blank" href="https://github.com/Gaiiden/FlightTracker/wiki">visiting the wiki</a> for detailed instructions on how to use the many features to be found herein.<p><span id='dismissIntro' style='cursor: pointer;'>Click here to dismiss</span><p style='font-size: 14px; text-align: center;'><span style="cursor: help; text-decoration: underline; text-decoration-style: dotted" class='tip' data-tipped-options="maxWidth: 300" title="The KSA uses cookies stored on your computer via the web browser to enable certain features of the website. It does not store tracking information nor use any third party cookies for analytics or other data gathering. The website's core functionality will not be affected should cookies be disabled, at the expense of certain usability features.">Cookie Use Policy</span></p></center></div>

<!-- icon for static orbit display -->
<div id='iconStaticObt' style='cursor: pointer; z-index: 115; padding: 0; margin: 0; position: absolute; top: 458px; left: 723px; display: none;'><img src="staticObt.png" class="tip" title="View static orbits"></div>

<!-- icon for surface map display -->
<div id='iconSurfaceMap' style='cursor: pointer; z-index: 115; padding: 0; margin: 0; position: absolute; top: 458px; left: 778px; display: none;' href="http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=<%response.write rsBody.fields.item("Body")%>&map=true"><img src="groundMap.png" class="tip" title="View surface map"></div>

<!-- image containers for burn/thrust overlays -->
<div style='z-index: 125; padding: 0; margin: 0; position: absolute; top: 58px; left: 10px;'><img id='engineOverlay' src='empty.png'></div>
<div style='z-index: 125; padding: 0; margin: 0; position: absolute; top: 58px; left: 10px;'><img id='thrusterOverlay' src='empty.png'></div>

<!-- Arrows for craft rotation -->
<div id='craftRight' style='cursor: pointer; z-index: 135; padding: 0; margin: 0; position: absolute; top: 225px; left: 495px; display: none;'><img src="craftRight.png"></div>
<div id='craftLeft' style='cursor: pointer; z-index: 135; padding: 0; margin: 0; position: absolute; top: 225px; left: 15px; display: none;'><img src="craftLeft.png"></div>

<!-- hidden div that is set to contain data to show in tooltip -->
<div id='mapTipData' style='display: none'></div>

<!-- hidden div with dynamic tooltip for non-Firefox use to display over image maps -->
<div id="mapTip" style="position: absolute; display: none; z-index: 9999999;" class='tip-update' data-tipped-options="fixed: true, maxWidth: 200, inline: 'mapTipData', target: 'mouse', behavior: 'hide', detach: false"></div>

<!-- create the page section for craft information -->
<div style="width: 840px; float: left;">

<!-- header for craft information section with tag link to show related website entries/flickr photos -->
<center>
<h3><%response.write rsCraft.fields.item("CraftName")%>&nbsp;<img id="tagData"  class="tip" data-tipped-options="position: 'righttop'" style="margin-bottom: 10px; cursor: pointer;" title="view all tagged archive entries & flickr images" src="http://www.blade-edge.com/Tracker/tag.png"></a></h3>
<script>
  // store the craft name for use in finding tagged website entries and flickr photos
  var tagData = "<%response.write lcase(rsCraft.fields.item("CraftName"))%>"; 
  
  // prune out any additional info in ()
  if (tagData.includes("(")) { 
    tagData = tagData.slice(0, tagData.indexOf("("));
    tagData.trim();
  }
</script>

<script>
// add the craft name and currently viewed state to the page title
document.title = document.title + " - <%response.write rsCraft.fields.item("CraftName")%> (<%response.write rsCraft.fields.item("CraftDescTitle")%>)";</script>

<!-- main table for craft image, data fields and data display -->

<table style="width:100%">
<tr>
  <td>
  <table style="width:100%">
    <tr>

      <!-- 
      CRAFT DATA FIELDS
      =================
      Documentation:
      https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#craft-data-fields
      -->
      
      <!-- CSS slide-up caption image box -->
      <td>
        <div id="mainwrapper">
          <%
          'check for a craft image
          if not isnull(rsCraft.fields.item("CraftImg")) then
          
            'get the first craft image
            images = split(rsCraft.fields.item("CraftImg"), "|")
            craftImg = split(images(0), "~")(0)
            
            'sort out the various image angles
            imgIndex = 0
            for each img in images
              values = split(img, "~")
              
              'create the image maps if there are any
              if values(3) <> "null" then
                'Other browsers can not display tooltips by default so do not alter title if not in Firefox
                strContent = Request.ServerVariables("HTTP_USER_AGENT")
                if instr(strContent, "Firefox") > 0 then
                  response.write("<div id='craftImgOverlay" & imgIndex & "' style='z-index: 125; padding: 0; margin: 0; position: absolute; top: 58px; left: 10px;'>" & replace(values(3), "title", "class='tip' data-tipped-options=""fixed: true, maxWidth: 200, target: 'mouse', behavior: 'hide'"" title") & "</div>")
                else
                  response.write("<div id='craftImgOverlay" & imgIndex & "' style='z-index: 125; padding: 0; margin: 0; position: absolute; top: 58px; left: 10px;'>" & values(3) & "</div>")
                end if
                imgIndex = imgIndex + 1
              end if
              
              'save data to JS
              response.write("<script>craftImgs.push({Normal: '" & values(0) & "', Burn: '" & values(1) & "', Thrust: '" & values(2) & "'});</script>")
            next
          else
            
            'load the default image
            response.write("<div id='craftImgOverlay" & imgIndex & "' style='z-index: 125; padding: 0; margin: 0; position: absolute; top: 58px; left: 10px;'><img src='nada.png'></div>")
          end if
          
          'do not show the info box during an ascent state, just the image
          if bAscentActive then
            response.write("<img id='image-1' src='" & craftImg & "'/>")
          else
            response.write("<div id='box-1' class='box'>")
            response.write("<img id='image-1' width='520px' src='" & craftImg & "'/>")
            response.write("<span id='craftDesc' style='cursor: pointer;' class='caption simple-caption'>")
            
            'added the ^^ to hopefully make it more obvious to people that more informtion is available
            response.write("<center><b>^^ Craft Information - <span id='captionCraft'>" & rsCraft.fields.item("CraftDescTitle") & "</span> ^^</b></center>")
            response.write rsCraft.fields.item("CraftDescContent")
            response.write("</span>")
            response.write("</div>")

            'save data to JS
            response.write("<script>craftCaption = '" & rsCraft.fields.item("CraftDescTitle") & "';</script>")
          end if
          %>
        </div>
      </td>

      <!-- information box for orbital data, ascent data, resources, crew, etc -->
      
      <% 
      'need to force table constraint when in ascent mode so hiding video does not allow table to expand
      'craft image when in ascent state is slightly larger dimensions as well
      if bAscentActive then
        response.write("<td style='width:292px' valign='top'>")
      else
        response.write("<td style='width:100%' valign='top'>")
      end if
      %>
      
        <table border="1" style="width:100%;">

          <!-- mission date and time information -->
          
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
          Documentation: 
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#flight-data-fields
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
            if not rsOrbit.bof then
              
              'do we have a rendezvous occurring and need to render a second vessel?
              response.write("<script>var strRendezvousDB = '';</script>")
              if not isnull(rsOrbit.fields.item("Rendezvous")) then response.write("<script>var strRendezvousDB = '" & rsOrbit.fields.item("Rendezvous") & "';</script>")

              'print out all fields, check for and handle any blank records
              'dynamic tooltip to update in our tick function
              response.write("<div id='apsisSpeed' style='display: none'>Periapsis: ")
              if isnull(rsOrbit.fields.item("VelocityPe")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("VelocityPe")*1, 3)
                response.write(" km/s")
              end if
              response.write("<br>Apoapsis: ")
              if isnull(rsOrbit.fields.item("VelocityAp")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("VelocityAp")*1, 3)
                response.write(" km/s")
              end if
              response.write("</div><tr><td><b><span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'apsisSpeed'"">")
              response.write("<u>Avg Velocity</u><span>:</b> <span id='obtAvgVel'>")
              if isnull(rsOrbit.fields.item("Avg Velocity")) then
                response.write("N/A</span>")
              else
                response.write formatnumber(rsOrbit.fields.item("Avg Velocity")*1, 3)
                response.write("</span> km/s")
              end if
              response.write("</td></tr><tr><td><b>Periapsis:</b> <span id='obtPe'>")
              if isnull(rsOrbit.fields.item("Periapsis")) then
                response.write("N/A</span>")
              else
                response.write formatnumber(rsOrbit.fields.item("Periapsis")*1, 3)
                response.write("</span> km")
              end if
              response.write("</td></tr><tr><td><b>Apoapsis:</b> <span id='obtAp'>")
              if isnull(rsOrbit.fields.item("Apoapsis")) then
                response.write("N/A</span>")
              else
                response.write formatnumber(rsOrbit.fields.item("Apoapsis")*1, 3)
                response.write("</span> km")
              end if
              response.write("</td></tr><tr><td><b>Eccentricity:</b> <span id='obtEcc'>")
              if isnull(rsOrbit.fields.item("Eccentricity")) then
                response.write("N/A")
              else
                response.write formatnumber(rsOrbit.fields.item("Eccentricity")*1, 6)
              end if
              response.write("</span></td></tr><tr><td><b>Inclination:</b> <span id='obtInc'>")
              if isnull(rsOrbit.fields.item("Inclination")) then
                response.write("N/A</span>")
              else
                response.write formatnumber(rsOrbit.fields.item("Inclination")*1, 3)
                response.write("</span>&deg;")
              end if
              response.write("</td></tr><tr><td><b>Orbital Period:</b> ")
              if rsOrbit.fields.item("Orbital Period") <= 0 or isnull(rsOrbit.fields.item("Orbital Period")) then
                response.write("<u><span style='cursor:help' class='tip' title='Lack of orbital period means craft is on a hyperbolic/SOI-crossing trajectory<br>Ap/Pe refer to the lowest and highest points of the current trajectory'>N/A</span></u>")
              else
              
                'dynamic tooltip to update in our tick function
                response.write("<div id='periodTime' style='display: none'>")
                
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
                obtCount = 0
                recUT = rsOrbit.fields.item("ID")
                
                'search back to a time when this craft was not in orbit around this body to calculate the number of orbits since
                'which was when it was on a hyberbolic trajectory or before it had orbital data
                do while not rsOrbit.bof
                  if rsOrbit.fields.item("Eccentricity")*1 >= 1 then exit do
                  rsOrbit.moveprevious
                loop
                
                'does not matter if we hit BOF or not, we still would have gone back one record too far
                rsOrbit.movenext
                
                'save the data from this record and advance
                period = rsOrbit.fields.item("Orbital Period")*1
                prevTime = rsOrbit.fields.item("ID")*1
                rsOrbit.movenext
                if not rsOrbit.eof then
                  if rsOrbit.fields.item("ID") <= recUT then
                  
                    'we have not yet come back to our original orbit data
                    'continue to advance the record pointer and use the diff between the two records to calculate # of orbits for that period of time
                    do while rsOrbit.fields.item("ID") <= recUT
                      obtCount = obtCount + ((rsOrbit.fields.item("ID") - prevTime) / period)
                      period = rsOrbit.fields.item("Orbital Period")*1
                      prevTime = rsOrbit.fields.item("ID")*1
                      rsOrbit.movenext
                      
                      'stop if we have run out of records or gone past the record we started from
                      if rsOrbit.eof then
                        rsOrbit.moveprevious
                        exit do
                      elseif rsOrbit.fields.item("ID") > recUT then
                        rsOrbit.moveprevious
                        exit do
                      end if
                    loop
                    
                  'stop if we have run out of records or gone past the record we started from
                  else
                    rsOrbit.moveprevious
                  end if
                else
                  rsOrbit.moveprevious
                end if
                
                'do a final calculation factoring in the time that has elapsed from the current dbUT record until now
                obtCount = obtCount + ((dbUT - recUT) / rsOrbit.fields.item("Orbital Period"))
                response.write(ydhms & "<br>" & formatnumber(obtCount, 1) & " orbits to date</div>")
                response.write("<u><span id='obtPd' style='cursor:help' class='tip-update'  data-tipped-options=""inline: 'periodTime'"">")
                response.write formatnumber(rsOrbit.fields.item("Orbital Period")*1, 2)
                response.write("s")
                response.write("</span></u>")
              end if
              response.write("</span></td></tr>")
            end if
          end if
          %>
          
          <!-- 
          ASCENT DATA FIELDS
          ======================
          Documentation:
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#ascent-data-fields
          -->
          
          <%

          'check if we have any ascent data to display
          if bAscentActive then
            
            'point to the relevant record for this UT so we can initialize table fields
            rsAscent.MoveLast
            do until rsAscent.fields.item("id") <= dbUT
              rsAscent.MovePrevious
              
              'we could be before the launch time, in which case just load up the initial values
              if rsAscent.bof then 
                rsAscent.MoveFirst
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
            
            'some smaller units need conversion to larger units when large enough
            if rsAscent.fields.item("Velocity") > 1000 then
              response.write formatnumber(rsAscent.fields.item("Velocity") / 1000, 3)
              response.write(" km/s</span> (Throttle @ <span id='throttle'>")
            else
              response.write formatnumber(rsAscent.fields.item("Velocity"), 3)
              response.write(" m/s</span> (Throttle @ <span id='throttle'>")
            end if
            response.write formatnumber(rsAscent.fields.item("Throttle") * 100, 2)
            response.write("</span>%)</td></tr>")
            response.write("<tr><td><b>Total Thrust:</b> <span id='thrust'>")
            response.write formatnumber(rsAscent.fields.item("Thrust"), 3)
            response.write("</span> kN @ <span id='twr'>")
            
            'calculating TWR using gravity at the time
            'referenced from http://wiki.kerbalspaceprogram.com/wiki/Thrust-to-weight_ratio
            response.write formatnumber(rsAscent.fields.item("Thrust")/((rsAscent.fields.item("Mass") * 1000) * rsAscent.fields.item("Gravity")), 3)
            response.write("</span> TWR</td></tr>")
            response.write("<tr><td><b>Altitude:</b> <span id='altitude'>")
            if rsAscent.fields.item("Altitude") > 1000 then
              response.write formatnumber(rsAscent.fields.item("Altitude") / 1000, 3)
              response.write(" km")
            else
              response.write formatnumber(rsAscent.fields.item("Altitude"), 3)
              response.write(" m")
            end if
            response.write("</span></td></tr>")
            response.write("<tr><td><b>Apoapsis:</b> <span id='apoapsis'>")
            if rsAscent.fields.item("Apoapsis") > 1000 then
              response.write formatnumber(rsAscent.fields.item("Apoapsis") / 1000, 3)
              response.write(" km")
            else
              response.write formatnumber(rsAscent.fields.item("Apoapsis"), 3)
              response.write(" m")
            end if
            response.write("</span></td></tr>")
            
            'when Q is omitted (due to lack of atmosphere), Periapsis is displayed instead
            if rsAscent.fields.item("Q") <= 0 then
              response.write("<tr><td><b id='QPeCaption'>Periapsis:</b> <span id='QPe'>")
              if rsAscent.fields.item("Periapsis") > 1000 then
                response.write formatnumber(rsAscent.fields.item("Periapsis") / 1000, 3)
                response.write(" km")
              else
                response.write formatnumber(rsAscent.fields.item("Periapsis"), 3)
                response.write(" m")
              end if
            else
              response.write("<tr><td><b id='QPeCaption'>Dynamic Pressure (Q):</b> <span id='QPe'>")
              if rsAscent.fields.item("Q") >= 1 then
                response.write formatnumber(rsAscent.fields.item("Q"), 3)
                response.write(" kPa")
              else
                response.write formatnumber(rsAscent.fields.item("Q")*1000, 3)
                response.write(" Pa")
              end if
            end if
            response.write("</span></td></tr>")
            response.write("<tr><td><b>Inclination:</b> <span id='inclination'>")
            response.write formatnumber(rsAscent.fields.item("Inclination"), 3)
            response.write("&deg;")
            response.write("</span></td></tr>")
            response.write("<tr><td><b>Total Mass:</b> <span id='mass'>")
            response.write formatnumber(rsAscent.fields.item("Mass"), 3)
            response.write("</span> t</td></tr>")

            'calculate the length of the status bars, which is created by combining two solid-color 16x16 images
            'the green image is stretched the percentage of the remaining fuel, red fills in the rest
            percent = rsAscent.fields.item("StageFuel") * 1
            Gwidth = 206*percent
            Rwidth = 206-Gwidth
            response.write("<tr><td><b>Stage Fuel: </b>")
            response.write("<span id='stageFuel' style='position: absolute; z-index: 120; margin-left: 80px;'>" & formatNumber(percent * 100, 2) & "%</span>") 
            response.write("<img id='stageGreen' src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
            response.write("<img id='stageRed' src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")
            response.write("</td></tr>")
            percent = rsAscent.fields.item("TotalFuel") * 1
            Gwidth = 206*percent
            Rwidth = 206-Gwidth
            response.write("<tr><td><b>Total Fuel:</b>&nbsp;&nbsp;&nbsp;")
            response.write("<span id='totalFuel' style='position: absolute; z-index: 120; margin-left: 80px;'>" & formatNumber(percent * 100, 2) & "%</span>") 
            response.write("<img id='totalGreen' src='http://i.imgur.com/HszGFDA.png' height='16' width='" & Gwidth & "'>")
            response.write("<img id='totalRed' src='http://i.imgur.com/Gqe2mfx.png' height='16' width='" & Rwidth & "'>")
            response.write("</td></tr>")
            response.write("<tr><td><b>Distance Downrange:</b> <span id='downrange'>")
            if rsAscent.fields.item("DstDownrange") > 1000 then
              response.write formatnumber(rsAscent.fields.item("DstDownrange") / 1000, 3)
              response.write(" km")
            else
              response.write formatnumber(rsAscent.fields.item("DstDownrange"), 3)
              response.write(" m")
            end if
            response.write("</span></td></tr>")
            response.write("<tr><td><b>Distance Traveled:</b> <span id='traveled'>")
            if rsAscent.fields.item("DstTraveled") > 1000 then
              response.write formatnumber(rsAscent.fields.item("DstTraveled") / 1000, 3)
              response.write(" km")
            else
              response.write formatnumber(rsAscent.fields.item("DstTraveled"), 3)
              response.write(" m")
            end if
            response.write("</span></td></tr>")
            response.write("<tr><td><b>Angle of Attack:</b> <span id='aoa'>")
            response.write formatnumber(rsAscent.fields.item("AoA"), 2)
            response.write("</span>&deg; [")
            if isnull(rsAscent.fields.item("AoAWarn")) then
              response.write("<span id='aoawarn' style='color: green'>Nominal</span>")
            else
              response.write rsAscent.fields.item("AoAWarn")
              aoaStr = split(rsAscent.fields.item("AoAWarn"), ":")
              response.write("<span id='aoawarn' style='color: ")
              response.write aoaStr(1)
              response.write("'>")
              response.write aoaStr(0)
              response.write("</span>")
            end if
            response.write("]</td></tr>")
            response.write("<tr><td><b>Pitch:</b> <span id='pitch'>")
            response.write formatnumber(rsAscent.fields.item("Pitch"), 2)
            response.write("</span>&deg; | <b>Roll:</b> <span id='roll'>")
            response.write formatnumber(rsAscent.fields.item("Roll"), 2)
            response.write("</span>&deg; | <b>Heading:</b> <span id='heading'>")
            response.write formatnumber(rsAscent.fields.item("Heading"), 2)
            response.write("</span>&deg;")
            response.write("</td></tr>")
  
            'add a status text area for telemetry feed signal if this is a live launch
            'was originally just an extra field to keep map from popping up when craft image hides and no longer takes up space,
            'then realized it could be used to show time dilation
            if not bPastUT then
              response.write("<tr><td><center>Telemetry Status: <b><span id='telemData' style='color: green;'>Connected</span></b>&nbsp;<span id='telemFPS'>@ " & request.querystring("fps") & " FPS</span></center>")
              response.write("</td></tr>")
            end if
            
            'sets video captions if we have any
            'so thankful JQuery requests to non-existent elements fail gracefully
            response.write("<script>")
            response.write("$('#ascentStatus').html('Current Status: " & rsAscent.fields.item("Event") & "');")
            response.write("$('#videoCameraName').html('" & rsAscent.fields.item("Camera") & "');")
            response.write("</script>")
          end if
          %>
          
          <!-- 
          CREW MANIFEST FIELDS
          ====================
          Documentation:
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#crew-manifest-fields
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
            'and if there is no ascent underway (where we need the extra space)
            if not rsCrew.bof and not bAscentActive then
              response.write("<tr><td><b>Crew:</b> ")
              
              if isnull(rsCrew.fields.item("Crew")) then
                response.write("None")
              else
                crew = split(rsCrew.fields.item("Crew"), "|")
                for each kerbal in crew
                  values = split(kerbal, ";")
                  
                  'if needed, maintain querystring
                  if request.querystring("popout") then
                    query = "&popout=true"
                  else 
                    query = ""
                  end if
                  response.write("<span class='tip' title='")
                  response.write values(0)
                  response.write("<br>Boarded on: " & formatdatetime(values(2),2))
                  response.write("<br>MET: " & datediff("d", values(2), now()) & " days")
                  response.write("'><a target='_blank' href='http://www.kerbalspace.agency/Roster/roster.asp?db=")
                  response.write values(1)
                  response.write(query & "'><img src='http://www.kerbalspace.agency/Tracker/favicon.ico'></a></span> ")
                next
              end if
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
          Documentation:
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#craft-resources-fields
          -->
          
          <%
          'check if we have resource data to display
          response.write("<script>var solarOutputStr = '';</script>")
          response.write("<script>var solarDist = 0;</script>")
          response.write("<script>var resources = [];</script>")
          if not rsResources.eof then
          
            'point to the relevant record for this ut
            rsResources.movelast
            do until rsResources.fields.item("id") <= dbUT
              rsResources.MovePrevious
              if rsResources.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and if there is no ascent underway (where we need the extra space)
            if not rsResources.bof and not bAscentActive then
              response.write("<tr><td><b><span style='cursor:help' class='tip' title='Total &Delta;v: ")
              if isnull(rsResources.fields.item("DeltaV")) then 
                response.write "N/A"  
              else
                response.write formatnumber(rsResources.fields.item("DeltaV"), 3)
              end if
              response.write(" km/s<br>Total mass: ")
              response.write formatnumber(rsResources.fields.item("TotalMass"), 3)
              response.write(" t<br>Resource mass: ")
              if isnull(rsResources.fields.item("ResourceMass")) then 
                response.write "Unknown"
              else
                response.write formatnumber(rsResources.fields.item("ResourceMass"), 3)
              end if
              
              'create the prev/next buttons but do not show them until they are needed
              response.write(" t'><u>Resources</u><span>:</b> <img id='prevRes' src='prevList.png' style='display: none; cursor: pointer'> ")
              if isnull(rsResources.fields.item("Resources")) then 
                response.write "None"
              else
                resources = split(rsResources.fields.item("Resources"), "|")
                for each res in resources
                  values = split(res, ";")
                  
                  'special case - solar power calculation for electric charge
                  if values(0) = "ElectricCharge" and not isnull(rsResources.fields.item("MaxSolarOutput")) then
                    response.write("<script>var solarOutputStr = '" & rsResources.fields.item("MaxSolarOutput") & "';</script>")
                    
                    'get the distance from the sun
                    if rsBody.fields.item("Body") <> "Kerbol" then 
                    
                      'calculate the current mean anomaly (in UT)
                      obtTime = rsBody.fields.item("ObtPeriod") * (UT/rsBody.fields.item("ObtPeriod") - int(UT/rsBody.fields.item("ObtPeriod")))
                      
                      'get the closest time position from the table of data for the body that contains the distance for that time
                      rsDistance.open "select * from dst" & rsBody.fields.item("Body") & "toKerbol", connCatalog, 1, 1                    
                      do while not rsDistance.eof
                        if obtTime >= rsDistance.fields.item("UT") then exit do
                        rsDistance.movenext
                      loop
                      response.write("<script>solarDist = " & rsDistance.fields.item("Distance") & ";</script>")
                    end if
                  end if
                  
                  'stash these resources in a JS array to build the icons/tooltips from later so they can be scrolled if needed
                  response.write("<script>resources.push({Img: '" & values(0) & "', Title: '" & values(1) & "'});</script>")
                next
              end if
              
              'create the 5 images and dynamic tooltip content areas that will be used for each visible resource item
              for x=0 to 4
                response.write("<div id='resTip" & x & "' style='display: none'>temp</div>")
                response.write("<span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'resTip" & x & "', detach: false"">")
                response.write("<img id='resImg" & x & "' src='' style='display: none; padding-left: 1px; padding-right: 2px'></span>")
              next
              response.write("<img id='nextRes' src='nextList.png' style='display: none; cursor: pointer'></td></tr>")
            end if
          end if
          %>
          
          <!-- 
          CRAFT COMMS FIELDS
          ==================
          Documentation:
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#craft-comms-fields
          -->
          
          <%
          'check if we have comms data to display
          response.write("<script>var sigDelay = 0;</script>")
          if not rsComms.eof then
          
            'point to the relevant record for this ut
            rsComms.movelast
            do until rsComms.fields.item("id") <= dbUT
              rsComms.MovePrevious
              if rsComms.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and if there is no ascent underway (where we need the extra space)
            if not rsComms.bof and not bAscentActive then
              if not rsComms.fields.item("Connection") then
                response.write("<tr><td><b><span style='cursor:help' class='tip' title='Signal delay: No Connection")
              else
                response.write("<tr><td><b><span style='cursor:help' class='tip' title='Signal delay: ")
                
                'get the distance from Kerbin so we can calculate signal delay
                if rsBody.fields.item("Body") = "Kerbin" then 
                
                  'if we are in orbit around Kerbin just get our apoapsis
                  if not rsOrbit.eof then
                    kDist = rsOrbit.fields.item("Apoapsis")
                    
                  'must be pre-launch
                  else
                    kDist = 0
                  end if
                elseif rsBody.fields.item("Body") <> "Kerbol" then 
                     
                  'calculate the current mean anomaly (in UT)
                  obtTime = rsBody.fields.item("ObtPeriod") * (UT/rsBody.fields.item("ObtPeriod") - int(UT/rsBody.fields.item("ObtPeriod")))
                      
                  'get the closest time position from the table of data for the body that contains the distance for that time
                  rsDistance.open "select * from dst" & rsBody.fields.item("Body") & "toKerbin", connCatalog, 1, 1                    
                  do while not rsDistance.eof
                    if obtTime >= rsDistance.fields.item("UT") then exit do
                    rsDistance.movenext
                  loop
                  kDist = rsDistance.fields.item("Distance")
                else
                
                  'craft is in orbit around Kerbol and needs to access its own distance table for reference
                  rsDistance.open "select * from dst" & request.querystring("db") & "toKerbin", connCatalog, 1, 1                    
                  obtTime = rsOrbit.fields.item("Orbital Period") * (UT/rsDistance.fields.item("UT") - int(UT/rsDistance.fields.item("UT")))
                  
                  'craft orbits can change, so need to find the one for this dbUT
                  rsDistance.movelast
                  do until rsDistance.fields.item("id") <= dbUT
                    rsDistance.MovePrevious
                    if rsDistance.bof then exit do
                  Loop
                  
                  'extract the values for this orbital period and find the one closest to the mean anomaly
                  if not rsDistance.bof then
                    distance = split(rsDistance.fields.item("Data"), "|")
                    for each dist in distance
                      if dist(0) >= obTime then
                        kDist = dist(1)
                        exit for
                      end if
                    next
                  else
                    kDist = 0
                  end if
                end if
                
                'convert to light seconds
                sigDelay = formatnumber(kDist/299792.458, 3)
                response.write("<script>sigDelay = " & round(sigDelay) & ";</script>")
                if sigDelay < 0.001 then 
                  response.write("<0.001s")
                else
                
                  'convert from seconds to yy:ddd:hh:mm:ss
                  years = 0
                  days = 0
                  hours = 0
                  minutes = 0
                  delay = sigDelay
                  ydhms = ""
                  if delay >= 86400 then
                    days = int(delay / 86400)
                    delay = delay - (days * 86400)
                    ydhms = days & "d, "
                  end if
                  if days >= 365 then
                    years = int(days / 365)
                    days = days - (years * 365)
                    ydhms = years & "y " & days & "d, "
                  end if
                  if delay >= 3600 then
                    hours = int(delay / 3600)
                    delay = delay - (hours * 3600)
                    ydhms = ydhms & hours & "h "
                  end if
                  if delay >= 60 then
                    minutes = int(delay / 60)
                    delay = delay - (minutes * 60)
                    ydhms = ydhms & minutes & "m "
                  end if
                  if delay > 0 then
                    seconds = delay
                    ydhms = ydhms & seconds & "s"
                  end if
                  response.write ydhms
                end if
              end if
              response.write("'><u>Comms</u><span>:</b> ")
              
              'parse and display the comm icons, if there are any to show
              if isnull(rsComms.fields.item("Comms")) then
                response.write "None"
              else
                comms = split(rsComms.fields.item("Comms"), "|")
                for each comm in comms
                  values = split(comm, ";")
                  response.write("<span style='cursor:help' class='tip' title='")
                  response.write values(1)
                  response.write("'><img src='")
                  response.write values(0)
                  response.write(".png'></span> ")
                next
              end if
              response.write("</td></tr>")
            end if
          end if
          %>
          
          <!-- Related vessels -->
          
          <%
          'if this vessel is related to another, link to it and preserve certain URL variables
          if not isnull(rsCraft.fields.item("Related")) then
            values = split(rsCraft.fields.item("Related"), ";")
            strURLvars = ""
            if len(request.querystring("filter")) then strURLvars = strURLvars & "&filter=" & request.querystring("filter")
            if request.querystring("popout") then strURLvars = strURLvars & "&popout=" & request.querystring("popout")
            if len(request.querystring("pass")) then strURLvars = strURLvars & "&pass=" & request.querystring("pass")
            response.write("<tr><td><b>Related Vessel:</b> <a class='tip' title='" & values(2) & "' href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & values(0) & strURLvars & "'>" & values(1) & "</a></td></tr>")
          end if
          %>
          
          <!-- 
          CRAFT PORTS FIELDS
          ==================
          Documentation:
          https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#craft-ports-fields
          -->

          <%
          'check if we have ports data to display
          if not rsCrew.eof then
          
            'point to the relevant record for this ut
            rsPorts.MoveLast
            do until rsPorts.fields.item("id") <= dbUT
              rsPorts.MovePrevious
              if rsPorts.bof then exit do
            Loop
            
            'only execute further if we found a record earlier than this ut
            'and if there is no ascent underway (where we need the extra space)
            if not rsPorts.bof and not bAscentActive then
            
              'preserve certain URL variables for any links
              strURLvars = ""
              if len(request.querystring("filter")) then strURLvars = strURLvars & "&filter=" & request.querystring("filter")
              if request.querystring("popout") then strURLvars = strURLvars & "&popout=" & request.querystring("popout")
              if len(request.querystring("pass")) then strURLvars = strURLvars & "&pass=" & request.querystring("pass")
              response.write("<tr><td><b>Docking Ports:</b> ")

              'parse and handle port data, in one of three situations:
              '1) port is unoccupied
              '2) port is occupied and connected to another vessel that is not considered a part of this vessel (href link)
              '3) port is occupied and connected to another vessel that is considered a part of this vessel (no href link)
              ports = split(rsPorts.fields.item("Ports"), "|")
              for each port in ports
                values = split(port, ";")
                name = values(0) & "<br>Available port"
                dockImg = "unusedport.png"
                if values(2) <> "null" then 
                  name = values(0) & "<br>" & values(2)
                  dockImg = "usedport.png"
                end if
                if values(1) = "null" then 
                  response.write("<img src='" & dockImg & "' style='cursor: help' class='tip' title='" & name & "'> ")
                else
                  response.write("<a href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & values(1) & strURLvars & "'><img src='" & dockImg & "' class='tip' title='" & name & "'></a> ")
                end if
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
            response.write("<div id='localTime' style='display: none'></div>")
            response.write("<tr><td><b><span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'localTime'""><u>Last Update</u></span>:</b> ")
            
            'field can be left empty, such as prior to or during launch
            if not isnull(rsCraft.fields.item("DistanceTraveled")) then
              strAccDst = "Total Distance Traveled as of Last Update: " & formatnumber(rsCraft.fields.item("DistanceTraveled")*1, 0) & " km"

              'only estimate distance if we are the last record or the current record for the current time
              'do not allow distance estimation for ground vessels
              rsCrafts.find("db='" & request.querystring("db") & "'")
              if isnull(rsCraft.fields.item("MissionEnd")) or not rsOrbit.bof then
                rsCraft.movenext
                if rsCrafts.fields.item("Type") <> "rover" or rsCrafts.fields.item("Type") <> "base" or rsCrafts.fields.item("Type") <> "lander" then
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
              if bEstDst and not rsOrbit.bof then
                if not isnull(rsOrbit.fields.item("Avg Velocity")) then
                  strEstDst = "<br>Estimated Current Total Distance Traveled: "
                  prevUT = rsCraft.fields.item("id")
                  
                  'distance is estimated based on the average speed
                  dstTraveled = round((rsCraft.fields.item("DistanceTraveled")*1) + (rsOrbit.fields.item("Avg Velocity") * (UT - prevUT)))
                  strEstDst = strEstDst & FormatNumber(dstTraveled, 0) & " km"
                end if
              end if
              rsCrafts.movefirst
              
              'dynamic tooltip to update in our tick function
              response.write("<div id='distance' style='display: none'>" & strAccDst & strEstDst & "</div>")
              response.write("<span style='cursor:help' class='tip-update' data-tipped-options=""inline: 'distance'""><u>")
              response.write(rsCraft.fields.item("LastUpdate") & " UTC")
              response.write("</u></span>")
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
            
            'build the URL and preserve certain variables
            url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
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
                values = split(rsCraft.fields.item("MissionReport"), ";")
                if values(0) * 1 < UT then
                  response.write("<span class='tip' title='")
                  response.write values(1)
                  response.write("'><b><a" & close & "target='_blank' href='")
                  response.write values(2)
                  response.write("'>Mission Report</a></b></span> ")
                else
                  response.write("<b><span class='tip' title='Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Ongoing</a></span></b> ")
                end if
              else
                response.write("<b><span class='tip' title='Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Ongoing</a></span></b> ")
              end if
            else
            
              'this will only happen when a page loads so the telemetry stream will always be paused
              'buffer the controls with whitespace to make it less clumsy to use touchscreens (does not really help but oh well I tried)
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
  
<!-- 
FLIGHTPLAN FIELDS
=================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#flightplan-fields
-->

<%
'determine if we have an upcoming maneuver node and save that data to js
response.write("<script>")
response.write("var bUpcomingNode = false;")
response.write("var nodeUT = 0;")

'find the record that works for this time
if not rsFlightplan.bof then
  rsFlightplan.movelast
  do until rsFlightplan.bof
    if rsFlightplan.fields.item("ut") <= dbUT then exit do
    rsFlightplan.MovePrevious
  Loop
  
  'if we found one in the future, pass along the data to js for us to use later
  'otherwise we are in an active maneuver state
  if not rsFlightplan.bof then
    if rsFlightplan.fields.item("executeut") > dbUT then
      response.write("var bUpcomingNode = true;")
      response.write("var nodeUT = " & rsFlightplan.fields.item("executeut") & ";")
      response.write("var nodeEndUT = " & rsFlightplan.fields.item("endut") & ";")
      response.write("var nodePrograde = " & rsFlightplan.fields.item("prograde") & ";")
      response.write("var nodeNormal = " & rsFlightplan.fields.item("normal") & ";")
      response.write("var nodeRadial = " & rsFlightplan.fields.item("radial") & ";")
      response.write("var nodeTotal = " & rsFlightplan.fields.item("total") & ";")
      response.write("var nodeTelem = '" & rsFlightplan.fields.item("data") & "';")
      response.write("var nodeEndObt = '" & rsFlightplan.fields.item("plannedobt") & "';")
      response.write("var bNodeEngine = " & lcase(rsFlightplan.fields.item("engines")) & ";")
      response.write("var bNodeThruster = " & lcase(rsFlightplan.fields.item("thrusters")) & ";")
    elseif dbUT <= rsFlightplan.fields.item("endut")*1 + round(sigDelay) then
      response.write("var bUpcomingNode = true;")
      response.write("var bNodeExecution = true;")
      response.write("var nodeUT = " & rsFlightplan.fields.item("executeut") & ";")
      response.write("var nodeTelem = '" & rsFlightplan.fields.item("data") & "';")
      response.write("var nodeEndUT = " & rsFlightplan.fields.item("endut") & ";")
      response.write("var nodeEndObt = '" & rsFlightplan.fields.item("plannedobt") & "';")
      response.write("var bNodeEngine = " & lcase(rsFlightplan.fields.item("engines")) & ";")
      response.write("var bNodeThruster = " & lcase(rsFlightplan.fields.item("thrusters")) & ";")
    end if
  end if
end if
response.write("</script>")
%>
  
<!-- visualization field for orbits, locations, paths, etc -->

</tr>
  <%
  str = rsCraft.fields.item("ImgDataCode")

  'if there is a ~ symbol then this is an ascent state
  if left(str,1) = "~" then
    MapState = "ascent"
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 405px; width: 835px;'></div> </td> </tr>")
    bMapOrbit = false
    
    'extract the sizes of the various ascent videos
    vidLengths = split(right(str,len(str)-1), "|")
    response.write("<script>")
    response.write("var mp4Size = " & vidLengths(0) & ";")
    response.write("var webmSize = " & vidLengths(1) & ";")
    response.write("var oggSize = '" & vidLengths(2) & "';")
    response.write("</script>")

  'if there is a @ symbol this is a pre-launch state
  elseif left(str,1) = "@" then
    MapState = "prelaunch"
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 405px; width: 835px;'></div> </td> </tr>")
    
    'extract the launch location and name and save for js use later
    data = split(right(str,len(str)-1), "|")
    response.write("<script>")
    response.write("var launchLat = " & data(0) & ";")
    response.write("var launchLon = " & data(1) & ";")
    response.write("var launchsite = '" & data(2) & "';")
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
      response.write("<div id='map' class='map' style='padding: 0; margin: 0; height: 405px; width: 835px; position: absolute; top: 446px; left: 0px; visibility: hidden;'></div>")
    end if

    'check to see if this has coordinates for a static dynamic display for bodies that have no map data
    if instr(str, "[") then
      
      'fix up the string for something easier to extract from now that the format has been identified
      str = replace(replace(str, "]", ""), "[", "|")
      imgs = split(right(str,len(str)-1), "|")
      pos = split(imgs(2), ",")
      response.write("<tr> <td> <center> <span id='img' style='cursor:help'><img width='400px' src='" & imgs(0) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Ecliptic View'>&nbsp;<img width='400px' src='" & imgs(1) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Polar View'></span> </center> </td> </tr><div id='orbData' style='display: none; text-align: left; padding: 2px; font-family: sans-serif; font-size: 14px; border: 2px solid gray;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: " & 445 + (pos(0) * 1) & "px; left: " & pos(1) & "px;'></div>")
    else
    
      'extract the images used to show the static orbits
      imgs = split(right(str,len(str)-1), "|")
      response.write("<tr> <td> <center> <span id='img' style='cursor:help'><img width='400px' src='" & imgs(0) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Ecliptic View" & mapMsg & "'>&nbsp;<img width='400px' src='" & imgs(1) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Polar View" & mapMsg & "'></span> </center> </td> </tr>")
    end if
    
  'HTML formatted data, just spit it out
  'but make any titles compatible with Tipped tooltips
  else
    MapState = "none"
    response.write replace(rsCraft.fields.item("ImgDataCode"), "title", "class='tip' data-tipped-options=""target: 'mouse'"" title")
  end if
  %>
</table>

<!-- footer links -->

<span style="font-family:arial;color:black;font-size:12px;">

<%
'build the basic URL then add any included server variables that should be saved across pages
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")
vars = "?db=" & request.querystring("db")
if request.querystring("ut") then vars = vars & "&ut=" & request.querystring("ut")
if request.querystring("pass") then vars = vars & "&pass=" & request.querystring("pass")
if len(request.querystring("filter")) then vars = vars & "&filter=" & request.querystring("filter")

'we will want to close the window visiting an external link when the popout is in use
closemsg = ""
if request.querystring("popout") then	closemsg = "onclick='window.close()'"
response.write("<a " & closemsg & " target='_blank' href='http://www.kerbalspace.agency'>KSA Home Page</a>")
response.write(" | <a " & closemsg & " target='_blank' href='https://github.com/Gaiiden/FlightTracker/wiki/Flight-Tracker-Documentation'>Flight Tracker Wiki</a>")

'creates a pop-out window the user can move around
if not request.querystring("popout") then
  url = "http://www.kerbalspace.agency/Tracker/redirect.asp"
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
  response.write("<center><h3>Inactive Vessels</h3></center>")
else
  response.write("<center><h3>Active Vessels</h3></center>")
end if
%>

<!-- menu tree -->
<!-- yes, this method is very brute-force and not overly efficient but load times don't seem visibly affected to bother optimizing -->

<!-- 
CRAFT FIELDS
============
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#crafts-fields

MOON/PLANET FIELDS
==================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#moonplanet-fields
-->

<%
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
        if values(0)*1 <= UT then 
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
            if values(0)*1 <= UT then 
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
        if values(0)*1 <= UT then 
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
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
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
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
  if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
  response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
  response.write("<b>Filter By:</b> <a href='" & url & "'>Active Vessels</a>")
  
'check that there are craft, but if none were found then they must be inactive. Provide link to inactive filter
'NOTE: this assumes that there are inactive vessels!
elseif bCraftExist then
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
  if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
  if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
  response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
  response.write("<b>Filter By:</b> <a href='" & url & "&filter=inactive'>Inactive Vessels</a>")
end if
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
                response.write("var launchLink = '" & rsLaunch.fields.item("CraftLink") & "';")
                response.write("var launchCraft = '" & rsLaunch.fields.item("CraftName") & "';")
                response.write("var launchSchedUT = " & datediff("s", rsLaunch.fields.item("EventDate"), now()) & ";")
                response.write("</script>")
                
                'add a tooltip to give the user more details if available
                if not isnull(rsLaunch.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsLaunch.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                end if
                
                'print out the launch details and give the user the option to have the site remind them about it
                response.write(formatdatetime(rsLaunch.fields.item("EventDate")) & "<br>")
                response.write("<span id='tminuslaunch'></span>")
                response.write("<br /><div id='launchDiv'><input type='checkbox' id='remindLaunch'> <span class='tip' data-tipped-options=""maxWidth: 150"" title='Checking this box will cause the browser to alert you 5 minutes before the event' style='cursor: default; vertical-align: 2px;'>Remind Me</span> <img id='launchWarn' style='display: none; vertical-align: 1px; cursor: help;' src='warning-icon.png' class='tip' data-tipped-options=""maxWidth: 150"" title='You do not have cookies enabled, which means this setting will not be saved between pages/sessions. Click to dismiss'></div>")
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
                response.write(formatdatetime(rsManeuver.fields.item("EventDate")) & "<br>")
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

<!-- twitter timeline display --> 

<%
'find the craft data we need for this vessel
rsCrafts.movefirst
rsCrafts.find("db='" & request.querystring("db") & "'")

'if we are watching a live launch, show the main twitter stream even if there is a mission timeline so it auto-updates with launch tweets
'we should also hide the timeline if the currect craft record is telling us to do so
if (bAscentActive and len(request.querystring("ut")) = 0) or (rsCraft.fields.item("HideTimeline")) then
  response.write("<p><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center> <a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163' height='700' data-chrome='noheader'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
else
  
  'show the mission collection timeline if there is one available, or fall back to the main tweet stream
  if isnull(rsCrafts.fields.item("collection")) or rsCrafts.eof then 
    response.write("<p><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center> <a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163' height='700' data-chrome='noheader'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
  else
    response.write("<p><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center> <a class='twitter-timeline' data-partner='tweetdeck' href='https://twitter.com/KSA_MissionCtrl/timelines/" & rsCrafts.fields.item("collection") & "' height='600'>Curated tweets by KSA_MissionCtrl</a> <script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></p>")
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
  var UT = <%response.write UT%>;
  
  // js and vb can vary from 10-15 or more seconds
  // time is in favor of vb time, as majority of time stamps are done with dateDiff()
  // 1473739200000 ms = 9/13/16 00:00:00
  var d = new Date();
  d.setTime(1473739200000 + (UT * 1000));
  var startDate = Math.floor(d.getTime() / 1000);

  // show the local time for the latest update
  // break it up to show on two lines
  var lt = new Date();
  var newTime = 1473739200000 + (<%response.write rsCraft.fields.item("id")%> * 1000);
  lt.setTime(newTime);
  if (lt.toString().includes("Standard")) { lt.setTime(newTime + 3600000); }
  var ltStr = lt.toString().slice(0, lt.toString().indexOf("GMT"));
  var endStr = lt.toString().slice(lt.toString().indexOf("GMT"), lt.toString().length);
  $('#localTime').html(ltStr + "<br>" + endStr);
  
  // decide what kind of dynamic map we are creating, if any
  var mapState = "<%response.write MapState%>";
  var latlon = [];
  var orbitdata = [];
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
      zoom: 5,
    });

    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    // show controls only when the cursor is over the map
    if (!is_touch_device()) { 
      infoControl = new L.KSP.Control.Info({
          elevInfo: false,
          biomeInfo: false,
          slopeInfo: false
        });
      map.addControl(infoControl);
      $(".leaflet-control-info").css("display", "none");
      $(".leaflet-control-zoom").css("display", "none");
      map.on('mouseover', function(e) {
        $(".leaflet-control-info").fadeIn();
        $(".leaflet-control-zoom").fadeIn();
      });
      map.on('mouseout', function(e) {
        $(".leaflet-control-info").fadeOut();
        $(".leaflet-control-zoom").fadeOut();
      });
    }

    // set craft icon, determined by the entry in the crafts database
    <%rsCrafts.find("db='" & request.querystring("db") & "'")%>
    var ship = L.icon({iconUrl: 'button_vessel_<%response.write rsCrafts.fields.item("Type")%>.png', iconSize: [16, 16]});
    
    // render the terminator?
    // start by determining the current position of the sun given the body's degree of initial rotation and rotational period
    <%response.write("var solDay = " & rsBody.fields.item("SolarDay") & ";")%>
    <%response.write("var rotInitDeg = " & rsBody.fields.item("RotIni") & ";")%>
    if (solDay) {
      currRot = -rotInitDeg - (((parseInt(getParameterByName('ut')) / solDay) % 1) * 360);
      if (currRot < -180) { currRot += 360; }
      
      // create the icon for our sun marker
      var sunIcon = L.icon({
        iconUrl: 'sun.png',
        iconSize: [16, 16],
        iconAnchor: [8, 8]
      });
      
      // place the sun marker
      sunMark = L.marker([0,currRot], {icon: sunIcon, clickable: false}).addTo(map);

      // draw the terminators
      // terminators draw if there is room, extending as much as 180 degrees or to the edge of the map
      if (currRot - 90 > -180) {
        terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
      }
      if (currRot + 90 < 180) {
        terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
      }
    }
    
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
      for (x = 0; x < ascentDelta; x++) {
        if (ascentData[x].Phase && ascentData[x].DstTraveled.clamp > 0) {  
          ascentColorsIndex++;
          if (ascentColorsIndex == ascentColors.length) { ascentColorsIndex = 0; }
          ascentTracks.push(L.polyline([], {smoothFactor: .25, clickable: true, color: ascentColors[ascentColorsIndex], weight: 2, opacity: 1}).addTo(map));
          ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x-1].Lat, ascentData[x-1].Lon]);
          ascentTracks[ascentTracks.length-1]._myId = "<center>" + ascentData[x].Phase + "</center>";
          ascentTracks[ascentTracks.length-1].on('mouseover mousemove', function(e) {
            ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
            ascentPopup.setLatLng(e.latlng);
            ascentPopup.setContent(e.target._myId);
            ascentPopup.openOn(map);
          });
          ascentTracks[ascentTracks.length-1].on('mouseout', function(e) {
            if (ascentPopup) { map.closePopup(ascentPopup); }
            ascentPopup = null;
          });
        }
        if (ascentTracks.length) { ascentTracks[ascentTracks.length-1].spliceLatLngs(0, 0, [ascentData[x].Lat, ascentData[x].Lon]); }
        if (!noMarkBox.contains([ascentData[x].Lat, ascentData[x].Lon]) && ascentData[x].EventMark) {
          var labelIcon = L.icon({
            iconUrl: 'label.png',
            iconSize: [10, 10],
          });
          ascentMarks.push(L.marker([ascentData[x].Lat, ascentData[x].Lon], {icon: labelIcon}).addTo(map));
          ascentMarks[ascentMarks.length-1]._myId = ascentData[x].EventMark + ";" + ascentData[x].Lat + ";" + ascentData[x].Lon;
          ascentMarks[ascentMarks.length-1].on('mouseover mousemove', function(e) {
            data = e.target._myId.split(";")
            ascentPopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
            ascentPopup.setLatLng([data[1], data[2]]);
            ascentPopup.setContent(data[0]);
            ascentPopup.openOn(map);
          });
          ascentMarks[ascentMarks.length-1].on('mouseout', function(e) {
            if (ascentPopup) { map.closePopup(ascentPopup); }
            ascentPopup = null;
          });
        }
      }

      // kick off the telemetry update loop
      bAscentPaused = false;
      ascentStartTime = new Date().getTime() - (ascentDelta*1000);
      ascentUpdater(Math.floor(ascentDelta), false); 
      
    // launch hasn't started yet, so just place the craft on the first coordinates, center the map on it
    } else {
      craft = L.marker([ascentData[0].Lat, ascentData[0].Lon], {icon: ship, clickable: false}).addTo(map);
      map.setView(craft.getLatLng(), 5); 
    }

    // okay to update map stuff
    bMapRender = true;
    
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
    
    // only give the option to show the surface map as there is no orbit yet
    $("#iconSurfaceMap").fadeIn();

    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    // show controls only when the cursor is over the map
    if (!is_touch_device()) { 
      infoControl = new L.KSP.Control.Info({
          elevInfo: false,
          biomeInfo: false,
          slopeInfo: false
        });
      map.addControl(infoControl);
      $(".leaflet-control-info").css("display", "none");
      $(".leaflet-control-zoom").css("display", "none");
      map.on('mouseover', function(e) {
        $(".leaflet-control-info").fadeIn();
        $(".leaflet-control-zoom").fadeIn();
        $("#iconSurfaceMap").fadeIn();
      });
      
      // moving from map to surface icon triggers a mouseout event so make sure mouse is actually off map before hiding controls/icon
      map.on('mouseout', function(e) {
        setTimeout(function() {
          if (!$('#iconStaticObt').is(":hover") && !$('#iconSurfaceMap').is(":hover") && !$('#map').is(":hover")) { 
            $("#iconSurfaceMap").fadeOut();
            $(".leaflet-control-info").fadeOut();
            $(".leaflet-control-zoom").fadeOut();
          }
        }, 50);
      });
    }

    // render the terminator?
    // start by determining the current position of the sun given the body's degree of initial rotation and rotational period
    <%response.write("var solDay = " & rsBody.fields.item("SolarDay") & ";")%>
    <%response.write("var rotInitDeg = " & rsBody.fields.item("RotIni") & ";")%>
    if (solDay) {
      currRot = -rotInitDeg - (((UT / solDay) % 1) * 360);
      if (currRot < -180) { currRot += 360; }
      
      // create the icon for our sun marker
      var sunIcon = L.icon({
        iconUrl: 'sun.png',
        iconSize: [16, 16],
        iconAnchor: [8, 8]
      });
      
      // place the sun marker
      sunMark = L.marker([0,currRot], {icon: sunIcon, clickable: false}).addTo(map);

      // draw the terminators
      // terminators draw if there is room, extending as much as 180 degrees or to the edge of the map
      if (currRot - 90 > -180) {
        terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
      }
      if (currRot + 90 < 180) {
        terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
      }
    }
    
    // set launchsite icon
    launchsiteIcon = L.icon({popupAnchor: [0, -43], iconUrl: 'markers-spacecenter.png', iconSize: [30, 40], iconAnchor: [15, 40], shadowUrl: 'markers-shadow.png', shadowSize: [35, 16], shadowAnchor: [10, 12]});
    
    // place the marker and build the information window for it, then center the map on it and create a popup for it
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
    launchsiteMarker.bindPopup("<b>Launch Location</b><br>" + launchsite + "<br>[" + Math.abs(launchLat) + "&deg;" + cardinalLat + ", " + Math.abs(launchLon) + "&deg;" + cardinalLon + "]" , {closeButton: true});
    map.setView(launchsiteMarker.getLatLng(), 2); 
  
    // show the marker popup then hide it and surface icon in 5s if cursor is not over the icon or the map
    launchsiteMarker.openPopup(); 
    setTimeout(function () { 
      launchsiteMarker.closePopup(); 
      if (!$('#iconSurfaceMap').is(":hover") && !$('#map').is(":hover")) { 
        $("#iconSurfaceMap").fadeOut();
      }
    }, 5000);
    
    // okay to update map stuff
    bMapRender = true;
    
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
      response.write("var rotPeriod = " & rsBody.fields.item("RotPeriod") & ";")
      response.write("var solDay = " & rsBody.fields.item("SolarDay") & ";")
      response.write("var rotInitDeg = " & rsBody.fields.item("RotIni") & ";") 
      response.write("var rotInit = " & rsBody.fields.item("RotIni") * .017453292519943295 & ";") 
      response.write("var bodRad = " & rsBody.fields.item("Radius") & ";")
      response.write("var gmu = " & rsBody.fields.item("Gm") & ";")
      response.write("var sma = " & rsOrbit.fields.item("SMA") & ";")
      response.write("var ecc = " & rsOrbit.fields.item("Eccentricity") & ";")
      response.write("var inc = " & rsOrbit.fields.item("Inclination") * .017453292519943295 & ";")
      response.write("var raan = " & rsOrbit.fields.item("RAAN") * .017453292519943295 & ";")
      response.write("var arg = " & rsOrbit.fields.item("Arg") * .017453292519943295 & ";")
      response.write("var mean = " & rsOrbit.fields.item("Mean") * .017453292519943295 & ";")
      response.write("var eph = " & rsOrbit.fields.item("Eph") & ";")
      response.write("var period = " & rsOrbit.fields.item("Orbital Period") & ";")
      response.write("var atmoHeight = " & rsBody.fields.item("AtmoHeight") & ";")
    end if
    %>
    
    // don't do this if we don't have a surface map
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
        iconAnchor: [8, 18],
        popupAnchor: [0, -4]
      });
      var peIcon = L.icon({
        iconUrl: 'pe.png',
        iconSize: [16, 16],
        iconAnchor: [8, 18],
        popupAnchor: [0, -4]
      });

      // allow multiple popups to be open at the same time
      // http://jsfiddle.net/paulovieira/yVLJf/
      L.KSP.Map = L.KSP.Map.extend({
        openPopup: function(popup) {
          this._popup = popup;

          return this.addLayer(popup).fire('popupopen', {
            popup: this._popup
          });
        }
      });
      
      // create the map with some custom options, including one to make popups stay open on map click
      var map = new L.KSP.Map('map', {
        layers: [L.KSP.CelestialBody.<%response.write ucase(rsBody.fields.item("Body"))%>],
        zoom: 1,
        center: [0,0],
        bodyControl: false,
        layersControl: false,
        scaleControl: true,
        minZoom: 0,
        maxZoom: 5,
        closePopupOnClick: false
      });

      // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
      // leaflet.js was modified to remove the biome, slope and elevation data displays
      // show controls only when the cursor is over the map
      if (!is_touch_device()) { 
        infoControl = new L.KSP.Control.Info({
          elevInfo: false,
          biomeInfo: false,
          slopeInfo: false
        });
        map.addControl(infoControl);
        $(".leaflet-control-info").css("display", "none");
        $(".leaflet-control-zoom").css("display", "none");
        map.on('mouseover', function(e) {
          if (!bStaticObt) {
            $(".leaflet-control-info").fadeIn();
            $(".leaflet-control-zoom").fadeIn();
            $("#iconStaticObt").fadeIn();
            $("#iconSurfaceMap").fadeIn();
          }
        });
        
      // moving from map to surface/orbit icons triggers a mouseout event so make sure mouse is actually off map before hiding controls/icons
        map.on('mouseout', function(e) {
          setTimeout(function() {
            if (!$('#iconStaticObt').is(":hover") && !$('#iconSurfaceMap').is(":hover") && !$('#map').is(":hover") && !bStaticObt) { 
              $("#iconStaticObt").fadeOut();
              $("#iconSurfaceMap").fadeOut();
              $(".leaflet-control-info").fadeOut();
              $(".leaflet-control-zoom").fadeOut();
            }
          }, 50);
        });
      }
    }
    
    // orbital calculations status bar
    $("#orbDataMsg").fadeIn();
    
    // take into account whether we are viewing an active maneuver or not
    var currUT = initialUT = UT;
    var showMsg = false;
    var n;
    var endTime;
    var maxDeltaTime;
    if (!bNodeExecution) {
      
      // compute 3 orbits max, or only up to a future maneuver node along one of those three orbits
      if (bUpcomingNode) {
        endTime = UT + (nodeUT - UT);
        if (endTime - UT > period * 3) { endTime = UT + (Math.round(period * 3)); }
      } else {
        endTime = UT + (Math.round(period * 3));
      }
      
      // don't by default exceed 100,000s to ensure computation completes in a reasonable amount of time
      // however allow user to override this if they want
      if (getParameterByName('fullorbit').length) {
        maxDeltaTime = -1;
      } else {
        maxDeltaTime = 100000;
        if (endTime - currUT > maxDeltaTime) {
          endTime = UT + maxDeltaTime;
          
          // in cases where the orbital period exceeds 100,000s we should inform the user the whole orbit is not being plotted
          // this is handled when the map is shown (see renderMap function)
          if (period > maxDeltaTime) { showMsg = true; }
        }
      }
      
      // handle SOI escape orbits
      if (period < 0) { endTime = Math.abs(period); }
      
    // there is a maneuver node in progress, we need to jump the proper point in the telemetry
    } else {
      nodeTelemData = nodeTelem.split("|");
      if (UT - nodeUT < nodeTelemData.length) {
        data = nodeTelemData[UT - nodeUT].split(";");
      } else {
        data = nodeTelemData[nodeTelemData.length - 1].split(";");
      }
      sma = parseFloat(data[6]);
      ecc = parseFloat(data[3]);
      inc = parseFloat(data[4]) * .017453292519943295;
      raan = parseFloat(data[7]) * .017453292519943295;
      arg = parseFloat(data[8]) * .017453292519943295;
      mean = parseFloat(data[9]) * .017453292519943295;
      eph = parseFloat(data[10]);
      currUT = Math.floor(parseFloat(data[10]));
      endTime = Math.floor(currUT + parseFloat(data[5]));
    }
    
    // this function will continually call itself to batch-run orbital calculations and not completely lock up the browser
    var bIdle = true;
    orbitalCalc();
  }
  
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

  // debug: easy way to get the current UT
  if (getParameterByName("showut")) { console.log(UT); }
  
  // use any data gathered during the resource load to calculate current max solar output
  if (solarOutputStr) {
    var panels = [];
    
    // get the various panels and store their data
    var strSolar = solarOutputStr.split(":");
    for (x=0; x<strSolar.length; x++) {
      var data = strSolar[x].split("x");
      panels.push({output: parseFloat(data[0]), number: parseFloat(data[1])});
    }
    
    // get the luminosity factor
    var currBody = "<%response.write rsBody.fields.item("Body")%>";
    if (currBody == "Kerbol") { solarDist = orbitdata[0].alt; }
    power = Math.pow(13599840.256/solarDist,2);
    
    // add it all up
    var maxOutput = 0;
    for (x=0; x<panels.length; x++) {
      maxOutput += (panels[x].output * power) * panels[x].number;
    }
    
    // update what will be appended to the tooltip when EC icon is shown
    solarOutputStr = "<br>Max Solar Output: " + numeral(maxOutput).format('0,0.00') + " EC/s (" + numeral(power*100).format('0,0.00') + "%)";
  }
  
  // set up the resource icons
  var resIndex = 0;
  if (resources.length) {
  
    // scrolling is needed
    if (resources.length > 5) {
      $("#prevRes").fadeIn();
      $("#nextRes").fadeIn();
    }
    
    // set the 5 initial icons and titles
    for (x=0; x<5; x++) {  
      if (x == resources.length) { break; }
      $("#resImg" + x).attr("src", resources[x].Img + ".png");
      $("#resImg" + x).fadeIn();
      
      // caption may need modifying if electric charge icon is used
      if (resources[x].Img.toLowerCase() == "electriccharge") {
        $("#resTip" + x).html(resources[x].Title + solarOutputStr);
      } else {
        $("#resTip" + x).html(resources[x].Title);
      }
    }
  }

  // keep various things updated by calling this tick function every second
  var strMsg = "<%response.write msg%>";
  var MET = <%response.write origMET%>;
  var bUpdateMET = <%response.write lcase(bUpdateMET)%>;
  var bEstDst = <%response.write lcase(bEstDst)%>;
  var strAccDst = "<%response.write strAccDst%>";
  var dstTraveled = <%response.write dstTraveled%>;
  var tickStartTime = new Date().getTime();
  var tickDelta = 0;
  var eventCaption;
  var nodeTelemData = [];
  var camCaption;
  
  <%
    'save to JS for use updating estimated distance
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
    dd.setTime(1473739200000 + (UT * 1000));
    var currDate = Math.floor(dd.getTime() / 1000);
    var now = currDate - startDate;

    // build a string to use upon hitting a refresh trigger
    // this gets rid of any UT time when viewing the current event from a past one to ensure that the latest data is loaded
    var urlReload = "http://<%response.write Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")%>?db=" + getParameterByName('db');
    if (getParameterByName("filter")) { urlReload += "&filter=" + getParameterByName("filter"); }
    if (getParameterByName("popout")) { urlReload += "&popout=" + getParameterByName("popout"); }
    if (getParameterByName("fullorbit")) { urlReload += "&fullorbit=" + getParameterByName("fullorbit"); }

    // check if we need to refresh the page
    // did our orbital plot run out? (except for when there is a maneuver node)
    if (bDrawMap && now >= latlon.length && bNodeRefreshCheck) {
      window.location.href = urlReload;
    }
    
    // can we now draw our maneuver node?
    if (bDrawMap && bNodeRefreshCheck && nodeUT - UT < latlon.length) {
      window.location.href = urlReload;
    }

    // have we reached the next update? Check only happens if viewing the present record
    // if this is a live launch, present the user with a survey option including data from this launch stream
    if (bNextEventRefresh && UT >= nextEventUT) {
      if (!bPastUT && bAscentActive) { 
      
        // replace & with | so this is parsed by the page as a single URL variable
        surveyURL = "&surveyURL=https://docs.google.com/forms/d/1LC3e6xfWMzux8NvQQAurJpF6kdIvYZYtH4tTNNaamEg/viewform?" + 
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
          "|entry.667865474=" + formatTime(0, false)+ 
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
    
    // have we reached a new scheduled event?
    if (bFutureLaunch && UT >= nextLaunchSched) {
      window.location.href = urlReload;
    }
    if (bFutureManeuver && UT >= nextManeuverSched) {
      window.location.href = urlReload;
    }
    
    // is there new orbital data to calculate?
    if (bOrbitalDataRefresh && !bPastUT && UT >= orbitalDataRefreshUT) {
      window.location.href = urlReload;
    }
    
    // update dynamic map if needed
    if (mapState == "orbit" || mapState == "prelaunch" || mapState == "ascent") {

      // update our cardinal directions if either a dynamic map or overlay is active
      // make sure we don't overstep array bounds if a maneuver went off and left us waiting for an update
      if ((bDrawMap || $("#orbData").length) && mapState == "orbit" && now < latlon.length) {
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

        // update the sun marker?
        if (solDay) {
        
          // tie the time of day to the current playback setting when viewing an old ascent state
          if (mapState == "ascent" && bPastUT) {
          
            // elapsed time depends on whether we are in ascent data
            if (ascentDelta > 0) {
              currRot = -rotInitDeg - ((((parseInt(getParameterByName('ut')) + (telemetryUT - parseInt(getParameterByName('ut'))) + ascentDelta) / solDay) % 1) * 360);
            } else {
              currRot = -rotInitDeg - ((((parseInt(getParameterByName('ut')) + launchCountdown) / solDay) % 1) * 360);
            }
          } else {
            currRot = -rotInitDeg - (((UT / solDay) % 1) * 360);
          }
          if (currRot < -180) { currRot += 360; }
          sunMark.setLatLng([0,currRot]);
          
          // draw/update/remove the terminators
          if (currRot - 90 > -180) {
            if (!terminatorW) {
              terminatorW = L.rectangle([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
            } else {
              terminatorW.setBounds([[-90,currRot - 90], [90,maxCalc(currRot - 270, -180)]]);
            }
          } else if ((currRot - 90 < -180) && (terminatorW)) {
            map.removeLayer(terminatorW);
            terminatorW = null;
          }
          if (currRot + 90 < 180) {
            if (!terminatorE) {
              terminatorE = L.rectangle([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]], {color: "#000000", clickable: false, weight: 1, opacity: 0.5, fillOpacity: 0.5, fill: true}).addTo(map);
            } else {
              terminatorE.setBounds([[-90,currRot + 90], [90,maxCalc(currRot + 270, 180)]]);
            }
          } else if ((currRot + 90 > 180) && (terminatorE)) {
            map.removeLayer(terminatorE);
            terminatorE = null;
          }
        }
        
        // only update if a maneuver node hasn't executed and rendered all this invalid
        // number formatting done with Numeral.js - http://numeraljs.com/
        if (!bNodeExecution && now < latlon.length && mapState == "orbit") {
        
          // update craft position and popup content
          craft.setLatLng(latlon[now]);
          $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinalLat);
          $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinalLon);
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + " km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + " km/s");
          
          // update the Ap/Pe marker popup content
          $('#apTime').html("Time to Apoapsis<br>" + formatTime(apTime-now), false);
          $('#peTime').html("Time to Periapsis<br>" + formatTime(peTime-now), false);
          
          // update a second vessel marker and popup content if available
          if (bRV) {
            rvMarker.setLatLng(latlon2[now]);
            $('#lat2').html(numeral(latlon2[now].lat).format('0.0000') + "&deg;" + cardinalLat);
            $('#lng2').html(numeral(latlon2[now].lng).format('0.0000') + "&deg;" + cardinalLon);
            $('#alt2').html(numeral(orbitdata2[now].alt).format('0,0.000') + " km");
            $('#vel2').html(numeral(orbitdata2[now].vel).format('0,0.000') + " km/s");
          }
          
          // update maneuver node popup content if available
          if (bUpcomingNode) { $('#nodeTime').html("Time to Maneuver<br>" + formatTime((nodeUT - initialUT)-now), false); }

          // update SOI node popup content if available
          // check for an SOI mark at the end of a maneuver path first, otherwise it's along the current orbit
          if (period < 0 || period2 < 0) { 
            if (period2 < 0) {
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period2) - initialUT)-now, false)); 
            } else {
              $('#SOIExitTime').html("Time to SOI Exit<br>" + formatTime((Math.abs(period) - initialUT)-now, false)); 
            }
          }
          
          // update atmo entry node popup content if available
          $('#atmoEntryTime').html("Time to Atmosphere<br>" + formatTime((latlon2.length + latlon.length)-now), false);

          // update our Ap/Pe times if we've passed one by just adding on the orbital period
          // remove the marker entirely if it's past the end of the current plot
          if (now > apTime && apTime >= 0) {
            apTime += Math.round(period);
            if (apTime <= latlon.length && period > 0) {
              apMark.setLatLng(latlon[apTime]);
              apUTC = new Date();
              apUTC.setTime((startDate + Math.abs(apTime)) * 1000);
              hrs = apUTC.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              mins = apUTC.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              secs = apUTC.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              $('#apDate').html((apUTC.getUTCMonth() + 1) + "/" + apUTC.getUTCDate() + '/' + apUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC");
            } else {
              map.removeLayer(apMark);
              apTime = -1; 
            }
          }
          if (now > peTime && peTime >= 0) {
            peTime += Math.round(period);
            if (peTime <= latlon.length && period > 0) {
              peMark.setLatLng(latlon[peTime]);
              peUTC = new Date();
              peUTC.setTime((startDate + Math.abs(peTime)) * 1000);
              hrs = peUTC.getUTCHours();
              if (hrs < 10) { hrs = '0' + hrs; }
              mins = peUTC.getUTCMinutes();
              if (mins < 10) { mins = '0' + mins; }
              secs = peUTC.getUTCSeconds();
              if (secs < 10) { secs = '0' + secs; }
              $('#peDate').html((peUTC.getUTCMonth() + 1) + "/" + peUTC.getUTCDate() + '/' + peUTC.getUTCFullYear() + '<br>' + hrs + ':' + mins + ':' + secs + " UTC");
            } else {
              map.removeLayer(peMark);
              peTime = -1; 
            }
          }
          
          // check if there was a maneuver node that went off
          if (bUpcomingNode && !bNodeExecution && nodeUT - UT <= 0) {
            bNodeExecution = true;
            
            // split up the telemetry data
            nodeTelemData = nodeTelem.split("|");

            // get rid of the maneuver node marker
            map.removeLayer(nodeMark);
            
            // remove any lines rendered previously and clear the array
            for (x=0; x<lines.length; x++) { map.removeLayer(lines[x]); }
            lines = [];

            // is there signal delay to account for?
            if (nodeTelemData.length && sigDelay >= 1) {
              
              // modify the popup to inform user we are waiting on telemetry data
              craft.closePopup();
              craft.unbindPopup();
              craft.bindPopup("<center>Awaiting Telemetry Data<br>Signal Delay: <span id='signalDelay'>" + formatTime(sigDelay) + "</span></center>", {closeButton: false});
              craft.openPopup();
              
            // negligble signal delay
            } else if (nodeTelemData.length && sigDelay < 1) {
            
              // modify the popup to include extra data for the maneuver
              craft.closePopup();
              craft.unbindPopup();
              data = nodeTelemData[0].split(";");
              craft.bindPopup("Lat: <span id='lat'>" + numeral(data[11]).format('0.0000') + "&deg;S</span><br>Lng: <span id='lng'>" + numeral(data[12]).format('0.0000') + "&deg;W</span><br>Alt: <span id='alt'>" + numeral(data[14]).format('0,0.000') + " km</span><br>Vel: <span id='vel'>" + numeral(data[13]).format('0,0.000') + " km/s</span><br>&Delta;v Left: <span id='dv'>" + numeral(data[15]).format('0.000') + " km/s</span><br>Time Left: <span id='burnTime'>" + formatTime(nodeEndUT - UT) + "</span>", {closeButton: true});
              craft.openPopup();
              
              // order a new orbital plot
              sma = parseFloat(data[6]);
              ecc = parseFloat(data[3]);
              inc = parseFloat(data[4]) * .017453292519943295;
              raan = parseFloat(data[7]) * .017453292519943295;
              arg = parseFloat(data[8]) * .017453292519943295;
              mean = parseFloat(data[9]) * .017453292519943295;
              eph = parseFloat(data[10]);
              currUT = Math.floor(parseFloat(data[10]));
              endTime = Math.floor(currUT + parseFloat(data[5]));
              bIdle = false;
              latlon = [];
              orbitdata = [];
              orbitalCalc();
              
              // change the craft image to show burn in progress
              if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
              if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }

            // no data telemetry, just wait for update
            }	else {
              craft.closePopup();
              craft.unbindPopup();
              craft.bindPopup("<center>No Telemetry Data<br>Awaiting Update</center>", {closeButton: true});
              craft.openPopup();
            }
          }
          
        // a maneuver node is occurring and things need to be updated if we have telem data (short maneuvers may not)
        } else if (bNodeExecution) {
          
          // waiting for signal delay to run down?
          if (UT - nodeUT < sigDelay) {
            $("#signalDelay").html(formatTime(sigDelay - (UT - nodeUT)));
            
          // just about to jump into telem data so redo the popup
          } else if (UT - nodeUT == sigDelay) {
            craft.closePopup();
            craft.unbindPopup();
            craft.bindPopup("Lat: <span id='lat'>........&deg;S</span><br>Lng: <span id='lng'>........&deg;W</span><br>Alt: <span id='alt'>........ km</span><br>Vel: <span id='vel'>........ km/s</span><br>&Delta;v Left: <span id='dv'>................ km/s</span><br>Time Left: <span id='burnTime'>....................</span>", {closeButton: true});
            craft.openPopup();

            // change the craft image to show burn in progress
            if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
            if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }
          } else {
          
            // get the specific data points for this moment, if there is data
            if ((UT - nodeUT) - sigDelay < nodeTelemData.length) {
              data = nodeTelemData[(UT - nodeUT) - sigDelay].split(";");
              
              // update the data display orbital details 
              $("#obtAvgVel").html(numeral(data[0]).format('0,0.000'));
              $("#obtPe").html(numeral(data[1]).format('0,0.000'));
              $("#obtAp").html(numeral(data[2]).format('0,0.000'));
              $("#obtEcc").html(numeral(data[3]).format('0.000000'));
              $("#obtInc").html(numeral(data[4]).format('0,0.000'));
              $("#obtPd").html(numeral(data[5]).format('0,0.00') + "s");
              $("#apsisSpeed").html("Periapsis: " + data[16] + " km/s<br>Apoapsis: " + data[17] + " km/s");
              $("#periodTime").html(formatTime(data[5], true));

              // order a new orbital plot if the last order has finished
              if (bIdle) {
                sma = parseFloat(data[6]);
                ecc = parseFloat(data[3]);
                inc = parseFloat(data[4]) * .017453292519943295;
                raan = parseFloat(data[7]) * .017453292519943295;
                arg = parseFloat(data[8]) * .017453292519943295;
                mean = parseFloat(data[9]) * .017453292519943295;
                eph = parseFloat(data[10]);
                currUT = Math.floor(parseFloat(data[10]));
                endTime = Math.floor(currUT + parseFloat(data[5]));
                bIdle = false;
                latlon = [];
                orbitdata = [];
                orbitalCalc();
              }
              
              // update the craft marker and data
              if (data[11] < 0) {
                cardinalLat = "S";
              } else {
                cardinalLat = "N";
              }
              if (data[12] < 0) {
                cardinalLon = "W";
              } else {
                cardinalLon = "E";
              }
              craft.setLatLng([data[11], data[12]]);
              $('#lat').html(numeral(data[11]).format('0.0000') + "&deg;" + cardinalLat);
              $('#lng').html(numeral(data[12]).format('0.0000') + "&deg;" + cardinalLon);
              $('#alt').html(numeral(data[14]).format('0,0.000') + " km");
              $('#vel').html(numeral(data[13]).format('0,0.000') + " km/s");
              $('#dv').html(numeral(data[15]).format('0.000') + " km/s");
              $('#burnTime').html(formatTime(nodeEndUT - (UT - sigDelay)));
            
            // maneuver is over - await update
            } else if ((UT - nodeUT) - sigDelay == nodeTelemData.length) {
              
              // switch off the engines/thrusters
              $("#engineOverlay").attr("src", "empty.png");
              $("#thrusterOverlay").attr("src", "empty.png");
              craft.closePopup();
              craft.unbindPopup();
              
              // we may not have even bothered with maneuver telem
              if (nodeTelemData.length > 0) {
                craft.bindPopup("<center>Maneuver Completed<br>Awaiting Update</center>", {closeButton: false});
              } else {
                craft.bindPopup("<center>Awaiting Update</center>", {closeButton: false});
              }
              craft.openPopup();
            }
          }
        }
        
      // we have an orbital overlay to update, no dynamic map content
      } else if ($("#orbData").length) {

        // non maneuver telemetry
        if (!bNodeExecution) {
        
          // update the craft main info
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
          $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinalLat);
          $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinalLon);
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + " km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + " km/s");
          
          // SOI exit event? update time remaining
          if (period < 0) {
            $('#soiTime').html(formatTime(Math.abs(period) - UT, false));

          // atmo entry event? update time remaining
          } else if (orbitdata[orbitdata.length-1].alt <= atmoHeight) {
            $('#atmoTime').html(formatTime((latlon.length + initialUT) - UT, false));
            
          // normal orbit, so update Ap/Pe
          } else {
            $('#apTime').html(formatTime(apTime-now, false));
            $('#peTime').html(formatTime(peTime-now, false));
          }

          // do we need to update maneuver data?
          if (bUpcomingNode) { 
          
            // update time remaining
            $('#boxUpdate').html("<b>Time to Maneuver:</b> " + formatTime(((nodeUT - initialUT) - now), false));

            // have we reached the node?
            if (nodeUT - UT <= 0) { 
              bNodeExecution = true; 

              // split up the telemetry data
              nodeTelemData = nodeTelem.split("|");

              // change the craft image to show burn in progress
              if (UT - nodeUT == sigDelay) {
                if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
                if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }
              }
            }
          }
        } else {

          // waiting for signal delay to run down?
          if (UT - nodeUT <= sigDelay) {
            $("#boxUpdate").html("<b>Signal Delay:</b> " + formatTime(sigDelay - (UT - nodeUT)));

            // change the craft image to show burn in progress
            if (UT - nodeUT == sigDelay) { 
              if (bNodeEngine) { $("#engineOverlay").attr("src", craftImgs[craftImgIndex].Burn); }
              if (bNodeThruster) { $("#thrusterOverlay").attr("src", craftImgs[craftImgIndex].Thrust); }
            }
          } else {
          
            // get the specific data points for this moment, if there is data
            if ((UT - nodeUT) - sigDelay < nodeTelemData.length) {
              data = nodeTelemData[(UT - nodeUT) - sigDelay].split(";");
              
              // update the data display orbital details 
              $("#obtAvgVel").html(numeral(data[0]).format('0,0.000'));
              $("#obtPe").html(numeral(data[1]).format('0,0.000'));
              $("#obtAp").html(numeral(data[2]).format('0,0.000'));
              $("#obtEcc").html(numeral(data[3]).format('0.000000'));
              $("#obtInc").html(numeral(data[4]).format('0,0.000'));
              $("#obtPd").html(numeral(data[5]).format('0,0.00') + "s");
              $("#apsisSpeed").html("Periapsis: " + data[16] + " km/s<br>Apoapsis: " + data[17] + " km/s");
              $("#periodTime").html(formatTime(data[5], true));

              // update the craft data
              if (data[11] < 0) {
                cardinalLat = "S";
              } else {
                cardinalLat = "N";
              }
              if (data[12] < 0) {
                cardinalLon = "W";
              } else {
                cardinalLon = "E";
              }
              $('#orbData').html("<b>Lat:</b> " + numeral(data[11]).format('0.0000') + "&deg;" + cardinalLat + "<br>" +
                "<b>Lng:</b> " + numeral(data[12]).format('0.0000') + "&deg;" + cardinalLon + "<br>" +
                "<b>Alt:</b> " + numeral(data[14]).format('0,0.000') + " km" + "<br>" +
                "<b>Vel:</b> " + numeral(data[13]).format('0,0.000') + " km/s" + "<br>" +
                "<b>&Delta;v Left:</b> " + numeral(data[15]).format('0.000') + " km/s" + "<br>" +
                "<span id='boxUpdate'><b>Time Left:</b> " + formatTime(nodeEndUT - (UT - sigDelay)) + "</span>");
            
            // maneuver is over - await update
            } else if ((UT - nodeUT) - sigDelay == nodeTelemData.length) {
              
              // switch off the engines/thrusters
              $("#engineOverlay").attr("src", "empty.png");
              $("#thrusterOverlay").attr("src", "empty.png");
              
              // we may not have even bothered with maneuver telem
              if (nodeTelemData.length > 0) {
                $("#boxUpdate").html("Maneuver Completed!<br>Awaiting Update");
              } else {
                $("#boxUpdate").html("Awaiting Update");
              }
            }
          }
        }

        // show the orbital data if it is hidden, when it's been calculated
        if ($('#orbData').css("display") == "none" && bMapRender) { $('#orbData').fadeIn(); }

        // update our Ap/Pe times if we've passed one by just adding on the orbital period
        if (now == apTime) { apTime += Math.round(period); }
        if (now == peTime) { peTime += Math.round(period); }
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
      $("#distance").html(strAccDst + "<br>Estimated Current Total Distance Traveled: " + numeral(dstTraveled + (now * avgSpeed)).format('0,0') + " km");
    }

    // update the clock and any accompanying countdowns
    $('#ksctime').html(dd.toLocaleDateString() + ' ' + Date.toTZString(dd, 'E'));
    if (bLaunchCountdown) {
      
      // remind the user a launch is coming up if they want it
      if (Math.abs(launchSchedUT) == 300 && bLaunchRemind && $('#launchDiv').css("display") != "none") {
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
    
      // is launch is currently a live event?
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
            $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Hide video</u>)");
            $("#videoStatus").css("top", "59px");
            launchVideo.play();
          } else if (videoStartUT > UT) {
            if (!bPastUT) {
              $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - refUT) - launchCountdown, false));
            } else {
              $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
            }
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
            $("#videoCameraName").fadeIn();
            launchVideo.play();
            $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Hide video</u>");
          } else if ((videoStartUT - getParameterByName('ut')) - launchCountdown > 0) {
            $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - getParameterByName('ut')) - launchCountdown, false));
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
          for (x=0; x<ascentData.length; x++) {
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
        if (duration >= launchVideo.duration || percentLoaded >= 100) {
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
                $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Hide video</u>)");
                $("#videoStatus").css("top", "59px");
                launchVideo.play();
              } else {
                $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Hide video</u>");
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
                $("#videoStatus").html("<u style='text-decoration: underline; cursor: pointer'>Hide video</u>");
                if (!bAscentPaused) { launchVideo.play(); }
              } else {
                $("#videoStatus").html("<span style='color: red'>&#9899;</span> LIVE (<u style='text-decoration: underline; cursor: pointer'>Hide video</u>)");
                $("#videoStatus").css("top", "59px");
                launchVideo.play();
              }
            } else {
              if (!bPastUT) {
                $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - refUT) - launchCountdown, false));
              } else {
                $("#videoStatus").html("Video feed begins in: " + formatTime((videoStartUT - refUT) - launchCountdown, false));
              }
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
connCatalog.Close
Set connCatalog = nothing
set adoxConn = nothing  
connEvent.Close
Set connEvent = nothing
%>

</body>
</html>