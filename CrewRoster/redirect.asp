<!DOCTYPE html>
<html>
<head>
<script>
function centeredPopup(url,winName,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no, status=no'
wnd = 'http://www.blade-edge.com/images/KSA/Roster/roster.asp?db=' + 
window.open(url,'Flight Status',settings)
window.close()
}
</script>
</head>
<%response.write("<body onload=""centeredPopup(")
response.write("'http://www.kerbalspace.agency/Roster/roster.asp?db=" & request.querystring("db") & "','myWindow','800','625','no')")
response.write(""">")%>
<center>
<table width="250px">
<tr>
  <td>
    <center><h2>Mobile User?</h2></center>
    <p>If the crew roster did not load, then you are likely on a mobile device that could not load the pop-up window. If this is the case, you can still access the crew roster as a regular page.</p>
    <p><center><%response.write("<a href='http://www.kerbalspace.agency/Roster/roster.asp?db=" & request.querystring("db") & "'>")%><b>Click/Tap Here</b></a></center></p>
    <p>Please note that touchscreen users will not have full capability of the roster, which uses pop-up text info boxes when a mouse cursor is hovered over some elements. However, you can still tap/hold to bring up image text with additional information.</p>
    </td>
  </tr>
</table>
</center>
</body>
</html>