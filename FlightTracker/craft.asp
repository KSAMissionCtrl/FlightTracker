<!DOCTYPE html>

<!-- code/comments not formatted for word wrap -->

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Flight Tracker</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/2IH1UpQ.png" />
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

  <!-- ensure proper scale of page -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto:900" />
  <link rel="stylesheet" type="text/css" href="http://static.kerbalmaps.com/leaflet.css" />
  <link rel="stylesheet" type="text/css" href="leaflet.label.css" />
  <link rel="stylesheet" type="text/css" href="tipped.css" />

  <!-- JS libraries -->
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script type="text/javascript" src="leaflet.js"></script>
  <script type="text/javascript" src="leafletembed.js"></script>
  <script type="text/javascript" src="sylvester.js"></script>
  <script type="text/javascript" src="sylvester.src.js"></script>
  <script type="text/javascript" src="leaflet.label.js"></script>
  <script type="text/javascript" src="numeral.min.js"></script>
  <script type="text/javascript" src="tipped.js"></script>
  
  <script>
    // determine whether this is a touchscreen device for proper tooltip handling
    // http://ctrlq.org/code/19616-detect-touch-screen-javascript
    function is_touch_device() {
     return (('ontouchstart' in window)
          || (navigator.MaxTouchPoints > 0)
          || (navigator.msMaxTouchPoints > 0));
    }
    
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
      var str= short_months[d.getUTCMonth()]+' '+d.getUTCDate()+', ';
      return h+':'+m+':' +s+ ' '+pm.toUpperCase() + ' ' + "(UTC -" + label + ")";
    }

    // take an amount of time in seconds and convert it to years, days, hours, minutes and seconds
    // leave out any values that are not necessary (0y, 0d won't show, for example)
    function formatTime(time) {
      var years = 0;
      var days = 0;
      var hours = 0;
      var minutes = 0;
      var seconds = "";
      var ydhms = "";

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
      
      if (Math.floor(time) < 10) {
        seconds = "0" + Math.floor(time);
      }
      else seconds = Math.floor(time);

      return ydhms += seconds + "s";
    }

    // JQuery setup
    $(document).ready(function(){
      // shows the map again after it is hidden to show static orbits
      $("#img").click(function(){
        if (bDrawMap) { $("#map").css("visibility", "visible"); }
      });
      
      // does away with the notification for orbital plot length
      $("#msgObtPd").click(function(){
        $("#msgObtPd").css("visibility", "hidden");
      });
      
      // does away with the notification for future maneuver node
      $("#msgNode").click(function(){
        $("#msgNode").css("visibility", "hidden");
      });
      
      // does away with the information box presented to redditor visitors
      $("#close").click(function(){
        $("#intro").css("visibility", "hidden");
      });
      
      // pops up the maneuver node information
      $("#next").click(function(){
        nodeMark.openPopup();
      });
      
      // behavior of the tooltip depends on the device
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
    
    // for retrieving URL query strings
    // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }		
  </script>	
</head>
<body style="padding: 0; margin: 0;">

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
Flighplan recordset contains maneuver node data that can be displayed on the dynamic map if it occurs within 100,000s of the current time (usage not required)

All recordsets can be updated independently. If you add a record to Craft Data, you do not have to add a corresponding UT record to all the other recordsets

See the various recordset display code sections below for further details.
-->

<%
'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\db" & request.querystring("db") & ".mdb"
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
bFlightplan = false 
for each table in adoxConn.tables 
  if lcase(table.name) = "ascent data" then 
    bAscentData = true 
  elseif lcase(table.name) = "flightplan" then 
    bFlightplan = true 
  end if 
next

'trying to open a recordset that does not exist will kill the page
if bAscentData then rsAscent.open "select * from [ascent data]", connCraft, 2
if bFlightplan then rsFlightplan.open "select * from flightplan", connCraft, 2

'calculate the time in seconds since epoch 0 when the game started
fromDate = "16-Feb-2014 00:00:00"
UT = datediff("s", fromdate, now())

'used to debug orbital plotting by adjusting the current UT
if request.querystring("deltaut") then
  UT = UT + request.querystring("deltaut")
end if

'what record are we looking to pull from the DB, the one that is most recent to the current UT or a specific entry?
if request.querystring("ut") then
  'convert the text string into a number
  dbUT = request.querystring("ut") * 1
  
  'make note so we do not auto-update the page
  response.write("<script>")
  response.write("var bPastUT = true;")
  response.write("</script>")
  
  'do not allow people to abuse the UT query to peek ahead 
  'a passcode query is required when requesting a UT entry later than the current UT
  if dbUT > UT then
    if request.querystring("pass") <> "2725" then 
      'passcode incorrect or not supplied. Revert back to current UT
      dbUT = UT
    end if
  end if
else
  dbUT = UT
  response.write("<script>")
  response.write("var bPastUT = false;")
  response.write("</script>")
end if
'regardless of previous outcomes, moving forward all recordset quieries should be made via dbUT

'starting from the end, work back to find the first record earlier than or equal to the UT we are looking for
if not rsCraft.eof then
  rsCraft.MoveLast
  do until rsCraft.fields.item("id") <= dbUT
    rsCraft.MovePrevious
  Loop
end if

'check to see if this database supports fields not found in older databases
'godammit I forgot all about On Error from my vb days - although that was 20 years ago
'http://stackoverflow.com/questions/16474210/detect-if-a-names-field-exists-in-a-record-set
bDstTraveled = true
bNodeLink = true

on error resume next
test = rsCraft.fields("DistanceTraveled").name
If Err <> 0 Then bDstTraveled = false
Err.Clear

on error resume next
test = rsCraft.fields("NodeLink").name
If Err <> 0 Then bNodeLink = false
Err.Clear

'get the next and previous event times/descriptions
'by looking forward and backwards from the current record
nextevent = 0
prevevent = 0
rsCraft.movenext
if not rsCraft.eof then
  'remember "id" is the UT
  nextevent = rsCraft.fields.item("id")
  nexteventdesc = rsCraft.fields.item("CraftDescTitle")
  
  'save to js so page will auto-update when next event arrives
  response.write("<script>")
  response.write("var bNextEventRefresh = true;")
  response.write("var nextEventUT = " & rsCraft.fields.item("id") & ";")
  response.write("</script>")
else
  response.write("<script>var bNextEventRefresh = false;</script>")
end if
rsCraft.moveprevious
'done looking ahead, now look behind then reset pointer again to current record
rsCraft.moveprevious
if not rsCraft.bof then 
  prevevent = rsCraft.fields.item("id")
  preveventdesc = rsCraft.fields.item("CraftDescTitle")
end if
rsCraft.movenext

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
      'inform user that displayed time for this record is not accurate
      msg = "Actual launch time: " & rsCraft.fields.item("LaunchDateUTC") & " UTC<br />"
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
  msg = "Mission yet to launch<br />T-"
else
  MET = origMET
  msg = "Mission ongoing<br />MET: "
end if

'redo the message entirely if the mission is over
if not isnull(rsCraft.fields.item("EndTime")) and UT >= rsCraft.fields.item("EndTime") then
  msg = rsCraft.fields.item("EndMsg") & "<br />MET: "
  MET = datediff("s", rsCraft.fields.item("LaunchDate"), rsCraft.fields.item("EndDate"))
end if

'convert from seconds to yy:ddd:hh:mm:ss
years = 0
days = 0
hours = 0
minutes = 0
ydhms = ""

if MET >= 86400 then
  days = int(MET / 86400)
  MET = MET - (days * 86400)
  ydhms = days & "d, "
end if

if days >= 365 then
  years = int(days / 365)
  days = days - (years * 365)
  ydhms = years & "y " & days & "d, "
end if

if MET >= 3600 then
  hours = int(MET / 3600)
  MET = MET - (hours * 3600)
  ydhms = ydhms & hours & "h "
end if

if MET >= 60 then
  minutes = int(MET / 60)
  MET = MET - (minutes * 60)
  ydhms = ydhms & minutes & "m "
end if

if MET > 0 then
  seconds = MET
  ydhms = ydhms & round(seconds,2) & "s"
end if

'we need to compose the pop-up text for a variety of situations
datestamp = "UTC"
if isnull(rsCraft.fields.item("LaunchDate")) or not tzero then
  'launch has been scrubbed but a new launch time has not yet been announced
  launchmsg = "To Be Determined"
  if isnull(rsCraft.fields.item("LaunchDate")) then	datestamp = ""
else
  'launch is a go!
  launchmsg = msg & ydhms
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

UT - the time in seconds from 0 epoch at which this maneuver node occurs
Prograde - m/s movement along the prograde vector
Normal - m/s movement along the normal vector
Radial - m/s movement along the radial vector
Total - total amount of Δv required for maneuver
-->

<%
'determine if we have an upcoming maneuver node and save that data to js
if bFlightplan then 
  do until rsFlightplan.eof
    if rsFlightplan.fields.item("ut") > dbUT then exit do
    rsFlightplan.MoveNext
  Loop
  
  if not rsFlightplan.eof then
    response.write("<script>")
    response.write("var bUpcomingNode = true;")
    response.write("var nodeUT = " & rsFlightplan.fields.item("ut") & ";")
    response.write("var nodePrograde = " & rsFlightplan.fields.item("prograde") & ";")
    response.write("var nodeNormal = " & rsFlightplan.fields.item("normal") & ";")
    response.write("var nodeRadial = " & rsFlightplan.fields.item("radial") & ";")
    response.write("var nodeTotal = " & rsFlightplan.fields.item("total") & ";")
    response.write("</script>")
  else
    response.write("<script>")
    response.write("var bUpcomingNode = false;")
    response.write("</script>")
  end if
else
  response.write("<script>")
  response.write("var bUpcomingNode = false;")
  response.write("</script>")
end if
  
'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
  response.write("<div style='width: 100%; overflow: hidden;'>")
else
  response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if
%>

<!-- area for displaying text with JQuery for debugging purposes -->
<div id="debug" style="position: absolute; top: 38px; left: 0px;"></div>

<!-- create the page section for craft information -->
<div style="width: 840px; float: left;">

<!-- header for craft information section-->
<center>
<h3><%response.write rsCraft.fields.item("CraftName")%></h3>

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
      [RefreshRate] - Deprecated, js refresh-detection used instead
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
      [ImgDataCode] - HTML that shows an image infographic below the craft information in an area of 760x380. Special formatting is also recognized
      [DistanceTraveled] - the total (not change in) distance (in km) the spacecraft has traveled since launch
      [NodeLink] - the UT of a future maneuver node (in Flightplan recordset!) that this description talks about, so the user can find it easier on the map if it is visible
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

          <!-- start time -->
          <tr>
            <td>
              <b><%response.write rsCraft.fields.item("LaunchDateTerm")%>:</b> 
              <!-- this tooltip can be dynamically updated -->
              <div id="met" style="display: none"><%response.write(launchmsg)%></div>
              <span style="cursor:help" class="tip-update" data-tipped-options="inline: 'met'">
                <u><%response.write(rsCraft.fields.item("LaunchDateUTC") & " " & datestamp)%></u>
              </span>
            </td>
          </tr>
          
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
          if not rsOrbit.eof then
          
            'point to the relevant record for this UT
            rsOrbit.MoveLast
            do until rsOrbit.fields.item("id") <= dbUT
              rsOrbit.MovePrevious
              if rsOrbit.bof then exit do
            Loop
            
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
              response.write("<br />Apoapsis: ")
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
                response.write("<u><span style='cursor:help' class='tip' title='Lack of orbital period means craft is on a hyperbolic/SOI-crossing trajectory<br />Ap/Pe refer to the lowest and highest points of the current trajectory'>N/A</span></u>")
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
                
                response.write("<span class='tip' title='")
                response.write rsCrew.fields.item(x)
                response.write("'><a " & closemsg & " target='_blank' href='")
                response.write rsCrew.fields.item(x+1)
                response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/favicon.ico'></a></span> ")
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
              if bAscentData then
                if rsResources.fields.item("Hide") then bShow = false
              end if
            end if
            
            if bShow then
              response.write("<tr><td><b><span style='cursor:help' class='tip' title='Total &Delta;v: ")
              response.write rsResources.fields.item("DeltaV")
              response.write("km/s<br />Total mass: ")
              response.write rsResources.fields.item("TotalMass")
              response.write("t<br />Resource mass: ")
              response.write formatnumber(rsResources.fields.item("ResourceMass")*1, 3)
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
                response.write("<span style='cursor:help' class='tip' title='")
                'prior to using Tipped.js for tooltips a newline character was used for line breaks. This needs to be replaced
                str = replace(rsResources.fields.item(x+1), "&#013;", "<br />")
                response.write str
                response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/")
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
              if bAscentData then
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
                response.write("<span style='cursor:help' class='tip' title='")
                'prior to using Tipped.js for tooltips a newline character was used for line breaks. This needs to be replaced
                str = replace(rsComms.fields.item(x+1), "&#013;", "<br />")
                response.write str
                response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/")
                response.write rsComms.fields.item(x)
                response.write(".png'></span> ")
              next
              response.write("</td></tr>")
            end if
          end if
          %>
          
          <tr><td><b>Last Update:</b>
          
          <%
          'we need dummy values to assign to JS later regardless of whether they are needed or not
          dstTraveled = 0
          bEstDst = false
          if bDstTraveled then
            'field can be left empty, such as prior to or during launch
            if not isnull(rsCraft.fields.item("DistanceTraveled")) then
              strAccDst = "Total Distance Traveled as of Last Update: " & formatnumber(rsCraft.fields.item("DistanceTraveled")*1, 0) & "km"
                            
              'only estimate distance if we are the last record or the current record for the current time
              rsCrafts.find("db='" & request.querystring("db") & "'")
              'rover check is for until I decide how to handle updating rover travel distances
              if rsCrafts.fields.item("Type") <> "rover" then
                rsCraft.movenext
                if rsCraft.eof then
                  bEstDst = true
                else
                  if rsCraft.fields.item("id") > UT then
                    bEstDst = true
                  end if
                end if
                rsCraft.moveprevious
              end if
              
              'string starts empty. If we have nothing more to add, nothing more will show in tooltip
              strEstDst = ""
              if bEstDst then
                if not isnull(rsOrbit.fields.item("Avg Velocity")) then
                  strEstDst = "<br />Estimated Current Total Distance Traveled: "
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
          %>
          
          </td></tr>
          <tr><td><center>
          
          <%
          'there a previous event?
          if prevevent then
            'reload the page on click and force an earlier UT
            response.write("<span class='tip' title='")
            response.write preveventdesc
            response.write("'><a href='http://")
            response.write(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"))
            response.write("?db=" & request.querystring("db") & "&ut=" & prevevent)
            if len(request.querystring("filter")) then response.write("&filter=" & request.querystring("filter"))
            if len(request.querystring("pass")) then response.write("&pass=" & request.querystring("pass"))
            response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/prev.png'></a></span> ")
          else
            response.write("<span style='cursor:help' class='tip' title='No previous events'><img src='http://www.blade-edge.com/images/KSA/Flights/prev.png'></span> ")
          end if
          
          'whether we need to close the window when going to an external link
          'if user chose to enable refresh, we will keep it open, assuming they are keeping tabs on it for some reason
          close = " "
          if request.querystring("r") = "" then close = " onclick='window.close()' "
          
          'what is the current status of the mission?
          'not really a fan of current implementation - requires these fields set for every record
          if not isnull(rsCraft.fields.item("MissionReport")) then
            response.write("<span class='tip' title='")
            response.write rsCraft.fields.item("MissionReportTitle")
            response.write("'><b><a" & close & "target='_blank' href='")
            response.write rsCraft.fields.item("MissionReport")
            response.write("'>Mission Report</a></b></span> ")
          elseif UT >= rsCraft.fields.item("EndTime") then
            response.write("<b><span class='tip' title='Mission report coming soon<br />Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Concluded</a></span></b> ")
          else
            response.write("<b><span class='tip' title='Updates on twitter'><a" & close & "target='_blank' href='https://twitter.com/KSA_MissionCtrl'>Mission Ongoing</a></span></b> ")
          end if
          
          'is there a future event we can click to?
          if nextevent and UT >= nextevent then
            response.write("<span class='tip' title='")
            response.write nexteventdesc
            response.write("'><a href='http://")
            response.write(Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL"))
            response.write("?db=" & request.querystring("db") & "&ut=" & nextevent)
            if len(request.querystring("filter")) then response.write("&filter=" & request.querystring("filter"))
            response.write("'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png'></a></span> ")
            
          'no future event record we can go to but maybe a description of a future event
          else
            if not isnull(rsCraft.fields.item("NextEventTitle")) then

              'is there a maneuver node link field and an upcoming node?
              if bNodeLink then 
                
                'thanks to lack of short-circuit logic we cannot put this test in the above if statement
                if not rsFlightplan.eof then
                
                  'check if this event description is tied to the node
                  if rsCraft.fields.item("NodeLink") = rsFlightplan.fields.item("UT") then
                  
                    'finally, check that the node is visible on the dynamic map
                    'if it is, let user know and enable click event, otherwise regular title string
                    if (rsFlightplan.fields.item("UT") - UT) <= 100000 then
                      response.write("<span id='next' style='cursor:pointer'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' class='tip' title='")
                      response.write rsCraft.fields.item("NextEventTitle")
                      response.write("<br />Click to view Maneuver Node")
                      response.write("'></span>")
                    else
                      response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' class='tip' title='")
                      response.write rsCraft.fields.item("NextEventTitle")
                      response.write("'></span>")
                    end if
                  end if
                end if
              else
                response.write("<span style='cursor:help'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png' class='tip' title='")
                response.write rsCraft.fields.item("NextEventTitle")
                response.write("'></span>")
              end if
            else
              response.write("<span style='cursor:help' class='tip' title='No future events'><img src='http://www.blade-edge.com/images/KSA/Flights/next.png'></span>")
            end if
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
  <%
  str = rsCraft.fields.item("ImgDataCode")
  'if there is no code then this is an ascent state
  if isnull(str) then
    MapState = "ascent"
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px;'></div> </td> </tr>")
    bMapOrbit = false
  'if there is a @ symbol this is a pre-launch state
  'same result as the previous state but we can not test for a null field and a non-null field at the same time. No short-circuit logic
  'TODO - interactive map for pre-launch with a marker for launch location
  elseif left(str,1) = "@" then
    response.write("<tr> <td> <div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px;'></div> </td> </tr>")
    
  'if there is a ! symbol this is an orbital state
  elseif left(str,1) = "!" then
    MapState = "orbit"
    
    'do not create the real-time map if current orbital data is out of date
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
    
    'as with the last code block, we assume no dynamic map and adjust message as required
    mapMsg = "<br />Dynamic view not available - old orbital data loaded"
    if bMapOrbit then
      mapMsg = "<br />Click for dynamic view"
      
      'creat the map area, also create message boxes but hide them until needed
      response.write("<div id='map' class='map' style='padding: 0; margin: 0; height: 380px; width: 835px; position: absolute; top: 451px; left: 0px; visibility: hidden;'></div>")
      response.write("<div id='msgObtPd' style='cursor: pointer; font-family: sans-serif; border-style: solid; border-width: 2px; height: 133px; width: 415px; padding: 0; margin: 0; position: absolute; top: 561px; left: 210px; visibility: hidden; background-color: gray;'><b>NOTICE</b><p>This craft's orbital period exceeds 100,000 seconds. For performance reasons, its full orbit was not rendered. Ap/Pe markings may be missing as a result.</p><p>Click to dismiss</p></div>")
      response.write("<div id='msgNode' style='cursor: pointer; font-family: sans-serif; border-style: solid; border-width: 2px; height: 113px; width: 250px; padding: 0; margin: 0; position: absolute; top: 571px; left: 292px; visibility: hidden; background-color: gray;'><b>NOTICE</b><p>Future maneuver node is not yet visible along this orbital plot.</p><p>Click to dismiss</p></div>")
      
      'special notice box to be used when directing anyone here who possibly is unfamiliar with the concept of @KSA_MissionCtrl
      if request.querystring("intro") = "y" then
        response.write("<div id='intro' style='font-family: sans-serif; border-style: solid; border-width: 2px; height: 727px; width: 670px; padding: 0; position: absolute; z-index: 101; margin: 0; top: 50px; left: 100px; visibility: visible; background-color: gray;'><b>The Significance of the Orbital Plotting Feature</b><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>The main concept of the Kerbal Space Agency is that the game time is locked to real time (in this case Eastern Time US). The game was begun on Feb 16th, 2014 - which meant that on Year 1, Day 1 @ 13:45:00 it was 1:45pm EST on 2/16/14. Tweets that appear on @KSA_MissionCtrl reflect this, showing up when events actually happen at certain times in the game. So the ability for people to come here and see a spacecraft's orbital trajectory and current position isn't just some fancy gimmick for show. The events transpiring via @KSA_MissionCtrl are now more immersive than ever. If a launch is scheduled to occur beneath the orbit of a satellite, anyone looking at the track of that satellite at launch time would see its #1 orbit over KSC. In the future, maneuver nodes will be shown on the map as well, for starters.</p><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>To better see the link between game and Flight Tracker, here's an image with the relevant bits correlated by color. Again, the game began on 2/16/14, so a game time of Year 2, Day 99 corresponds to 5/25/15. Likewise, the game time of 20:37:04 corresponds to a real-world time of 8:37:04pm EST. You can see that the flight tracker and game data match within a reasonable error of margin.</p><a target='_blank' href='http://i.imgur.com/fTgODPx.png'><img src='http://i.imgur.com/fTgODPxl.png'></a><p><span id='close' style='cursor: pointer;'>Thanks for reading! Click here to close this box</span><br /><a target='_blank' href='https://github.com/Gaiiden/FlightTracker'>Source on Github</a></p></div>")
      end if
    end if
    
    'this could have been done better and made more robust, now that I know more about JQuery
    'check to see if this has coordinates for a static dynamic display for bodies that have no map data
    if instr(str, "[") then
      if mapMsg = "<br />Click for dynamic view" then mapMsg = ""
      response.write("<tr> <td> <center> <span id='img' style='cursor:help'><img src='" & mid(str, 2, instr(str, "|")) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Ecliptic View" & mapMsg & "'>&nbsp;<img src='" & mid(str, instr(str, "|")+1, 30) & "' class='tip' data-tipped-options=""target: 'mouse'"" title='Polar View" & mapMsg & "'></span> </center> </td> </tr>")
      
      if bMapOrbit then
        response.write("<div id='orbData' style='visibility: hidden; text-align: left; padding: 2px; font-family: sans-serif; font-size: 14px; border: 2px solid gray;	border-collapse: collapse; background-color: #E6E6E6; position: absolute; top: " & mid(str, instr(str, "[")+1, instr(str, ",") - instr(str, "[") -1) & "px; left: " & mid(str, instr(str, ",")+1, len(str) - instr(str, ",") -1) & "px;'></div>")
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
    response.write replace(replace(rsCraft.fields.item("ImgDataCode"), "title", "class='tip' data-tipped-options=""target: 'mouse'"" title"), "&#013;", "<br />")
  end if
  %>
</table>

<!-- footer links for craft information section-->
<span style="font-family:arial;color:black;font-size:12px;">
<%
'build the basic URL then add any included server variables as needed
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")
vars = "?db=" & request.querystring("db")
if request.querystring("ut") then vars = vars & "&ut=" & request.querystring("ut")
if request.querystring("pass") then vars = vars & "&pass=" & request.querystring("ut")

closemsg = ""
if request.querystring("popout") then	closemsg = "onclick='window.close()'"
response.write("<a " & closemsg & " target='_blank' href='http://bit.ly/KSAHomePage'>KSA Historical Archives</a>")
response.write(" | <a target='_blank' href='http://bit.ly/-FltTrk'>Flight Tracker Source on Github</a>")

'creates a pop-out window the user can move around
if not request.querystring("popout") then
  url = "http://www.blade-edge.com/images/KSA/Flights/redirect.asp"
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

<!-- 
EVENTS DATABASE INFORMATION
===========================

Launches recordset contains a list of all future launches that will be displayed on the clock
Maneuvers recordset contains a list of all future maneuvers that will be displayed on the clock

EVENTS FIELDS
=============

UT - the date at which this scheduled event will appear on the clock
CraftName - the name of the craft that will be performing this event
CraftLink - link to the craft page
EventDate - date string in VBScript date format for the time of the event (in local time!)
--> 

<%
'open database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\dbEvents.mdb"
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
  rsLaunch.find ("ut>" & dbUT)
  rsLaunch.moveprevious
end if

if not rsManeuver.eof then
  rsManeuver.find ("ut>" & dbUT)
  rsManeuver.moveprevious
end if
%>

<p>
<table style="width: 100%; border: 1px solid #007FDB;	border-collapse: collapse; background-color: #77C6FF;">
  <tr>
    <td>
      <center>
      <b>Current Time @ KSC</b><br />
      <span id='ksctime' style="font-size: 16px"></span>
      <br /><br />
      <table border="0" style="width: 100%; border-collapse: collapse;">
        <tr>
          <td style="width: 50%; border-width: 1px; text-align: center; vertical-align: top; border-top-style: none; border-right-style: solid; border-bottom-style: none; border-left-style: none;">
            <b>Next Launch</b><br />
            <%
            'if we are at EOF there are no records yet, if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
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
                response.write("var bLaunchCountdown = true;")

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
              else
                response.write("<script>")
                response.write("var bLaunchCountdown = true;")
                response.write("var bFutureLaunch = false;")
                response.write("var nextLaunchSched = 0;")
                response.write("var launchUT = " & datediff("s", rsLaunch.fields.item("EventDate"), now()) & ";")
                response.write("</script>")
                response.write("<a href='" & rsLaunch.fields.item("CraftLink") & "'>" & rsLaunch.fields.item("CraftName") & "</a><br />")
                response.write(formatdatetime(rsLaunch.fields.item("EventDate")) & "<br />")
                response.write("<span id='tminuslaunch'></span>")
              end if
            end if
            %>
          </td>
          <td style="width: 50%; vertical-align: top;	text-align: center;">
            <b>Next Maneuver</b><br />
            <%
            'if we are at EOF there are no records yet, if we are at BOF there are records but the first one is still beyond our current UT and inaccessible
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
                response.write("var bManeuverCountdown = true;")

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
              else
                response.write("<script>")
                response.write("var bManeuverCountdown = true;")
                response.write("var bFutureManeuver = false;")
                response.write("var nextManeuverSched = 0;")
                response.write("var maneuverUT = " & datediff("s", rsManeuver.fields.item("EventDate"), now()) & ";")
                response.write("</script>")
                response.write("<a href='" & rsManeuver.fields.item("CraftLink") & "&node=true'>" & rsManeuver.fields.item("CraftName") & "</a><br />")
                response.write(formatdatetime(rsManeuver.fields.item("EventDate")) & "<br />")
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

<!-- this will either display a mission timeline if the craft has one, or the recent tweets from @KSA_MissionCtrl --> 
<%
rsCrafts.movefirst
rsCrafts.find("db='" & request.querystring("db") & "'")
if isnull(rsCrafts.fields.item("collection")) then 
  response.write("<p><a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
else
  response.write("<p><a class='twitter-timeline' href='/KSA_MissionCtrl/timelines/598076346514984960' data-widget-id='" & rsCrafts.fields.item("collection") & "'>Mission Timeline</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
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
  <%response.write("var UT = " & UT & ";")%>
  
  // don't show until the mouse is over the map as otherwise it will just come up as undefined
  function showCursorData(e) {
    map.addControl(new L.KSP.Control.Info());
    map.off('mouseover', showCursorData);
  }

  if (mapState == "ascent") {
  
    // create the map with some custom options
    // details on Leaflet API can be found here - http://leafletjs.com/reference.html
    var map = new L.KSP.Map('map', {
      layers: [L.KSP.CelestialBody.KERBIN],
      center: [0,0],
      bodyControl: false,
      layersControl: false,
      scaleControl: true,
    });
    
    // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
    // leaflet.js was modified to remove the biome, slope and elevation data displays
    if (!is_touch_device()) { map.on('mouseover', showCursorData); }
    
    <%
    'do not run this code if there is image data to display instead
    if isnull(rsCraft.fields.item("ImgDataCode")) then
    
      ' set craft icon, determined by the entry in the crafts database
      rsCrafts.find("db='" & request.querystring("db") & "'")
      response.write("var ship = L.icon({iconUrl: 'button_vessel_" & rsCrafts.fields.item("Type") & ".png', iconSize: [16, 16]});")
      rsCrafts.movefirst
      
      'we have already used ascent data so reset the record pointer
      rsAscent.movefirst
      
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
      response.write("L.polyline(latlon, {smoothFactor: .25, clickable: false, color: '#00FF00', weight: 2, opacity: 1}).addTo(map);")
      response.write("L.marker([" & rsAscent.fields.item("lat") & "," & rsAscent.fields.item("lon") & "], {icon: ship, clickable: false}).addTo(map);")
  
      'really hackish method of zooming out the map further as KSC falls off the edge
      'assumes launch from KSC, assumes launch east with little inclination (accounts for lon movement only)
      if rsAscent.fields.item("lon") < -65.5714 then
        response.write("map.setView(latlon[latlon.length-1], 5);")
      elseif rsAscent.fields.item("lon") < -56.4697 then
        response.write("map.setView(latlon[latlon.length-1], 4);")
      else 
        response.write("map.setView(latlon[latlon.length-1], 3);")
      end if
      
      'keep the map locked to the ship if the page is going to update anyways in 15s
      if request.querystring("r") then 
        response.write("map.dragging.disable();")
        response.write("map.touchZoom.disable();")
        response.write("map.doubleClickZoom.disable();")
        response.write("map.scrollWheelZoom.disable();")
        response.write("map.boxZoom.disable();")
        response.write("map.removeControl(map.zoomControl);")
      end if
    end if
    %>
  
  // we can have an orbital state that doesn't require a map, so check that the element was created
  } else if (mapState == "orbit" && $("#map").length) {
  
    // just dummy values in case the real values are not available to retrieved from the database
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
      });

      // touchscreens don't register the cursor location, so only show location data if this isn't a touchscreen
      // leaflet.js was modified to remove the biome, slope and elevation data displays
      if (!is_touch_device()) { map.on('mouseover', showCursorData); }
    }
    
    // compute 3 orbits max, but don't exceed 100,000s or a noticeable freeze in the browser will occur
    var maxDeltaTime = 100000;
    var elapsedTime = UT + (Math.round(period * 3));
    var currUT = UT;
    if (elapsedTime - currUT > maxDeltaTime) {
      elapsedTime = UT + maxDeltaTime;
      
      // in cases where the orbital period exceeds 100,000s we should inform the user the whole orbit is not being plotted
      // this is handled via JQuery when the map is shown (see beginning of file)
      if (period > maxDeltaTime) { showMsg = true; }
    }
    while (currUT <= elapsedTime) {

      //////////////////////
      // computeMeanMotion() <-- refers to a function in KSPTOT code: https://github.com/Arrowstar/ksptot
      //////////////////////
      
      // adjust for motion since the time of this orbit
      var n = Math.sqrt(gmu/(Math.pow(Math.abs(sma),3)));
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
    }
    
    // place the marker at the current Lat/Lon position for this UT, with a high enough Z-index to stay on top of other map markers
    // put in some maximum default values since the JQuery update doesn't adjust the width of the popup
    if (bDrawMap) {
      var craft = L.marker(latlon[0], {icon: ship, zIndexOffset: 100}).addTo(map);
      craft.bindPopup("Lat: <span id='lat'>-000.0000&deg;S</span><br />Lng: <span id='lng'>-000.0000&deg;W</span><br />Alt: <span id='alt'>000,000.000km</span><br />Vel: <span id='vel'>000,000.000km/s</span>", {closeButton: false});
      
      // show the craft info box. This lets people know it exists and also serves to bring the craft into view
      craft.openPopup(); 

      // set up a listener for click events so we can immediately update the information and not have to wait for the next timer event
      var cardinal = "";
      craft.on('click', function(e) {
        if (latlon[0].lat < 0) {
          cardinal = "S";
        } else {
          cardinal = "N";
        }
        $('#lat').html(numeral(latlon[0].lat).format('0.0000') + "&deg;" + cardinal);
        if (latlon[0].lng < 0) {
          cardinal = "W";
        } else {
          cardinal = "E";
        }
        $('#lng').html(numeral(latlon[0].lng).format('0.0000') + "&deg;" + cardinal);
        $('#alt').html(numeral(orbitdata[0].alt).format('0,0.000') + "km");
        $('#vel').html(numeral(orbitdata[0].vel).format('0,0.000') + "km/s");
      });
      
      // draw the orbital paths
      var coord = 0;
      var colors = ['#00FF00', '#FF0000', '#FFFF00'];
      var pathNum = 0;
      while (coord < latlon.length) {
        var meridian = true;
        var path = [];
        
        // if a vessel is moving slower than the planet is rotating, it will move west to east
        // the same can happen for highly-inclined orbits (NOTE: unsure if I actually covered all cases here, at least I did for existing craft)
        if (period < rotPeriod && ((inc * 57.29577951308232) < 89 || (inc * 57.29577951308232) > 91)) {
        
          // check if the plot actually starts west of the meridian and update if needed
          if (latlon[coord].lng <= 0) { meridian = false; }
          
          while (coord < latlon.length) {
          
            // have we passed east of the meridian?
            if (latlon[coord].lng > 0) { meridian = true; }
            
            // if we started east or passed the meridian then a negative number means we are at the edge of the map
            // time to kill off this plot so it does not shoot a straight line to the other side
            if (meridian && latlon[coord].lng < 0) { break; }
            
            // cut the path if we've reached the end of an orbit
            if (coord/(pathNum+1) > period) {	break; }
            
            // cut the path if there's an upcoming maneuver node somewhere on this plot and we've reached it
            if (bUpcomingNode && nodeUT - UT < latlon.length && coord == nodeUT - UT) { break; }

            // create a new array entry for this location, then advance the array counter
            path.push(latlon[coord]);
            coord++;
          }
        } else {
          // check if the plot actually starts east of the meridian and update if needed
          if (latlon[coord].lng >= 0) { meridian = false; }
          
          while (coord < latlon.length) {
            // have we passed west of the meridian?
            if (latlon[coord].lng < 0) { meridian = true; }
            
            // if we started west or passed the meridian then a positive number means we are at the edge of the map
            // time to kill off this plot so it does not shoot a straight line to the other side
            if (meridian && latlon[coord].lng > 0) { break; }
            
            // cut the path if we've reached the end of an orbit
            if (coord/(pathNum+1) > period) {	break; }
            
            // cut the path if there's an upcoming maneuver node somewhere on this plot and we've reached it
            if (bUpcomingNode && nodeUT - UT < latlon.length && coord == nodeUT - UT) { break; }

            // create a new array entry for this location, then advance the array counter
            path.push(latlon[coord]);
            coord++;
          }
        }
        
        // create the path for this orbit
        // using leaflet.label - https://github.com/Leaflet/Leaflet.label
        // because for some reason couldn't get Leaflet popups to work
        var line = L.polyline(path, {smoothFactor: 1.25, clickable: true, color: colors[pathNum], weight: 3, opacity: 1}).bindLabel("Orbit #" + (pathNum+1) + "<br />Click for static view", {className: 'labeltext'}).addTo(map);
        
        // set up a listener for clicks on the line so we can let people switch to the static orbit view
        line.on('click', function(e) {
          $("#map").css("visibility", "hidden");
        });
        
        // check if we have completed an orbit, not just hit the end of the map
        if (coord/(pathNum+1) > period) {	pathNum++; }
      
        // don't draw any more paths if there's an upcoming maneuver node somewhere on this plot and we've reached it
        if (bUpcomingNode && nodeUT - UT < latlon.length && coord == nodeUT - UT) { break; }
      }
      
      // if we have an upcoming maneuver node, check that it can be drawn along our orbit and do so if possible
      var bNodeExecution = false;
      if (bUpcomingNode) {
        if (nodeUT - UT < latlon.length) {
          var bNodeRefreshCheck = false;
          var nodeIcon = L.icon({
            iconUrl: 'node.png',
            iconSize: [16, 16],
            iconAnchor: [8, 8]
          });
          var nodeMark = L.marker(latlon[nodeUT - UT], {icon: nodeIcon}).addTo(map);
          nodeMark.bindPopup("<center><span id='nodeTime'>Time to Maneuver<br />" + formatTime(nodeUT - UT) + "</span></center><br />Prograde &Delta;v: " + numeral(nodePrograde).format('0.000') + "<br />Normal &Delta;v: " + numeral(nodeNormal).format('0.000') + "<br />Radial &Delta;v: " + numeral(nodeRadial).format('0.000') + "<br />Total &Delta;v: " + numeral(nodeTotal).format('0.000'), {closeButton: false});
          nodeMark.on('click', function(e) {
            var dd = new Date();
            var currDate = Math.floor(dd.getTime() / 1000);
            var now = currDate - startDate;
            $('#nodeTime').html("Time to Maneuver<br />" + formatTime((nodeUT - currUT)-now));
          });
          nodeMark.on('popupopen', function(e) {
            var dd = new Date();
            var currDate = Math.floor(dd.getTime() / 1000);
            var now = currDate - startDate;
            $('#nodeTime').html("Time to Maneuver<br />" + formatTime((nodeUT - currUT)-now));
          });
        }
        // if we can't yet draw the node, refresh the page when we can
        else {
          var bNodeRefreshCheck = true;
        }
      }

      // purposefully delay the display of the map (and any messages as needed)
      // this is so users can see the static plot exists first
      // remove the popup box for the craft position after 5 seconds, user can re-open it if they want to
      setTimeout(function () { 
        setTimeout(function () { 
          craft.closePopup();
          // open the maneuver node if we were sent here looking for it and it exists on the map
          if (getParameterByName('node') && bUpcomingNode && !bNodeRefreshCheck) { nodeMark.openPopup(); }
        }, 5000);
        $("#map").css("visibility", "visible");
        if (getParameterByName('node') && bUpcomingNode && bNodeRefreshCheck) { $("#msgNode").css("visibility", "visible"); }
        if (showMsg) { $("#msgObtPd").css("visibility", "visible"); }
      }, 2500);
    }
    
    // find the times to Apoapsis and Periapsis
    // same code used earlier for determining the change in mean since Eph
    newMean = mean + n * (UT - eph);
    if (newMean < 0 || newMean > 2*Math.PI) {
      newMean = Math.abs(newMean - (2*Math.PI) * Math.floor(newMean / (2*Math.PI)));
    }
    var apTime = Math.round((Math.PI - newMean)/n);
    var peTime = Math.round((Math.PI*2 - newMean)/n);
    
    // close to Ap/Pe we can get a negative value, so handle that by just adding the period
    if (apTime <= 0) { apTime += Math.round(period); }
    if (peTime <= 0) { peTime += Math.round(period); }
    
    // some orbits may be too long to show Ap/Pe markers, so ensure that we can display them at all
    if (apTime < latlon.length) { 
      if (bDrawMap) {
        var apMark = L.marker(latlon[apTime], {icon: apIcon}).addTo(map); 
        apMark.bindPopup("<center><span id='apTime'>Time to Apoapsis<br />" + formatTime(apTime) + "</span></center>", {closeButton: false});
        apMark.on('click', function(e) {
          var dd = new Date();
          var currDate = Math.floor(dd.getTime() / 1000);
          var now = currDate - startDate;
          $('#apTime').html("Time to Apoapsis<br />" + formatTime(apTime-now));
        });
      } else { apTime = -1; }
    }
    if (peTime < latlon.length) { 
      if (bDrawMap) {
        var peMark = L.marker(latlon[peTime], {icon: peIcon}).addTo(map); 
        peMark.bindPopup("<center><span id='peTime'>Time to Periapsis<br />" + formatTime(peTime) + "</span></center>", {closeButton: false});
        peMark.on('click', function(e) {
          var dd = new Date();
          var currDate = Math.floor(dd.getTime() / 1000);
          var now = currDate - startDate;
          $('#peTime').html("Time to Periapsis<br />" + formatTime(peTime-now));
        });
      } else { peTime = -1; }
    }
  }

  // keep various things updated by calling this function every second
  var d = new Date();
  var startDate = Math.floor(d.getTime() / 1000);
  var strMsg = "<%response.write msg%>";
  var MET = <%response.write origMET%>;
  var bUpdateMET = <%response.write lcase(bUpdateMET)%>;
  var bEstDst = <%response.write lcase(bEstDst)%>;
  var strAccDst = "<%response.write strAccDst%>";
  var dstTraveled = <%response.write dstTraveled%>;
  var currUT = UT;
  <%
    if not isnull(rsOrbit.fields.item("Avg Velocity")) and not rsOrbit.bof then
      response.write("var avgSpeed = " & rsOrbit.fields.item("Avg Velocity") & ";")
    else
      response.write("var avgSpeed = 0;")
    end if
  %>
  setInterval(function () {
    // get the difference in time since the page load and use that to find the right coords
    var dd = new Date();
    var currDate = Math.floor(dd.getTime() / 1000);
    var now = currDate - startDate;

    // update orbital data if needed
    if (mapState == "orbit") {

      // update the popup content with JQuery, because once again I can't seem to get them to cooperate
      // or update the static display data
      // number formatting done with Numeral.js - http://numeraljs.com/
      if (latlon[now].lat < 0) {
        cardinal = "S";
      } else {
        cardinal = "N";
      }
      if (latlon[now].lng < 0) {
        cardinal = "W";
      } else {
        cardinal = "E";
      }
      if (bDrawMap) {

        // only update if a maneuver node hasn't executed and rendered all this invalid
        if (!bNodeExecution) {
          craft.setLatLng(latlon[now]);
          $('#lat').html(numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinal);
          $('#lng').html(numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinal);
          $('#alt').html(numeral(orbitdata[now].alt).format('0,0.000') + "km");
          $('#vel').html(numeral(orbitdata[now].vel).format('0,0.000') + "km/s");
          
          // update the Ap/Pe marker popup content
          $('#apTime').html("Time to Apoapsis<br />" + formatTime(apTime-now));
          $('#peTime').html("Time to Periapsis<br />" + formatTime(peTime-now));
          
          // update maneuver node popup content
          if (bUpcomingNode) { $('#nodeTime').html("Time to Maneuver<br />" + formatTime((nodeUT - currUT)-now)); }

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
          if (bUpcomingNode && !bNodeExecution && (nodeUT - currUT)-now <= 0) {
            map.removeLayer(nodeMark);
            bNodeExecution = true;
            craft.unbindPopup();
            craft.bindPopup("<center>Maneuver node executed<br />Awaiting new orbital data<br />Standy, page will auto update</center>", {closeButton: false});
            craft.openPopup();
          }	
        }
      } else if ($("#orbData").length) {
        if ($('#orbData').css("visibility") == "hidden") { $('#orbData').css("visibility", "visible"); }
        $('#orbData').html(
          "Lat: " + numeral(latlon[now].lat).format('0.0000') + "&deg;" + cardinal + "<br />" +
          "Lng: " + numeral(latlon[now].lng).format('0.0000') + "&deg;" + cardinal + "<br />" +
          "Alt: " + numeral(orbitdata[now].alt).format('0,0.000') + "km" + "<br />" +
          "Vel: " + numeral(orbitdata[now].vel).format('0,0.000') + "km/s" + "<br />" +
          "Time to Ap: " + formatTime(apTime-now) + "<br />" +
          "Time to Pe: " + formatTime(peTime-now));
      }
    }
    
    // update MET/countdown clock if needed
    if (bUpdateMET) {
      MET++;
      $("#met").html(strMsg + formatTime(Math.abs(MET)));
    }
    
    // update the estimated distance if needed
    if (bEstDst) {
      $("#distance").html(strAccDst + "<br />Estimated Current Total Distance Traveled: " + numeral(dstTraveled + (now * avgSpeed)).format('0,0') + "km");
    }
    
    // update the clock and any accompanying countdowns
    $('#ksctime').html(dd.toLocaleDateString() + ' ' + Date.toTZString(dd, 'E'));
    if (bLaunchCountdown) {
      
      // only count down if thete is something to countdown
      if (launchUT < 0) {
        $('#tminuslaunch').html(formatTime(Math.abs(launchUT)));
        launchUT++;
      }
      else {
        $('#tminuslaunch').html("LIFTOFF!!");
        bLaunchCountdown = false;
      }
    }
    if (bManeuverCountdown) {
      
      // only count down if thete is something to countdown
      if (maneuverUT < 0) {
        $('#tminusmaneuver').html(formatTime(Math.abs(maneuverUT)));
        maneuverUT++;
      }
      else {
        $('#tminusmaneuver').html("Maneuver Executed");
        bManeuverCountdown = false;
      }
    }
    
    // update all dynamic tooltips
    Tipped.refresh(".tip-update");
    
    // check if we need to refresh the page
    // did our orbital plot run out?
    if (bDrawMap && now >= latlon.length) {
      location.reload(true);
    }
    // can we now draw our maneuver node?
    if (bDrawMap && bNodeRefreshCheck && nodeUT - UT < 100000) {
      location.reload(true);
    }
    // have we reached the next update? Only check if viewing the present record
    if (bNextEventRefresh && !bPastUT && UT >= nextEventUT) {
      location.reload(true);
    }
    // have we reached a new scheduled launch posting?
    if (bFutureLaunch && UT >= nextLaunchSched) {
      location.reload(true);
    }
    // have we reached a new scheduled maneuver posting?
    if (bFutureManeuver && UT >= nextManeuverSched) {
      location.reload(true);
    }
    
    // update the UT now that no other calculations depend on it being static
    UT++;
  },
  1000);
</script>

<%
'clean up all previous connections
connCraft.Close
Set connCraft = nothing
connBodies.Close
Set connBodies = nothing
set adoxConn = nothing  
connLaunch.Close
Set connLaunch = nothing
%>

</body>
</html>