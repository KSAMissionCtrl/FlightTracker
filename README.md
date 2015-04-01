# FlightTracker
A means of dynamically displaying craft information online for vessels in Kerbal Space Program

These files use a mix of HTML, JavaScript and ASP with MSAccess dtabases to create a dynamic page to allow users to browse various craft a player has in KSP to see very specific details about the vessel, including resources, orbital information, crew members, etc. This provides a way to create persistence for any KSP role-play.

Included also is the code for displaying crew rosters that let people find out more information about the astronauts that make up your space program.

The following mods/apps are used to provide the data the Flight Tracker and Crew Roster require:

* [KSPTOT](http://forum.kerbalspaceprogram.com/threads/36476-WIN-KSP-Trajectory-Optimization-Tool-v0-12-2-Mission-Architect-Update!)
* [Final Frontier](http://forum.kerbalspaceprogram.com/threads/67246)
* [VOID](http://forum.kerbalspaceprogram.com/threads/54533-0-23-VOID-Vessel-Orbital-Informational-Display)
* [FAR](http://forum.kerbalspaceprogram.com/threads/20451-0-23-Ferram-Aerospace-Research-v0-12-5-2-Aero-Fixes-For-Planes-Rockets-1-7-14)

Blank template MDB Access files are included for both crafts and rosters, as well as filled-in example databases.

Simply install the folders to your server and feed them a database to reference with `?db=[name]` appended to the URL pointing to either craft.asp or roster.asp

**Known Issues**

None

**Future Additions**

* [FT] Real-time orbital path display with [Leaflet.KSP](https://github.com/saik0/Leaflet.KSP) (also for displaying rover and ascent tracks)
* [FT] Some form of integration with [OrbitViewer](http://www.astroarts.com/products/orbitviewer/index.html)?
* [FT] Filtering the vessels menu by various craft types
* [FT] Allowing the vessels menu to switch between active and inactive vessels
* [FT] Interpolation of ascent data to allow for continuous streaming rather than 15s update intervals
* [CR] Roll-up text to give biographies for astronauts
* [CR] Link for pop-out window when viewing as a full page
