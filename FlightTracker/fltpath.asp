<%
response.expires=-1
flightDataStr = ""

if len(request.querystring("data")) = 0 then 
  response.write "!"
else
  paths = split(request.querystring("data"), ",")
  
  'first output all the info from the Mission Data tables
  for each path in paths
  
    'open the database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\dbFlt" & path & ".mdb"
    Dim connFlight
    Set connFlight = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"
    connFlight.Open(sConnection)

    'create the tables
    set rsMissionData = Server.CreateObject("ADODB.recordset")

    'query the data, ensure that bookmarking is enabled
    rsMissionData.open "select * from [mission data]", connFlight, 1, 1
    
    flightDataStr = flightDataStr & rsMissionData.fields.item("Title") & "|"
    flightDataStr = flightDataStr & rsMissionData.fields.item("Img") & "|"
    flightDataStr = flightDataStr & rsMissionData.fields.item("Desc") & "|"
    flightDataStr = flightDataStr & rsMissionData.fields.item("Report") & "`"
    
    connFlight.Close
    Set connFlight = nothing
  next
  
  flightDataStr = left(flightDataStr, len(flightDataStr)-1)
  flightDataStr = flightDataStr & "~"

  'now get the data from the Flight Data table
  for each path in paths
  
    'open the database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\dbFlt" & path & ".mdb"
    Set connFlight = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"
    connFlight.Open(sConnection)

    'create the tables
    set rsFlightData = Server.CreateObject("ADODB.recordset")

    'query the data, ensure that bookmarking is enabled
    rsFlightData.open "select * from [flight data]", connFlight, 1, 1
    
    do until rsFlightData.eof
      flightDataStr = flightDataStr & rsFlightData.fields.item("UT") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("ASL") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("AGL") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("Lat") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("Lng") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("Spd") & ","
      flightDataStr = flightDataStr & rsFlightData.fields.item("Dist")
      
      'for now, use a low resolution since users can not zoom in much
      rsFlightData.move 5
      if not rsFlightData.eof then 
        flightDataStr = flightDataStr & "|"
      else
        flightDataStr = flightDataStr & ";"
      end if
    loop
    
    connFlight.Close
    Set connFlight = nothing
  next
  
  flightDataStr = left(flightDataStr, len(flightDataStr)-1)
  response.write flightDataStr
end if
%>