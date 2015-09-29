<!DOCTYPE html>

<!-- code/comments not formatted for word wrap -->

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/gIRTgKb.png" />

	<!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="tipped.css" />
	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto:900" />
	<link rel="stylesheet" type="text/css" href="http://static.kerbalmaps.com/leaflet.css" />
	<link rel="stylesheet" type="text/css" href="leaflet.label.css" />

	<!-- JS libraries -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="leaflet.js"></script>
	<script type="text/javascript" src="leafletembed.js"></script>
	<script type="text/javascript" src="tipped.js"></script>

	<script>
		// determine whether this is a touchscreen device for proper tooltip handling
		// http://ctrlq.org/code/19616-detect-touch-screen-javascript
		function is_touch_device() {
		 return (('ontouchstart' in window)
					|| (navigator.MaxTouchPoints > 0)
					|| (navigator.msMaxTouchPoints > 0));
		}

		// JQuery setup
		$(document).ready(function(){
			// behavior of the tooltip depends on the device
			if (is_touch_device()) {
				var showOpt = 'click';
			} else {
				var showOpt = 'mouseenter';
			}
			
			// create all the tooltips using Tipped.js - http://www.tippedjs.com/
			Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});
			
			// determines whether the flag icon on the image map was clicked
			// hides elements as appropriate
			// code from http://stackoverflow.com/questions/2409836/how-to-set-cursor-style-to-pointer-for-links-without-hrefs
			$("map[name=orbits] area").click(function () {
        if ($(this).attr('id') == "flags") {
          $("#map").css("visibility", "visible");
          $("#close").css("visibility", "visible");
          $("#kscflags").css("visibility", "visible");
          $("#orbitImg").css("display", "none");
          $("#mapholder").css("display", "block");
          $("#key").css("visibility", "hidden");
          $("#utc").css("visibility", "hidden");
        }
      });

      // determines what elements to show/hide - map or KSC image?
			$("#close").click(function(){
        if ($("#map").css("visibility") == "visible")
        {
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
          $("#kscflagsmap").css("display", "none");
        }
			});

      // special case for KSC flags when viewing Kerbin
			$("#kscflags").click(function(){
        $("#map").css("visibility", "hidden");
        $("#kscflags").css("visibility", "hidden");
        $("#mapholder").css("display", "none");
        $("#kscflagsmap").css("display", "block");
			});
		});
	</script>	
</head>
<body style="padding: 0; margin: 0;">

<!-- 
BODIES DATABASE INFORMATION
===========================

These recordsets contain information that allows for the display of orbital trajectory images to let people see what craft are doing around a body.
It is tied indirectly to the menu on the right through the name of the recordsets (no spaces!)
If a body has no vessels in orbit, it does not need a recordset. Nor does an existing recordset *have* to be referenced
Also note that the dynamic flag display depends on the recordset for an individual body being named only for that body - i.e. Duna's recordset 
should not be named "DunaOrbits" or anything like that, just "Duna" so that it can be converted to "DUNA" and be properly referenced by the dynamic
map to show Duna's surface when it loads. Anything else, like an over view of the entire Duna system or Kerbol system, can be named whatever you want

FIELDS
======

UT - the time at which the data in this recordset should be displayed, in seconds since the start of the game
HTML - the image map code that will display the image and links (images 840px wide)
UTC - the text to print out in the time box that lets people know what time/date this orbital data displays
Key - the position of the Key showing what color means what type of craft, in CSS top/bottom, left/right format
UTCPos - same as above, used to keep both text areas clear of obstructing orbital lines as much as possible
Flags - if checked, it allows a dynamic map to be displayed containing flag positions for that body (see Flags db definition below)
-->
<%
'calculate the time in seconds since epoch 0 when the game started
fromDate = "16-Feb-2014 00:00:00"
UT = datediff("s", fromdate, now())

'open database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\db" & request.querystring("db") & ".mdb"
Dim connCraft, sConnection
Set connCraft = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connCraft.Open(sConnection)

