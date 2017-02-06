<%
response.expires=-1

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

if len(request.querystring("crafts")) = 0 then
  response.write("!")
else

  'get the parts we are pulling info for
  crafts = split(request.querystring("crafts"), ",")
  
  'find and return the part details
  craftData = request.querystring("surfaceMap") & "|"
  for each craft in crafts
  
    'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
    on error resume next
    db = "..\..\database\db" & craft & ".mdb"
    Dim connCraft, sConnection
    Set connCraft = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"

    'attempt to access the database
    connCraft.Open(sConnection)
    if Err <> 0 Then 
      response.write("!")
    else

      'create the tables
      set rsCraft = Server.CreateObject("ADODB.recordset")
      set rsResources = Server.CreateObject("ADODB.recordset")
      set rsOrbit = Server.CreateObject("ADODB.recordset")
      set rsCrew = Server.CreateObject("ADODB.recordset")
      set rsFlightplan = Server.CreateObject("ADODB.recordset")
      set rsComms = Server.CreateObject("ADODB.recordset")
      
      'query the data
      rsCraft.open "select * from [craft data]", connCraft, 2
      rsResources.open "select * from [craft resources]", connCraft, 2
      rsOrbit.open "select * from [flight data]", connCraft, 2
      rsCrew.open "select * from [crew manifest]", connCraft, 2
      rsFlightplan.open "select * from flightplan", connCraft, 2
      rsComms.open "select * from [craft comms]", connCraft, 2

      'calculate the time in seconds since epoch 0 when the game started
      'or use a custom UT
      if request.querystring("ut") then
        UT = request.querystring("ut") * 1
      else
        UT = datediff("s", "13-Sep-2016 00:00:00", now())
      end if
      
      'starting from the end, work back to find the first record earlier than or equal to the UT we are looking for
      if not rsCraft.eof then
        rsCraft.MoveLast
        do until rsCraft.fields.item("id") <= UT
          rsCraft.MovePrevious
          if rsCraft.bof then exit do
        Loop
      end if
      if not rsOrbit.eof then
        rsOrbit.MoveLast
        do until rsOrbit.fields.item("id") <= UT
          rsOrbit.MovePrevious
          if rsOrbit.bof then exit do
        Loop
      end if
      if not rsResources.eof then
        rsResources.MoveLast
        do until rsResources.fields.item("id") <= UT
          rsResources.MovePrevious
          if rsResources.bof then exit do
        Loop
      end if
      if not rsCrew.eof then
        rsCrew.MoveLast
        do until rsCrew.fields.item("id") <= UT
          rsCrew.MovePrevious
          if rsCrew.bof then exit do
        Loop
      end if

      'get the record containing the information relative to this vessel
      rsCrafts.movefirst
      rsCrafts.find("db='" & craft & "'")
      if rsCrafts.eof or rsCrafts.bof then 

        'use Kerbin as a default
        ref = 3
      else

        'parse all the SOIs this craft has/will be in and find the one it is in currently
        locations = split(rsCrafts.fields.item("SOI"), "|")
        for each loc in locations
          values = split(loc, ";")
          if values(0)*1 <= dbUT then 
            ref = values(1)*1
          end if
        next 
      end if

      'create a recordset copy of the moon/planet recordset depending on what is being orbited at this time
      'moons use 50 or greater for reference numbers
      if ref < 50 then
        set rsBody = rsPlanets.clone()
      else
        set rsBody = rsMoons.clone()
      end if

      'now get the specific body
      rsBody.movefirst
      rsBody.find("id=" & ref)

      'fetch and return the data
      craftData = craftData & craft
      if isnull(rsCraft.fields.item("CraftImg")) then
        craftData = craftData & ";null"
      else
        craftData = craftData & ";" & split(split(rsCraft.fields.item("CraftImg"), "|")(0), "~")(0)
      end if
      craftData = craftData & ";" & formatnumber(rsOrbit.fields.item("Apoapsis")*1000,0)
      craftData = craftData & ";" & formatnumber(rsOrbit.fields.item("Periapsis")*1000,0)
      craftData = craftData & ";" & formatnumber(rsOrbit.fields.item("Eccentricity"),3)
      craftData = craftData & ";" & formatnumber(rsOrbit.fields.item("Inclination"),3)

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

      craftData = craftData & ";" & ydhms
      craftData = craftData & ";" & formatnumber(rsOrbit.fields.item("VelocityAp")*1000,0) & "-" & formatnumber(rsOrbit.fields.item("VelocityPe")*1000,0)
      craftData = craftData & ";" & rsCraft.fields.item("LaunchDateTerm")
      craftData = craftData & ";" & rsCraft.fields.item("LaunchDateUTC")

      'convert from seconds to yy:ddd:hh:mm:ss
      years = 0
      days = 0
      hours = 0
      minutes = 0
      MET = datediff("s", rsCraft.fields.item("LaunchDate"), now())
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

      craftData = craftData & ";" & missionMET
      craftData = craftData & ";" & formatnumber(rsResources.fields.item("TotalMass"),3)

      if isnull(rsResources.fields.item("ResourceMass")) then
        craftData = craftData & ";Unknown"
      else
        craftData = craftData & ";" & formatnumber(rsResources.fields.item("ResourceMass"),3)
      end if

      if isnull(rsResources.fields.item("DeltaV")) then
        craftData = craftData & ";N/A"
      else
        craftData = craftData & ";" & formatnumber(rsResources.fields.item("DeltaV")*1000,3)
      end if

      if not rsCrew.bof then
        craftData = craftData & ";"
        
        if isnull(rsCrew.fields.item("Crew")) then
          craftData = craftData & ";None"
        else
          crew = split(rsCrew.fields.item("Crew"), "|")
          for each kerbal in crew
            values = split(kerbal, ";")
            craftData = craftData & values(0) & ", "
          next
          craftData = left(craftData, len(craftData)-2)
        end if
      else
        craftData = craftData & ";None"
      end if

      craftData = craftData & ";" & rsCraft.fields.item("id")

      if not rsComms.eof then
      
        'point to the relevant record for this ut
        rsComms.movelast
        do until rsComms.fields.item("id") <= UT
          rsComms.MovePrevious
          if rsComms.bof then exit do
        Loop
        
        'get the distance from Kerbin so we can calculate signal delay
        if rsBody.fields.item("Body") = "Kerbin" then 
        
          'if we are in orbit around Kerbin just get our apoapsis
          kDist = rsOrbit.fields.item("Apoapsis")
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
          rsDistance.open "select * from dst" & craft & "toKerbin", connCatalog, 1, 1                    
          obtTime = rsOrbit.fields.item("Orbital Period") * (UT/rsDistance.fields.item("UT") - int(UT/rsDistance.fields.item("UT")))
          
          'craft orbits can change, so need to find the one for this UT
          rsDistance.movelast
          do until rsDistance.fields.item("id") <= UT
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
      else
        sigDelay = 0
      end if
      craftData = craftData & ";" & sigDelay
      
      'determine if we have an upcoming maneuver node 
      'find the record that works for this time
      if not rsFlightplan.eof then
        rsFlightplan.movelast
        do until rsFlightplan.bof
          if rsFlightplan.fields.item("ut") <= UT then exit do
          rsFlightplan.MovePrevious
        Loop
        
        'check if we found one in the future or are in an active maneuver state
        if not rsFlightplan.bof then
          if rsFlightplan.fields.item("executeut") > UT then
            craftData = craftData & ";" & rsFlightplan.fields.item("executeut")
          elseif UT <= rsFlightplan.fields.item("endut")*1 + round(sigDelay) then
            craftData = craftData & ";" & "0"
          else
            craftData = craftData & ";" & "-1"
          end if
        else
          craftData = craftData & ";" & "-1"
        end if
      else
        craftData = craftData & ";" & "-1"
      end if

      'raw orbital data for calculation use
      if not rsOrbit.bof then
        craftData = craftData & ";" & rsOrbit.fields.item("Eccentricity")
        craftData = craftData & ";" & rsOrbit.fields.item("Inclination")
        craftData = craftData & ";" & rsOrbit.fields.item("Orbital Period")
        craftData = craftData & ";" & rsOrbit.fields.item("SMA")
        craftData = craftData & ";" & rsOrbit.fields.item("RAAN")
        craftData = craftData & ";" & rsOrbit.fields.item("Arg")
        craftData = craftData & ";" & rsOrbit.fields.item("TrueAnom")
        craftData = craftData & ";" & rsOrbit.fields.item("Eph") & "|"
      else
        craftData = craftData & ";null|"
      end if
    end if
  next

  'clean up and post the data
  craftData = left(craftData, len(craftData) - 1)
  response.write craftData
  connCraft.Close
  Set connCraft = nothing
end if

connCatalog.Close
Set connCatalog = nothing
%>