<!-- turn word wrap off in your text editor-->

<!DOCTYPE html>
<html>
<head>

  <!-- Display the KSA favicon -->
  <link rel="shortcut icon" href="/images/KSA/favicon.ico" type="image/x-icon" />

  <title>KSA Crew Roster</title>
  <link href="style.css" rel="stylesheet" type="text/css" media="screen" />

  <!-- use this image link to force reddit to use a certain image for its thumbnail -->
  <meta property="og:image" content="http://i.imgur.com/3zFaENT.jpg" />
  
</head>
<body>

<!-- ROSTER DATABASE INFORMATION
     ===========================
     
     Kerbal Stats recordset contains information about the kerbal's service history and current assignment
     Mission recordset contains links to previous missions (that have been written up and posted online)
     Ribbons recordset contains all ribbons awarded via Final Frontier. Ribbons do not have to be awarded upon initial recordset creation
     
     All recordsets can be updated independently.
     
     See the various recordset display code sections below for further details.
-->

<%
'open roster database. "db" was prepended because without it for some reason I had trouble connecting
db = "..\..\..\..\database\db" & request.querystring("db") & ".mdb"
Dim conn, sConnection
Set conn = Server.CreateObject("ADODB.Connection")
sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

              "Data Source=" & server.mappath(db) &";" & _

              "Persist Security Info=False"
conn.Open(sConnection)

'calculate the time in seconds since epoch 0 when the game started
fromDate = "16-Feb-2014 00:00:00"
UT = datediff("s", fromdate, now())

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

'get the roster tables
set rsKerbal = Server.CreateObject("ADODB.recordset")
set rsMissions = Server.CreateObject("ADODB.recordset")
set rsRibbons = Server.CreateObject("ADODB.recordset")

'for some recordsets, we can just grab the specific one or few records we need right from the start
rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & dbUT & " order by UT desc", conn, 1, 1
rsMissions.open "select * from missions where UT <= " & dbUT, conn, 1, 1
rsRibbons.open "select * from ribbons", conn, 1, 1
%>

<!-- header -->
<center>
<h3><%response.write(rsKerbal.fields.item("Rank") & " " & rsKerbal.fields.item("Name"))%> Kerman</h3>
<table style="width:770px">
<tr>

  <!-- image of the kerbal -->
  <td style="width:50%">
    <%response.write("<img src='" & rsKerbal.fields.item("Image") & "'>")%>
  </td>
  
  <!-- KERBAL STATS FIELDS
       ===================
       
       UT - the time in seconds from 0 epoch at which this change occurs
       Rank - the rank of the astronaut, which will appear before their name in the Header
       Name - the first name of the astronaut, Kerman is automatially appended
       Image - the URL to the 360x543 image of the kerbal
       Activation - the date at which the kerbal was hired into service, any format acceptable
       Dockings - the number of dockings performed by the kerbal as reported by Final Frontier
       TMD - Total Mission Days as reported by Final Frontier
       TEVA - Total EVA time, as reported by Final Frontier
       Staus - HTML/text on current status of kerbal - alive/dead/on mission/etc
       Mission - HTML/text on the astronaut's current assignment
  -->
  
  <td style="width:50%"  valign="top">
  <table border="1" style="width:100%;">
    <tr><td><b>Activation Date:</b> <%response.write rsKerbal.fields.item("Activation")%></td></tr>
    <tr><td><b>Completed Missions:</b> <%response.write rsMissions.RecordCount%></td></tr>
    <tr><td><b>Docking Operations:</b> <%response.write rsKerbal.fields.item("Dockings")%></td></tr>
    <tr><td><b>Total Mission Days:</b> <%response.write rsKerbal.fields.item("TMD")%></td></tr>
    <tr><td><b>Total EVA Time:</b> <%response.write rsKerbal.fields.item("TEVA")%></td></tr>
    <tr><td><b>Current Status:</b> <%response.write rsKerbal.fields.item("Status")%></td></tr>
    <tr><td><b>Current Mission:</b> <%response.write rsKerbal.fields.item("Mission")%></td></tr>
    <tr><td><b>Past Missions:</b> 
    
    <!-- MISSIONS FIELDS
         ===============
         
         UT - the time in seconds from 0 epoch at which this change occurs
         Link - URL to the mission report
         Title - text to appear in pop-up when hovered over the link
         
         It should be noted that mission reports are never scheduled, so the UT field here is mostly just used as a unique field for the record only
    -->
    
    <%
      for missionCount = 1 to rsMissions.RecordCount
        response.Write "<a onclick='window.close()' target='_blank' href='"
        response.write rsMissions.fields.item("Link")
        response.write "' title='"
        response.write rsMissions.fields.item("Title")
        response.write ("'>#" & missionCount & "</a> ")
        rsMissions.MoveNext
      next
    %></td></tr>
    <tr><td>
    
    <!-- RIBBONS FIELDS
         ==============
         
         UT - the time in seconds from 0 epoch at which this change occurs
         Ribbon - the name of a ribbon that corresponds to a PNG image file on the server 
         Title - the text that will appear when the ribbon image is hovered over
         [Override] - the UT at which this ribbon is superceded by another, meaning it will not be shown
    -->
    
    <%
      if rsRibbons.eof then
          response.write("<center>None Yet Awarded</center>")
      else
        do while rsRibbons.fields.item("UT") <= dbUT
          bOverride = true
          do while bOverride
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
          response.Write "<img src='http://www.blade-edge.com/images/KSA/Roster/Ribbons/"
          response.write rsRibbons.fields.item("Ribbon")
          response.write ".png' title='"
          response.write rsRibbons.fields.item("Title")
          response.write "'>"
          rsRibbons.MoveNext
          if rsRibbons.eof then exit do
        loop
      end if
    %>
    </td></tr>
  </table>
  <%
    if not rsRibbons.eof then	response.write("<center>(mouse over ribbons for name and date awarded)</center>")
  %>
  </td>
</tr>
</table>
</center>
<%	
conn.Close
Set conn = nothing
%>
</center>
</body>
</html>