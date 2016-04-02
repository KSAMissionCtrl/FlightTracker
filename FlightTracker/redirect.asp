<!DOCTYPE html>
<html>
<head>
<script>
function centeredPopup(url,winName,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no, status=no'
wnd = 'http://www.blade-edge.com/images/KSA/Flights/craft.asp?popout=true&r=true&db=' + 
window.open(url,'Flight Status',settings)
window.close()
}
</script>
</head>
<%
queryString = request.querystring("db")
if request.querystring("ut") then	queryString = queryString & "&ut=" & request.querystring("ut")
if request.querystring("pass") then	queryString = queryString & "&pass=" & request.querystring("pass")

if request.querystring("popout") then
  response.write("<body onload=""centeredPopup(")
  response.write("'http://www.kerbalspace.agency/Tracker/craft.asp?popout=true&db=" & querystring & "','myWindow','1160','890','no')")
  response.write(""">")
else
  response.redirect "http://www.kerbalspace.agency/Tracker/craft.asp?popout=false&db=" & querystring
end if 
%>
<center>
<table width="250px">
<tr>
  <td>
    <center><h2>Mobile User?</h2></center>
    <p>If the flight tracker did not load, then you are likely on a mobile device that could not load the pop-up window. If this is the case, you can still access the flight tracker as a regular page.</p>
    <p><center><%response.write("<a href='http://www.kerbalspace.agency/Tracker/craft.asp?popout=true&r=true&db=" & request.querystring("db") & "'>")%><b>Click/Tap Here</b></a></center></p>
    </td>
  </tr>
</table>
</center>
</body>
</html>