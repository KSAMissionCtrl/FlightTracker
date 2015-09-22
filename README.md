# FlightTracker
A means of dynamically displaying craft information online for vessels in Kerbal Space Program

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

None

### Future Additions

* [FT] Further KSP.Leaflet integration (maneuver nodes, terminator view, etc)
* [FT] Hyperbolic orbital plotting
* [FT] Some form of integration with [OrbitViewer](http://www.astroarts.com/products/orbitviewer/index.html)?
* [FT] Interpolation/streaming of ascent data to allow for continuous updates rather than 15s intervals
* [CR] Roll-up text to give biographies for astronauts
* [CR] Link for pop-out window when viewing as a full page
* [CR] Menu for easier browsing between astronaut profiles

### Change Log

**v2.1** (9/22/15)

Fixes:
- Moved `<!DOCTYPE html>` tags to the very top of the documents where they belong
- Inactive Vessels listing now shows up properly in body.asp
- `formatTime` function was missing a semicolon statement end
- Next button, in the instance of having a next event, was still using a regular tooltip instead of tipped.js
- Orbital plotting now handles polar orbits much better
- A math error was causing the estimated orbital distance to be calculated incorrectly

Changes:
- New link for a better image map creation service
- body.asp now makes better use of tipped.js pop ups (hide on mouseover mainly)
- Number formatting used for some additional craft data displays that can now accomodate increased precision (Ap/Pe velocity, Avg Velocity, resource mass)
- Cleaned up and made slightly more robust the code that handles the type of static/dynamic map being displayed for the current event
- More widespread adoption of tipped.js tooltips, dynamically converting older tooltip use so dozens of records don't need to be modified
- Dynamic map won't show cursor location info (which comes up undefined) until the cursor is actually over the map for the first time

Additions:
- Dynamic maps for flags, can be displayed for any body via image map `<area>` having `id="flags"` and includes a special case for flags located around KSC
- Included documentation for the bodies and flags databases in body.asp
- Added an area at the top of the page in craft.asp and body.asp for showing debug information via JQuery
- Can page back through orbital states in the main Kerbol System and Inner Kerbol System views to see planets moving over time (less applicable to planets themselves, to which you can still link directly to certain times if needed)
- Image mapping tool used now linked in the footer for body.asp
- Viewport meta tag added to craft.asp to ensure proper page scaling
- Bodies that do not have dynamic maps (Kerbol, any added bodies) now show real-time orbital information in a text box
