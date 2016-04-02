<%
response.expires=-1

'open vessel database. "db" was prepended because without it for some reason I had trouble connecting
on error resume next
db = "..\..\database\db" & request.querystring("db") & ".mdb"
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
  set rsOrbit = Server.CreateObject("ADODB.recordset")
  set rsCraft = Server.CreateObject("ADODB.recordset")

  'query the data
  rsOrbit.open "select * from [flight data]", connCraft, 2
  rsCraft.open "select * from [craft data]", connCraft, 2

  'calculate the time in seconds since epoch 0 when the game started
  UT = datediff("s", "16-Feb-2014 00:00:00", now())

  'starting from the end, work back to find the first record earlier than or equal to the UT we are looking for
  if not rsCraft.eof then
    rsCraft.MoveLast
    do until rsCraft.fields.item("id") <= UT
      rsCraft.MovePrevious
    Loop
  end if
  if not rsOrbit.eof then
    rsOrbit.MoveLast
    do until rsOrbit.fields.item("id") <= UT
      rsOrbit.MovePrevious
    Loop
  end if

  'fetch and return the data
  orbitData = rsOrbit.fields.item("Eccentricity")
  orbitData = orbitData & ";" & rsOrbit.fields.item("Inclination")
  orbitData = orbitData & ";" & rsOrbit.fields.item("Orbital Period")
  orbitData = orbitData & ";" & rsOrbit.fields.item("SMA")
  orbitData = orbitData & ";" & rsOrbit.fields.item("RAAN")
  orbitData = orbitData & ";" & rsOrbit.fields.item("Arg")
  orbitData = orbitData & ";" & rsOrbit.fields.item("Mean")
  orbitData = orbitData & ";" & rsOrbit.fields.item("Eph")
  orbitData = orbitData & ";" & rsCraft.fields.item("CraftName")

  'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\database\dbCatalog.mdb"
  Dim connCatalog
  Set connCatalog = Server.CreateObject("ADODB.Connection")
  sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  connCatalog.Open(sConnection2)

  'create the tables
  set rsCrafts = Server.CreateObject("ADODB.recordset")

  'query the data, ensure that bookmarking is enabled
  rsCrafts.open "select * from crafts", connCatalog, 1, 1

  'get the record containing the information relative to this vessel
  rsCrafts.find("db='" & request.querystring("db") & "'")
  orbitData = orbitData & ";" & rsCrafts.fields.item("Type")
  
  'post the data
  response.write orbitData
end if

connCraft.Close
Set connCraft = nothing
connCatalog.Close
Set connCatalog = nothing
%>