# FlightTracker & Crew Roster
A means of dynamically displaying craft & crew information online for vessels in Kerbal Space Program

These files use a mix of HTML, JavaScript, JQuery and ASP with MSAccess dtabases to create a dynamic page to allow users to browse various craft a player has in KSP to see very specific details about the vessel, including resources, orbital information, crew members, etc. This provides a way to create persistence for any KSP role-play.

Included also is the code for displaying crew rosters that let people find out more information about the astronauts that make up your space program.

The Flight Tracker is fully compatible with touchscreens on mobile devices.

The following mods/apps are used to provide the data the Flight Tracker and Crew Roster require:

* [KSPTOT](http://forum.kerbalspaceprogram.com/threads/36476-WIN-KSP-Trajectory-Optimization-Tool-v0-12-2-Mission-Architect-Update!)
* [Final Frontier](http://forum.kerbalspaceprogram.com/threads/67246)
* [VOID](http://forum.kerbalspaceprogram.com/threads/54533-0-23-VOID-Vessel-Orbital-Informational-Display)
* [FAR](http://forum.kerbalspaceprogram.com/threads/20451-0-23-Ferram-Aerospace-Research-v0-12-5-2-Aero-Fixes-For-Planes-Rockets-1-7-14)

The following JavaScript libraries are used:

* [Leaflet](http://leafletjs.com/)
* [Sylvester](http://sylvester.jcoglan.com/)
* [Leaflet Label](https://github.com/Leaflet/Leaflet.label)
* [Numeral](http://numeraljs.com/)
* [Tipped](http://www.tippedjs.com/)

Blank template MDB Access files are included for both crafts and rosters, as well as filled-in example databases.

Simply install the folders to your server and feed them a database to reference with `?db=[name]` appended to the URL pointing to either craft.asp or roster.asp

### Known Issues

* For some reason, in the `setTimeout` call that withholds display of the map, no code will execute past `if (showMsg) { $("#msg").css("visibility", "visible"); }` within the function

### Future Additions

* [FT] Further KSP.Leaflet integration (terminator view, etc)
* [FT] Hyperbolic orbital plotting
* [FT] Some form of integration with [OrbitViewer](http://www.astroarts.com/products/orbitviewer/index.html)?
* [FT] Interpolation/streaming of ascent data to allow for continuous updates rather than 15s intervals
* [FT] Embedded Sketchfab rendering of vessel to display in addition to static vessel image (static will be fallback and switchable like the static orbits)
* [CR] Roll-up text to give biographies for astronauts
* [CR] Link for pop-out window when viewing as a full page
* [CR] Menu for easier browsing between astronaut profiles (with sort options for rank, status, mission)

### Change Log

**v2.3** (9/29/15)

Fixes:
- [FT] Bad link in redirect.asp for popout windows was loading an older test version of craft.asp
- [FT] Maneuver node update code now tracks time & counts down properly
- [FT] The JQuery code to update the map craft marker was left outside the `if` case testing whether the map was even drawn on the page

Changes:
- [CR] Ribbon box can now properly display empty if no ribbons are yet awarded to the astronaut
- [FT] body.asp now handles tooltips the same way craft.asp does, where mousing over them when moving off the element they are anchored to will close them and where tooltip closing action depends on touch support
- [FT] Menu tooltips for planets and moons now show up to the right, since names will never be too long
- [FT] Menu tootlips for vessels are now aligned with the vessel icon, and have a max width so they do not extend out past the edge of the menu, also allowing for more verbose vessel descriptions to be shown
- [FT] Moved the map delayed-show `setTimeout` call out of the body header and down past the orbital calculation code, so that any delay caused by a lengthy calculation of a long orbit doesn't affect the timer. This also has the added benefit of allowing the map to show with the craft tooltip displaying actual data and not the default values used when the popup is first created
- [FT] Switched to a better method of determining whether or not a recordset contains a certain field by using `On Error Resume Next` now that it's necessary to check for more than one additional field
- [FT] Updated documentation for the Craft Data recordset
- [FT] Removed uneccesary code for tooltip addition to the Next> image that would never be executed anyways
- [FT] Un-tabified all source files so they show up better and more consistently in Github
- [FT] Craft info box now only stays open 5s after map is shown instead of 10
- [FT] Code updating the craft vessel marker location is now properly placed with the rest of the craft data update code
- [FT] When drawing orbits, if a visible maneuver node is detected the map will terminate orbit rendering at the node and not draw any orbital lines after that
- [FT] Event callback added to maneuver node map object so the popup updates immediately when it is opened instead of waiting for the global update tick
- [FT] When the vessel marker reaches a maneuver node on the map, the node is removed, the vessel marker no longer updates and opens its popup to inform the user an automatic update will happen shortly with new data

Additions:
- [FT] A link to the Github source code is now included in the footer of both craft and body pages
- [FT] Future event descriptions can now link to future maneuver nodes with a new field `NodeLink` in the Craft Data recordset. When this is done, if the maneuver node is visible on the map the Next> event link will allow the user to click it, which will display the maneuver node popup, thus locating it on the map

**v2.2** (9/26/15)

Fixes:
- [FT] Incorrect path for popout link called an old orbital test script instead of the current craft page

Changes:
- [FT] Moved `now` and `currDate` outside of the map-loaded-only code so anything can access them in the update function
- [FT] URL query string refresh code completely removed (breaks auto-refresh of ascent data but future launches will use js update anyways)
- [FT] Auto-refresh enable/disable link removed

Additions:
- [FT] Documentation for the new Flightplan recordset that contains maneuver node information
- [FT] Maneuver nodes can now be displayed on the dynamic map, will only show up if visible along the currently-drawn orbit(s)
- [FT] Instead of a preset timer to refresh the page, smart page refresh will now reload the page when either [1] the craft marker reaches the end of the currently-drawn orbit(s)  [2] a maneuver node becomes visible along the orbit(s)  [3] the next scheduled event occurs

**v2.1** (9/22/15)

Fixes:
- [FT] Moved `<!DOCTYPE html>` tags to the very top of the documents where they belong
- [FT] Inactive Vessels listing now shows up properly in body.asp
- [FT] `formatTime` function was missing a semicolon statement end
- [FT] Next button, in the instance of having a next event, was still using a regular tooltip instead of tipped.js
- [FT] Orbital plotting now handles polar orbits much better
- [FT] A math error was causing the estimated orbital distance to be calculated incorrectly

Changes:
- [FT] New link for a better image map creation service
- [FT] body.asp now makes better use of tipped.js pop ups (hide on mouseover mainly)
- [FT] Number formatting used for some additional craft data displays that can now accomodate increased precision (Ap/Pe velocity, Avg Velocity, resource mass)
- [FT] Cleaned up and made slightly more robust the code that handles the type of static/dynamic map being displayed for the current event
- [FT] More widespread adoption of tipped.js tooltips, dynamically converting older tooltip use so dozens of records don't need to be modified
- [FT] Dynamic map won't show cursor location info (which comes up undefined) until the cursor is actually over the map for the first time

Additions:
- [FT] Dynamic maps for flags, can be displayed for any body via image map `<area>` having `id="flags"` and includes a special case for flags located around KSC
- [FT] Included documentation for the bodies and flags databases in body.asp
- [FT] Added an area at the top of the page in craft.asp and body.asp for showing debug information via JQuery
- [FT] Can page back through orbital states in the main Kerbol System and Inner Kerbol System views to see planets moving over time (less applicable to planets themselves, to which you can still link directly to certain times if needed)
- [FT] Image mapping tool used now linked in the footer for body.asp
- [FT] Viewport meta tag added to craft.asp to ensure proper page scaling
- [FT] Bodies that do not have dynamic maps (Kerbol, any added bodies) now show real-time orbital information in a text box
