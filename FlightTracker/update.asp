<%
response.expires=-1

'calculate the time in seconds since epoch 0 when the game started
UT = datediff("s", "13-Sep-2016 00:00:00", now())

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
set rsCrews = Server.CreateObject("ADODB.recordset")

'query the data, ensure that bookmarking is enabled
rsPlanets.open "select * from planets", connCatalog, 1, 1
rsMoons.open "select * from moons", connCatalog, 1, 1
rsCrafts.open "select * from crafts", connCatalog, 1, 1
rsCrews.open "select * from crew", connCatalog, 1, 1

do while not rsCrafts.eof

  rsPlanets.movefirst
  rsPlanets.moveprevious
  rsMoons.movefirst
  rsMoons.moveprevious

  locations = split(rsCrafts.fields.item("SOI"), "|")
  ref = -1
  for each loc in locations
    values = split(loc, ";")
    if values(0)*1 <= UT then 
      ref = values(1)*1
    end if
  next 

  if ref >= 0 then
  
    'create a recordset copy of the moon/planet recordset depending on what is being orbited at this time
    'moons use 50 or greater for reference numbers
    if ref < 50 then
      rsPlanets.find("id=" & ref)
    else
      rsMoons.find("id=" & ref)
      rsPlanets.find("id=" & rsMoons.fields.item("Ref"))
    end if

    'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
    db = "..\..\database\db" & rsCrafts.fields.item("DB") & ".mdb"
    Dim connCraft, sConnection
    Set connCraft = Server.CreateObject("ADODB.Connection")
    sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                  "Data Source=" & server.mappath(db) &";" & _

                  "Persist Security Info=False"

    'attempt to access the database
    connCraft.Open(sConnection)

    'create the tables
    set rsCraft = Server.CreateObject("ADODB.recordset")
    set rsResources = Server.CreateObject("ADODB.recordset")
    set rsOrbit = Server.CreateObject("ADODB.recordset")
    set rsCrew = Server.CreateObject("ADODB.recordset")
    set rsComms = Server.CreateObject("ADODB.recordset")
    set rsPorts = Server.CreateObject("ADODB.recordset")

    'query the data
    rsCraft.open "select top 1 * from [craft data] where ID <= " & UT & " order by ID desc", connCraft, 1, 1
    rsResources.open "select top 1 * from [craft resources] where ID <= " & UT & " order by ID desc", connCraft, 1, 1
    rsOrbit.open "select top 1 * from [flight data] where ID <= " & UT & " order by ID desc", connCraft, 1, 1
    rsCrew.open "select top 1 * from [crew manifest] where ID <= " & UT & " order by ID desc", connCraft, 1, 1
    rsComms.open "select top 1 * from [craft comms] where ID <= " & UT & " order by ID desc", connCraft, 1, 1
    rsPorts.open "select top 1 * from [craft ports] where ID <= " & UT & " order by ID desc", connCraft, 1, 1

    lastUpdate = rsCraft.fields.item("id")
    if not rsResources.bof then if rsResources.fields.item("id") > lastUpdate then lastUpdate = rsResources.fields.item("id")
    if not rsOrbit.bof then if rsOrbit.fields.item("id") > lastUpdate then lastUpdate = rsOrbit.fields.item("id")
    if not rsCrew.bof then if rsCrew.fields.item("id") > lastUpdate then lastUpdate = rsCrew.fields.item("id")
    if not rsComms.bof then if rsComms.fields.item("id") > lastUpdate then lastUpdate = rsComms.fields.item("id")
    if not rsPorts.bof then if rsPorts.fields.item("id") > lastUpdate then lastUpdate = rsPorts.fields.item("id")

    'fetch and return the data
    craftUpdate = ""
    craftUpdate = rsCrafts.fields.item("db") & ";" & lastUpdate & ";" & rsPlanets.fields.item("body") & ";"
    if not rsMoons.bof then craftUpdate = craftUpdate & rsMoons.fields.item("body") else craftUpdate = craftUpdate & "null"
  
    rsCrafts.movenext
    if not rsCrafts.eof and len(craftUpdate) then craftUpdate = craftUpdate & ":"
    response.write craftUpdate
  else
    rsCrafts.movenext
    response.write("null:")
  end if
  
Loop

response.write("|")

do while not rsCrews.eof

  'open roster database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\database\db" & rsCrews.fields.item("Kerbal") & ".mdb"
  Set conn = Server.CreateObject("ADODB.Connection")
  sConnection3 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  conn.Open(sConnection3)

  'get the roster tables
  set rsKerbal = Server.CreateObject("ADODB.recordset")
  set rsMissions = Server.CreateObject("ADODB.recordset")
  set rsRibbons = Server.CreateObject("ADODB.recordset")
  set rsBackground = Server.CreateObject("ADODB.recordset")

  'for some recordsets, we can just grab the specific one or few records we need right from the start
  rsKerbal.open "select top 1 * from [kerbal stats] where UT <= " & UT & " order by UT desc", conn, 1, 1
  rsMissions.open "select top 1 * from missions where UT <= " & UT & " order by UT desc", conn, 1, 1
  rsRibbons.open "select top 1 * from ribbons where UT <= " & UT & " order by UT desc", conn, 1, 1
  rsBackground.open "select top 1 * from [background] where UT <= " & UT & " order by UT desc", conn, 1, 1
  
  lastUpdate = rsKerbal.fields.item("UT")
  if not rsMissions.bof then if rsMissions.fields.item("UT") > lastUpdate then lastUpdate = rsMissions.fields.item("UT")
  if not rsRibbons.bof then if rsRibbons.fields.item("UT") > lastUpdate then lastUpdate = rsRibbons.fields.item("UT")
  if not rsBackground.bof then if rsBackground.fields.item("UT") > lastUpdate then lastUpdate = rsBackground.fields.item("UT")
  
  kerbalUpdate = rsCrews.fields.item("Kerbal") & ";" & lastUpdate
  rsCrews.movenext
  if not rsCrews.eof and len(kerbalUpdate) then kerbalUpdate = kerbalUpdate & ":"
  response.write kerbalUpdate
loop

connCatalog.Close
Set connCatalog = nothing
if ref >= 0 then connCraft.Close
Set connCraft = nothing
conn.Close
Set conn = nothing
%>