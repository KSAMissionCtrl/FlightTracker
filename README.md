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
* [kOS](https://github.com/KSP-KOS/KOS)

The following JavaScript libraries are used:

* [Leaflet](http://leafletjs.com/)
* [Sylvester](http://sylvester.jcoglan.com/)
* [Leaflet Label](https://github.com/Leaflet/Leaflet.label)
* [Numeral](http://numeraljs.com/)
* [Tipped](http://www.tippedjs.com/)
* [Codebird](https://github.com/jublonet/codebird-js)
* [Spin.js](http://fgnass.github.io/spin.js/)
* [iOSBadge.js](http://kristerkari.github.io/iOSBadge/)

Blank template MDB Access files are included for both crafts and rosters, as well as filled-in example databases.

### Getting Started

Basically you need to install the folders to your server and feed them a database to reference with `?db=[name]` appended to the URL pointing to either craft.asp, body.asp or roster.asp. The databases included in the Flight Tracker that are not labeled as examples are required to be present for the pages to load. Search the files for `db =` which is where the databases are opened and change the relative path to point to where you store your database tables if you don't want to keep them in the public directory. See the [current KSA Flight Tracker](http://bit.ly/FltTracker) to get an idea of how things work together.

### Known Issues

- [FT] Mobile Safari does not reset the drop-down list boxes on page unload, so using the Back button will have them still set to whatever was last selected
- [FT] Sketchfab model viewer does not autoplay when it is shown, nor does it stop when it is hidden unless manually stopped first. Sketchfab has already responded to us about some API extensions to allow us to do this eventually ([link](https://help.sketchfab.com/hc/en-us/articles/203509907-Share-Embed-Online))
- [FT] Captions cannot be automatically enabled when a video goes fullscreen on mobile devices. We've not found a way to get this to work
- [FT] There are actually two caption tracks, one for current event the second for the name, but apprently only one can be shown on iphone in fullscreen
- [FT] When left in the background for a while, the countdown timers for maneuver nodes both in the events box and the map pop-up fall way behind and don't ever catch up once focus is returned to the window, necessitating a refresh
- [FT] A slight gap is visible between orbital paths on the dynamic map where switching to the next orbit color
- [FT] Craft popups on ground maps are always 500px wide - despite this being set via a `maxWidth` property, Leaflet does not size down the popups when they contain content smaller than this width when this property is changed from default
- [FT] Update/New badges can be cutoff from the menu if the craft name is just long enough to not wrap and leave little room at the end of the line to show the badge
- [FT] Notification badges are too large in the menu and overlap. Smaller sizes are being looked into
- [FT] Hiding a video during archive playback makes it come back when the back seek arrow is used
- [CR] Going to an astronaut page from the full roster doesn't save filter settings
- [FT] *Chrome Only* scheduled events tooltip does not show up when the list item is hovered over
- [FT] *Chrome Only* launch video replays do not always load fully

### Future Additions

* [FT] Terminators for dynamic maps
* [FT] New sat/terrain/biome maps for OPM
* [FT] Updated biome maps for stock planets
* [FT] Ground tracking for rovers. Resolution of movement dependent on whether max zoom level can be increased
* [FT] 2-3 additional zoom levels for dynamic map
* [FT] note the number of crew aboard and use that to calculate in real-time the remaining duration for any included life support resources (need to decide what life support system to use first - USI or TAC)
* [FT/CR] back-end interface that allows creation/modification of records through the website when detecting the missionctrl cookie for updating craft and crew databases
* [FT] change the filters to check boxes to allow more than one to be selected at a time - default is they are all checked on page load - perhaps tag the craft type when building the menu and then use jQuery to hide the elements associated with the check boxes types. Save active filters as cookie, keep URL string for non-cookie users (add warning icon for non-cookie users)
* [FT] Bring back ability for reminder notification to persist across FT pages for non-cookie users
* [FT/CR] [push notifications](https://developer.mozilla.org/en-US/docs/Web/API/Push_API)?
* [FT] KSC map needs to be schedulable for updates, currently is hard-coded
* [FT] Allow for camera switches prior to launch
* [FT] Allow live launches to also hide the video
* [FT] `loc` URL variable shows a pin on the map w/caption, `center` focuses on a certain spot
* [FT] Cookie override for FPS setting when URL variable is modified by user
* [FT] Craft 2D image can have multiple angles to allow users to rotate the craft to view different sides
* [FT] see if for Kerbin "satellite" layer can be changed to "aerial"
* [CR] extended information in the tooltips on the Full Roster page
* [CR] twitter timelines for kerbals (extend crew recordset in catalog DB)
* [FT] Add information to the static orbit real-time display for maneuvers and SOI escapes, allow it to display maneuver telemetry
* [FT] Craft image can be image map
* [FT] option for non-satellite availablity for surface maps so places like Eve and Tekto can't have them due to perpetual cloud cover

### Change Log

**v3.0** (11/17/15)

Fixes:
- [FT] **Ground plots now handle map edges properly** - a much nicer algortithm now cuts off lines at the edge of the map in all instances before they wrap across to the other side and doesn't care if the craft is moving in a prograde or retrograde orbit
- [FT] **Time synched between JS and VBscript** - the methods used to get the time elapsed from a certain date in javascript and vbscript can return results that differ by as much as 20-30 seconds. The offset is now recorded on page load and applied throughout all operations involving calculated elapsed time, favoring the result given by vbscript's `dateDiff()`
- [FT] **Current event always recognized** - it is now properly recognized when coming from a past event to an event from the Next Event(s) list (`ut` query string included in the URL) whether this event is in fact the *current* event (the event you would get if you removed `ut` from the URL). This is important as before the flight tracker assumed any inclusion of `ut` in the URL was indication of viewing an event that occurred in the past
- [FT] `body.asp` now contains character encoding information
- [FT] Missing options `minZoom`, `maxZoom` and `zoom` added to all leaflet map initialization. Not only does this solve the problem where maps would fail to even render, the + zoom button will now grey out when max zoom is achieved
- [FT] Event calendar was incorrectly referencing the UT passed by URL querystring when available instead of the UT calculated for the current time, so it was showing past events
- [FT] Event calendar was setting `bLaunchCountdown` and `bManeuverCountdown` to `true` by default, is now properly defaulting to `false` and switching to `true` only when an upcoming event is displayed
- [FT] Viewport scaling removed to allow tablet/mobile devices to load the page from a more zoomed-out perspective
- [FT] `formatTime()` now uses the absolute value of any number passed to it to prevent errors where number is negative
- [FT] All JS functions shuffled about to be defined before they are called to play better with Chrome browsers
- [FT] VBscript now returns to proper error checking after it has tested for possibly-unsupported databse fields
- [FT] When viewing a past event that includes a launch time which was scrubbed, the actual launch time now finally properly displays in the tooltip as originally designed back in like v1.0
- [FT] Several JS variables that were not being properly set to default values and throwing reference errors because the ASP code that creates them did not execute due to a logical condition now have default values that are created regardless
- [FT] In some instances the Distance Traveled field would fail to show estimated distance
- [FT] Traveling to other crafts via the menu now properly preserves certain variables in the URL
- [FT] `latlon` was being referenced by index at times when it had no data
- [FT] Craft marker popup was displaying the same cardinal directions for both Lat and Lng
- [FT] Page no longer refreshes when the end of the orbit is reached if a maneuver node (which would end the orbit plot) just fired and instead waits for the next event to trigger a refresh

Changes:
- [FT] **Greater timer accuracy and monitoring** - using a method proposed online the code no longer uses `setInterval()` for timed callbacks but instead calls itself with `setTimeout()` after it has processed and monitors the time it took to carry out its operations and when it needs to call itself again to remain on time with whatever interval it is set for. This not only keeps things accurate when users are viewing the page, but if they tab off and the page's CPU priority is reduced, when they come back they will see things catch up to the current time
- [FT] **Quick event jumping** - The [<]Prev and Next[>] buttons that only went forward/backward a single event at a time have been replaced with drop-down list boxes that contain the *entire* history of the vessel to make it easier to go back in time for vessels that have been in operation for a while. Future-planned events and maneuvers are still implemented when available in the Next Event(s) drop-down list and shown via tooltip or if on a touchscreen via an alert. Any future-planned event is shown only when viewing the current event for that time, and not any past events
- [FT] **Asynchronous orbital data calculation** - Orbital data calculation is now wrapped in an inline function and batch-called every millisecond instead of run as a single loop. This takes slightly longer for large orbits but has the benefits of no longer locking up the browser entirely waiting for it to complete, shows a snazzy loading bar and makes it feasible to expose the option to render all 3 orbits for craft with very long (100,000s+) orbital periods
- [FT] Because the asynchronous batch loading of orbital data breaks the linear flow of the original JS loading code, `renderMap()` now exists to complete the loading of the map once the orbital data calculations have finished
- [FT]/[CR] Paths and URLs changed to point properly to new kerbalspace.agency domain and file structure. String replace also utilized to automatically change links pulled from DB
- [FT] Removed second footer line with obvious instructions from body overview page 
- [FT] Event calendar now displays "None Scheduled" when lacking a future event
- [FT] Text on landing page for mobile users attempting to view a popout has been updated to no longer say mobile devices are unsupported in controlling various aspects of the flight tracker
- [FT] Clock now shows UTC in the title instead of the time, as iOS devices were outputting the full month name instead of shorthand and causing a text wrap of the current time
- [FT] `formatTime()` can now optionally return seconds with 5 significant digits (00.000) instead of a whole number
- [FT] Fancy JQuery fade events are now rampantly applied across the entire page to show/hide pretty much everything that needs to be shown and hidden including notification boxes, the map lat/lng key (now only visible when the cursor is over the map), the dynamic map itself, and more
- [FT] The page will not auto-update to a new event if the user is viewing a past event under the assumption that the user is purposely on that past event for a reason and wants to stay there
- [FT] Documentation updated for all recordsets
- [FT] The page title now includes the craft name and current event title
- [FT] The values for deltaV and vessel mass can now be ommitted from the database fields and the page will display 0
- [FT] The communication signal delay is now formatted into yy:dd:hh:mm:ss.ms instead of displaying raw seconds
- [FT] The ImgDataCode field no longer has to remain empty to trigger an ascent telemetry event, as it can hold the size information for the three HTML5 video files. It must still remain empty to load older ascent telemetry
- [FT] The note that appeared below the Inactive Vessels menu is now in a tooltip cited next to the menu header
- [FT] Vessel template DB now contains new ascent data table

Additions:
- [FT] **Real-time video and telemetry streaming** - this deprecates the original launch telemetry functionality that auto-updated the entire page every 15s with new data (still viewable on older craft). Now, the page stays loaded and JQuery updates telemetry data, which is initially read from a database that contains values for a set interval (0.5s, 1s, 5s, whatever) and then linear interpolation fills in the rest to be played back at up to 30FPS. FPS throttling allows the page to lower the FPS if it detects the launch time is falling behind real time, keeping older devices in sync during live launch streams. Video can be created to load at any point before the launch and play through to any point during the launch and supports all three major HTML5 formats. Video captions are supplied for devices that cannot play video inline. Mobile/tablet users are warned of the video size they will need to download. Once a launch occurs it can be viewed again in archive mode that allows the ability to seek through the telemetry data. A post-launch survey collects user data and feedback to help improve the system. During a live launch the main twitter timeline will be displayed so tweets pushed out during the launch are shown (within 30s) and users can interact directly through the widget
- [FT] **Sketchfab model viewer support** - unfortunately this is a very premature feature as the Sketchfab KSP exporter remains in beta status at the time of this release and is not capable of handling modded craft files very well. Where avaiable, the Sketchfab icon will appear over the craft description box and allow the user to switch between the 2D image/description and the 3D model viewer. The craft model can also change from event to event as the craft changes configuration
- [FT] **Dynamic pre-launch map** - the event prior to launch telemetry can now hold a dynamic map that shows the location of the launch site as well as basic information about it
- [FT] ASP check for mobile browsers
- [FT] Codebird.js allows the flight tracker to send automated tweets
- [FT] Spin.js allows the flight tracker to show custom loading spinners where needed
- [FT] `craft.asp` now initially loads loads all the time with a background "loading" image that is then removed via JQuery when all the heavy ASP processing at the top of the page is completed (mainly seen during launch telemetry interpolation)
- [FT] OS and browser information is now collected and made available to JS to enable/disable functionality of certain features not globally supported
- [FT] If there is a launch scheduled in the event calendar and the user is on another craft page or looking at an older craft entry an alert box will pop up 5-mins prior to the launch to give the user the option to jump to the craft page of the launching vehicle
- [FT] A new auto-refresh check now reloads the page to re-render the map when new orbital data is detected
- [FT] A tooltip can show up for launch and maneuver events if a description has been added to them, providing quick information about the event
- [FT] A sample Excel spreadsheet is included showing telemetry data

**v2.4** (9/30/15)

Fixes:
- [FT] `origMET` now always contains a value so it doesn't end up breaking js when it's assigned in situations where no launch time is defined (TBD launch dates)
- [FT] Use of `on error resume next` was causing unintended fall-through of logic code such that future event description text was being accompanied by "Click to View Maneuver Node" even when no node was linked. Lack of short-circuit logic in VBScript necessitated a further nesting of the code logic. Also added an `else` branch that was missing for in the event of no future maneuver node
- [FT] Sending the absolute value to `formatDate()` now for the case of updating countdown timers, which have negative `MET` values

Changes:
- [FT] Flight Template.mdb now contains the new `NodeLink` field introduced in v2.3
- [FT] Removed "example" from databases that are required by body/craft.asp to actually function. Kept in all records to let people see what's doing what and hopefully not cause any horrendous errors out of the box when setting things up
- [FT] body.asp now too contains and uses the `formatTime` routine, which has also been modified in craft.asp to display a leading 0 for single-digit seconds. This will prevent a small glitch where if the user is looking at an open tooltip that counts from single to double digits the tooltip will not expand and the seconds will wrap down below (outside) the tooltip
- [FT] `drawMap` has been replaced by `MapState` which provides a much clearer understanding of what the area below the craft image and stats is being used for. Also removes the possibility of the HTML string that was before being plugged into `drawMap` contianing double quotes and breaking out early from the js assignment operation causing an end of line error
- [FT] Pulled the js definition of `UT` out into the main body of the map drawing code because otherwise it was coming up undefined in sitautions that didn't involve orbital plotting and thus killing js execution
- [FT] The check for whether the code should be updating map data every second was over complex and was simplified with the new `MapState` variable
- [FT] Moved code checking the state of AP/PE and maneuver node markers every second inside the section that only runs if a dynamic map has been drawn

Additions:
- [FT] A new routine `toTZString` in body.asp will convert UTC time to a specified time zone so anyone visiting will see the same time displayed on the KSC clock
- [FT] A clock now shows the local KSC time, auto-adjusts for daylight savings and updates every second
- [FT] A new events database allows for displaying the next launch and/or maneuver on *every* craft/body page so that anyone visiting the flight tracker will see what is upcoming. These events link to the craft page in question. In the case of maneuvers, when the craft page is loaded if the node is visible on the map it will automatically be shown after the craft popup closes. Otherwise a notice will display to let the user know it's not yet visible. The page will also auto refresh if no launch or maneuver is currently available but a later-scheduled one comes up

**v2.3** (9/29/15)

Fixes:
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
