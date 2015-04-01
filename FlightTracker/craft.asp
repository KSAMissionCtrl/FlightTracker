<!-- turn word wrap off in your text editor-->

<!DOCTYPE html>
<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="https://i.imgur.com/g2KVnpN.png" />

</head>
<body>

<!-- VESSEL DATABASE INFORMATION
     ===========================
     
     Craft Data recordset contains various general information about the vessel that is always displayed with every update.
     Craft Resources recordset contains information on vessel resources, types and weight.
     Flight Data recordset contains orbital information for when the craft is in space.
     Crew Manifest recordset contains information on any astronauts currently aboard.
     Craft Comms recordset contains information on any communications equipment aboard.
     Ascent Data recordset contains telemetry information for vessel ascent to orbit after launch. (usage not required)
     
     All recordsets can be updated independently. If you add a record to Craft Data, you do not have to add a corresponding UT record to all the other recordsets
     
     See the various recordset display code sections below for further details.
-->

<%
'open craft database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\db" & request.querystring("db") & ".mdb"
Dim connCraft, sConnection
Set connCraft = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connCraft.Open(sConnection)

'determine if this DB has ascent information, older databases may not contain this table
set adoxConn = CreateObject("ADOX.Catalog")  
adoxConn.activeConnection = connCraft  
bAscentData = false 
for each table in adoxConn.tables 
		if lcase(table.name) = "ascent data" then 
				bAscentData = true 
				exit for 
		end if 
next 

'calculate the time in seconds since epoch 0 when the game started
fromDate = "16-Feb-2014 00:00:00"
UT = datediff("s", fromdate, now())

'what record are we looking to pull from the DB, the one that is prior to the current UT or a specific entry?
if request.querystring("ut") then
  'convert the text string into a number
	dbUT = request.querystring("ut") * 1
	
	'do not allow people to abuse the UT query to peek ahead 
	'a passcode query is required for when requesting a UT entry later than the current UT
	if dbUT > UT then
		if request.querystring("pass") <> "2725" then 
			dbUT = UT
		end if
	end if
else
	dbUT = UT
end if

'get the craft tables
set rsCraft = Server.CreateObject("ADODB.recordset")
set rsOrbit = Server.CreateObject("ADODB.recordset")
set rsCrew = Server.CreateObject("ADODB.recordset")
set rsResources = Server.CreateObject("ADODB.recordset")
set rsComms = Server.CreateObject("ADODB.recordset")
set rsAscent = Server.CreateObject("ADODB.recordset")

rsCraft.open "select * from [craft data]", connCraft, 2
rsResources.open "select * from [craft resources]", connCraft, 2
rsOrbit.open "select * from [flight data]", connCraft, 2
rsCrew.open "select * from [crew manifest]", connCraft, 2
rsComms.open "select * from [craft comms]", connCraft, 2

'trying to open a recordset that does not exist will kill the page
if bAscentData then rsAscent.open "select * from [ascent data]", connCraft, 2

'point to the relevant record for this UT by finding one earlier
if not rsCraft.eof then
	rsCraft.MoveLast
	do until rsCraft.fields.item("id") <= dbUT
		rsCraft.MovePrevious
	Loop
end if

'check to see if this database supports distance traveled field, not found in older databases
bDstTraveled = false
if rsCraft.fields.count > 18 then
	if rsCraft.fields(18).name = "DistanceTraveled" then bDstTraveled = true
end if

'get the next and previous event times/descriptions
'by looking forward and backwards from the current record
nextevent = 0
prevevent = 0
rsCraft.movenext
if not rsCraft.eof then
  'remember "id" is the UT - I should really change that field name
 	nextevent = rsCraft.fields.item("id")
	nexteventdesc = rsCraft.fields.item("CraftDescTitle")
end if
rsCraft.moveprevious

rsCraft.moveprevious
if not rsCraft.bof then 
	prevevent = rsCraft.fields.item("id")
	preveventdesc = rsCraft.fields.item("CraftDescTitle")
end if
rsCraft.movenext

'are we auto-refreshing the page?
if request.QueryString("r") then
	'if there is a future event, go to it on refresh. Otherwise, refresh the page normally
	if nextevent and UT > nextevent then
		Response.AddHeader "Refresh", rsCraft.fields.item("RefreshRate") & ";URL=http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db") & "&r=true" & "&ut=" & nextevent
	else
		Response.AddHeader "Refresh", rsCraft.fields.item("RefreshRate") & ";URL=http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?" & request.querystring()
	end if
