<%
response.expires=-1

if len(request.querystring("parts")) = 0 then
  response.write("!")
else

  'open catalog database. "db" was prepended because without it for some reason I had trouble connecting
  db = "..\..\database\dbCatalog.mdb"
  Dim connCatalog
  Set connCatalog = Server.CreateObject("ADODB.Connection")
  sConnection2 = "Provider=Microsoft.Jet.OLEDB.4.0;" & _

                "Data Source=" & server.mappath(db) &";" & _

                "Persist Security Info=False"
  connCatalog.Open(sConnection2)

  'create the tables
  set rsParts = Server.CreateObject("ADODB.recordset")

  'query the data, ensure that bookmarking is enabled
  rsParts.open "select * from parts", connCatalog, 1, 1
  
  if rsParts.bof then
    response.write("!")
  else

    'get the parts we are pulling info for
    parts = split(request.querystring("parts"), ",")
    
    'find and return the part details
    partData = ""
    for each part in parts
    
      'get the record containing the information relative to this vessel
      rsParts.find("part='" & part & "'")
      partData = partData & part & "~" & rsParts.fields.item("html") & "|"

      'reset for the next go around
      rsParts.movefirst
    next
  end if
  
  'clean up and post the data
  partData = left(partData, len(partData) - 1)
  response.write partData
  
  connCatalog.Close
  Set connCatalog = nothing
end if
%>