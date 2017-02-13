<!DOCTYPE html>

<!-- code/comments not formatted for word wrap -->

<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Crew Roster</title>

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/TLwwOya.png" />

  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  
  <!-- CSS stylesheets -->
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />
  <link rel="stylesheet" type="text/css" href="../jslib/tipped.css" />
  <link rel="stylesheet" type="text/css" href="../jslib/iosbadge.css" />
  
  <!-- JS libraries -->
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.js"></script>
  <script type="text/javascript" src="../jslib/sylvester.src.js"></script>
  <script type="text/javascript" src="../jslib/numeral.min.js"></script>
  <script type="text/javascript" src="../jslib/tipped.js"></script>
  <script type="text/javascript" src="../jslib/iosbadge.js"></script>

  <script>
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
    
    // determine whether this is a touchscreen device 
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

    // for retrieving URL query strings
    // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    function getParameterByName(name) {
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
          results = regex.exec(location.search);
      return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }		
    
    // set up for AJAX requests
    // http://www.w3schools.com/ajax/
    var ajaxUpdate;
    if (window.XMLHttpRequest) {
      ajaxUpdate = new XMLHttpRequest();
    } else {
      // code for IE6, IE5
      ajaxUpdate = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    // don't allow AJAX to cache data, which mainly screws up requests for updated vessel times for notifications
    $.ajaxSetup({ cache: false });  

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
              if (parseInt(getCookie(craftInfo[0])) < parseInt(craftInfo[1])) {
                console.log("old");
                $("#flightTracker").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
              }
            } else {
            
              // this is a new craft - but if it's also a new user's first visit then no point notifying them
              if (bNewUser) {
                setCookie(craftInfo[0], UT, true);
              } else {
                $("#flightTracker").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
              }
            }
          }
        }
        
        // parse & handle all crew instances
        for (x=0; x<crew.length; x++) {
          kerbalInfo = crew[x].split(";");
          if (getCookie(kerbalInfo[0])) {
            if (parseInt(getCookie(kerbalInfo[0])) < parseInt(kerbalInfo[1])) {
            
              // place a badge over the image of the kerbal in addition to upping the count in the menu
              $("#" + kerbalInfo[0]).iosbadge({ theme: 'red', size: 20, content: 'Update' });
              $("#allCrew").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
            }
          } else {
            if (bNewUser) {
              setCookie(kerbalInfo[0], kerbalInfo[1], true);
            } else {
              $("#" + kerbalInfo[0]).iosbadge({ theme: 'red', size: 20, content: 'New' });
              $("#allCrew").iosbadge({ theme: 'red', size: 20, content: '+1',  position: 'top-left' });
            }
          }
        }
      }
    };

    // JQuery setup
    var bMET = false;
    var bDescOpen = false;
    $(document).ready(function(){
    
      // upon selection of a new list item, take the user to that mission report
      $("#missionSelect")
        .change(function () {
          if ($("#missionSelect").val().length) { 
            
            // could be missing a link still if report was filed but not created
            if ($("#missionSelect").val() == 'null') {
              alert("This report is not yet uploaded. Please check again later or let us know it is missing! Sorry for the inconvenience");
            } else {
              window.open($("#missionSelect").val(), '_blank'); 
            }
          }
        })
        .change();
        
      // open new windows for archive data
      $("#tagData").click(function () {
        window.open("http://www.kerbalspace.agency/?tag=" + tagData.replace(/ /g, "-"));
        window.open("https://www.flickr.com/search/?user_id=kerbal_space_agency&tags=" + tagData + ",-archive&view_all=1");
      });

      // scroll up the kerbal description text when the header is clicked
      $("#kerbalDesc").click(function(){
        if (!bDescOpen) {
          $("#kerbalDesc").css("transform", "translateY(-555px)");
          $("#kerbalDesc").css("cursor", "default");
          bDescOpen = true;
        }
      });

      // return description text to normal on hover off
      $("#mainwrapper").hover(function(){
      }, function(){
        if (bDescOpen) {
          $("#kerbalDesc").css("cursor", "pointer");
          $("#kerbalDesc").css("transform", "translateY(0px)");
          bDescOpen = false;
        }
      });
      
      // behavior of tooltips depends on the device
      if (is_touch_device()) {
        var showOpt = 'click';
      } else {
        var showOpt = 'mouseenter';
      }
 
      // create all the tooltips using Tipped.js - http://www.tippedjs.com/
      Tipped.create('.tip', {size: 'small', showOn: showOpt, hideOnClickOutside: is_touch_device()});

      // http://stackoverflow.com/questions/3442322/jquery-checkbox-event-handling
      $('#remindLaunch').click(function() {
        
        // $this will contain a reference to the checkbox   
        var $this = $(this);
        if ($this.is(':checked')) {
        
          // if the user doesn't have cookies enabled, warn them of the consequences
          if (!checkCookies()) { 
            $('#launchWarn').fadeIn(); 
          
          // set the cookie
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
      
      // check on cookies
      if (checkCookies()) {
        checkVisitor();
        if (bNewUser) {
          // display a welcome dialog with link to the Wiki
          $('#intro').fadeIn();
        }
        
        // if we're looking at an individual kerbal, update their cookie to the current time to clear any New/Update notifications
        if (getParameterByName("db")) { setCookie(getParameterByName("db"), UT, true); }
        
        // check to see if there are any update notifications to display
        ajaxUpdate.open("GET", "../Tracker/update.asp", true);
        ajaxUpdate.send();
      }
        
      // remove welcome message
      $('#dismissIntro').click(function() { $('#intro').fadeOut(); });
    });
  </script>	
</head>
<body style='padding: 0; margin: 0; font-family: sans-serif;'>

<!-- special notice box for new users to the site -->
<div id='intro' style='font-family: sans-serif; border-style: solid; border-width: 2px; height: 177px; width: 370px; padding: 0; position: absolute; z-index: 301; margin: 0; top: 300px; left: 500px; background-color: gray; display: none'><center><b>Welcome to the Flight Tracker & Crew Roster!</b><p style='font-size: 14px; text-align: justify; margin-left: 5px; margin-right: 5px'>Here you can learn everything there is to know about the astronauts & vessels involved in our space program. We highly suggest <a target="_blank" href="https://github.com/Gaiiden/FlightTracker/wiki">visiting the wiki</a> for detailed instructions on how to use the many features to be found herein.<p><span id='dismissIntro' style='cursor: pointer;'>Click here to dismiss</span><p style='font-size: 14px; text-align: center;'><span style="cursor: help; text-decoration: underline; text-decoration-style: dotted" class='tip' data-tipped-options="maxWidth: 300" title="The KSA uses cookies stored on your computer via the web browser to enable certain features of the website. It does not store tracking information nor use any third party cookies for analytics or other data gathering. The website's core functionality will not be affected should cookies be disabled, at the expense of certain usability features.">Cookie Use Policy</span></p></center></div>

<!-- 
CATALOG/ROSTER DATABASE LOAD
============================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbcatalog
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#dbkerbal-name
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
set rsCrew = Server.CreateObject("ADODB.recordset")

'query the data, ensure that bookmarking is enabled
rsCrew.open "select * from crew", connCatalog, 1, 1

'depending on whether we are in a pop-out window or normal page decides how page is formatted
if request.querystring("popout") then
  response.write("<div style='width: 100%; overflow: hidden;'>")
else
  response.write("<div style='width: 1145px; overflow: hidden; margin-left: auto; margin-right: auto; position: relative'>")
end if

'calculate the time in seconds since epoch 0 when the game started
'save the result to JS as well
UT = datediff("s", "13-Sep-2016 00:00:00", now())
response.write("<script>var UT = " & UT & ";</script>")

'are we showing the full roster or an individual listing?
Dim conn, sConnection
if request.querystring("db") = "" then

  'header
  response.write("<div style='position: relative; width: 840px; float: left;'>")
  response.write("<center><h3>Full Crew Roster</h3></center>")

  'build the crew listing
  do while not rsCrew.eof
  
    'open kerbal database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\db" & rsCrew.fields.item("Kerbal") & ".mdb"
    Set conn = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"
    conn.Open(sConnection)

    'get the roster table
    set rsKerbal = Server.CreateObject("ADODB.recordset")

    'grab the record that is closest to but prior to this time
    rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & UT & " order by UT desc", conn, 1, 1
    
    'only display the entry if this kerbal has been activated
    if not rsKerbal.bof then
      if isnull(rsKerbal.fields.item("Activation")) then
        actDate = "TBD"
      else
        actDate = formatdatetime(rsKerbal.fields.item("Activation"),2)
      end if
      strFilter = ""
      if len(request.querystring("filter")) then strFilter = "&filter=" & request.querystring("filter")
      response.write("<a id='" & rsCrew.fields.item("Kerbal") & "' style='position: relative;' href='http://www.kerbalspace.agency/Roster/roster.asp?db=" & rsCrew.fields.item("Kerbal") & strFilter & "'><img src='" & rsKerbal.fields.item("Image") & "' width='190px' style='padding: 5px' class='tip' data-tipped-options=""target: 'mouse', detach: false, position: 'bottom'"" title='<b>" & rsKerbal.fields.item("Rank") & " " & rsKerbal.fields.item("Name") & " Kerman</b><p><b>Activation Date:</b><br>" & actDate  & "<br><b>Current Status:</b><br>" & rsKerbal.fields.item("Status") & "<br><b>Current Assignment:</b><br>" & rsKerbal.fields.item("Assignment") & "'></a>")
    end if
    rsCrew.movenext
  loop
%>

<!-- Full Roster Footer -->

<%
  response.write("<br><center>")
  'build the basic URL then add any included server variables that should be saved across pages
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")
  vars = "?db=" & request.querystring("db")
  if request.querystring("ut") then vars = vars & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then vars = vars & "&pass=" & request.querystring("pass")
  if len(request.querystring("filter")) then vars = vars & "&filter=" & request.querystring("filter")

  closemsg = ""
  if request.querystring("popout") then	closemsg = "onclick='window.close()'"
  response.write("<a " & closemsg & " target='_blank' href='http://www.kerbalspace.agency'>KSA Home Page</a>")
  response.write(" | <a href='https://github.com/Gaiiden/FlightTracker/wiki/Crew-Roster-Documentation'>Crew Roster Wiki</a></center></div>")
  
else

  'open kerbal database. "db" was prepended because without it for some reason I had trouble connecting
  'if the database fails to load, try the archive site instead
  on error resume next
  db = "..\..\database\db" & request.querystring("db") & ".mdb"
  Set conn = Server.CreateObject("ADODB.Connection")
  sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  conn.Open(sConnection)
  If Err <> 0 Then response.redirect("http://www.kerbalspace.agency/Roster/roster.asp")
  On Error GoTo 0

  'what record are we looking to pull from the DB, the one that is prior to the current UT or a specific entry?
  if request.querystring("ut") then
    dbUT = request.querystring("ut") * 1
    
    'dont allow people to abuse the UT query to peek ahead
    'a passcode query is required for when requesting a UT entry later than the current UT
    if dbUT > UT then
      if request.querystring("pass") <> "2725" then 
        dbUT = UT
      end if
    end if
  else
    dbUT = UT
  end if
  'moving forward all recordset queries should use dbUT

  'get the roster tables
  set rsKerbal = Server.CreateObject("ADODB.recordset")
  set rsMissions = Server.CreateObject("ADODB.recordset")
  set rsRibbons = Server.CreateObject("ADODB.recordset")
  set rsBackground = Server.CreateObject("ADODB.recordset")

  'for some recordsets, we can just grab the specific one or few records we need right from the start
  rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & dbUT & " order by UT desc", conn, 1, 1
  rsMissions.open "select * from missions where UT <= " & dbUT, conn, 1, 1
  rsRibbons.open "select * from ribbons", conn, 1, 1
  rsBackground.open "select top 1 * from [background] where UT <= " & dbUT & " order by UT desc", conn, 1, 1

  'header with tag link to show related website entries/flickr photos
  response.write("<div style='position: relative; width: 840px; float: left;'><center>")
  response.write("<h3>" & rsKerbal.fields.item("Rank") & " " & rsKerbal.fields.item("Name") & " Kerman&nbsp;<img id='tagData' class='tip' data-tipped-options=""position: 'righttop'"" style='margin-bottom: 10px; cursor: pointer;' title='view all tagged archive entries & flickr images' src='http://www.blade-edge.com/Flights/tag.png'></a></h3><script>var tagData='" & lcase(rsKerbal.fields.item("Name")) & "';</script>")
  response.write("<table style='width: 100%'><tr>")
%>          

<!-- 
BACKGROUND FIELDS
=================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#background-fields
-->

<%  
  'all info is written out to scroll-up caption text over the kerbal photo
  response.write("<td style='width: 370px'><div id='mainwrapper'><div id='box-1' class='box'>")
  response.write("<img id='image-1' src='" & rsKerbal.fields.item("Image") & "'/>")
  response.write("<span id='kerbalDesc' style='cursor: pointer;' class='caption simple-caption'><center><b>^^ Additional Information ^^</b></center>")
  response.write("<p><b>Birth Date:</b> " & formatdatetime(rsBackground.fields.item("BirthDate"),2) & " (Age: " & datediff("yyyy", rsBackground.fields.item("BirthDate"), now()) & ")</p>")
  response.write("<p><b>Family Name:</b> " & rsBackground.fields.item("FamName") & "&nbsp;<img src='qmark.png' style='left: initial; cursor: help' class='tip' data-tipped-options=""position: 'right', maxWidth: 160"" title='as a show of global unity, all adult kerbals take the surname of the first planetary leader'></p>")
  response.write("<p><b>Specialty:</b> " & rsBackground.fields.item("Speciality") & "</p>")
  response.write("<p><b>Hobbies:</b> " & rsBackground.fields.item("Hobbies") & "</p>")
  response.write("<p><b>Biography:</b> " & rsBackground.fields.item("Bio") & "</p>")
  response.write("<p><b>Service History:</b> " & rsBackground.fields.item("History") & "</p>")
  response.write("</span></div></div></td>")
%>          
          
<!-- 
KERBAL STATS FIELDS
===================
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#karbal-stats-fields
-->
  
<%
  'activation date is not a required field
  response.write("<td valign='top'><table border='1' style='width:100%;'>")
  if not isnull(rsKerbal.fields.item("Activation")) then
    response.write("<tr><td><b>Activation Date:</b> " & formatdatetime(rsKerbal.fields.item("Activation"),2) & " (Service Years: " & formatnumber(datediff("m", rsKerbal.fields.item("Activation"), now())/12, 2) & ")</td></tr>")
  else
    response.write("<tr><td><b>Activation Date:</b> TBD</td></tr>")
  end if
  response.write("<tr><td><b>Completed Missions:</b> " & rsMissions.RecordCount & "</td></tr>")
  if not isnull(rsKerbal.fields.item("Dockings")) then
    response.write("<tr><td><b>Docking Operations:</b> " & rsKerbal.fields.item("Dockings") & "</td></tr>")
  end if
  response.write("<tr><td><b>Total Mission Days:</b> " & rsKerbal.fields.item("TMD") & "</td></tr>")
  response.write("<tr><td><b>Total EVA Time:</b> " & rsKerbal.fields.item("TEVA") & "</td></tr>")
  response.write("<tr><td><b>Total Science Collected:</b> " & rsKerbal.fields.item("Science") & "</td></tr>")
  response.write("<tr><td><b>Total Distance Traveled:</b> " & rsKerbal.fields.item("Distance") & "</td></tr>")
  
  'add tooltips if there is more details to add to current mission/status
  if isnull(rsKerbal.fields.item("StatusHTML")) then
    response.write("<tr><td><b>Current Status:</b> " & rsKerbal.fields.item("Status") & "</td></tr>")
  else
    response.write("<tr><td><b>Current Status:</b> <u><span style='cursor:help' class='tip' data-tipped-options=""position: 'top'"" title='<center>" & rsKerbal.fields.item("StatusHTML") & "</center>'>" & rsKerbal.fields.item("Status") & "</span></u></td></tr>")
  end if
  if isnull(rsKerbal.fields.item("AssignmentHTML")) then
    response.write("<tr><td><b>Current Assignment:</b> " & rsKerbal.fields.item("Assignment") & "</td></tr>")
  else
    response.write("<tr><td><b>Current Assignment:</b> <u><span style='cursor:help' class='tip' data-tipped-options=""position: 'top'"" title='<center>" & rsKerbal.fields.item("AssignmentHTML") & "</center>'>" & rsKerbal.fields.item("Assignment") & "</span></u></td></tr>")
  end if
  
  'when mission start is included, we can determine the time until launch or that the mission has been underway
  if not isnull(rsKerbal.fields.item("MissionStart")) then
    MET = datediff("s", rsKerbal.fields.item("MissionStart"), now())
    if MET < 0 then
      response.write(" (Launch: ")
    else
      response.write(" (MET: ")
    end if
    response.write("<span id='met'></span>)")
    response.write("<script>var bMET = true; var MET = " & MET & ";</script>")
  end if
  response.write("</td></tr>")
%>      

<!-- 
MISSIONS FIELDS
===============
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#missions-fields
-->
      
<%
  response.write("<tr><td><b>Past Missions: </b><select id='missionSelect' style='width: 350px'><option value='' selected='selected'></option>")
  if not rsMissions.bof then 
    do while rsMissions.fields.item("UT") <= dbUT
    
      'fill in the dropdown list box with mission entries
      if isnull(rsMissions.fields.item("Link")) then
        strLink = "null"
      else
        strLink = rsMissions.fields.item("Link")
      end if
      response.write("<option value='" & strLink & "'>" & rsMissions.fields.item("Title") & "</option>")
      rsMissions.MoveNext
      if rsMissions.eof then exit do
    loop
  else
    response.write("<option value=''>No Missions</option>")
  end if
  response.write("</select></td></tr><tr><td>")
%>
      
<!-- 
RIBBONS FIELDS
==============
Documentation:
https://github.com/Gaiiden/FlightTracker/wiki/Database-Documentation#ribbons-fields
-->

<%
  if rsRibbons.eof then
    response.write("<center>No Ribbons Yet Awarded</center>")
  else
    bRibbonUsed = false
    do while rsRibbons.fields.item("UT") <= dbUT
      bRibbonUsed = true
      bOverride = true
      do while bOverride
      
        'determine whether this ribbon is meant to supercede another
        if not isnull(rsRibbons.fields.item("Override")) then
          if rsRibbons.fields.item("Override")*1 <= dbUT then 
            rsRibbons.MoveNext
          else 
            bOverride = false
          end if
        else
          bOverride = false
        end if
      loop
      response.Write "<img src='http://www.blade-edge.com/Roster/Ribbons/"
      response.write rsRibbons.fields.item("Ribbon")
      response.write ".png' width='109px' class='tip' style='cursor: help' data-tipped-options=""maxWidth: 150, position: 'top'"" title='<center>"
      response.write rsRibbons.fields.item("Title")
      response.write "</center>'>"
      rsRibbons.MoveNext
      if rsRibbons.eof then exit do
    loop
    if not bRibbonUsed then response.write("<center>No Ribbons Yet Awarded</center>")
  end if
  response.write("</td></tr></table>")
  response.write("<center><div style='padding: 5px;'>")
%>

<script>
// add the kerbal name to the page title
if (getParameterByName("db")) { 
  document.title = document.title + " - <%response.write(rsKerbal.fields.item("Rank") & " " & rsKerbal.fields.item("Name") & " Kerman")%>"; 
}
</script>

<!-- Idividual Roster Footer -->

<%
  'build the basic URL then add any included server variables that should be saved across pages
  url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL")
  vars = "?db=" & request.querystring("db")
  if request.querystring("ut") then vars = vars & "&ut=" & request.querystring("ut")
  if request.querystring("pass") then vars = vars & "&pass=" & request.querystring("pass")
  if len(request.querystring("filter")) then vars = vars & "&filter=" & request.querystring("filter")

  closemsg = ""
  if request.querystring("popout") then	closemsg = "onclick='window.close()'"
  response.write("<a " & closemsg & " target='_blank' href='http://www.kerbalspace.agency'>KSA Home Page</a>")
  response.write(" | Ribbons & Stats by <a " & closemsg & " target='_blank' href='http://forum.kerbalspaceprogram.com/index.php?/topic/61065-105-final-frontier-kerbal-individual-merits-098-1882/'>Final Frontier</a>")

  'creates a pop-out window the user can move around
  if not request.querystring("popout") then
    url = "http://www.kerbalspace.agency/Roster/redirect.asp"
    vars = vars & "&popout=true"
    response.write(" | ")
    response.write("<a target='_blank' href='" & url & vars & "'>Popout</a>")
  end if
  response.write(" | <a href='https://github.com/Gaiiden/FlightTracker/wiki/Crew-Roster-Documentation'>Crew Roster Wiki</a></div></center></td></tr></table></center></div>")
end if
%>

<!-- crew menu section -->

<div style="margin-left: 845px; font: 12pt normal Arial, sans-serif;"> 

<!-- crew menu header -->
<center><h3>Astronaut Corps</h3></center>

<!-- menu tree -->

<%
filters = Array("name", "status", "rank", "assignment")
%>

<!-- shows all the kerbals on one page -->
<ol class='tree'>

<%
strFilter = ""
if len(request.querystring("filter")) then strFilter = "?filter=" & request.querystring("filter")
response.write("<li> <labelRoster for='Roster'><a href='http://www.kerbalspace.agency/Roster/roster.asp" & strFilter & "' style='text-decoration: none; color: black' class='tip' data-tipped-options=""position: 'right'"" title='Show all astronauts'>Full Crew Roster</a>&nbsp;&nbsp;<span id='allCrew' style='position: relative;'></span></labelRoster> </li>")
%>

<!-- filters -->

<%
if request.querystring("filter") = "name" then

  'build the crew listing
  dim names()
  dim dbs()
  nameCount = 0

  'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\database\dbCatalog.mdb"
  Set connCatalog = Server.CreateObject("ADODB.Connection")
  sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  connCatalog.Open(sConnection2)

  'create the tables
  set rsCrew = Server.CreateObject("ADODB.recordset")

  'requery the data for alphabetical order
  rsCrew.open "select * from crew order by kerbal asc", connCatalog, 1, 1
  do while not rsCrew.eof
  
    'open kerbal database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\db" & rsCrew.fields.item("Kerbal") & ".mdb"
    Set conn = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"
    conn.Open(sConnection)

    'get the roster table
    set rsKerbal = Server.CreateObject("ADODB.recordset")

    'grab the record that is closest to but prior to this time
    rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & UT & " order by UT desc", conn, 1, 1
    
    'only add this kerbal if they have been activated
    if not rsKerbal.bof then
      redim preserve names(nameCount)
      redim preserve dbs(nameCount)
      names(nameCount) = rsKerbal.fields.item("Name")
      dbs(nameCount) = rsCrew.fields.item("Kerbal")
      nameCount = nameCount + 1
    end if
    rsCrew.movenext
  loop
  
  'a-f
  folder = false
  for i=0 to ubound(names)
    if strcomp("f", lcase(names(i))) >= 0 then
      if not folder then
        response.write("<li> <label for='a'><span style='cursor: pointer' class='tip' data-tipped-options=""position: 'right'"" title='View astronauts'>A-F</span></label> <input type='checkbox' id='a' /> <ol>")
        folder = true
      end if
      url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & dbs(i)
      if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
      if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
      if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
      if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
      response.write("<li class='eva'><a href='" & url & "'><span class='tip' data-tipped-options=""position: 'right'"" title='View astronaut profile' >" & names(i) & " Kerman</span></a></li>")
    end if
  next
  if folder then response.write("</ol>")
  
  'g-l
  folder = false
  for i=0 to ubound(names)
    if strcomp("l", lcase(names(i))) >= 0 and strcomp("f", lcase(names(i))) < 0 then
      if not folder then
        response.write("<li> <label for='g'><span style='cursor: pointer' class='tip' data-tipped-options=""position: 'right'"" title='View astronauts'>G-L</span></label> <input type='checkbox' id='g' /> <ol>")
        folder = true
      end if
      url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & dbs(i)
      if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
      if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
      if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
      if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
      response.write("<li class='eva'><a href='" & url & "'><span class='tip' data-tipped-options=""position: 'right'"" title='View astronaut profile' >" & names(i) & " Kerman</span></a></li>")
    end if
  next
  if folder then response.write("</ol>")

  'm-r
  folder = false
  for i=0 to ubound(names)
    if strcomp("r", lcase(names(i))) >= 0 and strcomp("l", lcase(names(i))) < 0 then
      if not folder then
        response.write("<li> <label for='r'><span style='cursor: pointer' class='tip' data-tipped-options=""position: 'right'"" title='View astronauts'>M-R</span></label> <input type='checkbox' id='r' /> <ol>")
        folder = true
      end if
      url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & dbs(i)
      if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
      if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
      if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
      if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
      response.write("<li class='eva'><a href='" & url & "'><span class='tip' data-tipped-options=""position: 'right'"" title='View astronaut profile' >" & names(i) & " Kerman</span></a></li>")
    end if
  next
  if folder then response.write("</ol>")

  's-z
  folder = false
  for i=0 to ubound(names)
    if strcomp("z", lcase(names(i))) >= 0 and strcomp("r", lcase(names(i))) < 0 then
      if not folder then
        response.write("<li> <label for='s'><span style='cursor: pointer' class='tip' data-tipped-options=""position: 'right'"" title='View astronauts'>S-Z</span></label> <input type='checkbox' id='s' /> <ol>")
        folder = true
      end if
      url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & dbs(i)
      if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
      if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
      if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
      if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
      response.write("<li class='eva'><a href='" & url & "'><span class='tip' data-tipped-options=""position: 'right'"" title='View astronaut profile' >" & names(i) & " Kerman</span></a></li>")
    end if
  next
  if folder then response.write("</ol>")
  
'remaining filters can all be handled in the same way
'potentially error-prone if someone passes a value that is not in the filters list
elseif len(request.querystring("filter")) then

  'build the crew listing
  dim unique()
  dim filter()
  dim names2()
  dim dbs2()
  count = 0
  countUnique = 0
  strFilter = request.querystring("filter")

  'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\database\dbCatalog.mdb"
  Set connCatalog = Server.CreateObject("ADODB.Connection")
  sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  connCatalog.Open(sConnection2)

  'create the tables
  set rsCrew = Server.CreateObject("ADODB.recordset")

  'requery the data for alphabetical order
  rsCrew.open "select * from crew order by kerbal asc", connCatalog, 1, 1
  
  'get the first kerbal data
  db = "..\..\database\db" & rsCrew.fields.item("Kerbal") & ".mdb"
  Set conn = Server.CreateObject("ADODB.Connection")
  sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  conn.Open(sConnection)

  'get the roster table
  set rsKerbal = Server.CreateObject("ADODB.recordset")

  'grab the record that is closest to but prior to this time
  rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & UT & " order by UT desc", conn, 1, 1
  
  redim preserve names2(count)
  redim preserve dbs2(count)
  redim preserve filter(count)
  redim preserve unique(countUnique)
  names2(count) = rsKerbal.fields.item("name")
  filter(count) = rsKerbal.fields.item(strFilter)
  unique(countUnique) = rsKerbal.fields.item(strFilter)
  dbs2(count) = rsCrew.fields.item("Kerbal")
  count = count + 1
  countUnique = countUnique + 1
  rsCrew.movenext
  
  do while not rsCrew.eof
  
    'open roster database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\db" & rsCrew.fields.item("Kerbal") & ".mdb"
    Set conn = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"
    conn.Open(sConnection)

    'get the roster table
    set rsKerbal = Server.CreateObject("ADODB.recordset")

    'grab the record that is closest to but prior to this time
    rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & UT & " order by UT desc", conn, 1, 1
    
    'only add this kerbal if they have been activated
    if not rsKerbal.bof then
      redim preserve names2(count)
      redim preserve dbs2(count)
      redim preserve filter(count)
      
      'check if the value of this kerbals field is a unique entry and add it if so
      bNew = true
      for i=0 to ubound(unique)
        if unique(i) = rsKerbal.fields.item(strFilter) then 
          bNew = false
          exit for
        end if
      next
      if bNew then
        redim preserve unique(count)
        unique(countUnique) = rsKerbal.fields.item(strFilter)
        countUnique = countUnique + 1
      end if
      
      'save the kerbal data for display
      names2(count) = rsKerbal.fields.item("Name")
      filter(count) = rsKerbal.fields.item(strFilter)
      dbs2(count) = rsCrew.fields.item("Kerbal")
      count = count + 1
    end if
    rsCrew.movenext
  loop
  
  'create the menu items based on what was found
  for s=0 to ubound(unique)
    folder = false
    for i=0 to ubound(filter)
      if unique(s) = filter(i) then
        if not folder then
          response.write("<li> <label for='" & filter(i) & "'><span style='cursor: pointer' class='tip' data-tipped-options=""position: 'right'"" title='View astronauts'>" & filter(i) & "</span></label> <input type='checkbox' id='" & filter(i) & "' /> <ol>")
          folder = true
        end if
        url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & dbs2(i)
        if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
        if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
        if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")
        if len(request.querystring("filter")) then url = url & "&filter=" & request.querystring("filter")
        response.write("<li class='eva'><a href='" & url & "'><span class='tip' data-tipped-options=""position: 'right'"" title='View astronaut profile' >" & names2(i) & " Kerman</span></a></li>")
      end if
    next
    if folder then response.write("</ol>")
  next
end if
%>

<!-- adds a link to the Flight Tracker to the end of the menu list -->
<li> <labelBody for='Sol'><a id='link' class='tip' style="text-decoration: none; color: black" data-tipped-options="position: 'right'" title='Information on KSA vessels' href='http://www.kerbalspace.agency/Tracker'>Flight Tracker</a>&nbsp;&nbsp;<span id='flightTracker' style='position: relative;'></span></labelBody></li>
</ol>

<!-- filter listing -->

<span style='font-family:arial;color:black;font-size:12px;'>
<%
'build a URL to use for linking
url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?db=" & request.querystring("db")
if request.querystring("ut") then url = url & "&ut=" & request.querystring("ut")
if request.querystring("pass") then url = url & "&pass=" & request.querystring("pass")
if request.querystring("popout") then url = url & "&popout=" & request.querystring("popout")

response.write("<b>Filter By:</b> <span id=filter>")

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

'decide whether to link the None filter
if len(request.querystring("filter")) then
  response.write("<a href='" & url & "'>None</a>")
else
  response.write("None")
end if
%>
</span></span>

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
                rsLaunch.movenext
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

<!-- twitter timeline display --> 

<%
'show the main tweet stream if this is the Full Roster
if len(request.querystring("db")) = 0 then 
  response.write("<P><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center> <a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163' height='600' data-chrome='nofooter noheader'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>  </p>")
else

  'reset and find the current kerbal
  rsCrew.movefirst
  do while not rsCrew.eof
    if rsCrew.fields.item("kerbal") = request.querystring("db") then exit do
    rsCrew.movenext
  loop

  'show the kerbal collection timeline if there is one available, or fall back to the main tweet stream
  if isnull(rsCrew.fields.item("collection")) or rsCrew.eof then 
    response.write("<p><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center><a class='twitter-timeline' href='https://twitter.com/KSA_MissionCtrl' data-widget-id='598711760149852163' height='600' data-chrome='nofooter noheader'>Tweets by @KSA_MissionCtrl</a> <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script></p>")
  else
    response.write("<p><center><a href='https://twitter.com/KSA_MissionCtrl' class='twitter-follow-button' data-show-count='true'>Follow @KSA_MissionCtrl</a><script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></center> <a class='twitter-timeline' data-partner='tweetdeck' href='https://twitter.com/KSA_MissionCtrl/timelines/" & rsCrew.fields.item("collection") & "' height='600' data-chrome='nofooter noheader'>Curated tweets by KSA_MissionCtrl</a> <script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script></p>")
  end if
end if
%>

</span></div> </div>

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
  var tickStartTime = new Date().getTime();
  var tickDelta = 0;
  var ticktock = 623648;
  (function tick() {
    var dd = new Date();
    dd.setTime(1473739200000 + (UT * 1000));
    
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
        if (checkCookies()) { setCookie("maneuverReminder", maneuverCraft, 0); }
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
    
    // update mission timer?
    if (bMET) {
      $('#met').html(formatTime(MET));
      MET++;
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
conn.Close
Set conn = nothing
connCatalog.Close
Set connCatalog = nothing
connEvent.Close
Set connEvent = nothing
%>

</center>
</body>
</html>