end if

'assign the launch date, but - 
'if we are viewing this record as a past event and the launch for this record was scrubbed,
'the launch time for this record is no longer valid for Mission Elapsed Time calculation
'so we need to look ahead for the actual launch time, which was one without a scrub
tzero = true
fromdate = rsCraft.fields.item("LaunchDate")
if UT >= nextevent and rsCraft.fields.item("Scrub") then
	bkmark = 0
	'do not search past the end of the recordset or the current UT
	'we do not need people to know the actual launch time if that event has not occured yet
	tzero = false
	do while rsCraft.fields.item("id") < UT and not rsCraft.eof
		bkmark = bkmark - 1
		rsCraft.movenext
		if not rsCraft.fields.item("Scrub") then 
			fromdate = rsCraft.fields.item("LaunchDate")
			'inform reader that displayed time for this record is not accurate
			msg = "Actual launch time: " & rsCraft.fields.item("LaunchDateUTC") & " UTC&#013;"
			tzero = true
			exit do
		end if
	loop
	'return the cursor to the proper record
	rsCraft.move bkmark
end if
		
'calculate the time since the start of the mission
'this field could be blank if a new entry was created in Craft Data after a scrub with no new launch time
if not isnull(rsCraft.fields.item("LaunchDate")) then MET = datediff("s", fromdate, now())

'is it prior to launch?
if MET <= 0 then
	MET = MET * -1
	msg = "Mission yet to launch&#013;T-"
else
	msg = "Mission ongoing&#013;MET: "
end if

'redo if the mission is over
if not isnull(rsCraft.fields.item("EndTime")) and UT >= rsCraft.fields.item("EndTime") then
	msg = rsCraft.fields.item("EndMsg") & "&#013;MET: "
	MET = datediff("s", rsCraft.fields.item("LaunchDate"), rsCraft.fields.item("EndDate"))
end if

'convert from seconds to yy:ddd:hh:mm:ss
years = 0
days = 0
hours = 0
minutes = 0

if MET >= 86400 then
	days = int(MET / 86400)
	MET = MET - (days * 86400)
end if

if days >= 365 then
	years = int(MET / 365)
	days = days - (years * 86400)
end if

if MET >= 3600 then
	hours = int(MET / 3600)
	MET = MET - (hours * 3600)
end if

if MET >= 60 then
	minutes = int(MET / 60)
	MET = MET - (minutes * 60)
end if

seconds = MET

'we need to compose the pop-up text for a variety of situations
datestamp = "UTC"
if isnull(rsCraft.fields.item("LaunchDate")) or not tzero then
  'launch has been scrubbed but a new launch time has not yet been announced
	launchmsg = "Awaiting new launch time'"
	if isnull(rsCraft.fields.item("LaunchDate")) then	datestamp = ""
else
  'launch is a go!
	launchmsg = msg & years & "y " & days & "d, " & hours & "h:" & minutes & "m:" & seconds & "s'"
end if 

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
	response.write("<div style='width: 100%; overflow: hidden;'>")
else
	response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; '>")
end if
%>

<!-- create the page section for craft information -->
<div style="width: 840px; float: left;">

<!-- header for craft information section-->
<center>
<h3><%response.write rsCraft.fields.item("CraftName")%></h3>

