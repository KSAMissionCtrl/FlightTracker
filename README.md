# FlightTracker
A means of dynamically displaying craft information online for vessels in Kerbal Space Program

These files use a mix of HTML, JavaScript, JQuery and ASP with MSAccess dtabases to create a dynamic page to allow users to browse various craft a player has in KSP to see very specific details about the vessel, including resources, orbital information, crew members, etc. This provides a way to create persistence for any KSP role-play.

Included also is the code for displaying crew rosters that let people find out more information about the astronauts that make up your space program.

The Flight Tracker is fully compaitble with touchscreens on mobile devices.

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

**Known Issues**

None

**Future Additions**

* [FT] Further KSP.Leaflet integration (maneuver nodes, map markers for Flags, etc)
* [FT] Hyperbolic orbital plotting
* [FT] Data overlays for bodies not supported by KSP.Leaflet
* [FT] Some form of integration with [OrbitViewer](http://www.astroarts.com/products/orbitviewer/index.html)?
* [FT] Interpolation of ascent data to allow for continuous streaming rather than 15s update intervals
* [CR] Roll-up text to give biographies for astronauts
* [CR] Link for pop-out window when viewing as a full page
