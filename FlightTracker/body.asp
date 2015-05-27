<!-- code/comments not formatted for word wrap -->

<!DOCTYPE html>
<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/6Qc1v08.png" />

	<!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="tipped.css" />

	<!-- JS libraries -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="tipped.js"></script>

	<script>
		// JQuery setup
		$(document).ready(function(){
			// create all the tooltips
			Tipped.create('.tip');
		});
	</script>	
</head>
<body style="padding: 0; margin: 0;">

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

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
	response.write("<div style='width: 100%; overflow: hidden;'>")
else
	response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if
%>

<!-- create the page section for body information -->
<div style="position: relative; width: 840px; float: left;">

<!-- header for body information section-->
<center>
<h3><%response.write(replace(request.querystring("body"), "-", " "))%></h3>

<%
'image map data for the system
'image maps created via https://www.image-maps.com/
'replace functions adds compatibility with Tipped
response.write(replace(replace(rsBody.fields.item("HTML"), "title", "class='tip' data-tipped-options=""target: 'mouse'"" title"), "&#013;", "<br />"))
%>

<!-- the Key and Timestamp boxes, displayed according to position data from the database -->
<table style="border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; <%response.write(rsBody.fields.item("Key"))%> "><tr><td style="font-size: 10px;"><b>Color Key</b><br><span style="color: red;">Debris</span><br><span style="color: #00CC00;">Communications</span><br><span style="color: magenta;">Station</span><br><span style="color: blue;">Probe</span><br><span style="color: #33CCFF;">Ship</span><br><span style="color: brown;">Asteroid</span></td></tr></table>
<table style="border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; <%response.write(rsBody.fields.item("UTCPos"))%>"><tr><td style="font-size: 10px;">Positions shown as of <%response.write(rsBody.fields.item("UTC"))%></td></tr></table>

<%
'currently, the ability to page between UT is only available for Kerbol, although it could be rolled out to the rest of the systems
if request.querystring("body") = "Kerbol-System" then
	url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&body=" & request.querystring("body")
	
	'determin if we need a Prev button
	if rsBody.AbsolutePosition > 1 then
		rsBody.moveprevious
		response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 860px; left: 10px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Back one week' href='" & url & "&ut=" & rsBody.fields.item("UT") + 1 & "'><<</a></td></tr></table>")
		rsBody.movenext
	end if
	
	'determine if we need a Next button
	if rsBody.AbsolutePosition < rsBody.recordcount then
		rsBody.movenext
		if rsBody.fields.item("UT") < UT then
			response.write("<table style='border: 1px solid black;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: 860px; left: 40px;'><tr><td style='font-size: 10px;'><a style='text-decoration: none; color: black;' class='tip' title='Forward one week' href='" & url & "&ut=" & rsBody.fields.item("UT") & "'>>></a></td></tr></table>")
		end if
	end if
end if
%>

<!-- footer links for craft information section-->
<span style="font-family:arial;color:black;font-size:12px;">
<p>Hover over dots to view & click to load, or expand the menu on the right</p>
<p>
<a target='_blank' href='http://bit.ly/KSAHomePage'>KSA Historical Archives</a> | Orbits rendered with <a target='_blank' href="http://forum.kerbalspaceprogram.com/threads/36476-WIN-MAC-KSP-Trajectory-Optimization-Tool-v1-3-0-Update-for-KSP-1-0!">KSPTOT</a>
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
						response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "'target='_blank' href='"& rsCrafts.fields.item("popout") & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
					else
						response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db") & "&filter=inactive'>" & rsCrafts.fields.item("vessel") & "</a></li>")
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
									response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'topleft'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
									bPlanet = true
								end if
								
								url = "http://www.blade-edge.com/images/KSA/Flights/body.asp?db=bodies&body=" & rsMoons.fields.item("body")
								if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
								response.write("<li><label for='" & rsMoons.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'topleft'"" title='Show body overview' href='" & url & "'>" & rsMoons.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
								bVessels = true
							end if
							
							'include the craft as a child of the moon
							url = "http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db")
							if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
							response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & "' href='" & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
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
						response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'><a id='link' class='tip' data-tipped-options=""position: 'topleft'"" title='Show body overview' href='" & url & "'>" & rsPlanets.fields.item("body") & "</a></label> <input type='checkbox' id='' /> <ol>")
						bPlanet = true
					end if
					
					'include the craft as a child of the planet
					url = "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?db=" & rsCrafts.fields.item("db")
					if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
					response.write("<li class='" & rsCrafts.fields.item("type") & "'><a class='tip' data-tipped-options=""position: 'topleft'"" title='" & rsCrafts.fields.item("desc") & url & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
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
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
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

<!-- temporary notice concerning the current status of the KSA -->
<p><table style="border: 1px solid red;	border-collapse: collapse; background-color: #FFB8B8;"><tr><td><center><b>Special Notice</b><p>Please read <a target="_blank" href="http://t.co/iaKV2TGDPe">this statement</a> regarding future and ongoing operations for the Kerbal Space Agency</p></center></td></tr></table></p>

<!-- this will display the recent tweets from @KSA_MissionCtrl --> 
<p><a class="twitter-timeline" href="https://twitter.com/KSA_MissionCtrl" data-widget-id="598711760149852163">Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>  </p>
</span></div> </div>

<%
'clean up all previous connections
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
%>

</body>
</html>