<!-- main table for craft image and data fields -->
<table style="width:100%">
<tr>
	<td>
	<table style="width:100%">
		<tr>

      <!-- CRAFT DATA FIELDS
           =================
           
           ID - the time in seconds from 0 epoch at which this change occurs (UT)
           RefreshRate - how often, in seconds, to refresh the page to possibly display new data
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
           [NextEventTitle] - text that appears over Next image if a future event is scheduled
           ImgDataCode - HTML that shows an image infographic below the craft information in an area of 760x380
           [DistanceTraveled] - the distance (in km) the spacecraft has traveled since launch
      -->
      
      <!-- CSS slide-up caption image box -->
			<td style="width:64%">
				<div id="mainwrapper">
					<div id="box-1" class="box">
						<img id="image-1" <%response.write("src='" & rsCraft.fields.item("CraftImg") & "'")%>/>
							<span class="caption simple-caption">
                <!-- added the ^^ to hopefully make it more obvious to people that more informtion is available -->
								<center><b>^^ Craft Information - <%response.write rsCraft.fields.item("CraftDescTitle")%> ^^</b></center>
								<%response.write rsCraft.fields.item("CraftDescContent")%>
							</span>
					</div>
				</div>
			</td>

      <!-- information box for orbital data, ascent data, resources, crew, etc -->
			<td style="width:36%"  valign="top">
				<table border="1" style="width:100%;">
					<tr><td><b><%response.write rsCraft.fields.item("LaunchDateTerm")%>:</b> <span style="cursor:help" <%response.write("title='" & launchmsg)%>><u><%response.write(rsCraft.fields.item("LaunchDateUTC") & " " & datestamp)%></u></span></td></tr>
					
					<!-- FLIGHT DATA FIELDS
               ==================
               ID - the time in seconds from 0 epoch at which this change occurs (UT)
               [Avg Velocity] - the average velocity (calculated from Ap/Pe velocities) of the craft along current *trajectory* (not necessarily an orbit)
               [VelocityPe] - the speed of the craft at lowest point along current trajectory
               [VelocityAp] - the speed of the craft at highest point along current trajectory
               [Periapsis] - the altitude, in km, of lowest point along current trajectory
               [Apoapsis] - the altitude, in km, of highest point along current trajectory
               [Eccentricity] - eccentricity value of the current trajectory
               [inclination] - inclination value of the current trajectory in degrees
               [Orbital Period] - number of seconds to complete one orbit
          -->
               
					<%
					'check if we have any orbital data to display
					if not rsOrbit.eof then
					
						'point to the relevant record for this UT
						rsOrbit.MoveLast
						do until rsOrbit.fields.item("id") <= dbUT
							rsOrbit.MovePrevious
							if rsOrbit.bof then exit do
						Loop
						
						'only execute further if we found a record earlier than this UT
						'print out all fields, check for any blank records
						if not rsOrbit.bof then
							response.write("<tr><td><b><span style='cursor:help' title='Periapsis: ")
							if isnull(rsOrbit.fields.item("VelocityPe")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("VelocityPe")
								response.write("km/s")
							end if
							response.write("&#013;Apoapsis: ")
							if isnull(rsOrbit.fields.item("VelocityAp")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("VelocityAp")
								response.write("km/s")
							end if
							response.write("'><u>Avg Velocity</u><span>:</b> ")
							if isnull(rsOrbit.fields.item("Avg Velocity")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Avg Velocity")
								response.write("km/s")
							end if
							response.write("</td></tr><tr><td><b>Periapsis:</b> ")
							if isnull(rsOrbit.fields.item("Periapsis")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Periapsis")
								response.write("km")
							end if
							response.write("</td></tr><tr><td><b>Apoapsis:</b> ")
							if isnull(rsOrbit.fields.item("Apoapsis")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Apoapsis")
								response.write("km")
							end if
							response.write("</td></tr><tr><td><b>Eccentricity:</b> ")
							if isnull(rsOrbit.fields.item("Eccentricity")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Eccentricity")
							end if
							response.write("</td></tr><tr><td><b>Inclination:</b> ")
							if isnull(rsOrbit.fields.item("Inclination")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Inclination")
								response.write("°")
							end if
							response.write("</td></tr><tr><td><b>Orbital Period:</b> ")
							if isnull(rsOrbit.fields.item("Orbital Period")) then
								response.write("N/A")
							else
								response.write rsOrbit.fields.item("Orbital Period")
								response.write("s")
							end if
							response.write("</td></tr>")
						end if
					end if
					%>
					
					<!-- ASCENT DATA FIELDS
               ==================
               
               ID - the time in seconds from 0 epoch at which this change occurs (UT)
               Velocity - the current *orbital* velocity of the craft, in km/s
               TWR - the current acceleration of the craft
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
							if not rsAscent.bof and rsOrbit.bof then
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
								end if
								if not isnull(rsAscent.fields.item("Q")) then
									response.write("</td></tr><tr><td><b>Atmo Press (Q):</b> ")
									response.write rsAscent.fields.item("Q")
									response.write("Pa")
								end if

								response.write("</td></tr><tr><td><b>Inclination:</b> ")
								response.write rsAscent.fields.item("Inclination")
								response.write("°")

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
					
					<!-- CREW MANIFEST FIELDS
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
							if bAscentData then
								if rsCrew.fields.item("Hide") then bShow = false
							end if
						end if
						
						if bShow then
							response.write("<tr><td><b>Crew:</b> ")

							'if we have an ascent table, adjust column start position
							'because older databases will not have the "Hide" field
							col = 1
							if bAscentData then col = 2
							
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
								
								response.write("<a " & closemsg & " target='_blank' href='")
								response.write rsCrew.fields.item(x+1)
								response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/favicon.ico' title='")
								response.write rsCrew.fields.item(x)
								response.write("'></a> ")
							next
							response.write("</td></tr>")
						else
              'handles a special case scenario
							if bShow then response.write("<tr><td><b>Crew:</b> None</td></tr>")
						end if
					end if
					%>
					
					<!-- CRAFT RESOURCES FIELDS
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
							if bAscentData then
								if rsResources.fields.item("Hide") then bShow = false
							end if
						end if
						
						if bShow then
							response.write("<tr><td><b><span style='cursor:help' title='Total &Delta;v: ")
							response.write rsResources.fields.item("DeltaV")
							response.write("km/s&#013;Total mass: ")
							response.write rsResources.fields.item("TotalMass")
							response.write("t&#013;Resource mass: ")
							response.write rsResources.fields.item("ResourceMass")
							response.write("t'><u>Resources</u><span>:</b> ")
							
							'if we have an ascent table, adjust column start position
							'because older databases will not have the "Hide" field
							col = 4
							if bAscentData then col = 5

							'iterate through resource data, two fields for each resource, until we hit an empty field
							'if that empty field is right at the start, no resources are aboard
							for x = col to rsResources.fields.count - 1 step 2
								if isnull(rsResources.fields.item(x)) then 
									if x = col then response.write "None"
									exit for
								end if
								response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/")
								response.write rsResources.fields.item(x)
								response.write(".png' title='")
								response.write rsResources.fields.item(x+1)
								response.write("'></span> ")
							next
							response.write("</td></tr>")
						end if
					end if
					%>
					
					<!-- CRAFT COMMS FIELDS
               ==================
               
               ID - the time in seconds from 0 epoch at which this change occurs (UT)
               Hide - should be used to remove this data from display to allow room for ascent data
               [SignalDelay] - if using RemoteTech, signal delay is reported in seconds
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
							if bAscentData then
								if rsComms.fields.item("Hide") then bShow = false
							end if
						end if

						if bShow then
							response.write("<tr><td><b><span style='cursor:help' title='Signal delay (max): ")

              'can leave signal delay field empty if RT not installed
              'or when connected direct to mission control prior to launch or when no connection is present
							if isnull(rsComms.fields.item("SignalDelay")) then
								response.write "N/A"
							else
								response.write rsComms.fields.item("SignalDelay") & "s"
							end if
							response.write("'><u>Comms</u><span>:</b> ")

							'if we have an ascent table, adjust column start position
							'because older databases will not have the "Hide" field
							col = 2
							if bAscentData then col = 3
							
							'iterate through comms data, two fields for each comm unit, until we hit an empty field
							'if that empty field is right at the start, no comms are aboard
							for x = col to rsComms.fields.count - 1 step 2
								if isnull(rsComms.fields.item(x)) then 
									if x = col then response.write "None"
									exit for
								end if 
								response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/")
								response.write rsComms.fields.item(x)
								response.write(".png' title='")
								response.write rsComms.fields.item(x+1)
								response.write("'></span> ")
							next
							response.write("</td></tr>")
						end if
					end if
					%>
					
					<tr><td><b>Last Update:</b>
					
					<%
					if bDstTraveled then
            'field can be left empty, such as prior to launch
						if not isnull(rsCraft.fields.item("DistanceTraveled")) then
							response.write("<span style='cursor:help' title='Distance Traveled: ")
							response.write rsCraft.fields.item("DistanceTraveled")
							response.write("km'><u>")
							response.write(rsCraft.fields.item("LastUpdate") & " UTC")
							response.write("</u></span>")
						else
							response.write(rsCraft.fields.item("LastUpdate") & " UTC")
						end if
					else
						response.write(rsCraft.fields.item("LastUpdate") & " UTC")
					end if
					%>
					
					</td></tr>
					<tr><td><center>
					
					<%
					'there a previous event?
					if prevevent then
						'reload the page on click and force an earlier UT
						response.write("<a href='http://")
						response.write(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"))
						response.write("?db=" & request.querystring("db") & "&ut=" & prevevent)
						if request.querystring("pass") = "2725" then response.write("&pass=2725")
						response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/prev.png' title='")
						response.write preveventdesc
						response.write("'></a> ")
					else
						response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/prev.png' title='No previous events'></span> ")
					end if
					
					'whether we need to close the window when going to an external link
					close = " "
					if request.querystring("r") = "" then close = " onclick='window.close()' "
					
					'what is the current status of the mission?
					'not really a fan of current implementation - requires these fields set for every record
					if not isnull(rsCraft.fields.item("MissionReport")) then
						response.write("<b><a" & close & "target='_blank' href='")
						response.write rsCraft.fields.item("MissionReport")
						response.write("' title='")
						response.write rsCraft.fields.item("MissionReportTitle")
						response.write("'>Mission Report</a></b> ")
					elseif UT >= rsCraft.fields.item("EndTime") then
						response.write("<b><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl' title='Mission report coming soon&#013;Updates on twitter'>Mission Concluded</a></b> ")
					else
						response.write("<b><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl' title='Updates on twitter'>Mission Ongoing</a></b> ")
					end if
					
					'is there a future event?
					if nextevent then
            'if we have passed that event time we can let people go to it
						if UT >= nextevent then
							response.write("<a href='http://")
							response.write(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"))
							response.write("?db=" & request.querystring("db") & "&ut=" & nextevent)
							response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' title='")
							response.write nexteventdesc
							response.write("'></a> ")
						'otherwise do not link to next event
						else
							response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' title='")
							if not isnull(rsCraft.fields.item("NextEventTitle")) then
								response.write rsCraft.fields.item("NextEventTitle")
							else
								response.write "No future events"
							end if
							response.write("'></span>")
						end if
					else
						response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' title='No future events'></span>")
					end if
					%>
					</center></td></tr>
				</table>
			</td>
		</tr>
	</table>
	</td>
	
<!-- visualization field for orbits, locations, paths, etc -->
</tr>
	<%response.write rsCraft.fields.item("ImgDataCode")%>
</table>

<!-- footer links for craft information section-->
<%
'build the basic URL then add any included server variables as needed
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")

if request.querystring("r") then
	refreshmsg = "Disable auto-refresh (" & rsCraft.fields.item("RefreshRate") & "s)"
else
	refreshmsg = "Enable auto-refresh (" & rsCraft.fields.item("RefreshRate") & "s)"
	url = url & "&r=true"
end if

if request.querystring("popout") then
	closemsg = "onclick='window.close()'"
else 
	closemsg = ""
end if

response.write("<a " & closemsg & " target='_blank' href='http://bit.ly/KSAHomePage'>KSA Historical Archives</a>")
response.write(" | ")

'creates a pop-out window the user can move around
response.write("<a href='" & url & "'>" & refreshmsg & "</a>")
if not request.querystring("popout") then
	url = "http://www.blade-edge.com/images/KSA/Flights/redirect.asp?popout=true&db=" & request.querystring("db")
	if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
	if request.querystring("r") then url = url & "&r=true"
	response.write(" | ")
	response.write("<a href='" & url & "'>Open in Popout Window</a>")
end if
%>
</center>
</div>

<!-- active craft menu section -->
<div style="margin-left: 845px; font: 12pt normal Arial, sans-serif;"> 

<!-- active craft menu header -->
<center><h3>All Active Vessels</h3></center>

<!-- menu tree -->
<!-- yes, this method is very brute-force and not overly efficient but load times don't seem visibly affected to bother optimizing -->

<!-- MENU DATABASE INFORMATION
     =========================
     
     Planets recordset contains all planets in the Kerbol system, each given a name and assigned a unique ID. Can include any additional planets, not just stock
     
     Moons recordset contains all moons in the Kerbol system, each given a name and assigned a unique ID. Their reference field links them to the planet they orbit.
     Like planets there can be additional moons besides stock

     Crafts recordset contains data on crafts within certain SOIs
     
     CRAFT FIELDS
     ============
     
     ID - a unique number, used only for the database record. Can be anything as long as it's unique
     DB - the name of the database containing the craft information, minus the "db" prefix
     Vessel - the printed name of the vessel to appear in the menu tree
     Type - the name of a vessel description that corresponds to a PNG image file on the server, should match all in-game types (Ship, Probe, Debris, etc)
     Desc - a short description of the vessel that will appear as pop-up text when the link is hovered over
     UT# - the time in seconds from 0 epoch (UT) at which the vessel is within this SOI
     Ref# - the unique planet or moon ID that identifies the SOI the vessel is within
     
     Adding additional UT/Ref field pairs will cause the vessel to move from one SOI to another as the UT for that transition is passed
     
     UT/Ref fields can be extended as much as needed, maintaining the paired values. They do not need to be named UT2/Ref2, UT3/ref3 etc. 
     They do not need to contain a value, so long as any empty fields are at the end of a continuous run of field pairs
-->
<%
'open craft database
db = "..\..\..\..\database\dbCrafts.mdb"
Dim connBodies
Set connBodies = Server.CreateObject("ADODB.Connection")
sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
connBodies.Open(sConnection2)

'get the tables
set rsPlanets = Server.CreateObject("ADODB.recordset")
set rsMoons = Server.CreateObject("ADODB.recordset")
set rsCrafts = Server.CreateObject("ADODB.recordset")

rsPlanets.open "select * from planets", connBodies, 2
rsMoons.open "select * from moons", connBodies, 2
rsCrafts.open "select * from crafts", connBodies, 2

'start the tree
response.write("<ol class='tree'>")

'loop through all the planets
do while not rsPlanets.eof
	bPlanet = False
	
	'check for any moons of this planet
	do while not rsMoons.eof
		if rsMoons.fields.item("ref") = rsPlanets.fields.item("id") then
			
			'check for vessels in moon SOI
			'corresponding to this UT
			bVessels = false
			do while not rsCrafts.eof
				ref = -1
				
				'field 5 is the start of SOI information, which uses two fields
				for x = 5 to rsCrafts.fields.count - 1 step 2

          'first field is the UT, second field is the body reference #
					if rsCrafts.fields.item(x) <= UT then 
						ref = rsCrafts.fields.item(x+1)
					else
						exit for
					end if
				next

        'check if the craft that matches this UT is within the SOI of this moon
				if ref = rsMoons.fields.item("id") then
					if not bVessels then
						if not bPlanet then
              'include the planet in the tree if this has not yet been done
							response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'>" & rsPlanets.fields.item("body") & "</label> <input type='checkbox' id='" & rsPlanets.fields.item("body") & "' /> <ol>")
							bPlanet = true
						end if
						
						'include the moon as a child of the planet if this is the first vessel found within its SOI
						response.write("<li><label for='" & rsMoons.fields.item("body") & "'>" & rsMoons.fields.item("body") & "</label> <input type='checkbox' id='" & rsMoons.fields.item("body") & "' /> <ol>")
					end if
					bVessels = true
					
					'include the craft as a child of the moon
					response.write("<li class='" & rsCrafts.fields.item("type") & "'><a title='" & rsCrafts.fields.item("desc") & "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?r=true&db=" & rsCrafts.fields.item("db") & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
				end if
				rsCrafts.movenext
			loop
			
			'reset the craft record pointer for the next moon
			rsCrafts.movefirst
			
			'if we found vessels around moons, there is a tree we need to close off
			if bVessels then response.write("</ol> </li>")
		end if
		rsMoons.movenext
	loop
	rsMoons.movefirst
	
	'check for vessels in planet SOI
	'corresponding to this UT
	do while not rsCrafts.eof
		ref = -1

		'field 5 is the start of SOI information, which uses two fields
		for x = 5 to rsCrafts.fields.count - 1 step 2

      'first field is the UT, second field is the body reference #
			if rsCrafts.fields.item(x) <= UT then 
				ref = rsCrafts.fields.item(x+1)
			else
				exit for
			end if
		next
		
    'check if the craft that matches this UT is within the SOI of this planet
		if ref = rsPlanets.fields.item("id") then
			if not bPlanet then
        'include the planet in the tree if this has not yet been done
				response.write("<li> <label for='" & rsPlanets.fields.item("body") & "'>" & rsPlanets.fields.item("body") & "</label> <input type='checkbox' id='" & rsPlanets.fields.item("body") & "' /> <ol>")
				bPlanet = true
			end if
			
			'include the craft as a child of the planet
			response.write("<li class='" & rsCrafts.fields.item("type") & "'><a title='" & rsCrafts.fields.item("desc") & "' href='http://www.blade-edge.com/images/KSA/Flights/craft.asp?r=true&db=" & rsCrafts.fields.item("db") & "'>" & rsCrafts.fields.item("vessel") & "</a></li>")
		end if
		rsCrafts.movenext
	loop
	rsCrafts.movefirst

  'if we found vessels around planets, there is a tree we need to close off
	if bPlanet then response.write("</ol>	</li>")

	rsPlanets.movenext
loop
response.write("</ol> *Inactive vessels can be found via the Historical Archives link at bottom</div> </div>")

'clean up all previous connections
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
set adoxConn = nothing  
%>

</body>
</html>