'create the table
set rsBody = Server.CreateObject("ADODB.recordset")

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
%>
<!-- 
FLAGS DATABASE INFORMATION
==========================

These recordsets contain information that allows for the display of flags on a dynamic map of the body being displayed.
Recordset names should directly match the name of the planet - so no "KerbinFlags" for flags on Kerbin. Just "Kerbin"

FIELDS
======

UT - the time at which the data in this recordset should be displayed, in seconds since the start of the game
Lat - latitude of the flag's position (can be taken from the flag's VESSEL{} in the SFS file)
Lng - longitude (same as above) - if greater than 180 it should be subtracted by 359 before entered into this field
Alt - altitude, in meters (can also be taken from the flag's VESSEL{} in the SFS file)
Title - the name given to the flag (can also be taken from the flag's VESSEL{} in the SFS file)
Crew - who was involved in the mission that planted the flag (or just the kerbal who planted it - can be taken from the flag's VESSEL{} in the SFS file)
Plaque - the inscription on the flag (can also be taken from the flag's VESSEL{} in the SFS file)
Placed - the real world date the flag was placed on
Link - a link to whatever expanded material you have involving the flag's placement (like a mission report)
Link Text - the text that will be hyperlinked
-->
<%
'do we need to open the flags DB?
if rsBody.fields.item("Flags") then
  'open database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\..\..\database\dbFlags.mdb"
  Dim connFlags, sConnectionFlags
  Set connFlags = Server.CreateObject("ADODB.Connection")
  sConnectionFlags = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  connFlags.Open(sConnectionFlags)

  'create the table and load data up to and including the current UT
  set rsFlags = Server.CreateObject("ADODB.recordset")
  rsFlags.open "select * from " & request.querystring("body") & " where UT <= " & dbUT, connFlags, 1, 1
end if

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
	response.write("<div style='width: 100%; overflow: hidden;'>")
else
	response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if
%>

<!-- area for displaying text with JQuery for debugging purposes -->
<div id="debug" style="position: absolute; top: 8px; left: 0px;"></div>

<!-- area for map display if this body has any flags planted -->
<div id='map' class='map' style='z-index: 50; padding: 0; margin: 0; height: 380px; width: 840px; position: absolute; top: 50px; left: 0px; visibility: hidden;'></div>

<!-- create the page section for body information -->
<div style="position: relative; width: 840px; float: left;">

<!-- header for body information section-->
<center>
<h3><%response.write(replace(request.querystring("body"), "-", " "))%></h3>

<%
'image map data for the system
'image maps created via http://summerstyle.github.io/summer/
'replace functions adds compatibility with Tipped
response.write(replace(replace(rsBody.fields.item("HTML"), "title", "class='tip' data-tipped-options=""target: 'mouse', behavior: 'hide'"" title"), "&#013;", "<br />"))
%>

<!-- 
hack used to allow collapse of orbital image and still display footer text below dynamic map, 
as Leaflet map for some reason didn't agree with the 'display' CSS property
-->
<img src="mapholder.png" style="display: none; z-index: -1;" id="mapholder">

<!-- the Key and Timestamp boxes, displayed according to position data from the database -->
<table id="key" style="border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; <%response.write(rsBody.fields.item("Key"))%> "><tr><td style="font-size: 10px;"><b>Color Key</b><br><span style="color: red;">Debris</span><br><span style="color: #00CC00;">Communications</span><br><span style="color: magenta;">Station</span><br><span style="color: blue;">Probe</span><br><span style="color: #33CCFF;">Ship</span><br><span style="color: brown;">Asteroid</span></td></tr></table>
<table id="utc" style="border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; <%response.write(rsBody.fields.item("UTCPos"))%>"><tr><td style="font-size: 10px;">Positions shown as of <%response.write(rsBody.fields.item("UTC"))%></td></tr></table>

<!-- map close button -->
<table id="close" style="cursor: pointer; z-index: 51; border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 55px; right: 10px; visibility: hidden;"><tr><td style="font-size: 10px;"><span id="caption" title="Close">X</span></td></tr></table>

<%
'special case for KSC flags when viewing Kerbin
'creates link for showing flags as well as image map for flag sites
if rsBody.fields.item("Flags") then
  response.write("<table id='kscflags' style='cursor: pointer; z-index: 51; border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 55px; right: 30px; visibility: hidden;'><tr><td style='font-size: 10px;'><span id='kscflagshow'>Show KSC Flags</span></td></tr></table>")
  response.write("<img style='display: none;' id='kscflagsmap' src='http://i.imgur.com/utKnvF5.png' alt='' usemap='#map' /> <map name='map'> <area shape='circle' coords='631, 192, 9' href='http://forum.kerbalspaceprogram.com/threads/82506-The-Kerbal-Space-Agency-Flight-Log-K-130-Science-Missions-Entry-6?p=1476265&viewfull=1#post1476265' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Mk1.3 Kerboljet III Crash</b><br />Flight Officer Kirk<br />10/7/14<br /><br />&quot;Flight Officer Kirk Kerman made an amazing recovery after the Mk1.3 nosed up early in the takeoff roll and destroyed the tail end, slewing the aircraft off the runway. Still he saved the majority of it from destruction&quot;<br /><br />Click for Flight Log' target='_blank'/> <area shape='circle' coords='560, 135, 10' href='http://forum.kerbalspaceprogram.com/threads/82506-The-Kerbal-Space-Agency-Mission-Dispatch-28-Booster-Overload?p=1365684&viewfull=1#post1365684' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Mk1.3 Kerboljet Crash</b><br />Flight Officer Greggan<br />8/21/14<br /><br />&quot;Piloted by FO Greggan Kerman, the Kerboljet slewed off the runway and met its demise here. FO Greggan successfully ejected&quot;<br /><br />Click for Flight Log' target='_blank'/> <area shape='circle' coords='434, 64, 9' href='http://forum.kerbalspaceprogram.com/threads/71520-Dispatch-from-the-Kerbal-Space-Agency-Kerbal-III-%28M003-Chimps-are-for-Wimps-F1%29' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>First Landing</b><br />Commander Jebediah<br />2/22/14<br /><br />&quot;Here is where Jeb Kerman safely landed, the first kerbal to launch in a rocket and return in one peice&quot;<br /><br />Click for Mission Dispatch' target='_blank'/> <area shape='circle' coords='372, 46, 8' href='http://forum.kerbalspaceprogram.com/threads/71664-Dispatch-from-the-Kerbal-Space-Agency-Kerbal-III-%28M004-Chimps-are-for-Wimps-F2%29' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Second Landing</b><br />Captain Bill<br />2/26/14<br /><br />&quot;Here Bill Kerman became the second kerbal to launch in a rocket and safely return&quot;<br /><br />Click for Mission Dispatch' target='_blank'/> <area shape='circle' coords='412, 244, 9' href='http://forum.kerbalspaceprogram.com/threads/82506-The-Kerbal-Space-Agency-A-real-time-twitter-fiction-driven-by-KSP?p=1219383&viewfull=1#post1219383' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Mk1 Lawn Dart Crash</b><br />Flight Officer Kirk<br />6/13/14<br /><br />&quot;Piloted by Flight Officer Kirk Kerman, the Mk1 Lawn Dart unfortunately lived up to its name&quot;<br /><br />Click for Flight Log' target='_blank'/> <area shape='circle' coords='18, 479, 10' href='http://forum.kerbalspaceprogram.com/threads/82506-The-Kerbal-Space-Agency-A-real-time-twitter-fiction-driven-by-KSP?p=1224364&viewfull=1#post1224364' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Mk1 Lawn Dart Recovery</b><br />Flight Officer Jermal<br />6/19/14<br /><br />&quot;Although the flight tests ultimately failed, the recovery system worked admirably in returning the Lawn Dart to the ground intact&quot;<br /><br />Click for Flight Log' target='_blank'/> <area shape='circle' coords='362, 34, 8' href='http://forum.kerbalspaceprogram.com/threads/82506-The-Kerbal-Space-Agency-Mission-Dispatch-29-Munar-Relay-Network-Completion?p=1434541&viewfull=1#post1434541' class='tip' data-tipped-options=""target: 'mouse', fixed: true, maxWidth: 300, behavior: 'hide'"" title='<b>Mk1.3 Kerboljet II Crash</b><br />Flight Officer Kirk<br />9/23/14<br /><br />&quot;Flight Officer Kirk Kerman&#8217;s attempt to pilot the Kerboljet II ended in failure as the plane flew off the runway but failed to attain lift. Kirk was fortunate to have survived&quot;<br /><br />Click for Flight Log' target='_blank'/></map>")
end if
%>

<!-- Displaying flags when needed -->
<script>
  // don't run this script if we don't have any flags on this body
  var flags = <%response.write(lcase(rsBody.fields.item("Flags")))%>;
  if (flags) 
  {
    // don't show until the mouse is over the map as otherwise it will just come up as undefined
    function showCursorData(e) {
      map.addControl(new L.KSP.Control.Info());
      map.off('mouseover', showCursorData);
    }
    
		// create the map with some custom options
		// details on Leaflet API can be found here - http://leafletjs.com/reference.html
		var map = new L.KSP.Map('map', {
			layers: [L.KSP.CelestialBody.<%response.write ucase(request.querystring("body"))%>],
      center: [0,0],
			bodyControl: false,
			layersControl: false,
			scaleControl: true,
		});
		
		// for some reason this call is needed for the map to display, even though no such call is needed in craft.asp
		map.fitWorld();
		
		// touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
		// leaflet.js was modified to remove the biome, slope and elevation data displays
		if (!is_touch_device()) { map.on('mouseover', showCursorData); }

    // define the flag icon using the default flag icon from the game
    var flag = L.icon({
      iconUrl: 'button_vessel_flag.png',
      iconSize: [16, 16],
    });
    
    // loop through all flag records and place them on the map with their info boxes
		var flagiIcon = "";
		<%
      if rsBody.fields.item("Flags") then 
        do while not rsFlags.eof
          response.write("flagIcon = L.marker([" & rsFlags.fields.item("Lat") & "," & rsFlags.fields.item("Lng") & "], {icon: flag, zIndexOffset: 100}).addTo(map);")
          response.write("flagIcon.bindPopup(""<b>" & rsFlags.fields.item("Title") & "</b><br />" & rsFlags.fields.item("Crew") & "<br />" & rsFlags.fields.item("Placed") & "<br />" & formatnumber((rsFlags.fields.item("Alt")*1)/1000, 3) & "km<br /><br />&quot;" & rsFlags.fields.item("Plaque") & "&quot;<br /><br /><a target='_blank' href='" & rsFlags.fields.item("Link") & "'>" & rsFlags.fields.item("Link Text") & "</a>"", {closeButton: false});")
          rsFlags.movenext
        loop
      end if
		%>		
  }
</script>

<%
'currently, the ability to page between UT is only available for Kerbol, although it could be rolled out to the rest of the systems
if instr(request.querystring("body"), "Kerbol-System") then
	url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
	
	'determine if we need a Prev button
	if rsBody.AbsolutePosition > 1 then
		rsBody.moveprevious
		response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 845px; left: 10px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Back one week' href='" & url & "&ut=" & rsBody.fields.item("UT") + 1 & "'><<</a></td></tr></table>")
		rsBody.movenext
	end if
	
	'determine if we need a Next button
	if rsBody.AbsolutePosition < rsBody.recordcount then
		rsBody.movenext
		if rsBody.fields.item("UT") < UT then
			response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 845px; left: 40px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Forward one week' href='" & url & "&ut=" & rsBody.fields.item("UT") & "'>>></a></td></tr></table>")
		end if
	end if
end if
%>

<!-- footer links for craft information section-->
<span style="font-family:arial;color:black;font-size:12px;">
<p>Hover over dots to view & click to load, or expand the menu on the right</p>
<p>
<a target='_blank' href='http://bit.ly/KSAHomePage'>KSA Historical Archives</a> | <a target='_blank' href='http://bit.ly/-FltTrk'>Flight Tracker Source on Github</a> | Orbits rendered with <a target='_blank' href="http://bit.ly/KSPTOT">KSPTOT</a> | Image mapping via <a target='_blank' href="http://summerstyle.github.io/summer/">Summer Image Map Creator</a>
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
CRAFT DATABASE INFORMATION
==========================

Planets recordset contains all planets in the Kerbol system, each given a name and assigned a unique ID. Can include any additional planets, not just stock
This also contains all details needed for calculating orbital plots

Moons recordset contains all moons in the Kerbol system, each given a name and assigned a unique ID. Their reference field links them to the planet they orbit.
Like planets there can be additional moons besides stock
This also contains all details needed for calculating orbital plots

Crafts recordset contains data on crafts within certain SOIs
See the menu creation code later on for details on the recordset

CRAFT FIELDS
============

ID - a unique number, used only for the database record. Can be anything as long as it's unique
DB - the name of the database containing the craft information, minus the "db" prefix
[Popout] - link to open craft data in a popout, required for older craft. Can also open external site if no craft data is available (for a mission report, for example)
Vessel - the printed name of the vessel to appear in the menu tree
Type - the name of a vessel description that corresponds to a PNG image file on the server, should match all in-game types (Ship, Probe, Debris, etc)
Desc - a short description of the vessel that will appear as pop-up text when the link is hovered over
Collection - the ID for a twitter collection created in Tweetdeck and made into a widget
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
'open craft database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\dbCrafts.mdb"
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
						response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db") & "&filter=inactive'>" & rsCrafts.fields.item("vessel") & "</a></li>")
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
									url = "http://www.blade-edge.com/images/KSA/Flights/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
									if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
									response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
									bPlanet = true
								end if
								
								url = "http://www.blade-edge.com/images/KSA/Flights/body.asp?db=bodies&body=" & rsMoons.fields.item("body")
								if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
								response.write("<li><label for='" & rsMoons.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsMoons.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
								bVessels = true
							end if
							
							'include the craft as a child of the moon
							url = "http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db")
							if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
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
						url = "http://www.blade-edge.com/images/KSA/Flights/body.asp?db=bodies&body=" & rsPlanets.fields.item("body") & "-System"
						if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
						response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'right'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
						bPlanet = true
					end if
					
					'include the craft as a child of the planet
					url = "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db")
					if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
					response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""offset: { x: -10 }, maxWidth: 278, position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
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

'finish off the entire tree list
response.write("</ol>")

'build a URL to use for linking
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")

'decide what message to include beneath the menu tree
response.write("<span style='font-family:arial;color:black;font-size:12px;'>")
if request.querystring("filter") = "inactive" then
	response.write("<b>Filter By:</b> <a href='" & url & "'>Active Vessels</a><br><br><b>NOTE:</b> Some older craft not compatible with the database display will require a popout window. Please allow popups. Some vessels prior to 10/20/14 were not tracked & instead link to their mission dispatches.")
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

<!-- Launch clock - COMING SOON(TM)
<p>
<table style="border: 1px solid #007FDB;	border-collapse: collapse; background-color: #77C6FF;">
  <tr>
    <td>
      <center>
      <b>Current Time @ KSC</b>
      <p style="font-size: 16px"><%response.write(formatdatetime(dateadd("s", UT, fromDate)))%></p>
      </center>
    </td>
  </tr>
</table>
</p>--> 

<!-- this will display the recent tweets from @KSA_MissionCtrl --> 
<p><a class="twitter-timeline" href="https://twitter.com/KSA_MissionCtrl" data-widget-id="598711760149852163">Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>  </p>
</span></div> </div>

<%
'clean up all previous connections
if rsBody.fields.item("Flags") then
  connFlags.Close
  Set connFlags = nothing
end if
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
%>

</body>
</html>