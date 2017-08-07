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
  <meta property="og:image" content="http://i.imgur.com/UC1B3Bc.png" />

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
  <link rel="stylesheet" type="text/css" href="../jslib/leaflet.rrose.css" />

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
  <script type="text/javascript" src="../jslib/leaflet.rrose-src.js"></script>
  <script type="text/javascript" src="https://cdn.geogebra.org/apps/deployggb.js"></script>
  
  <!-- "Data load" screen -->
  <style>
    html { 
      width:100%; 
      height:100%; 
      background:url(dataload.png) center center no-repeat;
    }
  </style>

  <script>
    // for retrieving URL query strings
    // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    function getParameterByName(name) {
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
          results = regex.exec(location.search);
      return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }		
    
    // setup GeoGebra
    // use a random number to always load a new file not from cache
    // can use cookies to check for prev version and load new cache if needed
    var parameters = {"prerelease":false,"width":840,"height":840,"showToolBar":false,"borderColor":null,"showMenuBar":false,"showAlgebraInput":false,"showResetIcon":true,"enableLabelDrags":false,"enableShiftDragZoom":true,"enableRightClick":false,"capturingThreshold":null,"showToolBarHelp":false,"errorDialogsActive":true,"useBrowserForJS":true,"filename":"ggb/" + getParameterByName("body") + ".ggb?v=" + Math.random()};
    var views = {"is3D":1};
    var applet = new GGBApplet('5.0', parameters, views);
    var ggbAppletLoaded = false;
    var strTinyBodyLabel = "";
    var planetLabels = [];
    var nodes = [];
    var nodesVisible = [];
    window.onload = function() { applet.inject('applet_container'); }
    // called after load and after user clicks the reset
    function ggbOnInit(){
      ggbAppletLoaded = true;
      nodesVisible = [];
      planetLabels = [];
      nodes = [];
      if (getParameterByName("body").includes("Kerbin")) {
        ggbApplet.evalCommand('M2="dgu-266"');
        ggbApplet.evalCommand("M3=18756.2316090024");
        ggbApplet.evalCommand("M5=11554.04+600");
        ggbApplet.evalCommand("M6=24758.46+600");
        ggbApplet.evalCommand("M8=0.352002569278094");
        ggbApplet.evalCommand("M9=54.169863254196pi/180");
        ggbApplet.evalCommand("M10=270.49462751749pi/180");
        ggbApplet.evalCommand("M11=44.6140261917081pi/180");
        ggbApplet.evalCommand("M12=271589.199286178");
        ggbApplet.evalCommand("M14=6.0168559406875115");
        ggbApplet.evalCommand("M4=M3 sqrt(1 - M8^2)");
        ggbApplet.evalCommand("M7=M6 - M5");
        ggbApplet.evalCommand("M13=2pi / M12");
        ggbApplet.evalCommand("M20=Line(origin, Vector((1; M10 - pi / 2; pi / 2 - M9)))");
        ggbApplet.setVisible("M20", false);
        ggbApplet.evalCommand("M21=Rotate(Rotate((M7; 0; 0), M10, zAxis), M11 + pi, M20)");
        ggbApplet.setVisible("M21", false);
        ggbApplet.evalCommand("M22=Rotate(Rotate((M3; 0; 0), M10, zAxis), M11 - acos(-M8), M20)");
        ggbApplet.setVisible("M22", false);
        ggbApplet.evalCommand("M23=Ellipse(origin, M21, M22)");
        ggbApplet.setColor("M23", 153, 102, 51);
        ggbApplet.setFixed("M23", true, false);
        ggbApplet.evalCommand("M26=Point(M23, 0)");
        ggbApplet.setCaption("M26", "Pe");
        ggbApplet.setLabelStyle("M26", 3);
        ggbApplet.setLabelVisible("M26", true);
        ggbApplet.setColor("M26", 0, 153, 255);
        ggbApplet.setPointSize("M26", 3);
        ggbApplet.setFixed("M26", true, false);
        ggbApplet.evalCommand("M27=Point(M23, 0.5)");
        ggbApplet.setCaption("M27", "Ap");
        ggbApplet.setLabelStyle("M27", 3);
        ggbApplet.setLabelVisible("M27", true);
        ggbApplet.setColor("M27", 0, 153, 255);
        ggbApplet.setPointSize("M27", 3);
        ggbApplet.setFixed("M27", true, false);
        ggbApplet.evalCommand("M28=If(M9 != 0, Element({Intersect(xOyPlane, M23)}, 1), Point(M23, M10 / (2pi)))");
        ggbApplet.setCaption("M28", "AN");
        ggbApplet.setLabelStyle("M28", 3);
        ggbApplet.setLabelVisible("M28", true);
        ggbApplet.setColor("M28", 51, 255, 0);
        ggbApplet.setPointSize("M28", 3);
        ggbApplet.setFixed("M28", true, false);
        ggbApplet.evalCommand("M29=If(M11 != 0, Angle(M26, origin, M28), 0)");
        ggbApplet.evalCommand("M30=If(M29 > pi, 2pi - acos((M8 + cos(M29)) / (1 + M8 cos(M29))), acos((M8 + cos(M29)) / (1 + M8 cos(M29))))");
        ggbApplet.evalCommand("M31=M30 - M8 sin(M30)");
        ggbApplet.evalCommand("M32=If(M9 != 0, Element({Intersect(xOyPlane, M23)}, 2), Point(M23, (M10 + pi) / (2pi)))");
        ggbApplet.setCaption("M32", "DN");
        ggbApplet.setLabelStyle("M32", 3);
        ggbApplet.setLabelVisible("M32", true);
        ggbApplet.setColor("M32", 51, 255, 0);
        ggbApplet.setPointSize("M32", 3);
        ggbApplet.setFixed("M32", true, false);
        ggbApplet.evalCommand("M34=Mod(M14 + M13 (UT-24389614.5343108), 2pi)");
        ggbApplet.evalCommand("M35=Iteration(M - (M - M8 sin(M) - M34) / (1 - M8 cos(M)), M, {M34}, 20)");
        ggbApplet.evalCommand("M36=Point(M23, M35 / (2pi))");
        ggbApplet.setCaption("M36", "Remises");
        ggbApplet.setLabelStyle("M36", 3);
        ggbApplet.setPointSize("M36", 3);
        ggbApplet.setLabelVisible("M36", true);
        ggbApplet.setColor("M36", 153, 102, 51);
        ggbApplet.evalCommand('N2="icx-922"');
        ggbApplet.evalCommand("N3=43615.7938577481");
        ggbApplet.evalCommand("N5=2537.064+600");
        ggbApplet.evalCommand("N6=83495.45+600");
        ggbApplet.evalCommand("N8=0.92809646649485");
        ggbApplet.evalCommand("N9=65.578370337925pi/180");
        ggbApplet.evalCommand("N10=113.919439382577pi/180");
        ggbApplet.evalCommand("N11=266.029760107074pi/180");
        ggbApplet.evalCommand("N12=963074.28425002");
        ggbApplet.evalCommand("N14=2.8404884410964564");
        ggbApplet.evalCommand("N4=N3 sqrt(1 - N8^2)");
        ggbApplet.evalCommand("N7=N6 - N5");
        ggbApplet.evalCommand("N13=2pi / N12");
        ggbApplet.evalCommand("N20=Line(origin, Vector((1; N10 - pi / 2; pi / 2 - N9)))");
        ggbApplet.setVisible("N20", false);
        ggbApplet.evalCommand("N21=Rotate(Rotate((N7; 0; 0), N10, zAxis), N11 + pi, N20)");
        ggbApplet.setVisible("N21", false);
        ggbApplet.evalCommand("N22=Rotate(Rotate((N3; 0; 0), N10, zAxis), N11 - acos(-N8), N20)");
        ggbApplet.setVisible("N22", false);
        ggbApplet.evalCommand("N23=Ellipse(origin, N21, N22)");
        ggbApplet.setColor("N23", 153, 102, 51);
        ggbApplet.setFixed("N23", true, false);
        ggbApplet.evalCommand("N26=Point(N23, 0)");
        ggbApplet.setCaption("N26", "Pe");
        ggbApplet.setLabelStyle("N26", 3);
        ggbApplet.setLabelVisible("N26", true);
        ggbApplet.setColor("N26", 0, 153, 255);
        ggbApplet.setPointSize("N26", 3);
        ggbApplet.setLabelVisible("N26", true);
        ggbApplet.evalCommand("N27=Point(N23, 0.5)");
        ggbApplet.setCaption("N27", "Ap");
        ggbApplet.setLabelStyle("N27", 3);
        ggbApplet.setLabelVisible("N27", true);
        ggbApplet.setColor("N27", 0, 153, 255);
        ggbApplet.setPointSize("N27", 3);
        ggbApplet.setLabelVisible("N27", true);
        ggbApplet.evalCommand("N28=If(N9 != 0, Element({Intersect(xOyPlane, N23)}, 1), Point(N23, N10 / (2pi)))");
        ggbApplet.setCaption("N28", "AN");
        ggbApplet.setLabelStyle("N28", 3);
        ggbApplet.setLabelVisible("N28", true);
        ggbApplet.setColor("N28", 51, 255, 0);
        ggbApplet.setPointSize("N28", 3);
        ggbApplet.setLabelVisible("N28", true);
        ggbApplet.evalCommand("N29=If(N11 != 0, Angle(N26, origin, N28), 0)");
        ggbApplet.evalCommand("N30=If(N29 > pi, 2pi - acos((N8 + cos(N29)) / (1 + N8 cos(N29))), acos((N8 + cos(N29)) / (1 + N8 cos(N29))))");
        ggbApplet.evalCommand("N31=N30 - N8 sin(N30)");
        ggbApplet.evalCommand("N32=If(N9 != 0, Element({Intersect(xOyPlane, N23)}, 2), Point(N23, (N10 + pi) / (2pi)))");
        ggbApplet.setCaption("N32", "DN");
        ggbApplet.setLabelStyle("N32", 3);
        ggbApplet.setLabelVisible("N32", true);
        ggbApplet.setColor("N32", 51, 255, 0);
        ggbApplet.setPointSize("N32", 3);
        ggbApplet.setLabelVisible("N32", true);
        ggbApplet.evalCommand("N34=Mod(N14 + N13 (UT-17193600), 2pi)");
        ggbApplet.evalCommand("N35=Iteration(N - (N - N8 sin(N) - N34) / (1 - N8 cos(N)), N, {N34}, 20)");
        ggbApplet.evalCommand("N36=Point(N23, N35 / (2pi))");
        ggbApplet.setCaption("N36", "Chikelu");
        ggbApplet.setLabelStyle("N36", 3);
        ggbApplet.setPointSize("N36", 3);
        ggbApplet.setLabelVisible("N36", true);
        ggbApplet.setColor("N36", 153, 102, 51);
      }
      // bring figure up to date
      ggbApplet.setValue("UT", UT);
      // listen for any planets clicked on
      ggbApplet.registerClickListener("planetInfo");
      // declutter the view
      setTimeout(function() { 
        // loop through all the objects - we'll only do this once
        for (obj=0; obj<ggbApplet.getObjectNumber(); obj++) {
          // if it's a node, hide the object and stash it
          if (ggbApplet.getCaption(ggbApplet.getObjectName(obj)).includes("AN") ||
              ggbApplet.getCaption(ggbApplet.getObjectName(obj)).includes("DN") ||
              ggbApplet.getCaption(ggbApplet.getObjectName(obj)).includes("Pe") ||
              ggbApplet.getCaption(ggbApplet.getObjectName(obj)).includes("Ap")) {
            ggbApplet.setVisible(ggbApplet.getObjectName(obj), false);
            nodes.push(ggbApplet.getObjectName(obj));
          // otherwise it's a planet
          } else if (ggbApplet.getCaption(ggbApplet.getObjectName(obj)).length) { 
            planetLabels.push(ggbApplet.getObjectName(obj)); 
            ggbApplet.setLabelVisible(ggbApplet.getObjectName(obj), false);
          }
        }
        ggbApplet.setVisible("RefLine", false);
        // uncheck all the boxes
        $(".checkboxes").prop('checked', false);
      }, 2500);
    }
    // display planetary info
    function planetInfo(object) {
      if (ggbApplet.getColor(object.charAt(0) + "36") == "#996633") { 
        for (craftIndex=0; craftIndex<bodyCrafts.length; craftIndex++) {
          if (ggbApplet.getValueString(object.charAt(0) + "2") == bodyCrafts[craftIndex].DB) { 
            strHTML = bodyCrafts[craftIndex].HTML;
            strHTML = strHTML.replace("INSERT", "<div style='cursor: pointer; position: absolute; top: 5px; right: 5px;' onclick='closePlanetInfo(&quot;" + object + "&quot;)'><img src='close-button.png' style='width: 25px; height: 25px;'></div>");
            strHTML += "<p><a href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" + bodyCrafts[craftIndex].DB + "' style='cursor: pointer; color: blue; text-decoration: none;'>View Craft Page</a> | ";
            // no nodes to show unless body has an eccentric or inclined orbit
            if (parseFloat(bodyCrafts[craftIndex].Ecc) || parseFloat(bodyCrafts[craftIndex].Inc)) {
              if (nodesVisible.includes(object.charAt(0))) {
                strHTML += "<span onclick='nodesToggle(&quot;" + object + "&quot;)' style='cursor: pointer; color: blue;'>Hide Nodes</span></p>"
              } else {
                strHTML += "<span onclick='nodesToggle(&quot;" + object + "&quot;)' style='cursor: pointer; color: blue;'>Show Nodes</span></p>"
              }
            } else { strHTML = strHTML.substring(0, strHTML.length-2); }
            strHTML += "</td></tr></table>";
          }
        }
      } else {
        if (object == "RefLine") {
          ggbApplet.evalCommand("SetViewDirection((0,0,1), true)");
          return;
        }
        // show label if clicked on an orbit
        if (strTinyBodyLabel.length) {
          ggbApplet.setLabelVisible(strTinyBodyLabel.charAt(0) + "36", false);
          strTinyBodyLabel = "";
        }
        if (parseInt(object.substring(1)) == 23) {
          ggbApplet.setLabelVisible(object.charAt(0) + "36", true);
          strTinyBodyLabel = object;
        }
        strBodyName = ggbApplet.getCaption(object.charAt(0) + "36");
        strHTML = "<table style='border: 0px; border-collapse: collapse;'><tr><td style='vertical-align: top; width: 256px;'>";
        var bodyIndex;
        for (bodyIndex=0; bodyIndex<bodiesCatalog.length; bodyIndex++) {
          if (strBodyName == bodiesCatalog[bodyIndex].Name) { break; }
        }
        if (bodiesCatalog[bodyIndex].Image != 'null') {
          strHTML += "<img src='" + bodiesCatalog[bodyIndex].Image + "' style='background-color:black;'>";
        } else {
          strHTML += "<img src='nada.png'>";
        }
        strHTML += "<i><p>&quot;" + bodiesCatalog[bodyIndex].Desc + "&quot;</p></i><p><b>- Kerbal Astronomical Society</b></p></td>";
        strHTML += "<td style='vertical-align: top;'><div style='cursor: pointer; position: absolute; top: 5px; right: 5px;' onclick='closePlanetInfo(&quot;" + object + "&quot;)'><img src='close-button.png' style='width: 25px; height: 25px;'></div><b><span style='font-size: 24px; line-height: 20px'>" + bodiesCatalog[bodyIndex].Name + "</span><p>Orbital Data</b></p>";
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
        if (getParameterByName("body") == "Kerbin-System" && strBodyName == "Kerbin") {
          strHTML += "<p><a href='http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbin&map=true' style='cursor: pointer; color: blue; text-decoration: none;'>View Surface</a> | ";
        } else if (getParameterByName("body").includes("System") && bodiesCatalog[bodyIndex].Moons && !getParameterByName("body").includes(strBodyName)) {
          strHTML += "<p><a href='http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=" + strBodyName + "-System' style='cursor: pointer; color: blue; text-decoration: none;'>View System</a> | ";
        }
        // no nodes to show unless body has an eccentric or inclined orbit
        if ((parseFloat(bodiesCatalog[bodyIndex].Ecc) || parseFloat(bodiesCatalog[bodyIndex].Inc)) && !getParameterByName("body").includes(strBodyName)) {
          if (nodesVisible.includes(object.charAt(0))) {
            strHTML += "<span onclick='nodesToggle(&quot;" + object + "&quot;)' style='cursor: pointer; color: blue;'>Hide Nodes</span>"
          } else {
            strHTML += "<span onclick='nodesToggle(&quot;" + object + "&quot;)' style='cursor: pointer; color: blue;'>Show Nodes</span>"
          }
        } else { strHTML = strHTML.substring(0, strHTML.length-2); }
        strHTML += "</p></td></tr></table>";
      }
      $('#planetInfo').html(strHTML);
      $('#planetInfoBox').fadeIn();
    }
    function closePlanetInfo(object) { 
      $('#planetInfoBox').fadeOut(); 
      if (strTinyBodyLabel.length) {
        ggbApplet.setLabelVisible(object.charAt(0) + "36", false);
        strTinyBodyLabel = false;
      }
    }
    function nodesToggle(object) {
      if ($('#planetInfo').html().includes("Show Nodes")) {
        $('#planetInfo').html($('#planetInfo').html().replace("Show Nodes", "Hide Nodes"));
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Priax") { object = object.replace("D", "C"); }
        ggbApplet.setVisible(object.charAt(0) + "26", true);
        ggbApplet.setVisible(object.charAt(0) + "27", true);
        ggbApplet.setVisible(object.charAt(0) + "28", true);
        ggbApplet.setVisible(object.charAt(0) + "32", true);
        nodesVisible.push(object.charAt(0));
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Polta") { nodesVisible.push("D"); }
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Priax") { nodesVisible.push("C"); }
      } else {
        $('#planetInfo').html($('#planetInfo').html().replace("Hide Nodes", "Show Nodes"));
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Priax") { object = object.replace("D", "C"); }
        ggbApplet.setVisible(object.charAt(0) + "26", false);
        ggbApplet.setVisible(object.charAt(0) + "27", false);
        ggbApplet.setVisible(object.charAt(0) + "28", false);
        ggbApplet.setVisible(object.charAt(0) + "32", false);
        nodesVisible.splice(nodesVisible.indexOf(object.charAt(0)), 1);
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Polta") { nodesVisible.splice(nodesVisible.indexOf("D"), 1); }
        if (ggbApplet.getCaption(object.charAt(0) + "36") == "Priax") { nodesVisible.splice(nodesVisible.indexOf("C"), 1); }
      }
    }
    function showMap() {
      $("#map").css("visibility", "visible");
      $("#close").css("visibility", "visible");
      $("#kscflags").css("visibility", "visible");
      $("#applet_container").css("display", "none");
      $("#mapholder").css("display", "block");
      $("#key").css("visibility", "hidden");
      $("#utc").css("visibility", "hidden");
    }
    
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
      
      ////////////////////////////
      // computeMeanFromTrueAnom() <-- refers to a function in KSPTOT code: https://github.com/Arrowstar/ksptot
      ////////////////////////////
      var mean;
      if (bodyCrafts[currCraft].Ecc < 1.0) {
        var EA = (Math.atan2(Math.sqrt(1-(Math.pow(bodyCrafts[currCraft].Ecc,2)))*Math.sin(bodyCrafts[currCraft].TruA), bodyCrafts[currCraft].Ecc+Math.cos(bodyCrafts[currCraft].TruA)));
        if (bodyCrafts[currCraft].TruA < 2*Math.PI) {
          EA = Math.abs(EA - (2*Math.PI) * Math.floor(EA / (2*Math.PI)));
        }
        mean = EA - bodyCrafts[currCraft].Ecc*Math.sin(EA);
        mean = Math.abs(mean - (2*Math.PI) * Math.floor(mean / (2*Math.PI)));
      } else {

        //////////////////////////////
        // computeHyperAFromTrueAnom()
        //////////////////////////////
        var num = Math.tan(bodyCrafts[currCraft].TruA/2);
        var denom = Math.pow((bodyCrafts[currCraft].Ecc+1)/(bodyCrafts[currCraft].Ecc-1),(1/2));
        var HA = 2*Math.atanh(num/denom);

        mean = bodyCrafts[currCraft].Ecc*Math.sinh(HA)-HA;
      }

      // calculate plots in batches of 1500 (each plot represents a second)
      for (x=0; x<=1500; x++) {
      
        //////////////////////
        // computeMeanMotion()
        //////////////////////
        
        // adjust for motion since the time of this orbit
        n = Math.sqrt(gmu/(Math.pow(Math.abs(bodyCrafts[currCraft].SMA),3)));
        var newMean = mean + n * (currUT - bodyCrafts[currCraft].Eph);

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
      if (bodyCrafts[currCraft].Img != 'null') {
        strHTML += "<img src='" + bodyCrafts[currCraft].Img + "' width='200px'>";
      } else {
        strHTML += "<img src='nada.png' width='200px'>";
      }
      if (bodyCrafts[currCraft].Type != "Moon") {
        strHTML += "<i><p>&quot;" + bodyCrafts[currCraft].Desc + "&quot;</p></i>";
        strHTML += "<p><a href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" + bodyCrafts[currCraft].DB + "'>View Craft Page</a></p>";
      }
      
      // possibly more than one name
      if (bodyCrafts[currCraft].Name.search(";") >= 0) {
        var names = bodyCrafts[currCraft].Name.split("|");
        var currentName = 0;
        
        // I apologize to my future self for how convoluted I made these next two lines of code :P
        for (n=0; n < names.length; n++) { if (names[n].split(";")[0] < UT) { currentName = n; } }
        strHTML += "</td><td style='vertical-align: top;'><b><span style='font-size: 24px; line-height: 20px'>" + bodyCrafts[currCraft].Name.split("|")[currentName].split(";")[1] + "</span><p>Current Orbital Data</b></p><p>";
      } else {
        strHTML += "</td><td style='vertical-align: top;'><b><span style='font-size: 24px; line-height: 20px'>" + bodyCrafts[currCraft].Name + "</span><p>Current Orbital Data</b></p><p>";
      }
      
      
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
            layerControl.addOverlay(overlays[currType], "<img src='button_vessel_" + types[currType] + ".png' width='10px' style='vertical-align: 1px;'> <span style='color: " + txtColor + ";'>" + types[currType] + "</span>", "Orbital Tracks");
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
            layerControl.addOverlay(plzWait, "Loading orbits...", "Orbital Tracks");
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
                          TruA: bodyObtData[x].TruA * .017453292519943295,
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
    
    // places a pin or group of pins when a link is clicked in a surface path mission data window
    function popupMarkerOpen(indexFlt, linkNum) {
      map.closePopup(positionPopup);

      for (pinIndex=0; pinIndex<flightData[indexFlt].Pins[linkNum].Group.length; pinIndex++) {
      
        // don't create this pin if it is already created
        if (!flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin) {
          flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin = L.marker([flightData[indexFlt].Pins[linkNum].Group[pinIndex].Lat, flightData[indexFlt].Pins[linkNum].Group[pinIndex].Lng]).bindPopup(decodeURI(flightData[indexFlt].Pins[linkNum].Group[pinIndex].HTML) + "<p><center><span onclick='popupMarkerClose(" + indexFlt + "," + linkNum + "," + pinIndex + ")' style='color: blue; cursor: pointer;'>Remove Pin</span></center></p>", {closeButton: false}).addTo(map);
          
          // if there is just one pin, open the popup
          if (flightData[indexFlt].Pins[linkNum].Group.length == 1) { flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin.openPopup(); }
          
        // if the pin is already created, open the popup
        } else {
          flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin.openPopup();
        }
      }
      
      return;
    }

    // removes a single pin when user clicks link in pin popup
    function popupMarkerClose(indexFlt, linkNum, pinIndex) {
      map.removeLayer(flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin);
      flightData[indexFlt].Pins[linkNum].Group[pinIndex].Pin = null;
      
      return;
    }
    
     // open new windows for related website entries/flickr photos
    function viewTag(tag) {

      // is this a tag for a system, then include all the moons in the system as well
      if (tag.includes("system")) {
      
        // special case for Kerbol
        if (tag.includes("kerbol")) {
          viewTag("kerbol");
          return;
        }
      
        // remove the "-system"
        tag = tag.slice(0, tag.indexOf("-"));
        
        // find the body in the catalog, replacing the first letter with an uppercase one to ensure a match
        var bodyIndex;
        for (bodyIndex=0; bodyIndex<bodiesCatalog.length; bodyIndex++) { if (bodiesCatalog[bodyIndex].Name.includes(tag.replace(tag.substr(0,1), tag.substr(0,1).toUpperCase()))) { break; } }
      
        // get the moons
        var moons = bodiesCatalog[bodyIndex].Moons.split(",");
        
        // add the bodies to a list selection in the tooltip
        var strHTML = "Select one of the following bodies below to<br>view all tagged website entries & flickr images<p><span onclick='viewTag(&quot;" + tag + "&quot;)' class='close-tooltip' style='cursor: pointer; text-decoration: underline;'>" + tag.replace(tag.substr(0,1), tag.substr(0,1).toUpperCase()) + "</span><br>";
        for (bodyIndex=0; bodyIndex<moons.length; bodyIndex++) {
          moons[bodyIndex].trim();
          strHTML += "<span onclick='viewTag(&quot;" + moons[bodyIndex] + "&quot;)' class='close-tooltip' style='cursor: pointer; text-decoration: underline;'>" + moons[bodyIndex] + "</span><br>";
        }
        strHTML += "</p>";
        $("#tagDataTip").html(strHTML);
        
        Tipped.refresh(".tip-update");
        
      // just get the tags for the body & reset the text
      } else {
        window.open("https://www.flickr.com/search/?user_id=kerbal_space_agency&tags=" + tag + ",-archive&view_all=1");
        window.open("http://www.kerbalspace.agency/?tag=" + tag.replace(/ /g, "-"));
      }
      
      return;
    }


    // set up for AJAX requests
    // http://www.w3schools.com/ajax/
    var ajaxCraftData;
    var ajaxUpdate;
    var ajaxFlightPath;
    if (window.XMLHttpRequest) {
      ajaxCraftData = new XMLHttpRequest();
      ajaxUpdate = new XMLHttpRequest();
      ajaxFlightPath = new XMLHttpRequest();
    } else {
      // code for IE6, IE5
      ajaxCraftData = new ActiveXObject("Microsoft.XMLHTTP");
      ajaxUpdate = new ActiveXObject("Microsoft.XMLHTTP");
      ajaxFlightPath = new ActiveXObject("Microsoft.XMLHTTP");
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
            
            // possibly more than one name
            if (craftsCatalog[craftIndex].Name.search(";") >= 0) {
              var names = craftsCatalog[craftIndex].Name.split("|");
              var currentName = 0;
              
              // I apologize to my future self for how convoluted I made these next two lines of code :P
              for (n=0; n < names.length; n++) { if (names[n].split(";")[0] < UT) { currentName = n; } }
              strHTML += "<td style='vertical-align: top;'>INSERT<b><span style='font-size: 24px; line-height: 20px'>" + craftsCatalog[craftIndex].Name.split("|")[currentName].split(";")[1] + "</span><p>Orbital Data</b></p><p>";
            } else {
              strHTML += "<td style='vertical-align: top;'>INSERT<b><span style='font-size: 24px; line-height: 20px'>" + craftsCatalog[craftIndex].Name + "</span><p>Orbital Data</b></p><p>";
            }
            
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

            // show the time/date this was posted
            // put a zero before hours and minutes if needed
            // 1473742800000 ms = 9/13/16 00:00:00
            // GMT-4 Standard times are an hour later than they should be. Adjust if needed
            // suspect it's because the base UT time from the game started during Daylight Savings and never actually changes an hour forward/back
            var lt = new Date();
            lt.setTime(1473742800000 + (craftInfo[15] * 1000));
            if (lt.toString().search("Standard") >= 0) { lt.setTime(1473742800000 + ((craftInfo[15] - 3600) * 1000)); }
            var lastUpdatehr = lt.getUTCHours();
            var lastUpdateMin = lt.getUTCMinutes();
            if (lastUpdatehr < 10) { lastUpdatehr = "0" + lastUpdatehr; }
            if (lastUpdateMin < 10) { lastUpdateMin = "0" + lastUpdateMin; }
            strHTML += "Last Updated: " + (lt.getUTCMonth() + 1) + "/" + lt.getUTCDate() + "/" + (lt.getUTCFullYear() - 2000) + " @ " + lastUpdatehr + ":" + lastUpdateMin + " UTC";
            
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
                                TruA: parseFloat(craftInfo[24]) * .017453292519943295,
                                Eph: parseFloat(craftInfo[25]),
                                Orbits: 0,
                                Layer: -1,
                                Obt: [],
                                Loaded: false,
                                Paths: [],
                                Craft: '',
                                HTML: strHTML});
              }
            }
          }
          
          // create all the tooltips using Tipped.js - http://www.tippedjs.com/
          // behavior of the tooltip depends on the device
          if (is_touch_device()) {
            Tipped.create('.tip', {size: 'small', showOn: 'click', hideOnClickOutside: true});
            Tipped.create('.tip-update', {size: 'small', showOn: 'click', hideOnClickOutside: true});
          } else {
            Tipped.create('.tip', {size: 'small'});
            Tipped.create('.tip-update', {size: 'small'});
          }
                    
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

    // handle requests for flight path information for surface map
    var flightData = [];
    var timePopup = null;
    var positionPopup = L.popup({offset: new L.Point(0,-1), closeButton: false, maxWidth: 500});
    var positionPopupisOpen = false;
    ajaxFlightPath.onreadystatechange = function() {
      if (ajaxFlightPath.readyState == 4 && ajaxFlightPath.status == 200) {
        
        // get the separate data sets
        var dataSets = ajaxFlightPath.responseText.split("~");
        
        // get the initial flight data
        var fltData = dataSets[0].split("`");
        for (fltIndex=0; fltIndex<fltData.length; fltIndex++) {
          var info = fltData[fltIndex].split("|");
          flightData.push({Name: info[0],
                           Img: info[1],
                           Desc: info[2],
                           Link: info[3],
                           Data: [],
                           Paths: [],
                           Pins: [],
                           HTML: null,
                           Layer: L.layerGroup()});
        }
        
        // separate the flight data string
        var flights = dataSets[1].split(";");
        for (fltIndex=0; fltIndex<flights.length; fltIndex++) {
          var path = flights[fltIndex].split("|");
          for (pathIndex=0; pathIndex<path.length; pathIndex++) {
            var data = path[pathIndex].split(",");
            flightData[fltIndex].Data.push({UT: parseInt(data[0]), 
                                            ASL: parseFloat(data[1]), 
                                            AGL: parseFloat(data[2]),
                                            Lat: parseFloat(data[3]),
                                            Lng: parseFloat(data[4]),
                                            Spd: parseFloat(data[5]),
                                            Dist: parseFloat(data[6])});
          }
        }
        
        // draw the flight paths
        var surfacePathColors = ["#FF0000", "#FFD800", "#4CFF00", "#00FFFF", "#0094FF", "#0026FF", "#4800FF", "#B200FF", "#FF00DC", "#FF006E"];
        var colorIndex = 0;
        for (fltIndex=0; fltIndex<flightData.length; fltIndex++) {
          var coord = 0;
          var coordStart = 0;
          while (coord < flightData[fltIndex].Data.length) {
            var path = [];
            while (coord < flightData[fltIndex].Data.length) {
            
              // create a new array entry for this location, then advance the array counter
              path.push({lat: flightData[fltIndex].Data[coord].Lat, lng: flightData[fltIndex].Data[coord].Lng});
              coord++;
              
              // use with hotline leaflet plugin when upgraded to leaflet 1.0
              // path.push([flightData[fltIndex].Data[coord].Lat, flightData[fltIndex].Data[coord].Lng, flightData[fltIndex].Data[coord].Alt / 1000]);

              // detect if we've crossed off the edge of the map and need to cut the line
              // compare this lng to the prev and if it changed from negative to positive or vice versa, we hit the edge  
              // (check if the lng is over 100 to prevent detecting a sign change while crossing the meridian)
              if (coord < flightData[fltIndex].Data.length) {
                if (((flightData[fltIndex].Data[coord].Lng < 0 && flightData[fltIndex].Data[coord-1].Lng > 0) && Math.abs(flightData[fltIndex].Data[coord].Lng) > 100) || ((flightData[fltIndex].Data[coord].Lng > 0 && flightData[fltIndex].Data[coord-1].Lng < 0) && Math.abs(flightData[fltIndex].Data[coord].Lng) > 100)) { break; }
              }
            }
            
            // create the path for this section
            if (colorIndex >= surfacePathColors.length) { colorIndex = 0; }
            flightData[fltIndex].Paths.push(L.polyline(path, {smoothFactor: 1.75, clickable: true, color: surfacePathColors[colorIndex], weight: 3, opacity: 1}));
            
            // use with hotline leaflet plugin when upgraded to leaflet 1.0
            // flightData[fltIndex].Paths.push(L.hotline(path, {smoothFactor: 0.25, clickable: true, palette: {0.0: '#FF0000', 0.15: '#FF6A00', 0.3: '#FFD800', 0.45: '#00AE21', 0.6: '#0094FF', 0.75: '#0026FF', 0.9: '#4800FF', 1.0: '#B200FF'}, min: 0, max: 45, weight: 3, opacity: 1}));            
            
            // save the beginning index of this line to make it faster when searching for a data point by not having to look at all paths
            // also save the current flight index to identify the data needed for the popups
            // and save the current path index this is
            flightData[fltIndex].Paths[flightData[fltIndex].Paths.length-1]._myId = flightData[fltIndex].Paths.length-1 + "," + coordStart + "," + fltIndex
            
            // show the time and data for this position
            flightData[fltIndex].Paths[flightData[fltIndex].Paths.length-1].on('mouseover mousemove', function(e) {
              
              // do not execute if the clicked popup is still open
              if (!positionPopupisOpen) {
                var idStr = e.target._myId.split(",");
                var index = parseInt(idStr[1]);
                var indexFlt = parseInt(idStr[2]);
                var indexPath = parseInt(idStr[0]);
                var margin = 0.1;
                
                // traverse the latlon array and get the diff between the current index and the location hovered
                // if it is smaller than the margin, stop. If the entire orbit is searched, increase the margin and try again
                while (true) {
                  if (Math.abs(flightData[indexFlt].Data[index].Lat - e.latlng.lat) < margin && Math.abs(flightData[indexFlt].Data[index].Lng - e.latlng.lng) < margin) { break; }
                  index++;
                  
                  // be sure to account for running to the end of the current path or end of array
                  if (index - parseInt(idStr[1]) >= flightData[indexFlt].Paths[indexPath].length || index >= flightData[indexFlt].Data.length) {
                    index = parseInt(idStr[1]);
                    margin += 0.1;
                  }
                }
                
                // set the current time
                // GMT-4 Standard times are an hour later than they should be. Adjust if needed
                // suspect it's because the base UT time from the game started during Daylight Savings and never actually changes an hour forward/back
                var dd = new Date();
                dd.setTime((1473742800000 + (flightData[indexFlt].Data[index].UT) * 1000));
                if (dd.toString().search("Standard") >= 0) { console.log("hi"); dd.setTime(1473742800000 + ((flightData[indexFlt].Data[index].UT - 3600) * 1000)); }

                // compose the popup HTML and place it on the cursor location then display it
                if (flightData[indexFlt].Data[index].Lat < 0) {
                  var cardinalLat = "S";
                } else {
                  var cardinalLat = "N";
                }
                if (flightData[indexFlt].Data[index].Lng < 0) {
                  var cardinalLng = "W";
                } else {
                  var cardinalLng = "E";
                }
                var hrs = dd.getUTCHours();
                if (hrs < 10) { hrs = '0' + hrs; }
                var mins = dd.getUTCMinutes();
                if (mins < 10) { mins = '0' + mins; }
                var secs = dd.getUTCSeconds();
                if (secs < 10) { secs = '0' + secs; }
                if (timePopup) { map.closePopup(timePopup); }
                timePopup = new L.Rrose({ offset: new L.Point(0,-1), closeButton: false, autoPan: false });
                timePopup.setLatLng(e.latlng);
                timePopup.setContent(dd.getUTCMonth() + 1 + '/' + dd.getUTCDate() + '/' + dd.getUTCFullYear() + ' @ ' + hrs + ':' + mins + ':' + secs + ' UTC<br>Latitude: ' + numeral(flightData[indexFlt].Data[index].Lat).format('0.0000') + '&deg;' + cardinalLat + '<br>Longitutde: ' + numeral(flightData[indexFlt].Data[index].Lng).format('0.0000') + '&deg;' + cardinalLng + '<br>Altitude ASL: ' + numeral(flightData[indexFlt].Data[index].ASL/1000).format('0,0.000') + ' km<br>Altitude AGL: ' + numeral(flightData[indexFlt].Data[index].AGL/1000).format('0,0.000') + " km<br>Velocity: " + numeral(flightData[indexFlt].Data[index].Spd).format('0,0.000') + " m/s" + '<br>Distance from KSC: ' + numeral(flightData[indexFlt].Data[index].Dist/1000).format('0,0.000') + " km<p>Click for additional flight information</p>");
                timePopup.openOn(map);
              }
            });
            
            // remove the mouseover popup
            flightData[fltIndex].Paths[flightData[fltIndex].Paths.length-1].on('mouseout', function(e) {
              if (timePopup) { map.closePopup(timePopup); }
              timePopup = null;
            });
            
            // when clicking along this line, display the mission data info
            flightData[fltIndex].Paths[flightData[fltIndex].Paths.length-1].on('click', function(e) {
              map.closePopup(timePopup);
              timePopup = null;
              positionPopupisOpen = true;
              var idStr = e.target._myId.split(",");
              var index = parseInt(idStr[1]);
              var indexFlt = parseInt(idStr[2]);
              var indexPath = parseInt(idStr[0]);

              // compose the popup HTML only if it has not been done so already
              if (!flightData[indexFlt].HTML) {
                var strHTML = "<table style='border: 0px; border-collapse: collapse;'><tr><td style='vertical-align: top; width: 256px;'>";
                strHTML += "<img src='" + flightData[indexFlt].Img + "' width='256px'></td>";
                strHTML += "<td style='vertical-align: top;'><b><span style='font-size: 24px; line-height: 20px'>" + flightData[indexFlt].Name + "</span></b><p>";
                
                // see if there is a marker link in the description
                if (flightData[indexFlt].Desc.indexOf("loc=") >= 0) {
                  
                  // cut up to the link
                  strHTML += flightData[indexFlt].Desc.slice(0, flightData[indexFlt].Desc.indexOf("<a"));
                  
                  // extract the popup data, checking for multiple links
                  var charLinkIndex = 0;
                  for (linkNum=0; linkNum<flightData[indexFlt].Desc.match(/<a/g).length; linkNum++) {
                    
                    // push a new pin group to the list
                    flightData[indexFlt].Pins.push({Group: []});
                    
                    // get the full link text
                    var linkStr = flightData[indexFlt].Desc.slice(flightData[indexFlt].Desc.indexOf("<a", charLinkIndex), flightData[indexFlt].Desc.indexOf('">', charLinkIndex));

                    // iterate through all the pins
                    var charPinIndex = 0;
                    for (pinNum=0; pinNum<linkStr.match(/loc=/g).length; pinNum++) {
                    
                      // get the pin from the link
                      // this works except for the last pin
                      if (pinNum < linkStr.match(/loc=/g).length-1) {
                        var pinData = flightData[indexFlt].Desc.slice(flightData[indexFlt].Desc.indexOf("loc=", charLinkIndex + charPinIndex)+4, flightData[indexFlt].Desc.indexOf('&amp', flightData[indexFlt].Desc.indexOf("loc=", charLinkIndex + charPinIndex))).split(",");
                      } else {
                        var pinData = flightData[indexFlt].Desc.slice(flightData[indexFlt].Desc.indexOf("loc=", charLinkIndex + charPinIndex)+4, flightData[indexFlt].Desc.indexOf('"', flightData[indexFlt].Desc.indexOf("loc=", charLinkIndex + charPinIndex))).split(",");
                      }
                      
                      // push the data to the group
                      flightData[indexFlt].Pins[linkNum].Group.push({Lat: pinData[0],
                                                                    Lng: pinData[1],
                                                                    HTML: pinData[2],
                                                                    Pin: null});
                                                                                          
                      // set the index so we search past the previous location
                      charPinIndex = flightData[indexFlt].Desc.indexOf("loc=", charLinkIndex + charPinIndex)+4;
                    }

                    // set the link name
                    strHTML += "<span onclick='popupMarkerOpen(" + indexFlt + "," + linkNum + ")' style='color: blue; cursor: pointer'>" + flightData[indexFlt].Desc.slice(flightData[indexFlt].Desc.indexOf('">', charLinkIndex)+2, flightData[indexFlt].Desc.indexOf('</a>', charLinkIndex)) + "</span>";
                    
                    // set the index so we search past the previous link
                    charLinkIndex = flightData[indexFlt].Desc.indexOf("</a>", charLinkIndex)+4;
                      
                    // if we're going around for more links, get the text between this and the next one
                    if (flightData[indexFlt].Desc.match(/<a/g).length > 1) {
                      strHTML += flightData[indexFlt].Desc.slice(charLinkIndex, flightData[indexFlt].Desc.indexOf("<a", charLinkIndex));
                    }
                  }
                    
                  // get the rest of the text
                  strHTML += flightData[indexFlt].Desc.slice(charLinkIndex, flightData[indexFlt].Desc.length) + "</p><p>";
                } else {
                  strHTML += flightData[indexFlt].Desc + "</p><p>";
                }
                strHTML += "<a href='" + flightData[indexFlt].Link + "' target='_blank'>Mission Report</a></p></td></tr></table>";
                positionPopup.setContent(strHTML);
                flightData[indexFlt].HTML = strHTML;
              } else {
                positionPopup.setContent(flightData[indexFlt].HTML);
              }
              
              // position and display the popup
              positionPopup.setLatLng(e.latlng);
              positionPopup.openOn(map);
            });
            
            // we're about to maybe start a new path, so update the starting location of the next path
            coordStart = coord;

            // add this to the layer
            flightData[fltIndex].Layer.addLayer(flightData[fltIndex].Paths[flightData[fltIndex].Paths.length-1]);
          }
          
          // add the layer to the layer control
          layerControl.addOverlay(flightData[fltIndex].Layer, "<span style='vertical-align: -8px; line-height: 5px; font-size: 36px; color: " + surfacePathColors[colorIndex] + "'>&#8226;</span>" + flightData[fltIndex].Name, "Surface Tracks");
          colorIndex++;
        }
        
        // if there was only one track, make it visible and zoom in on it
        if (fltIndex < 2) {
          flightData[0].Layer.addTo(map);
          map.setView([flightData[0].Data[0].Lat, flightData[0].Data[0].Lng], 3);
        }
        
        // get rid of the wait message
        layerControl.removeLayer(plzWaitFlt);
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
          if (bodiesCatalog[bodyIndex].Image != 'null') {
            strHTML += "<img src='" + bodiesCatalog[bodyIndex].Image + "'>";
          } else {
            strHTML += "<img src='nada.png'>";
          }
          strHTML += "<i><p>&quot;" + bodiesCatalog[bodyIndex].Desc + "&quot;</p></i><p><b>- Kerbal Astronomical Society</b></p></td>";
          strHTML += "<td style='vertical-align: top;'><b><span style='font-size: 24px; line-height: 20px'>" + bodiesCatalog[bodyIndex].Name + "</span><p>Orbital Data</b></p>";
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
      
        // create all the tooltips using Tipped.js - http://www.tippedjs.com/
        // behavior of the tooltip depends on the device
        if (is_touch_device()) {
          Tipped.create('.tip', {size: 'small', showOn: 'click', hideOnClickOutside: true});
          Tipped.create('.tip-update', {size: 'small', showOn: 'click', hideOnClickOutside: true});
        } else {
          Tipped.create('.tip', {size: 'small'});
          Tipped.create('.tip-update', {size: 'small'});
        }
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

      // close button for surface map, hides either map or KSC image depending on situation
      $("#close").click(function(){
        if ($("#map").css("visibility") == "visible")
        {
          window.location.href = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbin-System"
          $("#map").css("visibility", "hidden");
          $("#close").css("visibility", "hidden");
          $("#kscflags").css("visibility", "hidden");
          $("#applet_container").css("visibility", "visible");
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
      
      // close the planet info box
      $('#planetInfoClose').click(function() { console.log("clicky"); });
      
      // checkbox handling for dynamic figure
      // ensure all start checked
      $(".checkboxes").prop('checked', true);
      $("input").change(function () {
        if ($(this).is(":checked")) {
          if ($(this).attr("name") == "nodes") {
            nodes.forEach(function(item, index) {
              ggbApplet.setVisible(item, true);
            });
          } else if ($(this).attr("name") == "labels") {
            planetLabels.forEach(function(item, index) {
              ggbApplet.setLabelVisible(item, true);
            });
          } else if ($(this).attr("name") == "ref") {
            ggbApplet.setVisible("RefLine", true);
          }
        } else {
          if ($(this).attr("name") == "nodes") {
            nodes.forEach(function(item, index) {
              // don't hide the nodes if they were shown individually
              if (!nodesVisible.includes(item.charAt(0))) {
                ggbApplet.setVisible(item, false);
              }
            });
          } else if ($(this).attr("name") == "labels") {
            planetLabels.forEach(function(item, index) {
              ggbApplet.setLabelVisible(item, false);
            });
          } else if ($(this).attr("name") == "ref") {
            ggbApplet.setVisible("RefLine", false);
          }
        }
      });
      
      // load straight to the map?
      if (getParameterByName("map")) { 
        $("#map").css("visibility", "visible");
        $("#close").css("visibility", "visible");
        $("#applet_container").css("visibility", "hidden");
        $("#mapholder").css("display", "block");
      }

      // load straight to a map location?
      if (getParameterByName("center")) {
        $("#map").css("visibility", "visible");
        $("#applet_container").css("visibility", "hidden");
        $("#close").css("visibility", "visible");
        $("#mapholder").css("display", "block");
        mapLocation = getParameterByName("center").split(",");
        map.setView([mapLocation[0], mapLocation[1]], 3);
      }
      
      // load a map pin and caption?
      if (getParameterByName("loc")) {
        $("#map").css("visibility", "visible");
        $("#applet_container").css("visibility", "hidden");
        $("#close").css("visibility", "visible");
        $("#mapholder").css("display", "block");
        
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
        label= '4';
      } else {
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
'get the diff between system time and JS time
'because Brinkster servers are stupid and for some reason not synced to NIST
response.write("<script>console.log('vbscript: " & Now & "'); console.log('javascript: ' + new Date().toLocaleTimeString());</script>")
timeOffset = 84

'calculate the time in seconds since epoch 0 when the game started
UT = datediff("s", "13-Sep-2016 00:00:00", now()) + timeOffset

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

response.write("<div id='tagDataTip' style='display: none'>view all tagged website entries & flickr images</div>")
response.write("&nbsp;<span><img class='tip-update' onclick=""viewTag('" & lcase(request.querystring("body")) & "')"" data-tipped-options=""inline: 'tagDataTip', position: 'righttop'"" style='margin-bottom: 10px; cursor: pointer;' src='http://www.blade-edge.com/Tracker/tag.png'></span>")
%>
</h3>

<script>
// add the body name to the page title
document.title = document.title + " - <%response.write(replace(request.querystring("body"), "-", " "))%>";
</script>

<div id="applet_container"></div>

<!-- anchor to pull down page when scrolling through body diagrams -->
<a name="top">

<!-- 
hack used to allow collapse of orbital image and still display footer text below dynamic map, 
as Leaflet map doesn't play nice with the 'display' CSS property
-->
<img src="mapholder.png" style="display: none; z-index: -1;" id="mapholder">

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

<!-- Planet Info Box -->

<table id="planetInfoBox" style='display: none; border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 52px; left: 5px;'><tr><td style='font-size: 10px;'><span id='planetInfo'></span></td></tr></table>

<!-- Figure Controls -->

<div style='color: white; position: absolute; top: 865px; left: 5px;'><input class="checkboxes" name="nodes" type="checkbox"> Show Nodes <input class="checkboxes" name="labels" type="checkbox"> Show Names <input class="checkboxes" name="ref" type="checkbox"> Show Reference Line</div>

<!-- footer links-->

<span style="font-family:arial;color:black;font-size:10px;">
<p>
<a target='_blank' href='http://www.kerbalspace.agency'>KSA Home Page</a> | 2D Orbit rendering: <a target='_blank' href="http://bit.ly/KSPTOT">KSPTOT</a> | 3D Orbit Rendering: <a target='_blank' href="http://forum.kerbalspaceprogram.com/index.php?/topic/158826-3d-ksp-solar-system-scale-model-major-update-05202017/">by Syntax</a> | <a href='https://github.com/Gaiiden/FlightTracker/wiki/Flight-Tracker-Documentation'>Flight Tracker Wiki</a>
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
dbUT = datediff("s", "13-Sep-2016 00:00:00", now()) + timeOffset

'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
if request.querystring("ut") then

  'convert the text string into a number
  dbUT = request.querystring("ut") * 1
  
  'do not allow people to abuse the UT query to peek ahead 
  'a passcode query is required for when requesting a UT entry later than the current UT
  if dbUT > UT then
    if request.querystring("pass") <> "2725" then 
    
      'passcode incorrect or not supplied. Revert back to current UT
      dbUT = datediff("s", "13-Sep-2016 00:00:00", now()) + timeOffset
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

      'do not process aircraft
      if rsCrafts.fields.item("type") <> "aircraft" then 
      
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
            'get the vessel current name if there is more than one
            if (instr(rsCrafts.fields.item("vessel"), ";") > 0) then
              names = split(rsCrafts.fields.item("vessel"), "|")
              for each name in names
                values = split(name, ";")
                if values(0)*1 <= UT then 
                  vesselName = values(1)
                end if
              next 
            else 
              vesselName = rsCrafts.fields.item("vessel")
            end if
            response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db") & "&filter=inactive'>" & vesselName & "</a></li>")
          end if
        end if
      end if 
      rsCrafts.movenext
    loop
    
    'only close off the category if entries were created
    'then re-rack the crafts for another search through for a new type
    if bInactiveVessels then response.write("</ol> </li>")
    rsCrafts.movefirst
  next

  'look once more through all crafts in the table for any aircraft
  bInactiveVessels = false
  do while not rsCrafts.eof
    if rsCrafts.fields.item("type") = "aircraft" then

      'should this aircraft be shown?
      if rsCrafts.fields.item("SOI")*1 <= dbUT then
        
        'if this is the first vessel found for this filter, then create the category to list the vessel under
        if not bInactiveVessels then
          bInactiveVessels = true
          
          title = "Aircraft"
          response.write("<li> <label" & title & " for='" & title & "'>" & title & "</label" & title & "> <input type='checkbox' id='" & title & "' /> <ol>")
        end if
        
        'add the craft under this vessel type
        response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=Kerbin&map=true&flt=" & rsCrafts.fields.item("db") & "&filter=inactive'>" & rsCrafts.fields.item("vessel") & "</a></li>")
      end if
    end if
    rsCrafts.movenext
  loop
  
  'only close off the category if entries were created
  'then re-rack the crafts for the next search
 if bInactiveVessels then response.write("</ol> </li>")
 rsCrafts.movefirst

else

  'loop through all the planets
  do while not rsPlanets.eof
    
    'check for any moons of this planet
    bPlanet = false
    do while not rsMoons.eof
      if rsMoons.fields.item("ref") = rsPlanets.fields.item("id") then
        bVessels = false
        do while not rsCrafts.eof

          'do not process aircraft
          if rsCrafts.fields.item("type") <> "aircraft" then 
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
                    response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""showOn: 'mouseover', position: 'right'"" title='Show System overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsPlanets.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
                    bPlanet = true
                  end if
                  
                  // disable the ability to click on moon links to go to there body pages
                  //url = "http://www.kerbalspace.agency/Tracker/body.asp?db=bodies&body=" & rsMoons.fields.item("body")
                  //if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                  //if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
                  //response.write("<li><label for='" & rsMoons.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""showOn: 'mouseover', position: 'right'"" title='Show body overview' href='" & url & "'>" & rsMoons.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsMoons.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
                  response.write("<li><label for='" & rsMoons.fields.item("body") & "'>" & rsMoons.fields.item("body") & "&nbsp;&nbsp;<span id='" & rsMoons.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
                  bVessels = true
                end if
                
                'include the craft as a child of the moon
                'get the vessel current name if there is more than one
                if (instr(rsCrafts.fields.item("vessel"), ";") > 0) then
                  names = split(rsCrafts.fields.item("vessel"), "|")
                  for each name in names
                    values = split(name, ";")
                    if values(0)*1 <= UT then 
                      vesselName = values(1)
                    end if
                  next 
                else 
                  vesselName = rsCrafts.fields.item("vessel")
                end if
                url = "http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db")
                if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
                if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
                response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""showOn: 'mouseover', offset: { x: -10 }, maxWidth: 255, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & vesselName & "&nbsp;&nbsp;<span id='" & rsCrafts.fields.item("db") & "' style='position: relative;'></span></a></li>")
                bEntry = true
                
                'if this craft is orbiting around the body currently being viewed, it will probably need a rich tooltip to be displayed
                if instr(request.querystring("body"), rsMoons.fields.item("Body")) then
                  response.write("<script>craftQuery.push('" & rsCrafts.fields.item("db") & "');</script>")
                end if
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
    
      'do not process aircraft
      if rsCrafts.fields.item("type") <> "aircraft" then
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
                response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""showOn: 'mouseover', position: 'right'"" title='Show System overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a>&nbsp;&nbsp;<span id='" & rsPlanets.fields.item("body") & "' style='position: relative;'></span></label> <input type='checkbox' id='' /> <ol>")
              bPlanet = true
            end if
            
            'include the craft as a child of the planet
            'get the vessel current name if there is more than one
            if (instr(rsCrafts.fields.item("vessel"), ";") > 0) then
              names = split(rsCrafts.fields.item("vessel"), "|")
              for each name in names
                values = split(name, ";")
                if values(0)*1 <= UT then 
                  vesselName = values(1)
                end if
              next 
            else 
              vesselName = rsCrafts.fields.item("vessel")
            end if
            url = "' href='http://www.kerbalspace.agency/Tracker/craft.asp?db=" & rsCrafts.fields.item("db")
            if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
            if len(request.querystring("pass")) then url = url & "&pass=" & request.querystring("pass")
              response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""showOn: 'mouseover', offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & url & "'>" & vesselName & "&nbsp;&nbsp;<span id='" & rsCrafts.fields.item("db") & "' style='position: relative;'></span></a></li>")
            bEntry = true
                
            'if this craft is orbiting around the body currently being viewed, it will probably need a rich tooltip to be displayed
            if instr(request.querystring("body"), rsPlanets.fields.item("Body")) then
              response.write("<script>craftQuery.push('" & rsCrafts.fields.item("db") & "');</script>")
            end if
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
    response.write("<li> <label for='Kerbol'><a id='link' class='tip' data-tipped-options=""showOn: 'mouseover', position: 'right'"" title='Show System overview' href='" & url & "'>Kerbol</a>&nbsp;&nbsp;<span id='Kerbol' style='position: relative;'></span></label> <input type='checkbox' id='' /> </li>")
end if
%>

<!-- adds a link to the crew roster to the end of the menu list -->
<li> <labelRoster for='Roster'><a href="http://www.kerbalspace.agency/Roster/roster.asp" style="text-decoration: none; color: black" class="tip" data-tipped-options="showOn: 'mouseover', position: 'right'" title="Information on KSA astronauts">Crew Roster</a>&nbsp;&nbsp;<span id='crewRoster' style='position: relative;'></span></labelRoster> </li>
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
  
  'do not process aircraft
  if rsCrafts.fields.item("type") <> "aircraft" then 
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
                  ", TruA: " & rsMoons.fields.item("TrueAnom") & _
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
              
              'is this a countdown hold?
              if isnull(rsLaunch.fields.item("EventDate")) then 
                response.write("<script>")
                response.write("var bLaunchCountdown = false;")
                response.write("var bFutureLaunch = false;")
                response.write("var nextLaunchSched = 0;")

                'not an active countdown, but still contains data
                response.write("var launchLink = '" & rsLaunch.fields.item("CraftLink") & "';")
                response.write("var launchCraft = '" & rsLaunch.fields.item("CraftName") & "';")
                response.write("var launchSchedUT = 0;")
                response.write("</script>")

                'add a tooltip to give the user more details if available
                if not isnull(rsLaunch.fields.item("Desc")) then
                  response.write("<a class='tip' title='" & rsLaunch.fields.item("Desc") & "' data-tipped-options=""offset: { y: -10 }, maxWidth: 150, position: 'top'"" href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                else
                  response.write("<a href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br>")
                end if
                
                'display the hold message
                response.write("COUNTDOWN HOLD<br>Awaiting new L-0 time")
              else
                'has this launch has gone off already?
                if datediff("s", rsLaunch.fields.item("EventDate"), now()) + timeOffset >= 0 then
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
                  response.write("var launchSchedUT = " & datediff("s", rsLaunch.fields.item("EventDate"), now()) + timeOffset & ";")
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
              if datediff("s", rsManeuver.fields.item("EventDate"), now()) + timeOffset >= 0 then
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
                response.write("var maneuverUT = " & datediff("s", rsManeuver.fields.item("EventDate"), now()) + timeOffset & ";")
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
<a class="twitter-timeline" href="https://twitter.com/KSA_MissionCtrl" data-widget-id="598711760149852163" height="625" data-chrome="noheader">Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>  </p>
</span></div> </div>

<!-- Setting up known map layers -->

<script>
  // don't run this script if we don't have any maps on this body
  var currUT = initialUT = UT = <%response.write UT%>;
  var hasMap = <%response.write(lcase(rsBody.fields.item("Map")))%>;
  if (hasMap) 
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
      if (e.popup._source && !isNaN(e.popup._source._myId) && e.popup._source._myId >= 0) {
        for (p=0; p<bodyCrafts[e.popup._source._myId].Paths.length; p++) {
          bodyCrafts[e.popup._source._myId].Paths[p].setStyle({color: '#ffff00', weight: 5});
          bodyCrafts[e.popup._source._myId].Paths[p].bringToFront();
        }
      }
    });
   
    // if the popup was closed for a vessel, return its lines back to the proper color for its type
    map.on('popupclose', function(e) {
      positionPopupisOpen = false;
      if (e.popup._source && !isNaN(e.popup._source._myId) && e.popup._source._myId >= 0) {
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
    
    // check if we need to send for any flight path data
    if (getParameterByName("flt")) {
      var plzWaitFlt = L.layerGroup();
      layerControl.addOverlay(plzWaitFlt, "Loading paths...", "Surface Tracks");
      ajaxFlightPath.open("GET", "fltpath.asp?data=" + getQueryParams("flt").toString(), true);
      ajaxFlightPath.send();
    }
  
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
    layerControl.addOverlay(plzWait, "Loading orbits...", "Orbital Tracks");
    
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
  // 1473742800000 ms = 9/13/16 00:00:00
  var d = new Date();
  d.setTime(1473742800000 + (UT * 1000));
  
  // called every second to update page data
  var startDate = Math.floor(d.getTime() / 1000);
  var tickStartTime = new Date().getTime();
  var tickDelta = 0;
  (function tick() {
    var dd = new Date();
    dd.setTime(1473742800000 + (UT * 1000));
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
        } else {

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
          
          // will probably need to change at some point when multiple SOI need to be displayed...
          overlays[bodyCrafts[x].Layer].removeLayer(SOIMark);
          
          // re-render only if a maneuver node, SOI exit or atmo interface is not on this plot
          if (bodyCrafts[x].Node < 0 && bodyCrafts[x].ObtPd > 0 && bodyCrafts[x].Obt[bodyCrafts[x].Obt.length-1].Alt > bodiesCatalog[currBodyIndex].AtmoHeight && currCraft < 0) {
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
    
    // update the dynamic orbit figure
    if (ggbAppletLoaded) { ggbApplet.setValue("UT", UT); }
    
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