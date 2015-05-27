(function(t, e, i) {
    var n, o;
    typeof exports != i + "" ? n = exports : (o = t.L, n = {}, n.noConflict = function() {
            return t.L = o, this
        }, t.L = n), n.version = "0.5.1", n.Util = {
            extend: function(t) {
                var e, i, n, o, s = Array.prototype.slice.call(arguments, 1);
                for (i = 0, n = s.length; n > i; i++) {
                    o = s[i] || {};
                    for (e in o) o.hasOwnProperty(e) && (t[e] = o[e])
                }
                return t
            },
            bind: function(t, e) {
                var i = arguments.length > 2 ? Array.prototype.slice.call(arguments, 2) : null;
                return function() {
                    return t.apply(e, i || arguments)
                }
            },
            stamp: function() {
                var t = 0,
                    e = "_leaflet_id";
                return function(i) {
                    return i[e] = i[e] || ++t, i[e]
                }
            }(),
            limitExecByInterval: function(t, e, n) {
                var o, s;
                return function a() {
                    var r = arguments;
                    return o ? (s = !0, i) : (o = !0, setTimeout(function() {
                        o = !1, s && (a.apply(n, r), s = !1)
                    }, e), t.apply(n, r), i)
                }
            },
            falseFn: function() {
                return !1
            },
            formatNum: function(t, e) {
                var i = Math.pow(10, e || 5);
                return Math.round(t * i) / i
            },
            splitWords: function(t) {
                return t.replace(/^\s+|\s+$/g, "").split(/\s+/)
            },
            setOptions: function(t, e) {
                return t.options = n.extend({}, t.options, e), t.options
            },
            getParamString: function(t, e) {
                var i = [];
                for (var n in t) t.hasOwnProperty(n) && i.push(n + "=" + t[n]);
                return (e && -1 !== e.indexOf("?") ? "&" : "?") + i.join("&")
            },
            template: function(t, e) {
                return t.replace(/\{ *([\w_]+) *\}/g, function(t, i) {
                    var n = e[i];
                    if (!e.hasOwnProperty(i)) throw Error("No value provided for variable " + t);
                    return n
                })
            },
            isArray: function(t) {
                return "[object Array]" === Object.prototype.toString.call(t)
            },
            emptyImageUrl: "data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs="
        },
        function() {
            function e(e) {
                var i, n, o = ["webkit", "moz", "o", "ms"];
                for (i = 0; o.length > i && !n; i++) n = t[o[i] + e];
                return n
            }

            function o(e) {
                var i = +new Date,
                    n = Math.max(0, 16 - (i - s));
                return s = i + n, t.setTimeout(e, n)
            }
            var s = 0,
                a = t.requestAnimationFrame || e("RequestAnimationFrame") || o,
                r = t.cancelAnimationFrame || e("CancelAnimationFrame") || e("CancelRequestAnimationFrame") || function(e) {
                    t.clearTimeout(e)
                };
            n.Util.requestAnimFrame = function(e, s, r, h) {
                return e = n.bind(e, s), r && a === o ? (e(), i) : a.call(t, e, h)
            }, n.Util.cancelAnimFrame = function(e) {
                e && r.call(t, e)
            }
        }(), n.extend = n.Util.extend, n.bind = n.Util.bind, n.stamp = n.Util.stamp, n.setOptions = n.Util.setOptions, n.Class = function() {}, n.Class.extend = function(t) {
            var e = function() {
                    this.initialize && this.initialize.apply(this, arguments), this._initHooks && this.callInitHooks()
                },
                i = function() {};
            i.prototype = this.prototype;
            var o = new i;
            o.constructor = e, e.prototype = o;
            for (var s in this) this.hasOwnProperty(s) && "prototype" !== s && (e[s] = this[s]);
            t.statics && (n.extend(e, t.statics), delete t.statics), t.includes && (n.Util.extend.apply(null, [o].concat(t.includes)), delete t.includes), t.options && o.options && (t.options = n.extend({}, o.options, t.options)), n.extend(o, t), o._initHooks = [];
            var a = this;
            return o.callInitHooks = function() {
                if (!this._initHooksCalled) {
                    a.prototype.callInitHooks && a.prototype.callInitHooks.call(this), this._initHooksCalled = !0;
                    for (var t = 0, e = o._initHooks.length; e > t; t++) o._initHooks[t].call(this)
                }
            }, e
        }, n.Class.include = function(t) {
            n.extend(this.prototype, t)
        }, n.Class.mergeOptions = function(t) {
            n.extend(this.prototype.options, t)
        }, n.Class.addInitHook = function(t) {
            var e = Array.prototype.slice.call(arguments, 1),
                i = "function" == typeof t ? t : function() {
                    this[t].apply(this, e)
                };
            this.prototype._initHooks = this.prototype._initHooks || [], this.prototype._initHooks.push(i)
        };
    var s = "_leaflet_events";
    n.Mixin = {}, n.Mixin.Events = {
            addEventListener: function(t, e, i) {
                var o, a, r, h = this[s] = this[s] || {};
                if ("object" == typeof t) {
                    for (o in t) t.hasOwnProperty(o) && this.addEventListener(o, t[o], e);
                    return this
                }
                for (t = n.Util.splitWords(t), a = 0, r = t.length; r > a; a++) h[t[a]] = h[t[a]] || [], h[t[a]].push({
                    action: e,
                    context: i || this
                });
                return this
            },
            hasEventListeners: function(t) {
                return s in this && t in this[s] && this[s][t].length > 0
            },
            removeEventListener: function(t, e, i) {
                var o, a, r, h, l, u = this[s];
                if ("object" == typeof t) {
                    for (o in t) t.hasOwnProperty(o) && this.removeEventListener(o, t[o], e);
                    return this
                }
                for (t = n.Util.splitWords(t), a = 0, r = t.length; r > a; a++)
                    if (this.hasEventListeners(t[a]))
                        for (h = u[t[a]], l = h.length - 1; l >= 0; l--) e && h[l].action !== e || i && h[l].context !== i || h.splice(l, 1);
                return this
            },
            fireEvent: function(t, e) {
                if (!this.hasEventListeners(t)) return this;
                for (var i = n.extend({
                        type: t,
                        target: this
                    }, e), o = this[s][t].slice(), a = 0, r = o.length; r > a; a++) o[a].action.call(o[a].context || this, i);
                return this
            }
        }, n.Mixin.Events.on = n.Mixin.Events.addEventListener, n.Mixin.Events.off = n.Mixin.Events.removeEventListener, n.Mixin.Events.fire = n.Mixin.Events.fireEvent,
        function() {
            var o = !!t.ActiveXObject,
                s = o && !t.XMLHttpRequest,
                a = o && !e.querySelector,
                r = navigator.userAgent.toLowerCase(),
                h = -1 !== r.indexOf("webkit"),
                l = -1 !== r.indexOf("chrome"),
                u = -1 !== r.indexOf("android"),
                c = -1 !== r.search("android [23]"),
                _ = typeof orientation != i + "",
                d = t.navigator && t.navigator.msPointerEnabled && t.navigator.msMaxTouchPoints,
                p = "devicePixelRatio" in t && t.devicePixelRatio > 1 || "matchMedia" in t && t.matchMedia("(min-resolution:144dpi)") && t.matchMedia("(min-resolution:144dpi)").matches,
                m = e.documentElement,
                f = o && "transition" in m.style,
                g = "WebKitCSSMatrix" in t && "m11" in new t.WebKitCSSMatrix,
                v = "MozPerspective" in m.style,
                y = "OTransition" in m.style,
                L = !t.L_DISABLE_3D && (f || g || v || y),
                P = !t.L_NO_TOUCH && function() {
                    var t = "ontouchstart";
                    if (d || t in m) return !0;
                    var i = e.createElement("div"),
                        n = !1;
                    return i.setAttribute ? (i.setAttribute(t, "return;"), "function" == typeof i[t] && (n = !0), i.removeAttribute(t), i = null, n) : !1
                }();
            n.Browser = {
                ie: o,
                ie6: s,
                ie7: a,
                webkit: h,
                android: u,
                android23: c,
                chrome: l,
                ie3d: f,
                webkit3d: g,
                gecko3d: v,
                opera3d: y,
                any3d: L,
                mobile: _,
                mobileWebkit: _ && h,
                mobileWebkit3d: _ && g,
                mobileOpera: _ && t.opera,
                touch: P,
                msTouch: d,
                retina: p
            }
        }(), n.Point = function(t, e, i) {
            this.x = i ? Math.round(t) : t, this.y = i ? Math.round(e) : e
        }, n.Point.prototype = {
            clone: function() {
                return new n.Point(this.x, this.y)
            },
            add: function(t) {
                return this.clone()._add(n.point(t))
            },
            _add: function(t) {
                return this.x += t.x, this.y += t.y, this
            },
            subtract: function(t) {
                return this.clone()._subtract(n.point(t))
            },
            _subtract: function(t) {
                return this.x -= t.x, this.y -= t.y, this
            },
            divideBy: function(t) {
                return this.clone()._divideBy(t)
            },
            _divideBy: function(t) {
                return this.x /= t, this.y /= t, this
            },
            multiplyBy: function(t) {
                return this.clone()._multiplyBy(t)
            },
            _multiplyBy: function(t) {
                return this.x *= t, this.y *= t, this
            },
            round: function() {
                return this.clone()._round()
            },
            _round: function() {
                return this.x = Math.round(this.x), this.y = Math.round(this.y), this
            },
            floor: function() {
                return this.clone()._floor()
            },
            _floor: function() {
                return this.x = Math.floor(this.x), this.y = Math.floor(this.y), this
            },
            distanceTo: function(t) {
                t = n.point(t);
                var e = t.x - this.x,
                    i = t.y - this.y;
                return Math.sqrt(e * e + i * i)
            },
            equals: function(t) {
                return t.x === this.x && t.y === this.y
            },
            toString: function() {
                return "Point(" + n.Util.formatNum(this.x) + ", " + n.Util.formatNum(this.y) + ")"
            }
        }, n.point = function(t, e, i) {
            return t instanceof n.Point ? t : n.Util.isArray(t) ? new n.Point(t[0], t[1]) : isNaN(t) ? t : new n.Point(t, e, i)
        }, n.Bounds = function(t, e) {
            if (t)
                for (var i = e ? [t, e] : t, n = 0, o = i.length; o > n; n++) this.extend(i[n])
        }, n.Bounds.prototype = {
            extend: function(t) {
                return t = n.point(t), this.min || this.max ? (this.min.x = Math.min(t.x, this.min.x), this.max.x = Math.max(t.x, this.max.x), this.min.y = Math.min(t.y, this.min.y), this.max.y = Math.max(t.y, this.max.y)) : (this.min = t.clone(), this.max = t.clone()), this
            },
            getCenter: function(t) {
                return new n.Point((this.min.x + this.max.x) / 2, (this.min.y + this.max.y) / 2, t)
            },
            getBottomLeft: function() {
                return new n.Point(this.min.x, this.max.y)
            },
            getTopRight: function() {
                return new n.Point(this.max.x, this.min.y)
            },
            getSize: function() {
                return this.max.subtract(this.min)
            },
            contains: function(t) {
                var e, i;
                return t = "number" == typeof t[0] || t instanceof n.Point ? n.point(t) : n.bounds(t), t instanceof n.Bounds ? (e = t.min, i = t.max) : e = i = t, e.x >= this.min.x && i.x <= this.max.x && e.y >= this.min.y && i.y <= this.max.y
            },
            intersects: function(t) {
                t = n.bounds(t);
                var e = this.min,
                    i = this.max,
                    o = t.min,
                    s = t.max,
                    a = s.x >= e.x && o.x <= i.x,
                    r = s.y >= e.y && o.y <= i.y;
                return a && r
            },
            isValid: function() {
                return !(!this.min || !this.max)
            }
        }, n.bounds = function(t, e) {
            return !t || t instanceof n.Bounds ? t : new n.Bounds(t, e)
        }, n.Transformation = function(t, e, i, n) {
            this._a = t, this._b = e, this._c = i, this._d = n
        }, n.Transformation.prototype = {
            transform: function(t, e) {
                return this._transform(t.clone(), e)
            },
            _transform: function(t, e) {
                return e = e || 1, t.x = e * (this._a * t.x + this._b), t.y = e * (this._c * t.y + this._d), t
            },
            untransform: function(t, e) {
                return e = e || 1, new n.Point((t.x / e - this._b) / this._a, (t.y / e - this._d) / this._c)
            }
        }, n.DomUtil = {
            get: function(t) {
                return "string" == typeof t ? e.getElementById(t) : t
            },
            getStyle: function(t, i) {
                var n = t.style[i];
                if (!n && t.currentStyle && (n = t.currentStyle[i]), (!n || "auto" === n) && e.defaultView) {
                    var o = e.defaultView.getComputedStyle(t, null);
                    n = o ? o[i] : null
                }
                return "auto" === n ? null : n
            },
            getViewportOffset: function(t) {
                var i, o = 0,
                    s = 0,
                    a = t,
                    r = e.body,
                    h = n.Browser.ie7;
                do {
                    if (o += a.offsetTop || 0, s += a.offsetLeft || 0, o += parseInt(n.DomUtil.getStyle(a, "borderTopWidth"), 10) || 0, s += parseInt(n.DomUtil.getStyle(a, "borderLeftWidth"), 10) || 0, i = n.DomUtil.getStyle(a, "position"), a.offsetParent === r && "absolute" === i) break;
                    if ("fixed" === i) {
                        o += r.scrollTop || 0, s += r.scrollLeft || 0;
                        break
                    }
                    a = a.offsetParent
                } while (a);
                a = t;
                do {
                    if (a === r) break;
                    o -= a.scrollTop || 0, s -= a.scrollLeft || 0, n.DomUtil.documentIsLtr() || !n.Browser.webkit && !h || (s += a.scrollWidth - a.clientWidth, h && "hidden" !== n.DomUtil.getStyle(a, "overflow-y") && "hidden" !== n.DomUtil.getStyle(a, "overflow") && (s += 17)), a = a.parentNode
                } while (a);
                return new n.Point(s, o)
            },
            documentIsLtr: function() {
                return n.DomUtil._docIsLtrCached || (n.DomUtil._docIsLtrCached = !0, n.DomUtil._docIsLtr = "ltr" === n.DomUtil.getStyle(e.body, "direction")), n.DomUtil._docIsLtr
            },
            create: function(t, i, n) {
                var o = e.createElement(t);
                return o.className = i, n && n.appendChild(o), o
            },
            disableTextSelection: function() {
                e.selection && e.selection.empty && e.selection.empty(), this._onselectstart || (this._onselectstart = e.onselectstart || null, e.onselectstart = n.Util.falseFn)
            },
            enableTextSelection: function() {
                e.onselectstart === n.Util.falseFn && (e.onselectstart = this._onselectstart, this._onselectstart = null)
            },
            hasClass: function(t, e) {
                return t.className.length > 0 && RegExp("(^|\\s)" + e + "(\\s|$)").test(t.className)
            },
            addClass: function(t, e) {
                n.DomUtil.hasClass(t, e) || (t.className += (t.className ? " " : "") + e)
            },
            removeClass: function(t, e) {
                function i(t, i) {
                    return i === e ? "" : t
                }
                t.className = t.className.replace(/(\S+)\s*/g, i).replace(/(^\s+|\s+$)/, "")
            },
            setOpacity: function(t, e) {
                if ("opacity" in t.style) t.style.opacity = e;
                else if ("filter" in t.style) {
                    var i = !1,
                        n = "DXImageTransform.Microsoft.Alpha";
                    try {
                        i = t.filters.item(n)
                    } catch (o) {}
                    e = Math.round(100 * e), i ? (i.Enabled = 100 !== e, i.Opacity = e) : t.style.filter += " progid:" + n + "(opacity=" + e + ")"
                }
            },
            testProp: function(t) {
                for (var i = e.documentElement.style, n = 0; t.length > n; n++)
                    if (t[n] in i) return t[n];
                return !1
            },
            getTranslateString: function(t) {
                var e = n.Browser.webkit3d,
                    i = "translate" + (e ? "3d" : "") + "(",
                    o = (e ? ",0" : "") + ")";
                return i + t.x + "px," + t.y + "px" + o
            },
            getScaleString: function(t, e) {
                var i = n.DomUtil.getTranslateString(e.add(e.multiplyBy(-1 * t))),
                    o = " scale(" + t + ") ";
                return i + o
            },
            setPosition: function(t, e, i) {
                t._leaflet_pos = e, !i && n.Browser.any3d ? (t.style[n.DomUtil.TRANSFORM] = n.DomUtil.getTranslateString(e), n.Browser.mobileWebkit3d && (t.style.WebkitBackfaceVisibility = "hidden")) : (t.style.left = e.x + "px", t.style.top = e.y + "px")
            },
            getPosition: function(t) {
                return t._leaflet_pos
            }
        }, n.DomUtil.TRANSFORM = n.DomUtil.testProp(["transform", "WebkitTransform", "OTransform", "MozTransform", "msTransform"]), n.DomUtil.TRANSITION = n.DomUtil.testProp(["webkitTransition", "transition", "OTransition", "MozTransition", "msTransition"]), n.DomUtil.TRANSITION_END = "webkitTransition" === n.DomUtil.TRANSITION || "OTransition" === n.DomUtil.TRANSITION ? n.DomUtil.TRANSITION + "End" : "transitionend", n.LatLng = function(t, e) {
            var i = parseFloat(t),
                n = parseFloat(e);
            if (isNaN(i) || isNaN(n)) throw Error("Invalid LatLng object: (" + t + ", " + e + ")");
            this.lat = i, this.lng = n
        }, n.extend(n.LatLng, {
            DEG_TO_RAD: Math.PI / 180,
            RAD_TO_DEG: 180 / Math.PI,
            MAX_MARGIN: 1e-9
        }), n.LatLng.prototype = {
            equals: function(t) {
                if (!t) return !1;
                t = n.latLng(t);
                var e = Math.max(Math.abs(this.lat - t.lat), Math.abs(this.lng - t.lng));
                return n.LatLng.MAX_MARGIN >= e
            },
            toString: function(t) {
                return "LatLng(" + n.Util.formatNum(this.lat, t) + ", " + n.Util.formatNum(this.lng, t) + ")"
            },
            distanceTo: function(t) {
                t = n.latLng(t);
                var e = 6378137,
                    i = n.LatLng.DEG_TO_RAD,
                    o = (t.lat - this.lat) * i,
                    s = (t.lng - this.lng) * i,
                    a = this.lat * i,
                    r = t.lat * i,
                    h = Math.sin(o / 2),
                    l = Math.sin(s / 2),
                    u = h * h + l * l * Math.cos(a) * Math.cos(r);
                return 2 * e * Math.atan2(Math.sqrt(u), Math.sqrt(1 - u))
            },
            wrap: function(t, e) {
                var i = this.lng;
                return t = t || -180, e = e || 180, i = (i + e) % (e - t) + (t > i || i === e ? e : t), new n.LatLng(this.lat, i)
            }
        }, n.latLng = function(t, e) {
            return t instanceof n.LatLng ? t : n.Util.isArray(t) ? new n.LatLng(t[0], t[1]) : isNaN(t) ? t : new n.LatLng(t, e)
        }, n.LatLngBounds = function(t, e) {
            if (t)
                for (var i = e ? [t, e] : t, n = 0, o = i.length; o > n; n++) this.extend(i[n])
        }, n.LatLngBounds.prototype = {
            extend: function(t) {
                return t = "number" == typeof t[0] || "string" == typeof t[0] || t instanceof n.LatLng ? n.latLng(t) : n.latLngBounds(t), t instanceof n.LatLng ? this._southWest || this._northEast ? (this._southWest.lat = Math.min(t.lat, this._southWest.lat), this._southWest.lng = Math.min(t.lng, this._southWest.lng), this._northEast.lat = Math.max(t.lat, this._northEast.lat), this._northEast.lng = Math.max(t.lng, this._northEast.lng)) : (this._southWest = new n.LatLng(t.lat, t.lng), this._northEast = new n.LatLng(t.lat, t.lng)) : t instanceof n.LatLngBounds && (this.extend(t._southWest), this.extend(t._northEast)), this
            },
            pad: function(t) {
                var e = this._southWest,
                    i = this._northEast,
                    o = Math.abs(e.lat - i.lat) * t,
                    s = Math.abs(e.lng - i.lng) * t;
                return new n.LatLngBounds(new n.LatLng(e.lat - o, e.lng - s), new n.LatLng(i.lat + o, i.lng + s))
            },
            getCenter: function() {
                return new n.LatLng((this._southWest.lat + this._northEast.lat) / 2, (this._southWest.lng + this._northEast.lng) / 2)
            },
            getSouthWest: function() {
                return this._southWest
            },
            getNorthEast: function() {
                return this._northEast
            },
            getNorthWest: function() {
                return new n.LatLng(this._northEast.lat, this._southWest.lng)
            },
            getSouthEast: function() {
                return new n.LatLng(this._southWest.lat, this._northEast.lng)
            },
            contains: function(t) {
                t = "number" == typeof t[0] || t instanceof n.LatLng ? n.latLng(t) : n.latLngBounds(t);
                var e, i, o = this._southWest,
                    s = this._northEast;
                return t instanceof n.LatLngBounds ? (e = t.getSouthWest(), i = t.getNorthEast()) : e = i = t, e.lat >= o.lat && i.lat <= s.lat && e.lng >= o.lng && i.lng <= s.lng
            },
            intersects: function(t) {
                t = n.latLngBounds(t);
                var e = this._southWest,
                    i = this._northEast,
                    o = t.getSouthWest(),
                    s = t.getNorthEast(),
                    a = s.lat >= e.lat && o.lat <= i.lat,
                    r = s.lng >= e.lng && o.lng <= i.lng;
                return a && r
            },
            toBBoxString: function() {
                var t = this._southWest,
                    e = this._northEast;
                return [t.lng, t.lat, e.lng, e.lat].join(",")
            },
            equals: function(t) {
                return t ? (t = n.latLngBounds(t), this._southWest.equals(t.getSouthWest()) && this._northEast.equals(t.getNorthEast())) : !1
            },
            isValid: function() {
                return !(!this._southWest || !this._northEast)
            }
        }, n.latLngBounds = function(t, e) {
            return !t || t instanceof n.LatLngBounds ? t : new n.LatLngBounds(t, e)
        }, n.Projection = {}, n.Projection.SphericalMercator = {
            MAX_LATITUDE: 85.0511287798,
            project: function(t) {
                var e = n.LatLng.DEG_TO_RAD,
                    i = this.MAX_LATITUDE,
                    o = Math.max(Math.min(i, t.lat), -i),
                    s = t.lng * e,
                    a = o * e;
                return a = Math.log(Math.tan(Math.PI / 4 + a / 2)), new n.Point(s, a)
            },
            unproject: function(t) {
                var e = n.LatLng.RAD_TO_DEG,
                    i = t.x * e,
                    o = (2 * Math.atan(Math.exp(t.y)) - Math.PI / 2) * e;
                return new n.LatLng(o, i)
            }
        }, n.Projection.LonLat = {
            project: function(t) {
                return new n.Point(t.lng, t.lat)
            },
            unproject: function(t) {
                return new n.LatLng(t.y, t.x)
            }
        }, n.CRS = {
            latLngToPoint: function(t, e) {
                var i = this.projection.project(t),
                    n = this.scale(e);
                return this.transformation._transform(i, n)
            },
            pointToLatLng: function(t, e) {
                var i = this.scale(e),
                    n = this.transformation.untransform(t, i);
                return this.projection.unproject(n)
            },
            project: function(t) {
                return this.projection.project(t)
            },
            scale: function(t) {
                return 256 * Math.pow(2, t)
            }
        }, n.CRS.Simple = n.extend({}, n.CRS, {
            projection: n.Projection.LonLat,
            transformation: new n.Transformation(1, 0, -1, 0),
            scale: function(t) {
                return Math.pow(2, t)
            }
        }), n.CRS.EPSG3857 = n.extend({}, n.CRS, {
            code: "EPSG:3857",
            projection: n.Projection.SphericalMercator,
            transformation: new n.Transformation(.5 / Math.PI, .5, -.5 / Math.PI, .5),
            project: function(t) {
                var e = this.projection.project(t),
                    i = 6378137;
                return e.multiplyBy(i)
            }
        }), n.CRS.EPSG900913 = n.extend({}, n.CRS.EPSG3857, {
            code: "EPSG:900913"
        }), n.CRS.EPSG4326 = n.extend({}, n.CRS, {
            code: "EPSG:4326",
            projection: n.Projection.LonLat,
            transformation: new n.Transformation(1 / 360, .5, -1 / 360, .5)
        }), n.Map = n.Class.extend({
            includes: n.Mixin.Events,
            options: {
                crs: n.CRS.EPSG3857,
                fadeAnimation: n.DomUtil.TRANSITION && !n.Browser.android23,
                trackResize: !0,
                markerZoomAnimation: n.DomUtil.TRANSITION && n.Browser.any3d
            },
            initialize: function(t, e) {
                e = n.setOptions(this, e), this._initContainer(t), this._initLayout(), this.callInitHooks(), this._initEvents(), e.maxBounds && this.setMaxBounds(e.maxBounds), e.center && e.zoom !== i && this.setView(n.latLng(e.center), e.zoom, !0), this._initLayers(e.layers)
            },
            setView: function(t, e) {
                return this._resetView(n.latLng(t), this._limitZoom(e)), this
            },
            setZoom: function(t) {
                return this.setView(this.getCenter(), t)
            },
            zoomIn: function(t) {
                return this.setZoom(this._zoom + (t || 1))
            },
            zoomOut: function(t) {
                return this.setZoom(this._zoom - (t || 1))
            },
            fitBounds: function(t) {
                var e = this.getBoundsZoom(t);
                return this.setView(n.latLngBounds(t).getCenter(), e)
            },
            fitWorld: function() {
                var t = new n.LatLng(-60, -170),
                    e = new n.LatLng(85, 179);
                return this.fitBounds(new n.LatLngBounds(t, e))
            },
            panTo: function(t) {
                return this.setView(t, this._zoom)
            },
            panBy: function(t) {
                return this.fire("movestart"), this._rawPanBy(n.point(t)), this.fire("move"), this.fire("moveend")
            },
            setMaxBounds: function(t) {
                if (t = n.latLngBounds(t), this.options.maxBounds = t, !t) return this._boundsMinZoom = null, this;
                var e = this.getBoundsZoom(t, !0);
                return this._boundsMinZoom = e, this._loaded && (e > this._zoom ? this.setView(t.getCenter(), e) : this.panInsideBounds(t)), this
            },
            panInsideBounds: function(t) {
                t = n.latLngBounds(t);
                var e = this.getBounds(),
                    i = this.project(e.getSouthWest()),
                    o = this.project(e.getNorthEast()),
                    s = this.project(t.getSouthWest()),
                    a = this.project(t.getNorthEast()),
                    r = 0,
                    h = 0;
                return o.y < a.y && (h = a.y - o.y), o.x > a.x && (r = a.x - o.x), i.y > s.y && (h = s.y - i.y), i.x < s.x && (r = s.x - i.x), this.panBy(new n.Point(r, h, !0))
            },
            addLayer: function(t) {
                var e = n.stamp(t);
                return this._layers[e] ? this : (this._layers[e] = t, !t.options || isNaN(t.options.maxZoom) && isNaN(t.options.minZoom) || (this._zoomBoundLayers[e] = t, this._updateZoomLevels()), this.options.zoomAnimation && n.TileLayer && t instanceof n.TileLayer && (this._tileLayersNum++, this._tileLayersToLoad++, t.on("load", this._onTileLayerLoad, this)), this.whenReady(function() {
                    t.onAdd(this), this.fire("layeradd", {
                        layer: t
                    })
                }, this), this)
            },
            removeLayer: function(t) {
                var e = n.stamp(t);
                if (this._layers[e]) return t.onRemove(this), delete this._layers[e], this._zoomBoundLayers[e] && (delete this._zoomBoundLayers[e], this._updateZoomLevels()), this.options.zoomAnimation && n.TileLayer && t instanceof n.TileLayer && (this._tileLayersNum--, this._tileLayersToLoad--, t.off("load", this._onTileLayerLoad, this)), this.fire("layerremove", {
                    layer: t
                })
            },
            hasLayer: function(t) {
                var e = n.stamp(t);
                return this._layers.hasOwnProperty(e)
            },
            invalidateSize: function(t) {
                var e = this.getSize();
                if (this._sizeChanged = !0, this.options.maxBounds && this.setMaxBounds(this.options.maxBounds), !this._loaded) return this;
                var i = e._subtract(this.getSize())._divideBy(2)._round();
                return t === !0 ? this.panBy(i) : (this._rawPanBy(i), this.fire("move"), clearTimeout(this._sizeTimer), this._sizeTimer = setTimeout(n.bind(this.fire, this, "moveend"), 200)), this
            },
            addHandler: function(t, e) {
                return e ? (this[t] = new e(this), this.options[t] && this[t].enable(), this) : i
            },
            getCenter: function() {
                return this.layerPointToLatLng(this._getCenterLayerPoint())
            },
            getZoom: function() {
                return this._zoom
            },
            getBounds: function() {
                var t = this.getPixelBounds(),
                    e = this.unproject(t.getBottomLeft()),
                    i = this.unproject(t.getTopRight());
                return new n.LatLngBounds(e, i)
            },
            getMinZoom: function() {
                var t = this.options.minZoom || 0,
                    e = this._layersMinZoom || 0,
                    i = this._boundsMinZoom || 0;
                return Math.max(t, e, i)
            },
            getMaxZoom: function() {
                var t = this.options.maxZoom === i ? 1 / 0 : this.options.maxZoom,
                    e = this._layersMaxZoom === i ? 1 / 0 : this._layersMaxZoom;
                return Math.min(t, e)
            },
            getBoundsZoom: function(t, e) {
                t = n.latLngBounds(t);
                var i, o, s, a = this.getSize(),
                    r = this.options.minZoom || 0,
                    h = this.getMaxZoom(),
                    l = t.getNorthEast(),
                    u = t.getSouthWest(),
                    c = !0;
                e && r--;
                do r++, o = this.project(l, r), s = this.project(u, r), i = new n.Point(Math.abs(o.x - s.x), Math.abs(s.y - o.y)), c = e ? i.x < a.x || i.y < a.y : i.x <= a.x && i.y <= a.y; while (c && h >= r);
                return c && e ? null : e ? r : r - 1
            },
            getSize: function() {
                return (!this._size || this._sizeChanged) && (this._size = new n.Point(this._container.clientWidth, this._container.clientHeight), this._sizeChanged = !1), this._size.clone()
            },
            getPixelBounds: function() {
                var t = this._getTopLeftPoint();
                return new n.Bounds(t, t.add(this.getSize()))
            },
            getPixelOrigin: function() {
                return this._initialTopLeftPoint
            },
            getPanes: function() {
                return this._panes
            },
            getContainer: function() {
                return this._container
            },
            getZoomScale: function(t) {
                var e = this.options.crs;
                return e.scale(t) / e.scale(this._zoom)
            },
            getScaleZoom: function(t) {
                return this._zoom + Math.log(t) / Math.LN2
            },
            project: function(t, e) {
                return e = e === i ? this._zoom : e, this.options.crs.latLngToPoint(n.latLng(t), e)
            },
            unproject: function(t, e) {
                return e = e === i ? this._zoom : e, this.options.crs.pointToLatLng(n.point(t), e)
            },
            layerPointToLatLng: function(t) {
                var e = n.point(t).add(this._initialTopLeftPoint);
                return this.unproject(e)
            },
            latLngToLayerPoint: function(t) {
                var e = this.project(n.latLng(t))._round();
                return e._subtract(this._initialTopLeftPoint)
            },
            containerPointToLayerPoint: function(t) {
                return n.point(t).subtract(this._getMapPanePos())
            },
            layerPointToContainerPoint: function(t) {
                return n.point(t).add(this._getMapPanePos())
            },
            containerPointToLatLng: function(t) {
                var e = this.containerPointToLayerPoint(n.point(t));
                return this.layerPointToLatLng(e)
            },
            latLngToContainerPoint: function(t) {
                return this.layerPointToContainerPoint(this.latLngToLayerPoint(n.latLng(t)))
            },
            mouseEventToContainerPoint: function(t) {
                return n.DomEvent.getMousePosition(t, this._container)
            },
            mouseEventToLayerPoint: function(t) {
                return this.containerPointToLayerPoint(this.mouseEventToContainerPoint(t))
            },
            mouseEventToLatLng: function(t) {
                return this.layerPointToLatLng(this.mouseEventToLayerPoint(t))
            },
            _initContainer: function(t) {
                var e = this._container = n.DomUtil.get(t);
                if (e._leaflet) throw Error("Map container is already initialized.");
                e._leaflet = !0
            },
            _initLayout: function() {
                var t = this._container;
                n.DomUtil.addClass(t, "leaflet-container"), n.Browser.touch && n.DomUtil.addClass(t, "leaflet-touch"), this.options.fadeAnimation && n.DomUtil.addClass(t, "leaflet-fade-anim");
                var e = n.DomUtil.getStyle(t, "position");
                "absolute" !== e && "relative" !== e && "fixed" !== e && (t.style.position = "relative"), this._initPanes(), this._initControlPos && this._initControlPos()
            },
            _initPanes: function() {
                var t = this._panes = {};
                this._mapPane = t.mapPane = this._createPane("leaflet-map-pane", this._container), this._tilePane = t.tilePane = this._createPane("leaflet-tile-pane", this._mapPane), t.objectsPane = this._createPane("leaflet-objects-pane", this._mapPane), t.shadowPane = this._createPane("leaflet-shadow-pane"), t.overlayPane = this._createPane("leaflet-overlay-pane"), t.markerPane = this._createPane("leaflet-marker-pane"), t.popupPane = this._createPane("leaflet-popup-pane");
                var e = " leaflet-zoom-hide";
                this.options.markerZoomAnimation || (n.DomUtil.addClass(t.markerPane, e), n.DomUtil.addClass(t.shadowPane, e), n.DomUtil.addClass(t.popupPane, e))
            },
            _createPane: function(t, e) {
                return n.DomUtil.create("div", t, e || this._panes.objectsPane)
            },
            _initLayers: function(t) {
                t = t ? n.Util.isArray(t) ? t : [t] : [], this._layers = {}, this._zoomBoundLayers = {}, this._tileLayersNum = 0;
                var e, i;
                for (e = 0, i = t.length; i > e; e++) this.addLayer(t[e])
            },
            _resetView: function(t, e, i, o) {
                var s = this._zoom !== e;
                o || (this.fire("movestart"), s && this.fire("zoomstart")), this._zoom = e, this._initialTopLeftPoint = this._getNewTopLeftPoint(t), i ? this._initialTopLeftPoint._add(this._getMapPanePos()) : n.DomUtil.setPosition(this._mapPane, new n.Point(0, 0)), this._tileLayersToLoad = this._tileLayersNum;
                var a = !this._loaded;
                this._loaded = !0, this.fire("viewreset", {
                    hard: !i
                }), this.fire("move"), (s || o) && this.fire("zoomend"), this.fire("moveend", {
                    hard: !i
                }), a && this.fire("load")
            },
            _rawPanBy: function(t) {
                n.DomUtil.setPosition(this._mapPane, this._getMapPanePos().subtract(t))
            },
            _updateZoomLevels: function() {
                var t, e = 1 / 0,
                    n = -1 / 0;
                for (t in this._zoomBoundLayers)
                    if (this._zoomBoundLayers.hasOwnProperty(t)) {
                        var o = this._zoomBoundLayers[t];
                        isNaN(o.options.minZoom) || (e = Math.min(e, o.options.minZoom)), isNaN(o.options.maxZoom) || (n = Math.max(n, o.options.maxZoom))
                    }
                t === i ? this._layersMaxZoom = this._layersMinZoom = i : (this._layersMaxZoom = n, this._layersMinZoom = e)
            },
            _initEvents: function() {
                if (n.DomEvent) {
                    n.DomEvent.on(this._container, "click", this._onMouseClick, this);
                    var e, i, o = ["dblclick", "mousedown", "mouseup", "mouseenter", "mouseleave", "mousemove", "contextmenu"];
                    for (e = 0, i = o.length; i > e; e++) n.DomEvent.on(this._container, o[e], this._fireMouseEvent, this);
                    this.options.trackResize && n.DomEvent.on(t, "resize", this._onResize, this)
                }
            },
            _onResize: function() {
                n.Util.cancelAnimFrame(this._resizeRequest), this._resizeRequest = n.Util.requestAnimFrame(this.invalidateSize, this, !1, this._container)
            },
            _onMouseClick: function(t) {
                !this._loaded || this.dragging && this.dragging.moved() || (this.fire("preclick"), this._fireMouseEvent(t))
            },
            _fireMouseEvent: function(t) {
                if (this._loaded) {
                    var e = t.type;
                    if (e = "mouseenter" === e ? "mouseover" : "mouseleave" === e ? "mouseout" : e, this.hasEventListeners(e)) {
                        "contextmenu" === e && n.DomEvent.preventDefault(t);
                        var i = this.mouseEventToContainerPoint(t),
                            o = this.containerPointToLayerPoint(i),
                            s = this.layerPointToLatLng(o);
                        this.fire(e, {
                            latlng: s,
                            layerPoint: o,
                            containerPoint: i,
                            originalEvent: t
                        })
                    }
                }
            },
            _onTileLayerLoad: function() {
                this._tileLayersToLoad--, this._tileLayersNum && !this._tileLayersToLoad && this._tileBg && (clearTimeout(this._clearTileBgTimer), this._clearTileBgTimer = setTimeout(n.bind(this._clearTileBg, this), 500))
            },
            whenReady: function(t, e) {
                return this._loaded ? t.call(e || this, this) : this.on("load", t, e), this
            },
            _getMapPanePos: function() {
                return n.DomUtil.getPosition(this._mapPane)
            },
            _getTopLeftPoint: function() {
                if (!this._loaded) throw Error("Set map center and zoom first.");
                return this._initialTopLeftPoint.subtract(this._getMapPanePos())
            },
            _getNewTopLeftPoint: function(t, e) {
                var i = this.getSize()._divideBy(2);
                return this.project(t, e)._subtract(i)._round()
            },
            _latLngToNewLayerPoint: function(t, e, i) {
                var n = this._getNewTopLeftPoint(i, e).add(this._getMapPanePos());
                return this.project(t, e)._subtract(n)
            },
            _getCenterLayerPoint: function() {
                return this.containerPointToLayerPoint(this.getSize()._divideBy(2))
            },
            _getCenterOffset: function(t) {
                return this.latLngToLayerPoint(t).subtract(this._getCenterLayerPoint())
            },
            _limitZoom: function(t) {
                var e = this.getMinZoom(),
                    i = this.getMaxZoom();
                return Math.max(e, Math.min(i, t))
            }
        }), n.map = function(t, e) {
            return new n.Map(t, e)
        }, n.Projection.Mercator = {
            MAX_LATITUDE: 85.0840591556,
            R_MINOR: 6356752.3142,
            R_MAJOR: 6378137,
            project: function(t) {
                var e = n.LatLng.DEG_TO_RAD,
                    i = this.MAX_LATITUDE,
                    o = Math.max(Math.min(i, t.lat), -i),
                    s = this.R_MAJOR,
                    a = this.R_MINOR,
                    r = t.lng * e * s,
                    h = o * e,
                    l = a / s,
                    u = Math.sqrt(1 - l * l),
                    c = u * Math.sin(h);
                c = Math.pow((1 - c) / (1 + c), .5 * u);
                var _ = Math.tan(.5 * (.5 * Math.PI - h)) / c;
                return h = -a * Math.log(_), new n.Point(r, h)
            },
            unproject: function(t) {
                for (var e, i = n.LatLng.RAD_TO_DEG, o = this.R_MAJOR, s = this.R_MINOR, a = t.x * i / o, r = s / o, h = Math.sqrt(1 - r * r), l = Math.exp(-t.y / s), u = Math.PI / 2 - 2 * Math.atan(l), c = 15, _ = 1e-7, d = c, p = .1; Math.abs(p) > _ && --d > 0;) e = h * Math.sin(u), p = Math.PI / 2 - 2 * Math.atan(l * Math.pow((1 - e) / (1 + e), .5 * h)) - u, u += p;
                return new n.LatLng(u * i, a)
            }
        }, n.CRS.EPSG3395 = n.extend({}, n.CRS, {
            code: "EPSG:3395",
            projection: n.Projection.Mercator,
            transformation: function() {
                var t = n.Projection.Mercator,
                    e = t.R_MAJOR,
                    i = t.R_MINOR;
                return new n.Transformation(.5 / (Math.PI * e), .5, -.5 / (Math.PI * i), .5)
            }()
        }), n.TileLayer = n.Class.extend({
            includes: n.Mixin.Events,
            options: {
                minZoom: 0,
                maxZoom: 18,
                tileSize: 256,
                subdomains: "abc",
                errorTileUrl: "",
                attribution: "",
                zoomOffset: 0,
                opacity: 1,
                unloadInvisibleTiles: n.Browser.mobile,
                updateWhenIdle: n.Browser.mobile
            },
            initialize: function(t, e) {
                e = n.setOptions(this, e), e.detectRetina && n.Browser.retina && e.maxZoom > 0 && (e.tileSize = Math.floor(e.tileSize / 2), e.zoomOffset++, e.minZoom > 0 && e.minZoom--, this.options.maxZoom--), this._url = t;
                var i = this.options.subdomains;
                "string" == typeof i && (this.options.subdomains = i.split(""))
            },
            onAdd: function(t) {
                this._map = t, this._initContainer(), this._createTileProto(), t.on({
                    viewreset: this._resetCallback,
                    moveend: this._update
                }, this), this.options.updateWhenIdle || (this._limitedUpdate = n.Util.limitExecByInterval(this._update, 150, this), t.on("move", this._limitedUpdate, this)), this._reset(), this._update()
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            onRemove: function(t) {
                this._container.parentNode.removeChild(this._container), t.off({
                    viewreset: this._resetCallback,
                    moveend: this._update
                }, this), this.options.updateWhenIdle || t.off("move", this._limitedUpdate, this), this._container = null, this._map = null
            },
            bringToFront: function() {
                var t = this._map._panes.tilePane;
                return this._container && (t.appendChild(this._container), this._setAutoZIndex(t, Math.max)), this
            },
            bringToBack: function() {
                var t = this._map._panes.tilePane;
                return this._container && (t.insertBefore(this._container, t.firstChild), this._setAutoZIndex(t, Math.min)), this
            },
            getAttribution: function() {
                return this.options.attribution
            },
            setOpacity: function(t) {
                return this.options.opacity = t, this._map && this._updateOpacity(), this
            },
            setZIndex: function(t) {
                return this.options.zIndex = t, this._updateZIndex(), this
            },
            setUrl: function(t, e) {
                return this._url = t, e || this.redraw(), this
            },
            redraw: function() {
                return this._map && (this._map._panes.tilePane.empty = !1, this._reset(!0), this._update()), this
            },
            _updateZIndex: function() {
                this._container && this.options.zIndex !== i && (this._container.style.zIndex = this.options.zIndex)
            },
            _setAutoZIndex: function(t, e) {
                var i, n, o, s = t.children,
                    a = -e(1 / 0, -1 / 0);
                for (n = 0, o = s.length; o > n; n++) s[n] !== this._container && (i = parseInt(s[n].style.zIndex, 10), isNaN(i) || (a = e(a, i)));
                this.options.zIndex = this._container.style.zIndex = (isFinite(a) ? a : 0) + e(1, -1)
            },
            _updateOpacity: function() {
                n.DomUtil.setOpacity(this._container, this.options.opacity);
                var t, e = this._tiles;
                if (n.Browser.webkit)
                    for (t in e) e.hasOwnProperty(t) && (e[t].style.webkitTransform += " translate(0,0)")
            },
            _initContainer: function() {
                var t = this._map._panes.tilePane;
                (!this._container || t.empty) && (this._container = n.DomUtil.create("div", "leaflet-layer"), this._updateZIndex(), t.appendChild(this._container), 1 > this.options.opacity && this._updateOpacity())
            },
            _resetCallback: function(t) {
                this._reset(t.hard)
            },
            _reset: function(t) {
                var e = this._tiles;
                for (var i in e) e.hasOwnProperty(i) && this.fire("tileunload", {
                    tile: e[i]
                });
                this._tiles = {}, this._tilesToLoad = 0, this.options.reuseTiles && (this._unusedTiles = []), t && this._container && (this._container.innerHTML = ""), this._initContainer()
            },
            _update: function() {
                if (this._map) {
                    var t = this._map.getPixelBounds(),
                        e = this._map.getZoom(),
                        i = this.options.tileSize;
                    if (!(e > this.options.maxZoom || this.options.minZoom > e)) {
                        var o = new n.Point(Math.floor(t.min.x / i), Math.floor(t.min.y / i)),
                            s = new n.Point(Math.floor(t.max.x / i), Math.floor(t.max.y / i)),
                            a = new n.Bounds(o, s);
                        this._addTilesFromCenterOut(a), (this.options.unloadInvisibleTiles || this.options.reuseTiles) && this._removeOtherTiles(a)
                    }
                }
            },
            _addTilesFromCenterOut: function(t) {
                var i, o, s, a = [],
                    r = t.getCenter();
                for (i = t.min.y; t.max.y >= i; i++)
                    for (o = t.min.x; t.max.x >= o; o++) s = new n.Point(o, i), this._tileShouldBeLoaded(s) && a.push(s);
                var h = a.length;
                if (0 !== h) {
                    a.sort(function(t, e) {
                        return t.distanceTo(r) - e.distanceTo(r)
                    });
                    var l = e.createDocumentFragment();
                    for (this._tilesToLoad || this.fire("loading"), this._tilesToLoad += h, o = 0; h > o; o++) this._addTile(a[o], l);
                    this._container.appendChild(l)
                }
            },
            _tileShouldBeLoaded: function(t) {
                if (t.x + ":" + t.y in this._tiles) return !1;
                if (!this.options.continuousWorld) {
                    var e = this._getWrapTileNum();
                    if (this.options.noWrap && (0 > t.x || t.x >= e) || 0 > t.y || t.y >= e) return !1
                }
                return !0
            },
            _removeOtherTiles: function(t) {
                var e, i, n, o;
                for (o in this._tiles) this._tiles.hasOwnProperty(o) && (e = o.split(":"), i = parseInt(e[0], 10), n = parseInt(e[1], 10), (t.min.x > i || i > t.max.x || t.min.y > n || n > t.max.y) && this._removeTile(o))
            },
            _removeTile: function(t) {
                var e = this._tiles[t];
                this.fire("tileunload", {
                    tile: e,
                    url: e.src
                }), this.options.reuseTiles ? (n.DomUtil.removeClass(e, "leaflet-tile-loaded"), this._unusedTiles.push(e)) : e.parentNode === this._container && this._container.removeChild(e), n.Browser.android || (e.src = n.Util.emptyImageUrl), delete this._tiles[t]
            },
            _addTile: function(t, e) {
                var i = this._getTilePos(t),
                    o = this._getTile();
                n.DomUtil.setPosition(o, i, n.Browser.chrome || n.Browser.android23), this._tiles[t.x + ":" + t.y] = o, this._loadTile(o, t), o.parentNode !== this._container && e.appendChild(o)
            },
            _getZoomForUrl: function() {
                var t = this.options,
                    e = this._map.getZoom();
                return t.zoomReverse && (e = t.maxZoom - e), e + t.zoomOffset
            },
            _getTilePos: function(t) {
                var e = this._map.getPixelOrigin(),
                    i = this.options.tileSize;
                return t.multiplyBy(i).subtract(e)
            },
            getTileUrl: function(t) {
                return this._adjustTilePoint(t), n.Util.template(this._url, n.extend({
                    s: this._getSubdomain(t),
                    z: this._getZoomForUrl(),
                    x: t.x,
                    y: t.y
                }, this.options))
            },
            _getWrapTileNum: function() {
                return Math.pow(2, this._getZoomForUrl())
            },
            _adjustTilePoint: function(t) {
                var e = this._getWrapTileNum();
                this.options.continuousWorld || this.options.noWrap || (t.x = (t.x % e + e) % e), this.options.tms && (t.y = e - t.y - 1)
            },
            _getSubdomain: function(t) {
                var e = (t.x + t.y) % this.options.subdomains.length;
                return this.options.subdomains[e]
            },
            _createTileProto: function() {
                var t = this._tileImg = n.DomUtil.create("img", "leaflet-tile");
                t.style.width = t.style.height = this.options.tileSize + "px", t.galleryimg = "no"
            },
            _getTile: function() {
                if (this.options.reuseTiles && this._unusedTiles.length > 0) {
                    var t = this._unusedTiles.pop();
                    return this._resetTile(t), t
                }
                return this._createTile()
            },
            _resetTile: function() {},
            _createTile: function() {
                var t = this._tileImg.cloneNode(!1);
                return t.onselectstart = t.onmousemove = n.Util.falseFn, t
            },
            _loadTile: function(t, e) {
                t._layer = this, t.onload = this._tileOnLoad, t.onerror = this._tileOnError, t.src = this.getTileUrl(e)
            },
            _tileLoaded: function() {
                this._tilesToLoad--, this._tilesToLoad || this.fire("load")
            },
            _tileOnLoad: function() {
                var t = this._layer;
                this.src !== n.Util.emptyImageUrl && (n.DomUtil.addClass(this, "leaflet-tile-loaded"), t.fire("tileload", {
                    tile: this,
                    url: this.src
                })), t._tileLoaded()
            },
            _tileOnError: function() {
                var t = this._layer;
                t.fire("tileerror", {
                    tile: this,
                    url: this.src
                });
                var e = t.options.errorTileUrl;
                e && (this.src = e), t._tileLoaded()
            }
        }), n.tileLayer = function(t, e) {
            return new n.TileLayer(t, e)
        }, n.TileLayer.WMS = n.TileLayer.extend({
            defaultWmsParams: {
                service: "WMS",
                request: "GetMap",
                version: "1.1.1",
                layers: "",
                styles: "",
                format: "image/jpeg",
                transparent: !1
            },
            initialize: function(t, e) {
                this._url = t;
                var i = n.extend({}, this.defaultWmsParams);
                i.width = i.height = e.detectRetina && n.Browser.retina ? 2 * this.options.tileSize : this.options.tileSize;
                for (var o in e) this.options.hasOwnProperty(o) || (i[o] = e[o]);
                this.wmsParams = i, n.setOptions(this, e)
            },
            onAdd: function(t) {
                var e = parseFloat(this.wmsParams.version) >= 1.3 ? "crs" : "srs";
                this.wmsParams[e] = t.options.crs.code, n.TileLayer.prototype.onAdd.call(this, t)
            },
            getTileUrl: function(t, e) {
                this._adjustTilePoint(t);
                var i = this._map,
                    o = i.options.crs,
                    s = this.options.tileSize,
                    a = t.multiplyBy(s),
                    r = a.add(new n.Point(s, s)),
                    h = o.project(i.unproject(a, e)),
                    l = o.project(i.unproject(r, e)),
                    u = [h.x, l.y, l.x, h.y].join(","),
                    c = n.Util.template(this._url, {
                        s: this._getSubdomain(t)
                    });
                return c + n.Util.getParamString(this.wmsParams, c) + "&bbox=" + u
            },
            setParams: function(t, e) {
                return n.extend(this.wmsParams, t), e || this.redraw(), this
            }
        }), n.tileLayer.wms = function(t, e) {
            return new n.TileLayer.WMS(t, e)
        }, n.TileLayer.Canvas = n.TileLayer.extend({
            options: {
                async: !1
            },
            initialize: function(t) {
                n.setOptions(this, t)
            },
            redraw: function() {
                var t = this._tiles;
                for (var e in t) t.hasOwnProperty(e) && this._redrawTile(t[e])
            },
            _redrawTile: function(t) {
                this.drawTile(t, t._tilePoint, this._map._zoom)
            },
            _createTileProto: function() {
                var t = this._canvasProto = n.DomUtil.create("canvas", "leaflet-tile");
                t.width = t.height = this.options.tileSize
            },
            _createTile: function() {
                var t = this._canvasProto.cloneNode(!1);
                return t.onselectstart = t.onmousemove = n.Util.falseFn, t
            },
            _loadTile: function(t, e) {
                t._layer = this, t._tilePoint = e, this._redrawTile(t), this.options.async || this.tileDrawn(t)
            },
            drawTile: function() {},
            tileDrawn: function(t) {
                this._tileOnLoad.call(t)
            }
        }), n.tileLayer.canvas = function(t) {
            return new n.TileLayer.Canvas(t)
        }, n.ImageOverlay = n.Class.extend({
            includes: n.Mixin.Events,
            options: {
                opacity: 1
            },
            initialize: function(t, e, i) {
                this._url = t, this._bounds = n.latLngBounds(e), n.setOptions(this, i)
            },
            onAdd: function(t) {
                this._map = t, this._image || this._initImage(), t._panes.overlayPane.appendChild(this._image), t.on("viewreset", this._reset, this), t.options.zoomAnimation && n.Browser.any3d && t.on("zoomanim", this._animateZoom, this), this._reset()
            },
            onRemove: function(t) {
                t.getPanes().overlayPane.removeChild(this._image), t.off("viewreset", this._reset, this), t.options.zoomAnimation && t.off("zoomanim", this._animateZoom, this)
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            setOpacity: function(t) {
                return this.options.opacity = t, this._updateOpacity(), this
            },
            bringToFront: function() {
                return this._image && this._map._panes.overlayPane.appendChild(this._image), this
            },
            bringToBack: function() {
                var t = this._map._panes.overlayPane;
                return this._image && t.insertBefore(this._image, t.firstChild), this
            },
            _initImage: function() {
                this._image = n.DomUtil.create("img", "leaflet-image-layer"), this._map.options.zoomAnimation && n.Browser.any3d ? n.DomUtil.addClass(this._image, "leaflet-zoom-animated") : n.DomUtil.addClass(this._image, "leaflet-zoom-hide"), this._updateOpacity(), n.extend(this._image, {
                    galleryimg: "no",
                    onselectstart: n.Util.falseFn,
                    onmousemove: n.Util.falseFn,
                    onload: n.bind(this._onImageLoad, this),
                    src: this._url
                })
            },
            _animateZoom: function(t) {
                var e = this._map,
                    i = this._image,
                    o = e.getZoomScale(t.zoom),
                    s = this._bounds.getNorthWest(),
                    a = this._bounds.getSouthEast(),
                    r = e._latLngToNewLayerPoint(s, t.zoom, t.center),
                    h = e._latLngToNewLayerPoint(a, t.zoom, t.center)._subtract(r),
                    l = r._add(h._multiplyBy(.5 * (1 - 1 / o)));
                i.style[n.DomUtil.TRANSFORM] = n.DomUtil.getTranslateString(l) + " scale(" + o + ") "
            },
            _reset: function() {
                var t = this._image,
                    e = this._map.latLngToLayerPoint(this._bounds.getNorthWest()),
                    i = this._map.latLngToLayerPoint(this._bounds.getSouthEast())._subtract(e);
                n.DomUtil.setPosition(t, e), t.style.width = i.x + "px", t.style.height = i.y + "px"
            },
            _onImageLoad: function() {
                this.fire("load")
            },
            _updateOpacity: function() {
                n.DomUtil.setOpacity(this._image, this.options.opacity)
            }
        }), n.imageOverlay = function(t, e, i) {
            return new n.ImageOverlay(t, e, i)
        }, n.Icon = n.Class.extend({
            options: {
                className: ""
            },
            initialize: function(t) {
                n.setOptions(this, t)
            },
            createIcon: function() {
                return this._createIcon("icon")
            },
            createShadow: function() {
                return this._createIcon("shadow")
            },
            _createIcon: function(t) {
                var e = this._getIconUrl(t);
                if (!e) {
                    if ("icon" === t) throw Error("iconUrl not set in Icon options (see the docs).");
                    return null
                }
                var i = this._createImg(e);
                return this._setIconStyles(i, t), i
            },
            _setIconStyles: function(t, e) {
                var i, o = this.options,
                    s = n.point(o[e + "Size"]);
                i = "shadow" === e ? n.point(o.shadowAnchor || o.iconAnchor) : n.point(o.iconAnchor), !i && s && (i = s.divideBy(2, !0)), t.className = "leaflet-marker-" + e + " " + o.className, i && (t.style.marginLeft = -i.x + "px", t.style.marginTop = -i.y + "px"), s && (t.style.width = s.x + "px", t.style.height = s.y + "px")
            },
            _createImg: function(t) {
                var i;
                return n.Browser.ie6 ? (i = e.createElement("div"), i.style.filter = 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' + t + '")') : (i = e.createElement("img"), i.src = t), i
            },
            _getIconUrl: function(t) {
                return n.Browser.retina && this.options[t + "RetinaUrl"] ? this.options[t + "RetinaUrl"] : this.options[t + "Url"]
            }
        }), n.icon = function(t) {
            return new n.Icon(t)
        }, n.Icon.Default = n.Icon.extend({
            options: {
                iconSize: new n.Point(25, 41),
                iconAnchor: new n.Point(12, 41),
                popupAnchor: new n.Point(1, -34),
                shadowSize: new n.Point(41, 41)
            },
            _getIconUrl: function(t) {
                var e = t + "Url";
                if (this.options[e]) return this.options[e];
                n.Browser.retina && "icon" === t && (t += "@2x");
                var i = n.Icon.Default.imagePath;
                if (!i) throw Error("Couldn't autodetect L.Icon.Default.imagePath, set it manually.");
                return i + "/marker-" + t + ".png"
            }
        }), n.Icon.Default.imagePath = function() {
            var t, i, n, o, s = e.getElementsByTagName("script"),
                a = /\/?leaflet[\-\._]?([\w\-\._]*)\.js\??/;
            for (t = 0, i = s.length; i > t; t++)
                if (n = s[t].src, o = n.match(a)) return n.split(a)[0] + "/images"
        }(), n.Marker = n.Class.extend({
            includes: n.Mixin.Events,
            options: {
                icon: new n.Icon.Default,
                title: "",
                clickable: !0,
                draggable: !1,
                zIndexOffset: 0,
                opacity: 1,
                riseOnHover: !1,
                riseOffset: 250
            },
            initialize: function(t, e) {
                n.setOptions(this, e), this._latlng = n.latLng(t)
            },
            onAdd: function(t) {
                this._map = t, t.on("viewreset", this.update, this), this._initIcon(), this.update(), t.options.zoomAnimation && t.options.markerZoomAnimation && t.on("zoomanim", this._animateZoom, this)
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            onRemove: function(t) {
                this._removeIcon(), this.fire("remove"), t.off({
                    viewreset: this.update,
                    zoomanim: this._animateZoom
                }, this), this._map = null
            },
            getLatLng: function() {
                return this._latlng
            },
            setLatLng: function(t) {
                return this._latlng = n.latLng(t), this.update(), this.fire("move", {
                    latlng: this._latlng
                })
            },
            setZIndexOffset: function(t) {
                return this.options.zIndexOffset = t, this.update(), this
            },
            setIcon: function(t) {
                return this._map && this._removeIcon(), this.options.icon = t, this._map && (this._initIcon(), this.update()), this
            },
            update: function() {
                if (this._icon) {
                    var t = this._map.latLngToLayerPoint(this._latlng).round();
                    this._setPos(t)
                }
                return this
            },
            _initIcon: function() {
                var t = this.options,
                    e = this._map,
                    i = e.options.zoomAnimation && e.options.markerZoomAnimation,
                    o = i ? "leaflet-zoom-animated" : "leaflet-zoom-hide",
                    s = !1;
                this._icon || (this._icon = t.icon.createIcon(), t.title && (this._icon.title = t.title), this._initInteraction(), s = 1 > this.options.opacity, n.DomUtil.addClass(this._icon, o), t.riseOnHover && n.DomEvent.on(this._icon, "mouseover", this._bringToFront, this).on(this._icon, "mouseout", this._resetZIndex, this)), this._shadow || (this._shadow = t.icon.createShadow(), this._shadow && (n.DomUtil.addClass(this._shadow, o), s = 1 > this.options.opacity)), s && this._updateOpacity();
                var a = this._map._panes;
                a.markerPane.appendChild(this._icon), this._shadow && a.shadowPane.appendChild(this._shadow)
            },
            _removeIcon: function() {
                var t = this._map._panes;
                this.options.riseOnHover && n.DomEvent.off(this._icon, "mouseover", this._bringToFront).off(this._icon, "mouseout", this._resetZIndex), t.markerPane.removeChild(this._icon), this._shadow && t.shadowPane.removeChild(this._shadow), this._icon = this._shadow = null
            },
            _setPos: function(t) {
                n.DomUtil.setPosition(this._icon, t), this._shadow && n.DomUtil.setPosition(this._shadow, t), this._zIndex = t.y + this.options.zIndexOffset, this._resetZIndex()
            },
            _updateZIndex: function(t) {
                this._icon.style.zIndex = this._zIndex + t
            },
            _animateZoom: function(t) {
                var e = this._map._latLngToNewLayerPoint(this._latlng, t.zoom, t.center);
                this._setPos(e)
            },
            _initInteraction: function() {
                if (this.options.clickable) {
                    var t = this._icon,
                        e = ["dblclick", "mousedown", "mouseover", "mouseout", "contextmenu"];
                    n.DomUtil.addClass(t, "leaflet-clickable"), n.DomEvent.on(t, "click", this._onMouseClick, this);
                    for (var i = 0; e.length > i; i++) n.DomEvent.on(t, e[i], this._fireMouseEvent, this);
                    n.Handler.MarkerDrag && (this.dragging = new n.Handler.MarkerDrag(this), this.options.draggable && this.dragging.enable())
                }
            },
            _onMouseClick: function(t) {
                var e = this.dragging && this.dragging.moved();
                (this.hasEventListeners(t.type) || e) && n.DomEvent.stopPropagation(t), e || (this.dragging && this.dragging._enabled || !this._map.dragging || !this._map.dragging.moved()) && this.fire(t.type, {
                    originalEvent: t
                })
            },
            _fireMouseEvent: function(t) {
                this.fire(t.type, {
                    originalEvent: t
                }), "contextmenu" === t.type && this.hasEventListeners(t.type) && n.DomEvent.preventDefault(t), "mousedown" !== t.type && n.DomEvent.stopPropagation(t)
            },
            setOpacity: function(t) {
                this.options.opacity = t, this._map && this._updateOpacity()
            },
            _updateOpacity: function() {
                n.DomUtil.setOpacity(this._icon, this.options.opacity), this._shadow && n.DomUtil.setOpacity(this._shadow, this.options.opacity)
            },
            _bringToFront: function() {
                this._updateZIndex(this.options.riseOffset)
            },
            _resetZIndex: function() {
                this._updateZIndex(0)
            }
        }), n.marker = function(t, e) {
            return new n.Marker(t, e)
        }, n.DivIcon = n.Icon.extend({
            options: {
                iconSize: new n.Point(12, 12),
                className: "leaflet-div-icon"
            },
            createIcon: function() {
                var t = e.createElement("div"),
                    i = this.options;
                return i.html && (t.innerHTML = i.html), i.bgPos && (t.style.backgroundPosition = -i.bgPos.x + "px " + -i.bgPos.y + "px"), this._setIconStyles(t, "icon"), t
            },
            createShadow: function() {
                return null
            }
        }), n.divIcon = function(t) {
            return new n.DivIcon(t)
        }, n.Map.mergeOptions({
            closePopupOnClick: !0
        }), n.Popup = n.Class.extend({
            includes: n.Mixin.Events,
            options: {
                minWidth: 50,
                maxWidth: 300,
                maxHeight: null,
                autoPan: !0,
                closeButton: !0,
                offset: new n.Point(0, 6),
                autoPanPadding: new n.Point(5, 5),
                className: "",
                zoomAnimation: !0
            },
            initialize: function(t, e) {
                n.setOptions(this, t), this._source = e, this._animated = n.Browser.any3d && this.options.zoomAnimation
            },
            onAdd: function(t) {
                this._map = t, this._container || this._initLayout(), this._updateContent();
                var e = t.options.fadeAnimation;
                e && n.DomUtil.setOpacity(this._container, 0), t._panes.popupPane.appendChild(this._container), t.on("viewreset", this._updatePosition, this), this._animated && t.on("zoomanim", this._zoomAnimation, this), t.options.closePopupOnClick && t.on("preclick", this._close, this), this._update(), e && n.DomUtil.setOpacity(this._container, 1)
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            openOn: function(t) {
                return t.openPopup(this), this
            },
            onRemove: function(t) {
                t._panes.popupPane.removeChild(this._container), n.Util.falseFn(this._container.offsetWidth), t.off({
                    viewreset: this._updatePosition,
                    preclick: this._close,
                    zoomanim: this._zoomAnimation
                }, this), t.options.fadeAnimation && n.DomUtil.setOpacity(this._container, 0), this._map = null
            },
            setLatLng: function(t) {
                return this._latlng = n.latLng(t), this._update(), this
            },
            setContent: function(t) {
                return this._content = t, this._update(), this
            },
            _close: function() {
                var t = this._map;
                t && (t._popup = null, t.removeLayer(this).fire("popupclose", {
                    popup: this
                }))
            },
            _initLayout: function() {
                var t, e = "leaflet-popup",
                    i = e + " " + this.options.className + " leaflet-zoom-" + (this._animated ? "animated" : "hide"),
                    o = this._container = n.DomUtil.create("div", i);
                this.options.closeButton && (t = this._closeButton = n.DomUtil.create("a", e + "-close-button", o), t.href = "#close", t.innerHTML = "&#215;", n.DomEvent.on(t, "click", this._onCloseButtonClick, this));
                var s = this._wrapper = n.DomUtil.create("div", e + "-content-wrapper", o);
                n.DomEvent.disableClickPropagation(s), this._contentNode = n.DomUtil.create("div", e + "-content", s), n.DomEvent.on(this._contentNode, "mousewheel", n.DomEvent.stopPropagation), this._tipContainer = n.DomUtil.create("div", e + "-tip-container", o), this._tip = n.DomUtil.create("div", e + "-tip", this._tipContainer)
            },
            _update: function() {
                this._map && (this._container.style.visibility = "hidden", this._updateContent(), this._updateLayout(), this._updatePosition(), this._container.style.visibility = "", this._adjustPan())
            },
            _updateContent: function() {
                if (this._content) {
                    if ("string" == typeof this._content) this._contentNode.innerHTML = this._content;
                    else {
                        for (; this._contentNode.hasChildNodes();) this._contentNode.removeChild(this._contentNode.firstChild);
                        this._contentNode.appendChild(this._content)
                    }
                    this.fire("contentupdate")
                }
            },
            _updateLayout: function() {
                var t = this._contentNode,
                    e = t.style;
                e.width = "", e.whiteSpace = "nowrap";
                var i = t.offsetWidth;
                i = Math.min(i, this.options.maxWidth), i = Math.max(i, this.options.minWidth), e.width = i + 1 + "px", e.whiteSpace = "", e.height = "";
                var o = t.offsetHeight,
                    s = this.options.maxHeight,
                    a = "leaflet-popup-scrolled";
                s && o > s ? (e.height = s + "px", n.DomUtil.addClass(t, a)) : n.DomUtil.removeClass(t, a), this._containerWidth = this._container.offsetWidth
            },
            _updatePosition: function() {
                if (this._map) {
                    var t = this._map.latLngToLayerPoint(this._latlng),
                        e = this._animated,
                        i = this.options.offset;
                    e && n.DomUtil.setPosition(this._container, t), this._containerBottom = -i.y - (e ? 0 : t.y), this._containerLeft = -Math.round(this._containerWidth / 2) + i.x + (e ? 0 : t.x), this._container.style.bottom = this._containerBottom + "px", this._container.style.left = this._containerLeft + "px"
                }
            },
            _zoomAnimation: function(t) {
                var e = this._map._latLngToNewLayerPoint(this._latlng, t.zoom, t.center);
                n.DomUtil.setPosition(this._container, e)
            },
            _adjustPan: function() {
                if (this.options.autoPan) {
                    var t = this._map,
                        e = this._container.offsetHeight,
                        i = this._containerWidth,
                        o = new n.Point(this._containerLeft, -e - this._containerBottom);
                    this._animated && o._add(n.DomUtil.getPosition(this._container));
                    var s = t.layerPointToContainerPoint(o),
                        a = this.options.autoPanPadding,
                        r = t.getSize(),
                        h = 0,
                        l = 0;
                    0 > s.x && (h = s.x - a.x), s.x + i > r.x && (h = s.x + i - r.x + a.x), 0 > s.y && (l = s.y - a.y), s.y + e > r.y && (l = s.y + e - r.y + a.y), (h || l) && t.panBy(new n.Point(h, l))
                }
            },
            _onCloseButtonClick: function(t) {
                this._close(), n.DomEvent.stop(t)
            }
        }), n.popup = function(t, e) {
            return new n.Popup(t, e)
        }, n.Marker.include({
            openPopup: function() {
                return this._popup && this._map && (this._popup.setLatLng(this._latlng), this._map.openPopup(this._popup)), this
            },
            closePopup: function() {
                return this._popup && this._popup._close(), this
            },
            bindPopup: function(t, e) {
                var i = n.point(this.options.icon.options.popupAnchor) || new n.Point(0, 0);
                return i = i.add(n.Popup.prototype.options.offset), e && e.offset && (i = i.add(e.offset)), e = n.extend({
                    offset: i
                }, e), this._popup || this.on("click", this.openPopup, this).on("remove", this.closePopup, this).on("move", this._movePopup, this), this._popup = new n.Popup(e, this).setContent(t), this
            },
            unbindPopup: function() {
                return this._popup && (this._popup = null, this.off("click", this.openPopup).off("remove", this.closePopup).off("move", this._movePopup)), this
            },
            _movePopup: function(t) {
                this._popup.setLatLng(t.latlng)
            }
        }), n.Map.include({
            openPopup: function(t) {
                return this.closePopup(), this._popup = t, this.addLayer(t).fire("popupopen", {
                    popup: this._popup
                })
            },
            closePopup: function() {
                return this._popup && this._popup._close(), this
            }
        }), n.LayerGroup = n.Class.extend({
            initialize: function(t) {
                this._layers = {};
                var e, i;
                if (t)
                    for (e = 0, i = t.length; i > e; e++) this.addLayer(t[e])
            },
            addLayer: function(t) {
                var e = n.stamp(t);
                return this._layers[e] = t, this._map && this._map.addLayer(t), this
            },
            removeLayer: function(t) {
                var e = n.stamp(t);
                return delete this._layers[e], this._map && this._map.removeLayer(t), this
            },
            clearLayers: function() {
                return this.eachLayer(this.removeLayer, this), this
            },
            invoke: function(t) {
                var e, i, n = Array.prototype.slice.call(arguments, 1);
                for (e in this._layers) this._layers.hasOwnProperty(e) && (i = this._layers[e], i[t] && i[t].apply(i, n));
                return this
            },
            onAdd: function(t) {
                this._map = t, this.eachLayer(t.addLayer, t)
            },
            onRemove: function(t) {
                this.eachLayer(t.removeLayer, t), this._map = null
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            eachLayer: function(t, e) {
                for (var i in this._layers) this._layers.hasOwnProperty(i) && t.call(e, this._layers[i])
            },
            setZIndex: function(t) {
                return this.invoke("setZIndex", t)
            }
        }), n.layerGroup = function(t) {
            return new n.LayerGroup(t)
        }, n.FeatureGroup = n.LayerGroup.extend({
            includes: n.Mixin.Events,
            statics: {
                EVENTS: "click dblclick mouseover mouseout mousemove contextmenu"
            },
            addLayer: function(t) {
                return this._layers[n.stamp(t)] ? this : (t.on(n.FeatureGroup.EVENTS, this._propagateEvent, this), n.LayerGroup.prototype.addLayer.call(this, t), this._popupContent && t.bindPopup && t.bindPopup(this._popupContent, this._popupOptions), this.fire("layeradd", {
                    layer: t
                }))
            },
            removeLayer: function(t) {
                return t.off(n.FeatureGroup.EVENTS, this._propagateEvent, this), n.LayerGroup.prototype.removeLayer.call(this, t), this._popupContent && this.invoke("unbindPopup"), this.fire("layerremove", {
                    layer: t
                })
            },
            bindPopup: function(t, e) {
                return this._popupContent = t, this._popupOptions = e, this.invoke("bindPopup", t, e)
            },
            setStyle: function(t) {
                return this.invoke("setStyle", t)
            },
            bringToFront: function() {
                return this.invoke("bringToFront")
            },
            bringToBack: function() {
                return this.invoke("bringToBack")
            },
            getBounds: function() {
                var t = new n.LatLngBounds;
                return this.eachLayer(function(e) {
                    t.extend(e instanceof n.Marker ? e.getLatLng() : e.getBounds())
                }), t
            },
            _propagateEvent: function(t) {
                t.layer = t.target, t.target = this, this.fire(t.type, t)
            }
        }), n.featureGroup = function(t) {
            return new n.FeatureGroup(t)
        }, n.Path = n.Class.extend({
            includes: [n.Mixin.Events],
            statics: {
                CLIP_PADDING: n.Browser.mobile ? Math.max(0, Math.min(.5, (1280 / Math.max(t.innerWidth, t.innerHeight) - 1) / 2)) : .5
            },
            options: {
                stroke: !0,
                color: "#0033ff",
                dashArray: null,
                weight: 5,
                opacity: .5,
                fill: !1,
                fillColor: null,
                fillOpacity: .2,
                clickable: !0
            },
            initialize: function(t) {
                n.setOptions(this, t)
            },
            onAdd: function(t) {
                this._map = t, this._container || (this._initElements(), this._initEvents()), this.projectLatlngs(), this._updatePath(), this._container && this._map._pathRoot.appendChild(this._container), this.fire("add"), t.on({
                    viewreset: this.projectLatlngs,
                    moveend: this._updatePath
                }, this)
            },
            addTo: function(t) {
                return t.addLayer(this), this
            },
            onRemove: function(t) {
                t._pathRoot.removeChild(this._container), this.fire("remove"), this._map = null, n.Browser.vml && (this._container = null, this._stroke = null, this._fill = null), t.off({
                    viewreset: this.projectLatlngs,
                    moveend: this._updatePath
                }, this)
            },
            projectLatlngs: function() {},
            setStyle: function(t) {
                return n.setOptions(this, t), this._container && this._updateStyle(), this
            },
            redraw: function() {
                return this._map && (this.projectLatlngs(), this._updatePath()), this
            }
        }), n.Map.include({
            _updatePathViewport: function() {
                var t = n.Path.CLIP_PADDING,
                    e = this.getSize(),
                    i = n.DomUtil.getPosition(this._mapPane),
                    o = i.multiplyBy(-1)._subtract(e.multiplyBy(t)._round()),
                    s = o.add(e.multiplyBy(1 + 2 * t)._round());
                this._pathViewport = new n.Bounds(o, s)
            }
        }), n.Path.SVG_NS = "http://www.w3.org/2000/svg", n.Browser.svg = !(!e.createElementNS || !e.createElementNS(n.Path.SVG_NS, "svg").createSVGRect), n.Path = n.Path.extend({
            statics: {
                SVG: n.Browser.svg
            },
            bringToFront: function() {
                var t = this._map._pathRoot,
                    e = this._container;
                return e && t.lastChild !== e && t.appendChild(e), this
            },
            bringToBack: function() {
                var t = this._map._pathRoot,
                    e = this._container,
                    i = t.firstChild;
                return e && i !== e && t.insertBefore(e, i), this
            },
            getPathString: function() {},
            _createElement: function(t) {
                return e.createElementNS(n.Path.SVG_NS, t)
            },
            _initElements: function() {
                this._map._initPathRoot(), this._initPath(), this._initStyle()
            },
            _initPath: function() {
                this._container = this._createElement("g"), this._path = this._createElement("path"), this._container.appendChild(this._path)
            },
            _initStyle: function() {
                this.options.stroke && (this._path.setAttribute("stroke-linejoin", "round"), this._path.setAttribute("stroke-linecap", "round")), this.options.fill && this._path.setAttribute("fill-rule", "evenodd"), this._updateStyle()
            },
            _updateStyle: function() {
                this.options.stroke ? (this._path.setAttribute("stroke", this.options.color), this._path.setAttribute("stroke-opacity", this.options.opacity), this._path.setAttribute("stroke-width", this.options.weight), this.options.dashArray ? this._path.setAttribute("stroke-dasharray", this.options.dashArray) : this._path.removeAttribute("stroke-dasharray")) : this._path.setAttribute("stroke", "none"), this.options.fill ? (this._path.setAttribute("fill", this.options.fillColor || this.options.color), this._path.setAttribute("fill-opacity", this.options.fillOpacity)) : this._path.setAttribute("fill", "none")
            },
            _updatePath: function() {
                var t = this.getPathString();
                t || (t = "M0 0"), this._path.setAttribute("d", t)
            },
            _initEvents: function() {
                if (this.options.clickable) {
                    (n.Browser.svg || !n.Browser.vml) && this._path.setAttribute("class", "leaflet-clickable"), n.DomEvent.on(this._container, "click", this._onMouseClick, this);
                    for (var t = ["dblclick", "mousedown", "mouseover", "mouseout", "mousemove", "contextmenu"], e = 0; t.length > e; e++) n.DomEvent.on(this._container, t[e], this._fireMouseEvent, this)
                }
            },
            _onMouseClick: function(t) {
                this._map.dragging && this._map.dragging.moved() || this._fireMouseEvent(t)
            },
            _fireMouseEvent: function(t) {
                if (this.hasEventListeners(t.type)) {
                    var e = this._map,
                        i = e.mouseEventToContainerPoint(t),
                        o = e.containerPointToLayerPoint(i),
                        s = e.layerPointToLatLng(o);
                    this.fire(t.type, {
                        latlng: s,
                        layerPoint: o,
                        containerPoint: i,
                        originalEvent: t
                    }), "contextmenu" === t.type && n.DomEvent.preventDefault(t), "mousemove" !== t.type && n.DomEvent.stopPropagation(t)
                }
            }
        }), n.Map.include({
            _initPathRoot: function() {
                this._pathRoot || (this._pathRoot = n.Path.prototype._createElement("svg"), this._panes.overlayPane.appendChild(this._pathRoot), this.options.zoomAnimation && n.Browser.any3d ? (this._pathRoot.setAttribute("class", " leaflet-zoom-animated"), this.on({
                    zoomanim: this._animatePathZoom,
                    zoomend: this._endPathZoom
                })) : this._pathRoot.setAttribute("class", " leaflet-zoom-hide"), this.on("moveend", this._updateSvgViewport), this._updateSvgViewport())
            },
            _animatePathZoom: function(t) {
                var e = this.getZoomScale(t.zoom),
                    i = this._getCenterOffset(t.center)._multiplyBy(-e)._add(this._pathViewport.min);
                this._pathRoot.style[n.DomUtil.TRANSFORM] = n.DomUtil.getTranslateString(i) + " scale(" + e + ") ", this._pathZooming = !0
            },
            _endPathZoom: function() {
                this._pathZooming = !1
            },
            _updateSvgViewport: function() {
                if (!this._pathZooming) {
                    this._updatePathViewport();
                    var t = this._pathViewport,
                        e = t.min,
                        i = t.max,
                        o = i.x - e.x,
                        s = i.y - e.y,
                        a = this._pathRoot,
                        r = this._panes.overlayPane;
                    n.Browser.mobileWebkit && r.removeChild(a), n.DomUtil.setPosition(a, e), a.setAttribute("width", o), a.setAttribute("height", s), a.setAttribute("viewBox", [e.x, e.y, o, s].join(" ")), n.Browser.mobileWebkit && r.appendChild(a)
                }
            }
        }), n.Path.include({
            bindPopup: function(t, e) {
                return (!this._popup || e) && (this._popup = new n.Popup(e, this)), this._popup.setContent(t), this._popupHandlersAdded || (this.on("click", this._openPopup, this).on("remove", this.closePopup, this), this._popupHandlersAdded = !0), this
            },
            unbindPopup: function() {
                return this._popup && (this._popup = null, this.off("click", this._openPopup).off("remove", this.closePopup), this._popupHandlersAdded = !1), this
            },
            openPopup: function(t) {
                return this._popup && (t = t || this._latlng || this._latlngs[Math.floor(this._latlngs.length / 2)], this._openPopup({
                    latlng: t
                })), this
            },
            closePopup: function() {
                return this._popup && this._popup._close(), this
            },
            _openPopup: function(t) {
                this._popup.setLatLng(t.latlng), this._map.openPopup(this._popup)
            }
        }), n.Browser.vml = !n.Browser.svg && function() {
            try {
                var t = e.createElement("div");
                t.innerHTML = '<v:shape adj="1"/>';
                var i = t.firstChild;
                return i.style.behavior = "url(#default#VML)", i && "object" == typeof i.adj
            } catch (n) {
                return !1
            }
        }(), n.Path = n.Browser.svg || !n.Browser.vml ? n.Path : n.Path.extend({
            statics: {
                VML: !0,
                CLIP_PADDING: .02
            },
            _createElement: function() {
                try {
                    return e.namespaces.add("lvml", "urn:schemas-microsoft-com:vml"),
                        function(t) {
                            return e.createElement("<lvml:" + t + ' class="lvml">')
                        }
                } catch (t) {
                    return function(t) {
                        return e.createElement("<" + t + ' xmlns="urn:schemas-microsoft.com:vml" class="lvml">')
                    }
                }
            }(),
            _initPath: function() {
                var t = this._container = this._createElement("shape");
                n.DomUtil.addClass(t, "leaflet-vml-shape"), this.options.clickable && n.DomUtil.addClass(t, "leaflet-clickable"), t.coordsize = "1 1", this._path = this._createElement("path"), t.appendChild(this._path), this._map._pathRoot.appendChild(t)
            },
            _initStyle: function() {
                this._updateStyle()
            },
            _updateStyle: function() {
                var t = this._stroke,
                    e = this._fill,
                    i = this.options,
                    n = this._container;
                n.stroked = i.stroke, n.filled = i.fill, i.stroke ? (t || (t = this._stroke = this._createElement("stroke"), t.endcap = "round", n.appendChild(t)), t.weight = i.weight + "px", t.color = i.color, t.opacity = i.opacity, t.dashStyle = i.dashArray ? i.dashArray instanceof Array ? i.dashArray.join(" ") : i.dashArray.replace(/ *, */g, " ") : "") : t && (n.removeChild(t), this._stroke = null), i.fill ? (e || (e = this._fill = this._createElement("fill"), n.appendChild(e)), e.color = i.fillColor || i.color, e.opacity = i.fillOpacity) : e && (n.removeChild(e), this._fill = null)
            },
            _updatePath: function() {
                var t = this._container.style;
                t.display = "none", this._path.v = this.getPathString() + " ", t.display = ""
            }
        }), n.Map.include(n.Browser.svg || !n.Browser.vml ? {} : {
            _initPathRoot: function() {
                if (!this._pathRoot) {
                    var t = this._pathRoot = e.createElement("div");
                    t.className = "leaflet-vml-container", this._panes.overlayPane.appendChild(t), this.on("moveend", this._updatePathViewport), this._updatePathViewport()
                }
            }
        }), n.Browser.canvas = function() {
            return !!e.createElement("canvas").getContext
        }(), n.Path = n.Path.SVG && !t.L_PREFER_CANVAS || !n.Browser.canvas ? n.Path : n.Path.extend({
            statics: {
                CANVAS: !0,
                SVG: !1
            },
            redraw: function() {
                return this._map && (this.projectLatlngs(), this._requestUpdate()), this
            },
            setStyle: function(t) {
                return n.setOptions(this, t), this._map && (this._updateStyle(), this._requestUpdate()), this
            },
            onRemove: function(t) {
                t.off("viewreset", this.projectLatlngs, this).off("moveend", this._updatePath, this), this.options.clickable && this._map.off("click", this._onClick, this), this._requestUpdate(), this._map = null
            },
            _requestUpdate: function() {
                this._map && !n.Path._updateRequest && (n.Path._updateRequest = n.Util.requestAnimFrame(this._fireMapMoveEnd, this._map))
            },
            _fireMapMoveEnd: function() {
                n.Path._updateRequest = null, this.fire("moveend")
            },
            _initElements: function() {
                this._map._initPathRoot(), this._ctx = this._map._canvasCtx
            },
            _updateStyle: function() {
                var t = this.options;
                t.stroke && (this._ctx.lineWidth = t.weight, this._ctx.strokeStyle = t.color), t.fill && (this._ctx.fillStyle = t.fillColor || t.color)
            },
            _drawPath: function() {
                var t, e, i, o, s, a;
                for (this._ctx.beginPath(), t = 0, i = this._parts.length; i > t; t++) {
                    for (e = 0, o = this._parts[t].length; o > e; e++) s = this._parts[t][e], a = (0 === e ? "move" : "line") + "To", this._ctx[a](s.x, s.y);
                    this instanceof n.Polygon && this._ctx.closePath()
                }
            },
            _checkIfEmpty: function() {
                return !this._parts.length
            },
            _updatePath: function() {
                if (!this._checkIfEmpty()) {
                    var t = this._ctx,
                        e = this.options;
                    this._drawPath(), t.save(), this._updateStyle(), e.fill && (t.globalAlpha = e.fillOpacity, t.fill()), e.stroke && (t.globalAlpha = e.opacity, t.stroke()), t.restore()
                }
            },
            _initEvents: function() {
                this.options.clickable && this._map.on("click", this._onClick, this)
            },
            _onClick: function(t) {
                this._containsPoint(t.layerPoint) && this.fire("click", {
                    latlng: t.latlng,
                    layerPoint: t.layerPoint,
                    containerPoint: t.containerPoint,
                    originalEvent: t
                })
            }
        }), n.Map.include(n.Path.SVG && !t.L_PREFER_CANVAS || !n.Browser.canvas ? {} : {
            _initPathRoot: function() {
                var t, i = this._pathRoot;
                i || (i = this._pathRoot = e.createElement("canvas"), i.style.position = "absolute", t = this._canvasCtx = i.getContext("2d"), t.lineCap = "round", t.lineJoin = "round", this._panes.overlayPane.appendChild(i), this.options.zoomAnimation && (this._pathRoot.className = "leaflet-zoom-animated", this.on("zoomanim", this._animatePathZoom), this.on("zoomend", this._endPathZoom)), this.on("moveend", this._updateCanvasViewport), this._updateCanvasViewport())
            },
            _updateCanvasViewport: function() {
                if (!this._pathZooming) {
                    this._updatePathViewport();
                    var t = this._pathViewport,
                        e = t.min,
                        i = t.max.subtract(e),
                        o = this._pathRoot;
                    n.DomUtil.setPosition(o, e), o.width = i.x, o.height = i.y, o.getContext("2d").translate(-e.x, -e.y)
                }
            }
        }), n.LineUtil = {
            simplify: function(t, e) {
                if (!e || !t.length) return t.slice();
                var i = e * e;
                return t = this._reducePoints(t, i), t = this._simplifyDP(t, i)
            },
            pointToSegmentDistance: function(t, e, i) {
                return Math.sqrt(this._sqClosestPointOnSegment(t, e, i, !0))
            },
            closestPointOnSegment: function(t, e, i) {
                return this._sqClosestPointOnSegment(t, e, i)
            },
            _simplifyDP: function(t, e) {
                var n = t.length,
                    o = typeof Uint8Array != i + "" ? Uint8Array : Array,
                    s = new o(n);
                s[0] = s[n - 1] = 1, this._simplifyDPStep(t, s, e, 0, n - 1);
                var a, r = [];
                for (a = 0; n > a; a++) s[a] && r.push(t[a]);
                return r
            },
            _simplifyDPStep: function(t, e, i, n, o) {
                var s, a, r, h = 0;
                for (a = n + 1; o - 1 >= a; a++) r = this._sqClosestPointOnSegment(t[a], t[n], t[o], !0), r > h && (s = a, h = r);
                h > i && (e[s] = 1, this._simplifyDPStep(t, e, i, n, s), this._simplifyDPStep(t, e, i, s, o))
            },
            _reducePoints: function(t, e) {
                for (var i = [t[0]], n = 1, o = 0, s = t.length; s > n; n++) this._sqDist(t[n], t[o]) > e && (i.push(t[n]), o = n);
                return s - 1 > o && i.push(t[s - 1]), i
            },
            clipSegment: function(t, e, i, n) {
                var o, s, a, r = n ? this._lastCode : this._getBitCode(t, i),
                    h = this._getBitCode(e, i);
                for (this._lastCode = h;;) {
                    if (!(r | h)) return [t, e];
                    if (r & h) return !1;
                    o = r || h, s = this._getEdgeIntersection(t, e, o, i), a = this._getBitCode(s, i), o === r ? (t = s, r = a) : (e = s, h = a)
                }
            },
            _getEdgeIntersection: function(t, e, o, s) {
                var a = e.x - t.x,
                    r = e.y - t.y,
                    h = s.min,
                    l = s.max;
                return 8 & o ? new n.Point(t.x + a * (l.y - t.y) / r, l.y) : 4 & o ? new n.Point(t.x + a * (h.y - t.y) / r, h.y) : 2 & o ? new n.Point(l.x, t.y + r * (l.x - t.x) / a) : 1 & o ? new n.Point(h.x, t.y + r * (h.x - t.x) / a) : i
            },
            _getBitCode: function(t, e) {
                var i = 0;
                return t.x < e.min.x ? i |= 1 : t.x > e.max.x && (i |= 2), t.y < e.min.y ? i |= 4 : t.y > e.max.y && (i |= 8), i
            },
            _sqDist: function(t, e) {
                var i = e.x - t.x,
                    n = e.y - t.y;
                return i * i + n * n
            },
            _sqClosestPointOnSegment: function(t, e, i, o) {
                var s, a = e.x,
                    r = e.y,
                    h = i.x - a,
                    l = i.y - r,
                    u = h * h + l * l;
                return u > 0 && (s = ((t.x - a) * h + (t.y - r) * l) / u, s > 1 ? (a = i.x, r = i.y) : s > 0 && (a += h * s, r += l * s)), h = t.x - a, l = t.y - r, o ? h * h + l * l : new n.Point(a, r)
            }
        }, n.Polyline = n.Path.extend({
            initialize: function(t, e) {
                n.Path.prototype.initialize.call(this, e), this._latlngs = this._convertLatLngs(t)
            },
            options: {
                smoothFactor: 1,
                noClip: !1
            },
            projectLatlngs: function() {
                this._originalPoints = [];
                for (var t = 0, e = this._latlngs.length; e > t; t++) this._originalPoints[t] = this._map.latLngToLayerPoint(this._latlngs[t])
            },
            getPathString: function() {
                for (var t = 0, e = this._parts.length, i = ""; e > t; t++) i += this._getPathPartStr(this._parts[t]);
                return i
            },
            getLatLngs: function() {
                return this._latlngs
            },
            setLatLngs: function(t) {
                return this._latlngs = this._convertLatLngs(t), this.redraw()
            },
            addLatLng: function(t) {
                return this._latlngs.push(n.latLng(t)), this.redraw()
            },
            spliceLatLngs: function() {
                var t = [].splice.apply(this._latlngs, arguments);
                return this._convertLatLngs(this._latlngs), this.redraw(), t
            },
            closestLayerPoint: function(t) {
                for (var e, i, o = 1 / 0, s = this._parts, a = null, r = 0, h = s.length; h > r; r++)
                    for (var l = s[r], u = 1, c = l.length; c > u; u++) {
                        e = l[u - 1], i = l[u];
                        var _ = n.LineUtil._sqClosestPointOnSegment(t, e, i, !0);
                        o > _ && (o = _, a = n.LineUtil._sqClosestPointOnSegment(t, e, i))
                    }
                return a && (a.distance = Math.sqrt(o)), a
            },
            getBounds: function() {
                var t, e, i = new n.LatLngBounds,
                    o = this.getLatLngs();
                for (t = 0, e = o.length; e > t; t++) i.extend(o[t]);
                return i
            },
            _convertLatLngs: function(t) {
                var e, i;
                for (e = 0, i = t.length; i > e; e++) {
                    if (n.Util.isArray(t[e]) && "number" != typeof t[e][0]) return;
                    t[e] = n.latLng(t[e])
                }
                return t
            },
            _initEvents: function() {
                n.Path.prototype._initEvents.call(this)
            },
            _getPathPartStr: function(t) {
                for (var e, i = n.Path.VML, o = 0, s = t.length, a = ""; s > o; o++) e = t[o], i && e._round(), a += (o ? "L" : "M") + e.x + " " + e.y;
                return a
            },
            _clipPoints: function() {
                var t, e, o, s = this._originalPoints,
                    a = s.length;
                if (this.options.noClip) return this._parts = [s], i;
                this._parts = [];
                var r = this._parts,
                    h = this._map._pathViewport,
                    l = n.LineUtil;
                for (t = 0, e = 0; a - 1 > t; t++) o = l.clipSegment(s[t], s[t + 1], h, t), o && (r[e] = r[e] || [], r[e].push(o[0]), (o[1] !== s[t + 1] || t === a - 2) && (r[e].push(o[1]), e++))
            },
            _simplifyPoints: function() {
                for (var t = this._parts, e = n.LineUtil, i = 0, o = t.length; o > i; i++) t[i] = e.simplify(t[i], this.options.smoothFactor)
            },
            _updatePath: function() {
                this._map && (this._clipPoints(), this._simplifyPoints(), n.Path.prototype._updatePath.call(this))
            }
        }), n.polyline = function(t, e) {
            return new n.Polyline(t, e)
        }, n.PolyUtil = {}, n.PolyUtil.clipPolygon = function(t, e) {
            var i, o, s, a, r, h, l, u, c, _ = [1, 4, 2, 8],
                d = n.LineUtil;
            for (o = 0, l = t.length; l > o; o++) t[o]._code = d._getBitCode(t[o], e);
            for (a = 0; 4 > a; a++) {
                for (u = _[a], i = [], o = 0, l = t.length, s = l - 1; l > o; s = o++) r = t[o], h = t[s], r._code & u ? h._code & u || (c = d._getEdgeIntersection(h, r, u, e), c._code = d._getBitCode(c, e), i.push(c)) : (h._code & u && (c = d._getEdgeIntersection(h, r, u, e), c._code = d._getBitCode(c, e), i.push(c)), i.push(r));
                t = i
            }
            return t
        }, n.Polygon = n.Polyline.extend({
            options: {
                fill: !0
            },
            initialize: function(t, e) {
                n.Polyline.prototype.initialize.call(this, t, e), t && n.Util.isArray(t[0]) && "number" != typeof t[0][0] && (this._latlngs = this._convertLatLngs(t[0]), this._holes = t.slice(1))
            },
            projectLatlngs: function() {
                if (n.Polyline.prototype.projectLatlngs.call(this), this._holePoints = [], this._holes) {
                    var t, e, i, o;
                    for (t = 0, i = this._holes.length; i > t; t++)
                        for (this._holePoints[t] = [], e = 0, o = this._holes[t].length; o > e; e++) this._holePoints[t][e] = this._map.latLngToLayerPoint(this._holes[t][e])
                }
            },
            _clipPoints: function() {
                var t = this._originalPoints,
                    e = [];
                if (this._parts = [t].concat(this._holePoints), !this.options.noClip) {
                    for (var i = 0, o = this._parts.length; o > i; i++) {
                        var s = n.PolyUtil.clipPolygon(this._parts[i], this._map._pathViewport);
                        s.length && e.push(s)
                    }
                    this._parts = e
                }
            },
            _getPathPartStr: function(t) {
                var e = n.Polyline.prototype._getPathPartStr.call(this, t);
                return e + (n.Browser.svg ? "z" : "x")
            }
        }), n.polygon = function(t, e) {
            return new n.Polygon(t, e)
        },
        function() {
            function t(t) {
                return n.FeatureGroup.extend({
                    initialize: function(t, e) {
                        this._layers = {}, this._options = e, this.setLatLngs(t)
                    },
                    setLatLngs: function(e) {
                        var i = 0,
                            n = e.length;
                        for (this.eachLayer(function(t) {
                                n > i ? t.setLatLngs(e[i++]) : this.removeLayer(t)
                            }, this); n > i;) this.addLayer(new t(e[i++], this._options));
                        return this
                    }
                })
            }
            n.MultiPolyline = t(n.Polyline), n.MultiPolygon = t(n.Polygon), n.multiPolyline = function(t, e) {
                return new n.MultiPolyline(t, e)
            }, n.multiPolygon = function(t, e) {
                return new n.MultiPolygon(t, e)
            }
        }(), n.Rectangle = n.Polygon.extend({
            initialize: function(t, e) {
                n.Polygon.prototype.initialize.call(this, this._boundsToLatLngs(t), e)
            },
            setBounds: function(t) {
                this.setLatLngs(this._boundsToLatLngs(t))
            },
            _boundsToLatLngs: function(t) {
                return t = n.latLngBounds(t), [t.getSouthWest(), t.getNorthWest(), t.getNorthEast(), t.getSouthEast()]
            }
        }), n.rectangle = function(t, e) {
            return new n.Rectangle(t, e)
        }, n.Circle = n.Path.extend({
            initialize: function(t, e, i) {
                n.Path.prototype.initialize.call(this, i), this._latlng = n.latLng(t), this._mRadius = e
            },
            options: {
                fill: !0
            },
            setLatLng: function(t) {
                return this._latlng = n.latLng(t), this.redraw()
            },
            setRadius: function(t) {
                return this._mRadius = t, this.redraw()
            },
            projectLatlngs: function() {
                var t = this._getLngRadius(),
                    e = new n.LatLng(this._latlng.lat, this._latlng.lng - t),
                    i = this._map.latLngToLayerPoint(e);
                this._point = this._map.latLngToLayerPoint(this._latlng), this._radius = Math.max(Math.round(this._point.x - i.x), 1)
            },
            getBounds: function() {
                var t = this._getLngRadius(),
                    e = 360 * (this._mRadius / 40075017),
                    i = this._latlng,
                    o = new n.LatLng(i.lat - e, i.lng - t),
                    s = new n.LatLng(i.lat + e, i.lng + t);
                return new n.LatLngBounds(o, s)
            },
            getLatLng: function() {
                return this._latlng
            },
            getPathString: function() {
                var t = this._point,
                    e = this._radius;
                return this._checkIfEmpty() ? "" : n.Browser.svg ? "M" + t.x + "," + (t.y - e) + "A" + e + "," + e + ",0,1,1," + (t.x - .1) + "," + (t.y - e) + " z" : (t._round(), e = Math.round(e), "AL " + t.x + "," + t.y + " " + e + "," + e + " 0," + 23592600)
            },
            getRadius: function() {
                return this._mRadius
            },
            _getLatRadius: function() {
                return 360 * (this._mRadius / 40075017)
            },
            _getLngRadius: function() {
                return this._getLatRadius() / Math.cos(n.LatLng.DEG_TO_RAD * this._latlng.lat)
            },
            _checkIfEmpty: function() {
                if (!this._map) return !1;
                var t = this._map._pathViewport,
                    e = this._radius,
                    i = this._point;
                return i.x - e > t.max.x || i.y - e > t.max.y || i.x + e < t.min.x || i.y + e < t.min.y
            }
        }), n.circle = function(t, e, i) {
            return new n.Circle(t, e, i)
        }, n.CircleMarker = n.Circle.extend({
            options: {
                radius: 10,
                weight: 2
            },
            initialize: function(t, e) {
                n.Circle.prototype.initialize.call(this, t, null, e), this._radius = this.options.radius
            },
            projectLatlngs: function() {
                this._point = this._map.latLngToLayerPoint(this._latlng)
            },
            _updateStyle: function() {
                n.Circle.prototype._updateStyle.call(this), this.setRadius(this.options.radius)
            },
            setRadius: function(t) {
                return this.options.radius = this._radius = t, this.redraw()
            }
        }), n.circleMarker = function(t, e) {
            return new n.CircleMarker(t, e)
        }, n.Polyline.include(n.Path.CANVAS ? {
            _containsPoint: function(t, e) {
                var i, o, s, a, r, h, l, u = this.options.weight / 2;
                for (n.Browser.touch && (u += 10), i = 0, a = this._parts.length; a > i; i++)
                    for (l = this._parts[i], o = 0, r = l.length, s = r - 1; r > o; s = o++)
                        if ((e || 0 !== o) && (h = n.LineUtil.pointToSegmentDistance(t, l[s], l[o]), u >= h)) return !0;
                return !1
            }
        } : {}), n.Polygon.include(n.Path.CANVAS ? {
            _containsPoint: function(t) {
                var e, i, o, s, a, r, h, l, u = !1;
                if (n.Polyline.prototype._containsPoint.call(this, t, !0)) return !0;
                for (s = 0, h = this._parts.length; h > s; s++)
                    for (e = this._parts[s], a = 0, l = e.length, r = l - 1; l > a; r = a++) i = e[a], o = e[r], i.y > t.y != o.y > t.y && t.x < (o.x - i.x) * (t.y - i.y) / (o.y - i.y) + i.x && (u = !u);
                return u
            }
        } : {}), n.Circle.include(n.Path.CANVAS ? {
            _drawPath: function() {
                var t = this._point;
                this._ctx.beginPath(), this._ctx.arc(t.x, t.y, this._radius, 0, 2 * Math.PI, !1)
            },
            _containsPoint: function(t) {
                var e = this._point,
                    i = this.options.stroke ? this.options.weight / 2 : 0;
                return t.distanceTo(e) <= this._radius + i
            }
        } : {}), n.GeoJSON = n.FeatureGroup.extend({
            initialize: function(t, e) {
                n.setOptions(this, e), this._layers = {}, t && this.addData(t)
            },
            addData: function(t) {
                var e, i, o = n.Util.isArray(t) ? t : t.features;
                if (o) {
                    for (e = 0, i = o.length; i > e; e++)(o[e].geometries || o[e].geometry || o[e].features) && this.addData(o[e]);
                    return this
                }
                var s = this.options;
                if (!s.filter || s.filter(t)) {
                    var a = n.GeoJSON.geometryToLayer(t, s.pointToLayer);
                    return a.feature = t, a.defaultOptions = a.options, this.resetStyle(a), s.onEachFeature && s.onEachFeature(t, a), this.addLayer(a)
                }
            },
            resetStyle: function(t) {
                var e = this.options.style;
                e && (n.Util.extend(t.options, t.defaultOptions), this._setLayerStyle(t, e))
            },
            setStyle: function(t) {
                this.eachLayer(function(e) {
                    this._setLayerStyle(e, t)
                }, this)
            },
            _setLayerStyle: function(t, e) {
                "function" == typeof e && (e = e(t.feature)), t.setStyle && t.setStyle(e)
            }
        }), n.extend(n.GeoJSON, {
            geometryToLayer: function(t, e) {
                var i, o, s, a, r, h = "Feature" === t.type ? t.geometry : t,
                    l = h.coordinates,
                    u = [];
                switch (h.type) {
                    case "Point":
                        return i = this.coordsToLatLng(l), e ? e(t, i) : new n.Marker(i);
                    case "MultiPoint":
                        for (s = 0, a = l.length; a > s; s++) i = this.coordsToLatLng(l[s]), r = e ? e(t, i) : new n.Marker(i), u.push(r);
                        return new n.FeatureGroup(u);
                    case "LineString":
                        return o = this.coordsToLatLngs(l), new n.Polyline(o);
                    case "Polygon":
                        return o = this.coordsToLatLngs(l, 1), new n.Polygon(o);
                    case "MultiLineString":
                        return o = this.coordsToLatLngs(l, 1), new n.MultiPolyline(o);
                    case "MultiPolygon":
                        return o = this.coordsToLatLngs(l, 2), new n.MultiPolygon(o);
                    case "GeometryCollection":
                        for (s = 0, a = h.geometries.length; a > s; s++) r = this.geometryToLayer({
                            geometry: h.geometries[s],
                            type: "Feature",
                            properties: t.properties
                        }, e), u.push(r);
                        return new n.FeatureGroup(u);
                    default:
                        throw Error("Invalid GeoJSON object.")
                }
            },
            coordsToLatLng: function(t, e) {
                var i = parseFloat(t[e ? 0 : 1]),
                    o = parseFloat(t[e ? 1 : 0]);
                return new n.LatLng(i, o)
            },
            coordsToLatLngs: function(t, e, i) {
                var n, o, s, a = [];
                for (o = 0, s = t.length; s > o; o++) n = e ? this.coordsToLatLngs(t[o], e - 1, i) : this.coordsToLatLng(t[o], i), a.push(n);
                return a
            }
        }), n.geoJson = function(t, e) {
            return new n.GeoJSON(t, e)
        }, n.DomEvent = {
            addListener: function(t, e, o, s) {
                var a, r, h, l = n.stamp(o),
                    u = "_leaflet_" + e + l;
                return t[u] ? this : (a = function(e) {
                    return o.call(s || t, e || n.DomEvent._getEvent())
                }, n.Browser.msTouch && 0 === e.indexOf("touch") ? this.addMsTouchListener(t, e, a, l) : (n.Browser.touch && "dblclick" === e && this.addDoubleTapListener && this.addDoubleTapListener(t, a, l), "addEventListener" in t ? "mousewheel" === e ? (t.addEventListener("DOMMouseScroll", a, !1), t.addEventListener(e, a, !1)) : "mouseenter" === e || "mouseleave" === e ? (r = a, h = "mouseenter" === e ? "mouseover" : "mouseout", a = function(e) {
                    return n.DomEvent._checkMouse(t, e) ? r(e) : i
                }, t.addEventListener(h, a, !1)) : t.addEventListener(e, a, !1) : "attachEvent" in t && t.attachEvent("on" + e, a), t[u] = a, this))
            },
            removeListener: function(t, e, i) {
                var o = n.stamp(i),
                    s = "_leaflet_" + e + o,
                    a = t[s];
                if (a) return n.Browser.msTouch && 0 === e.indexOf("touch") ? this.removeMsTouchListener(t, e, o) : n.Browser.touch && "dblclick" === e && this.removeDoubleTapListener ? this.removeDoubleTapListener(t, o) : "removeEventListener" in t ? "mousewheel" === e ? (t.removeEventListener("DOMMouseScroll", a, !1), t.removeEventListener(e, a, !1)) : "mouseenter" === e || "mouseleave" === e ? t.removeEventListener("mouseenter" === e ? "mouseover" : "mouseout", a, !1) : t.removeEventListener(e, a, !1) : "detachEvent" in t && t.detachEvent("on" + e, a), t[s] = null, this
            },
            stopPropagation: function(t) {
                return t.stopPropagation ? t.stopPropagation() : t.cancelBubble = !0, this
            },
            disableClickPropagation: function(t) {
                for (var e = n.DomEvent.stopPropagation, i = n.Draggable.START.length - 1; i >= 0; i--) n.DomEvent.addListener(t, n.Draggable.START[i], e);
                return n.DomEvent.addListener(t, "click", e).addListener(t, "dblclick", e)
            },
            preventDefault: function(t) {
                return t.preventDefault ? t.preventDefault() : t.returnValue = !1, this
            },
            stop: function(t) {
                return n.DomEvent.preventDefault(t).stopPropagation(t)
            },
            getMousePosition: function(t, i) {
                var o = e.body,
                    s = e.documentElement,
                    a = t.pageX ? t.pageX : t.clientX + o.scrollLeft + s.scrollLeft,
                    r = t.pageY ? t.pageY : t.clientY + o.scrollTop + s.scrollTop,
                    h = new n.Point(a, r);
                return i ? h._subtract(n.DomUtil.getViewportOffset(i)) : h
            },
            getWheelDelta: function(t) {
                var e = 0;
                return t.wheelDelta && (e = t.wheelDelta / 120), t.detail && (e = -t.detail / 3), e
            },
            _checkMouse: function(t, e) {
                var i = e.relatedTarget;
                if (!i) return !0;
                try {
                    for (; i && i !== t;) i = i.parentNode
                } catch (n) {
                    return !1
                }
                return i !== t
            },
            _getEvent: function() {
                var e = t.event;
                if (!e)
                    for (var i = arguments.callee.caller; i && (e = i.arguments[0], !e || t.Event !== e.constructor);) i = i.caller;
                return e
            }
        }, n.DomEvent.on = n.DomEvent.addListener, n.DomEvent.off = n.DomEvent.removeListener, n.Draggable = n.Class.extend({
            includes: n.Mixin.Events,
            statics: {
                START: n.Browser.touch ? ["touchstart", "mousedown"] : ["mousedown"],
                END: {
                    mousedown: "mouseup",
                    touchstart: "touchend",
                    MSPointerDown: "touchend"
                },
                MOVE: {
                    mousedown: "mousemove",
                    touchstart: "touchmove",
                    MSPointerDown: "touchmove"
                },
                TAP_TOLERANCE: 15
            },
            initialize: function(t, e, i) {
                this._element = t, this._dragStartTarget = e || t, this._longPress = i && !n.Browser.msTouch
            },
            enable: function() {
                if (!this._enabled) {
                    for (var t = n.Draggable.START.length - 1; t >= 0; t--) n.DomEvent.on(this._dragStartTarget, n.Draggable.START[t], this._onDown, this);
                    this._enabled = !0
                }
            },
            disable: function() {
                if (this._enabled) {
                    for (var t = n.Draggable.START.length - 1; t >= 0; t--) n.DomEvent.off(this._dragStartTarget, n.Draggable.START[t], this._onDown, this);
                    this._enabled = !1, this._moved = !1
                }
            },
            _onDown: function(t) {
                if (!(!n.Browser.touch && t.shiftKey || 1 !== t.which && 1 !== t.button && !t.touches || (n.DomEvent.preventDefault(t), n.DomEvent.stopPropagation(t), n.Draggable._disabled))) {
                    if (this._simulateClick = !0, t.touches && t.touches.length > 1) return this._simulateClick = !1, clearTimeout(this._longPressTimeout), i;
                    var o = t.touches && 1 === t.touches.length ? t.touches[0] : t,
                        s = o.target;
                    n.Browser.touch && "a" === s.tagName.toLowerCase() && n.DomUtil.addClass(s, "leaflet-active"), this._moved = !1, this._moving || (this._startPoint = new n.Point(o.clientX, o.clientY), this._startPos = this._newPos = n.DomUtil.getPosition(this._element), t.touches && 1 === t.touches.length && n.Browser.touch && this._longPress && (this._longPressTimeout = setTimeout(n.bind(function() {
                        var t = this._newPos && this._newPos.distanceTo(this._startPos) || 0;
                        n.Draggable.TAP_TOLERANCE > t && (this._simulateClick = !1, this._onUp(), this._simulateEvent("contextmenu", o))
                    }, this), 1e3)), n.DomEvent.on(e, n.Draggable.MOVE[t.type], this._onMove, this), n.DomEvent.on(e, n.Draggable.END[t.type], this._onUp, this))
                }
            },
            _onMove: function(t) {
                if (!(t.touches && t.touches.length > 1)) {
                    var e = t.touches && 1 === t.touches.length ? t.touches[0] : t,
                        i = new n.Point(e.clientX, e.clientY),
                        o = i.subtract(this._startPoint);
                    (o.x || o.y) && (n.DomEvent.preventDefault(t), this._moved || (this.fire("dragstart"), this._moved = !0, this._startPos = n.DomUtil.getPosition(this._element).subtract(o), n.Browser.touch || (n.DomUtil.disableTextSelection(), this._setMovingCursor())), this._newPos = this._startPos.add(o), this._moving = !0, n.Util.cancelAnimFrame(this._animRequest), this._animRequest = n.Util.requestAnimFrame(this._updatePosition, this, !0, this._dragStartTarget))
                }
            },
            _updatePosition: function() {
                this.fire("predrag"), n.DomUtil.setPosition(this._element, this._newPos), this.fire("drag")
            },
            _onUp: function(t) {
                var i;
                if (clearTimeout(this._longPressTimeout), this._simulateClick && t.changedTouches) {
                    var o = t.changedTouches[0],
                        s = o.target,
                        a = this._newPos && this._newPos.distanceTo(this._startPos) || 0;
                    "a" === s.tagName.toLowerCase() && n.DomUtil.removeClass(s, "leaflet-active"), n.Draggable.TAP_TOLERANCE > a && (i = o)
                }
                n.Browser.touch || (n.DomUtil.enableTextSelection(), this._restoreCursor());
                for (var r in n.Draggable.MOVE) n.Draggable.MOVE.hasOwnProperty(r) && (n.DomEvent.off(e, n.Draggable.MOVE[r], this._onMove), n.DomEvent.off(e, n.Draggable.END[r], this._onUp));
                this._moved && (n.Util.cancelAnimFrame(this._animRequest), this.fire("dragend")), this._moving = !1, i && (this._moved = !1, this._simulateEvent("click", i))
            },
            _setMovingCursor: function() {
                n.DomUtil.addClass(e.body, "leaflet-dragging")
            },
            _restoreCursor: function() {
                n.DomUtil.removeClass(e.body, "leaflet-dragging")
            },
            _simulateEvent: function(i, n) {
                var o = e.createEvent("MouseEvents");
                o.initMouseEvent(i, !0, !0, t, 1, n.screenX, n.screenY, n.clientX, n.clientY, !1, !1, !1, !1, 0, null), n.target.dispatchEvent(o)
            }
        }), n.Handler = n.Class.extend({
            initialize: function(t) {
                this._map = t
            },
            enable: function() {
                this._enabled || (this._enabled = !0, this.addHooks())
            },
            disable: function() {
                this._enabled && (this._enabled = !1, this.removeHooks())
            },
            enabled: function() {
                return !!this._enabled
            }
        }), n.Map.mergeOptions({
            dragging: !0,
            inertia: !n.Browser.android23,
            inertiaDeceleration: 3400,
            inertiaMaxSpeed: 1 / 0,
            inertiaThreshold: n.Browser.touch ? 32 : 18,
            easeLinearity: .25,
            longPress: !0,
            worldCopyJump: !1
        }), n.Map.Drag = n.Handler.extend({
            addHooks: function() {
                if (!this._draggable) {
                    var t = this._map;
                    this._draggable = new n.Draggable(t._mapPane, t._container, t.options.longPress), this._draggable.on({
                        dragstart: this._onDragStart,
                        drag: this._onDrag,
                        dragend: this._onDragEnd
                    }, this), t.options.worldCopyJump && (this._draggable.on("predrag", this._onPreDrag, this), t.on("viewreset", this._onViewReset, this))
                }
                this._draggable.enable()
            },
            removeHooks: function() {
                this._draggable.disable()
            },
            moved: function() {
                return this._draggable && this._draggable._moved
            },
            _onDragStart: function() {
                var t = this._map;
                t._panAnim && t._panAnim.stop(), t.fire("movestart").fire("dragstart"), t.options.inertia && (this._positions = [], this._times = [])
            },
            _onDrag: function() {
                if (this._map.options.inertia) {
                    var t = this._lastTime = +new Date,
                        e = this._lastPos = this._draggable._newPos;
                    this._positions.push(e), this._times.push(t), t - this._times[0] > 200 && (this._positions.shift(), this._times.shift())
                }
                this._map.fire("move").fire("drag")
            },
            _onViewReset: function() {
                var t = this._map.getSize()._divideBy(2),
                    e = this._map.latLngToLayerPoint(new n.LatLng(0, 0));
                this._initialWorldOffset = e.subtract(t).x, this._worldWidth = this._map.project(new n.LatLng(0, 180)).x
            },
            _onPreDrag: function() {
                var t = this._worldWidth,
                    e = Math.round(t / 2),
                    i = this._initialWorldOffset,
                    n = this._draggable._newPos.x,
                    o = (n - e + i) % t + e - i,
                    s = (n + e + i) % t - e - i,
                    a = Math.abs(o + i) < Math.abs(s + i) ? o : s;
                this._draggable._newPos.x = a
            },
            _onDragEnd: function() {
                var t = this._map,
                    e = t.options,
                    i = +new Date - this._lastTime,
                    o = !e.inertia || i > e.inertiaThreshold || !this._positions[0];
                if (o) t.fire("moveend");
                else {
                    var s = this._lastPos.subtract(this._positions[0]),
                        a = (this._lastTime + i - this._times[0]) / 1e3,
                        r = e.easeLinearity,
                        h = s.multiplyBy(r / a),
                        l = h.distanceTo(new n.Point(0, 0)),
                        u = Math.min(e.inertiaMaxSpeed, l),
                        c = h.multiplyBy(u / l),
                        _ = u / (e.inertiaDeceleration * r),
                        d = c.multiplyBy(-_ / 2).round();
                    n.Util.requestAnimFrame(function() {
                        t.panBy(d, _, r)
                    })
                }
                t.fire("dragend"), e.maxBounds && n.Util.requestAnimFrame(this._panInsideMaxBounds, t, !0, t._container)
            },
            _panInsideMaxBounds: function() {
                this.panInsideBounds(this.options.maxBounds)
            }
        }), n.Map.addInitHook("addHandler", "dragging", n.Map.Drag), n.Map.mergeOptions({
            doubleClickZoom: !0
        }), n.Map.DoubleClickZoom = n.Handler.extend({
            addHooks: function() {
                this._map.on("dblclick", this._onDoubleClick)
            },
            removeHooks: function() {
                this._map.off("dblclick", this._onDoubleClick)
            },
            _onDoubleClick: function(t) {
                this.setView(t.latlng, this._zoom + 1)
            }
        }), n.Map.addInitHook("addHandler", "doubleClickZoom", n.Map.DoubleClickZoom), n.Map.mergeOptions({
            scrollWheelZoom: !0
        }), n.Map.ScrollWheelZoom = n.Handler.extend({
            addHooks: function() {
                n.DomEvent.on(this._map._container, "mousewheel", this._onWheelScroll, this), this._delta = 0
            },
            removeHooks: function() {
                n.DomEvent.off(this._map._container, "mousewheel", this._onWheelScroll)
            },
            _onWheelScroll: function(t) {
                var e = n.DomEvent.getWheelDelta(t);
                this._delta += e, this._lastMousePos = this._map.mouseEventToContainerPoint(t), this._startTime || (this._startTime = +new Date);
                var i = Math.max(40 - (+new Date - this._startTime), 0);
                clearTimeout(this._timer), this._timer = setTimeout(n.bind(this._performZoom, this), i), n.DomEvent.preventDefault(t), n.DomEvent.stopPropagation(t)
            },
            _performZoom: function() {
                var t = this._map,
                    e = this._delta,
                    i = t.getZoom();
                if (e = e > 0 ? Math.ceil(e) : Math.round(e), e = Math.max(Math.min(e, 4), -4), e = t._limitZoom(i + e) - i, this._delta = 0, this._startTime = null, e) {
                    var n = i + e,
                        o = this._getCenterForScrollWheelZoom(n);
                    t.setView(o, n)
                }
            },
            _getCenterForScrollWheelZoom: function(t) {
                var e = this._map,
                    i = e.getZoomScale(t),
                    n = e.getSize()._divideBy(2),
                    o = this._lastMousePos._subtract(n)._multiplyBy(1 - 1 / i),
                    s = e._getTopLeftPoint()._add(n)._add(o);
                return e.unproject(s)
            }
        }), n.Map.addInitHook("addHandler", "scrollWheelZoom", n.Map.ScrollWheelZoom), n.extend(n.DomEvent, {
            _touchstart: n.Browser.msTouch ? "MSPointerDown" : "touchstart",
            _touchend: n.Browser.msTouch ? "MSPointerUp" : "touchend",
            addDoubleTapListener: function(t, i, o) {
                function s(t) {
                    var e;
                    if (n.Browser.msTouch ? (p.push(t.pointerId), e = p.length) : e = t.touches.length, !(e > 1)) {
                        var i = Date.now(),
                            o = i - (r || i);
                        h = t.touches ? t.touches[0] : t, l = o > 0 && u >= o, r = i
                    }
                }

                function a(t) {
                    if (n.Browser.msTouch) {
                        var e = p.indexOf(t.pointerId);
                        if (-1 === e) return;
                        p.splice(e, 1)
                    }
                    if (l) {
                        if (n.Browser.msTouch) {
                            var o, s = {};
                            for (var a in h) o = h[a], s[a] = "function" == typeof o ? o.bind(h) : o;
                            h = s
                        }
                        h.type = "dblclick", i(h), r = null
                    }
                }
                var r, h, l = !1,
                    u = 250,
                    c = "_leaflet_",
                    _ = this._touchstart,
                    d = this._touchend,
                    p = [];
                t[c + _ + o] = s, t[c + d + o] = a;
                var m = n.Browser.msTouch ? e.documentElement : t;
                return t.addEventListener(_, s, !1), m.addEventListener(d, a, !1), n.Browser.msTouch && m.addEventListener("MSPointerCancel", a, !1), this
            },
            removeDoubleTapListener: function(t, i) {
                var o = "_leaflet_";
                return t.removeEventListener(this._touchstart, t[o + this._touchstart + i], !1), (n.Browser.msTouch ? e.documentElement : t).removeEventListener(this._touchend, t[o + this._touchend + i], !1), n.Browser.msTouch && e.documentElement.removeEventListener("MSPointerCancel", t[o + this._touchend + i], !1), this
            }
        }), n.extend(n.DomEvent, {
            _msTouches: [],
            _msDocumentListener: !1,
            addMsTouchListener: function(t, e, i, n) {
                switch (e) {
                    case "touchstart":
                        return this.addMsTouchListenerStart(t, e, i, n);
                    case "touchend":
                        return this.addMsTouchListenerEnd(t, e, i, n);
                    case "touchmove":
                        return this.addMsTouchListenerMove(t, e, i, n);
                    default:
                        throw "Unknown touch event type"
                }
            },
            addMsTouchListenerStart: function(t, i, n, o) {
                var s = "_leaflet_",
                    a = this._msTouches,
                    r = function(t) {
                        for (var e = !1, i = 0; a.length > i; i++)
                            if (a[i].pointerId === t.pointerId) {
                                e = !0;
                                break
                            }
                        e || a.push(t), t.touches = a.slice(), t.changedTouches = [t], n(t)
                    };
                if (t[s + "touchstart" + o] = r, t.addEventListener("MSPointerDown", r, !1), !this._msDocumentListener) {
                    var h = function(t) {
                        for (var e = 0; a.length > e; e++)
                            if (a[e].pointerId === t.pointerId) {
                                a.splice(e, 1);
                                break
                            }
                    };
                    e.documentElement.addEventListener("MSPointerUp", h, !1), e.documentElement.addEventListener("MSPointerCancel", h, !1), this._msDocumentListener = !0
                }
                return this
            },
            addMsTouchListenerMove: function(t, e, i, n) {
                function o(t) {
                    if (t.pointerType !== t.MSPOINTER_TYPE_MOUSE || 0 !== t.buttons) {
                        for (var e = 0; a.length > e; e++)
                            if (a[e].pointerId === t.pointerId) {
                                a[e] = t;
                                break
                            }
                        t.touches = a.slice(), t.changedTouches = [t], i(t)
                    }
                }
                var s = "_leaflet_",
                    a = this._msTouches;
                return t[s + "touchmove" + n] = o, t.addEventListener("MSPointerMove", o, !1), this
            },
            addMsTouchListenerEnd: function(t, e, i, n) {
                var o = "_leaflet_",
                    s = this._msTouches,
                    a = function(t) {
                        for (var e = 0; s.length > e; e++)
                            if (s[e].pointerId === t.pointerId) {
                                s.splice(e, 1);
                                break
                            }
                        t.touches = s.slice(), t.changedTouches = [t], i(t)
                    };
                return t[o + "touchend" + n] = a, t.addEventListener("MSPointerUp", a, !1), t.addEventListener("MSPointerCancel", a, !1), this
            },
            removeMsTouchListener: function(t, e, i) {
                var n = "_leaflet_",
                    o = t[n + e + i];
                switch (e) {
                    case "touchstart":
                        t.removeEventListener("MSPointerDown", o, !1);
                        break;
                    case "touchmove":
                        t.removeEventListener("MSPointerMove", o, !1);
                        break;
                    case "touchend":
                        t.removeEventListener("MSPointerUp", o, !1), t.removeEventListener("MSPointerCancel", o, !1)
                }
                return this
            }
        }), n.Map.mergeOptions({
            touchZoom: n.Browser.touch && !n.Browser.android23
        }), n.Map.TouchZoom = n.Handler.extend({
            addHooks: function() {
                n.DomEvent.on(this._map._container, "touchstart", this._onTouchStart, this)
            },
            removeHooks: function() {
                n.DomEvent.off(this._map._container, "touchstart", this._onTouchStart, this)
            },
            _onTouchStart: function(t) {
                var i = this._map;
                if (t.touches && 2 === t.touches.length && !i._animatingZoom && !this._zooming) {
                    var o = i.mouseEventToLayerPoint(t.touches[0]),
                        s = i.mouseEventToLayerPoint(t.touches[1]),
                        a = i._getCenterLayerPoint();
                    this._startCenter = o.add(s)._divideBy(2), this._startDist = o.distanceTo(s), this._moved = !1, this._zooming = !0, this._centerOffset = a.subtract(this._startCenter), i._panAnim && i._panAnim.stop(), n.DomEvent.on(e, "touchmove", this._onTouchMove, this).on(e, "touchend", this._onTouchEnd, this), n.DomEvent.preventDefault(t)
                }
            },
            _onTouchMove: function(t) {
                if (t.touches && 2 === t.touches.length) {
                    var e = this._map,
                        i = e.mouseEventToLayerPoint(t.touches[0]),
                        o = e.mouseEventToLayerPoint(t.touches[1]);
                    this._scale = i.distanceTo(o) / this._startDist, this._delta = i._add(o)._divideBy(2)._subtract(this._startCenter), 1 !== this._scale && (this._moved || (n.DomUtil.addClass(e._mapPane, "leaflet-zoom-anim leaflet-touching"), e.fire("movestart").fire("zoomstart")._prepareTileBg(), this._moved = !0), n.Util.cancelAnimFrame(this._animRequest), this._animRequest = n.Util.requestAnimFrame(this._updateOnMove, this, !0, this._map._container), n.DomEvent.preventDefault(t))
                }
            },
            _updateOnMove: function() {
                var t = this._map,
                    e = this._getScaleOrigin(),
                    i = t.layerPointToLatLng(e);
                t.fire("zoomanim", {
                    center: i,
                    zoom: t.getScaleZoom(this._scale)
                }), t._tileBg.style[n.DomUtil.TRANSFORM] = n.DomUtil.getTranslateString(this._delta) + " " + n.DomUtil.getScaleString(this._scale, this._startCenter)
            },
            _onTouchEnd: function() {
                if (this._moved && this._zooming) {
                    var t = this._map;
                    this._zooming = !1, n.DomUtil.removeClass(t._mapPane, "leaflet-touching"), n.DomEvent.off(e, "touchmove", this._onTouchMove).off(e, "touchend", this._onTouchEnd);
                    var i = this._getScaleOrigin(),
                        o = t.layerPointToLatLng(i),
                        s = t.getZoom(),
                        a = t.getScaleZoom(this._scale) - s,
                        r = a > 0 ? Math.ceil(a) : Math.floor(a),
                        h = t._limitZoom(s + r);
                    t.fire("zoomanim", {
                        center: o,
                        zoom: h
                    }), t._runAnimation(o, h, t.getZoomScale(h) / this._scale, i, !0)
                }
            },
            _getScaleOrigin: function() {
                var t = this._centerOffset.subtract(this._delta).divideBy(this._scale);
                return this._startCenter.add(t)
            }
        }), n.Map.addInitHook("addHandler", "touchZoom", n.Map.TouchZoom), n.Map.mergeOptions({
            boxZoom: !0
        }), n.Map.BoxZoom = n.Handler.extend({
            initialize: function(t) {
                this._map = t, this._container = t._container, this._pane = t._panes.overlayPane
            },
            addHooks: function() {
                n.DomEvent.on(this._container, "mousedown", this._onMouseDown, this)
            },
            removeHooks: function() {
                n.DomEvent.off(this._container, "mousedown", this._onMouseDown)
            },
            _onMouseDown: function(t) {
                return !t.shiftKey || 1 !== t.which && 1 !== t.button ? !1 : (n.DomUtil.disableTextSelection(), this._startLayerPoint = this._map.mouseEventToLayerPoint(t), this._box = n.DomUtil.create("div", "leaflet-zoom-box", this._pane), n.DomUtil.setPosition(this._box, this._startLayerPoint), this._container.style.cursor = "crosshair", n.DomEvent.on(e, "mousemove", this._onMouseMove, this).on(e, "mouseup", this._onMouseUp, this).preventDefault(t), this._map.fire("boxzoomstart"), i)
            },
            _onMouseMove: function(t) {
                var e = this._startLayerPoint,
                    i = this._box,
                    o = this._map.mouseEventToLayerPoint(t),
                    s = o.subtract(e),
                    a = new n.Point(Math.min(o.x, e.x), Math.min(o.y, e.y));
                n.DomUtil.setPosition(i, a), i.style.width = Math.max(0, Math.abs(s.x) - 4) + "px", i.style.height = Math.max(0, Math.abs(s.y) - 4) + "px"
            },
            _onMouseUp: function(t) {
                this._pane.removeChild(this._box), this._container.style.cursor = "", n.DomUtil.enableTextSelection(), n.DomEvent.off(e, "mousemove", this._onMouseMove).off(e, "mouseup", this._onMouseUp);
                var i = this._map,
                    o = i.mouseEventToLayerPoint(t);
                if (!this._startLayerPoint.equals(o)) {
                    var s = new n.LatLngBounds(i.layerPointToLatLng(this._startLayerPoint), i.layerPointToLatLng(o));
                    i.fitBounds(s), i.fire("boxzoomend", {
                        boxZoomBounds: s
                    })
                }
            }
        }), n.Map.addInitHook("addHandler", "boxZoom", n.Map.BoxZoom), n.Map.mergeOptions({
            keyboard: !0,
            keyboardPanOffset: 80,
            keyboardZoomOffset: 1
        }), n.Map.Keyboard = n.Handler.extend({
            keyCodes: {
                left: [37],
                right: [39],
                down: [40],
                up: [38],
                zoomIn: [187, 107, 61],
                zoomOut: [189, 109, 173]
            },
            initialize: function(t) {
                this._map = t, this._setPanOffset(t.options.keyboardPanOffset), this._setZoomOffset(t.options.keyboardZoomOffset)
            },
            addHooks: function() {
                var t = this._map._container; - 1 === t.tabIndex && (t.tabIndex = "0"), n.DomEvent.on(t, "focus", this._onFocus, this).on(t, "blur", this._onBlur, this).on(t, "mousedown", this._onMouseDown, this), this._map.on("focus", this._addHooks, this).on("blur", this._removeHooks, this)
            },
            removeHooks: function() {
                this._removeHooks();
                var t = this._map._container;
                n.DomEvent.off(t, "focus", this._onFocus, this).off(t, "blur", this._onBlur, this).off(t, "mousedown", this._onMouseDown, this), this._map.off("focus", this._addHooks, this).off("blur", this._removeHooks, this)
            },
            _onMouseDown: function() {
                this._focused || this._map._container.focus()
            },
            _onFocus: function() {
                this._focused = !0, this._map.fire("focus")
            },
            _onBlur: function() {
                this._focused = !1, this._map.fire("blur")
            },
            _setPanOffset: function(t) {
                var e, i, n = this._panKeys = {},
                    o = this.keyCodes;
                for (e = 0, i = o.left.length; i > e; e++) n[o.left[e]] = [-1 * t, 0];
                for (e = 0, i = o.right.length; i > e; e++) n[o.right[e]] = [t, 0];
                for (e = 0, i = o.down.length; i > e; e++) n[o.down[e]] = [0, t];
                for (e = 0, i = o.up.length; i > e; e++) n[o.up[e]] = [0, -1 * t]
            },
            _setZoomOffset: function(t) {
                var e, i, n = this._zoomKeys = {},
                    o = this.keyCodes;
                for (e = 0, i = o.zoomIn.length; i > e; e++) n[o.zoomIn[e]] = t;
                for (e = 0, i = o.zoomOut.length; i > e; e++) n[o.zoomOut[e]] = -t
            },
            _addHooks: function() {
                n.DomEvent.on(e, "keydown", this._onKeyDown, this)
            },
            _removeHooks: function() {
                n.DomEvent.off(e, "keydown", this._onKeyDown, this)
            },
            _onKeyDown: function(t) {
                var e = t.keyCode,
                    i = this._map;
                if (this._panKeys.hasOwnProperty(e)) i.panBy(this._panKeys[e]), i.options.maxBounds && i.panInsideBounds(i.options.maxBounds);
                else {
                    if (!this._zoomKeys.hasOwnProperty(e)) return;
                    i.setZoom(i.getZoom() + this._zoomKeys[e])
                }
                n.DomEvent.stop(t)
            }
        }), n.Map.addInitHook("addHandler", "keyboard", n.Map.Keyboard), n.Handler.MarkerDrag = n.Handler.extend({
            initialize: function(t) {
                this._marker = t
            },
            addHooks: function() {
                var t = this._marker._icon;
                this._draggable || (this._draggable = new n.Draggable(t, t).on("dragstart", this._onDragStart, this).on("drag", this._onDrag, this).on("dragend", this._onDragEnd, this)), this._draggable.enable()
            },
            removeHooks: function() {
                this._draggable.disable()
            },
            moved: function() {
                return this._draggable && this._draggable._moved
            },
            _onDragStart: function() {
                this._marker.closePopup().fire("movestart").fire("dragstart")
            },
            _onDrag: function() {
                var t = this._marker,
                    e = t._shadow,
                    i = n.DomUtil.getPosition(t._icon),
                    o = t._map.layerPointToLatLng(i);
                e && n.DomUtil.setPosition(e, i), t._latlng = o, t.fire("move", {
                    latlng: o
                }).fire("drag")
            },
            _onDragEnd: function() {
                this._marker.fire("moveend").fire("dragend")
            }
        }), n.Handler.PolyEdit = n.Handler.extend({
            options: {
                icon: new n.DivIcon({
                    iconSize: new n.Point(8, 8),
                    className: "leaflet-div-icon leaflet-editing-icon"
                })
            },
            initialize: function(t, e) {
                this._poly = t, n.setOptions(this, e)
            },
            addHooks: function() {
                this._poly._map && (this._markerGroup || this._initMarkers(), this._poly._map.addLayer(this._markerGroup))
            },
            removeHooks: function() {
                this._poly._map && (this._poly._map.removeLayer(this._markerGroup), delete this._markerGroup, delete this._markers)
            },
            updateMarkers: function() {
                this._markerGroup.clearLayers(), this._initMarkers()
            },
            _initMarkers: function() {
                this._markerGroup || (this._markerGroup = new n.LayerGroup), this._markers = [];
                var t, e, i, o, s = this._poly._latlngs;
                for (t = 0, i = s.length; i > t; t++) o = this._createMarker(s[t], t), o.on("click", this._onMarkerClick, this), this._markers.push(o);
                var a, r;
                for (t = 0, e = i - 1; i > t; e = t++)(0 !== t || n.Polygon && this._poly instanceof n.Polygon) && (a = this._markers[e], r = this._markers[t], this._createMiddleMarker(a, r), this._updatePrevNext(a, r))
            },
            _createMarker: function(t, e) {
                var i = new n.Marker(t, {
                    draggable: !0,
                    icon: this.options.icon
                });
                return i._origLatLng = t, i._index = e, i.on("drag", this._onMarkerDrag, this), i.on("dragend", this._fireEdit, this), this._markerGroup.addLayer(i), i
            },
            _fireEdit: function() {
                this._poly.fire("edit")
            },
            _onMarkerDrag: function(t) {
                var e = t.target;
                n.extend(e._origLatLng, e._latlng), e._middleLeft && e._middleLeft.setLatLng(this._getMiddleLatLng(e._prev, e)), e._middleRight && e._middleRight.setLatLng(this._getMiddleLatLng(e, e._next)), this._poly.redraw()
            },
            _onMarkerClick: function(t) {
                if (!(3 > this._poly._latlngs.length)) {
                    var e = t.target,
                        i = e._index;
                    this._markerGroup.removeLayer(e), this._markers.splice(i, 1), this._poly.spliceLatLngs(i, 1), this._updateIndexes(i, -1), this._updatePrevNext(e._prev, e._next), e._middleLeft && this._markerGroup.removeLayer(e._middleLeft), e._middleRight && this._markerGroup.removeLayer(e._middleRight), e._prev && e._next ? this._createMiddleMarker(e._prev, e._next) : e._prev ? e._next || (e._prev._middleRight = null) : e._next._middleLeft = null, this._poly.fire("edit")
                }
            },
            _updateIndexes: function(t, e) {
                this._markerGroup.eachLayer(function(i) {
                    i._index > t && (i._index += e)
                })
            },
            _createMiddleMarker: function(t, e) {
                var i, n, o, s = this._getMiddleLatLng(t, e),
                    a = this._createMarker(s);
                a.setOpacity(.6), t._middleRight = e._middleLeft = a, n = function() {
                    var n = e._index;
                    a._index = n, a.off("click", i).on("click", this._onMarkerClick, this), s.lat = a.getLatLng().lat, s.lng = a.getLatLng().lng, this._poly.spliceLatLngs(n, 0, s), this._markers.splice(n, 0, a), a.setOpacity(1), this._updateIndexes(n, 1), e._index++, this._updatePrevNext(t, a), this._updatePrevNext(a, e)
                }, o = function() {
                    a.off("dragstart", n, this), a.off("dragend", o, this), this._createMiddleMarker(t, a), this._createMiddleMarker(a, e)
                }, i = function() {
                    n.call(this), o.call(this), this._poly.fire("edit")
                }, a.on("click", i, this).on("dragstart", n, this).on("dragend", o, this), this._markerGroup.addLayer(a)
            },
            _updatePrevNext: function(t, e) {
                t && (t._next = e), e && (e._prev = t)
            },
            _getMiddleLatLng: function(t, e) {
                var i = this._poly._map,
                    n = i.latLngToLayerPoint(t.getLatLng()),
                    o = i.latLngToLayerPoint(e.getLatLng());
                return i.layerPointToLatLng(n._add(o)._divideBy(2))
            }
        }), n.Polyline.addInitHook(function() {
            n.Handler.PolyEdit && (this.editing = new n.Handler.PolyEdit(this), this.options.editable && this.editing.enable()), this.on("add", function() {
                this.editing && this.editing.enabled() && this.editing.addHooks()
            }), this.on("remove", function() {
                this.editing && this.editing.enabled() && this.editing.removeHooks()
            })
        }), n.Control = n.Class.extend({
            options: {
                position: "topright"
            },
            initialize: function(t) {
                n.setOptions(this, t)
            },
            getPosition: function() {
                return this.options.position
            },
            setPosition: function(t) {
                var e = this._map;
                return e && e.removeControl(this), this.options.position = t, e && e.addControl(this), this
            },
            addTo: function(t) {
                this._map = t;
                var e = this._container = this.onAdd(t),
                    i = this.getPosition(),
                    o = t._controlCorners[i];
                return n.DomUtil.addClass(e, "leaflet-control"), -1 !== i.indexOf("bottom") ? o.insertBefore(e, o.firstChild) : o.appendChild(e), this
            },
            removeFrom: function(t) {
                var e = this.getPosition(),
                    i = t._controlCorners[e];
                return i.removeChild(this._container), this._map = null, this.onRemove && this.onRemove(t), this
            }
        }), n.control = function(t) {
            return new n.Control(t)
        }, n.Map.include({
            addControl: function(t) {
                return t.addTo(this), this
            },
            removeControl: function(t) {
                return t.removeFrom(this), this
            },
            _initControlPos: function() {
                function t(t, s) {
                    var a = i + t + " " + i + s;
                    e[t + s] = n.DomUtil.create("div", a, o)
                }
                var e = this._controlCorners = {},
                    i = "leaflet-",
                    o = this._controlContainer = n.DomUtil.create("div", i + "control-container", this._container);
                t("top", "left"), t("top", "right"), t("bottom", "left"), t("bottom", "right")
            }
        }), n.Control.Zoom = n.Control.extend({
            options: {
                position: "topleft"
            },
            onAdd: function(t) {
                var e = "leaflet-control-zoom",
                    i = "leaflet-bar",
                    o = i + "-part",
                    s = n.DomUtil.create("div", e + " " + i);
                return this._map = t, this._zoomInButton = this._createButton("+", "Zoom in", e + "-in " + o + " " + o + "-top", s, this._zoomIn, this), this._zoomOutButton = this._createButton("-", "Zoom out", e + "-out " + o + " " + o + "-bottom", s, this._zoomOut, this), t.on("zoomend", this._updateDisabled, this), s
            },
            onRemove: function(t) {
                t.off("zoomend", this._updateDisabled, this)
            },
            _zoomIn: function(t) {
                this._map.zoomIn(t.shiftKey ? 3 : 1)
            },
            _zoomOut: function(t) {
                this._map.zoomOut(t.shiftKey ? 3 : 1)
            },
            _createButton: function(t, e, i, o, s, a) {
                var r = n.DomUtil.create("a", i, o);
                r.innerHTML = t, r.href = "#", r.title = e;
                var h = n.DomEvent.stopPropagation;
                return n.DomEvent.on(r, "click", h).on(r, "mousedown", h).on(r, "dblclick", h).on(r, "click", n.DomEvent.preventDefault).on(r, "click", s, a), r
            },
            _updateDisabled: function() {
                var t = this._map,
                    e = "leaflet-control-zoom-disabled";
                n.DomUtil.removeClass(this._zoomInButton, e), n.DomUtil.removeClass(this._zoomOutButton, e), t._zoom === t.getMinZoom() && n.DomUtil.addClass(this._zoomOutButton, e), t._zoom === t.getMaxZoom() && n.DomUtil.addClass(this._zoomInButton, e)
            }
        }), n.Map.mergeOptions({
            zoomControl: !0
        }), n.Map.addInitHook(function() {
            this.options.zoomControl && (this.zoomControl = new n.Control.Zoom, this.addControl(this.zoomControl))
        }), n.control.zoom = function(t) {
            return new n.Control.Zoom(t)
        }, n.Control.Attribution = n.Control.extend({
            options: {
                position: "bottomright",
                prefix: 'Powered by <a href="http://leafletjs.com">Leaflet</a>'
            },
            initialize: function(t) {
                n.setOptions(this, t), this._attributions = {}
            },
            onAdd: function(t) {
                return this._container = n.DomUtil.create("div", "leaflet-control-attribution"), n.DomEvent.disableClickPropagation(this._container), t.on("layeradd", this._onLayerAdd, this).on("layerremove", this._onLayerRemove, this), this._update(), this._container
            },
            onRemove: function(t) {
                t.off("layeradd", this._onLayerAdd).off("layerremove", this._onLayerRemove)
            },
            setPrefix: function(t) {
                return this.options.prefix = t, this._update(), this
            },
            addAttribution: function(t) {
                return t ? (this._attributions[t] || (this._attributions[t] = 0), this._attributions[t]++, this._update(), this) : i
            },
            removeAttribution: function(t) {
                return t ? (this._attributions[t]--, this._update(), this) : i
            },
            _update: function() {
                if (this._map) {
                    var t = [];
                    for (var e in this._attributions) this._attributions.hasOwnProperty(e) && this._attributions[e] && t.push(e);
                    var i = [];
                    this.options.prefix && i.push(this.options.prefix), t.length && i.push(t.join(", ")), this._container.innerHTML = i.join(" &#8212; ")
                }
            },
            _onLayerAdd: function(t) {
                t.layer.getAttribution && this.addAttribution(t.layer.getAttribution())
            },
            _onLayerRemove: function(t) {
                t.layer.getAttribution && this.removeAttribution(t.layer.getAttribution())
            }
        }), n.Map.mergeOptions({
            attributionControl: !0
        }), n.Map.addInitHook(function() {
            this.options.attributionControl && (this.attributionControl = (new n.Control.Attribution).addTo(this))
        }), n.control.attribution = function(t) {
            return new n.Control.Attribution(t)
        }, n.Control.Scale = n.Control.extend({
            options: {
                position: "bottomleft",
                maxWidth: 100,
                metric: !0,
                imperial: !0,
                updateWhenIdle: !1
            },
            onAdd: function(t) {
                this._map = t;
                var e = "leaflet-control-scale",
                    i = n.DomUtil.create("div", e),
                    o = this.options;
                return this._addScales(o, e, i), t.on(o.updateWhenIdle ? "moveend" : "move", this._update, this), t.whenReady(this._update, this), i
            },
            onRemove: function(t) {
                t.off(this.options.updateWhenIdle ? "moveend" : "move", this._update, this)
            },
            _addScales: function(t, e, i) {
                t.metric && (this._mScale = n.DomUtil.create("div", e + "-line", i)), t.imperial && (this._iScale = n.DomUtil.create("div", e + "-line", i))
            },
            _update: function() {
                var t = this._map.getBounds(),
                    e = t.getCenter().lat,
                    i = 6378137 * Math.PI * Math.cos(e * Math.PI / 180),
                    n = i * (t.getNorthEast().lng - t.getSouthWest().lng) / 180,
                    o = this._map.getSize(),
                    s = this.options,
                    a = 0;
                o.x > 0 && (a = n * (s.maxWidth / o.x)), this._updateScales(s, a)
            },
            _updateScales: function(t, e) {
                t.metric && e && this._updateMetric(e), t.imperial && e && this._updateImperial(e)
            },
            _updateMetric: function(t) {
                var e = this._getRoundNum(t);
                this._mScale.style.width = this._getScaleWidth(e / t) + "px", this._mScale.innerHTML = 1e3 > e ? e + " m" : e / 1e3 + " km"
            },
            _updateImperial: function(t) {
                var e, i, n, o = 3.2808399 * t,
                    s = this._iScale;
                o > 5280 ? (e = o / 5280, i = this._getRoundNum(e), s.style.width = this._getScaleWidth(i / e) + "px", s.innerHTML = i + " mi") : (n = this._getRoundNum(o), s.style.width = this._getScaleWidth(n / o) + "px", s.innerHTML = n + " ft")
            },
            _getScaleWidth: function(t) {
                return Math.round(this.options.maxWidth * t) - 10
            },
            _getRoundNum: function(t) {
                var e = Math.pow(10, (Math.floor(t) + "").length - 1),
                    i = t / e;
                return i = i >= 10 ? 10 : i >= 5 ? 5 : i >= 3 ? 3 : i >= 2 ? 2 : 1, e * i
            }
        }), n.control.scale = function(t) {
            return new n.Control.Scale(t)
        }, n.Control.Layers = n.Control.extend({
            options: {
                collapsed: !0,
                position: "topright",
                autoZIndex: !0
            },
            initialize: function(t, e, i) {
                n.setOptions(this, i), this._layers = {}, this._lastZIndex = 0, this._handlingClick = !1;
                for (var o in t) t.hasOwnProperty(o) && this._addLayer(t[o], o);
                for (o in e) e.hasOwnProperty(o) && this._addLayer(e[o], o, !0)
            },
            onAdd: function(t) {
                return this._initLayout(), this._update(), t.on("layeradd", this._onLayerChange, this).on("layerremove", this._onLayerChange, this), this._container
            },
            onRemove: function(t) {
                t.off("layeradd", this._onLayerChange).off("layerremove", this._onLayerChange)
            },
            addBaseLayer: function(t, e) {
                return this._addLayer(t, e), this._update(), this
            },
            addOverlay: function(t, e) {
                return this._addLayer(t, e, !0), this._update(), this
            },
            removeLayer: function(t) {
                var e = n.stamp(t);
                return delete this._layers[e], this._update(), this
            },
            _initLayout: function() {
                var t = "leaflet-control-layers",
                    e = this._container = n.DomUtil.create("div", t);
                n.Browser.touch ? n.DomEvent.on(e, "click", n.DomEvent.stopPropagation) : (n.DomEvent.disableClickPropagation(e), n.DomEvent.on(e, "mousewheel", n.DomEvent.stopPropagation));
                var i = this._form = n.DomUtil.create("form", t + "-list");
                if (this.options.collapsed) {
                    n.DomEvent.on(e, "mouseover", this._expand, this).on(e, "mouseout", this._collapse, this);
                    var o = this._layersLink = n.DomUtil.create("a", t + "-toggle", e);
                    o.href = "#", o.title = "Layers", n.Browser.touch ? n.DomEvent.on(o, "click", n.DomEvent.stopPropagation).on(o, "click", n.DomEvent.preventDefault).on(o, "click", this._expand, this) : n.DomEvent.on(o, "focus", this._expand, this), this._map.on("movestart", this._collapse, this)
                } else this._expand();
                this._baseLayersList = n.DomUtil.create("div", t + "-base", i), this._separator = n.DomUtil.create("div", t + "-separator", i), this._overlaysList = n.DomUtil.create("div", t + "-overlays", i), e.appendChild(i)
            },
            _addLayer: function(t, e, i) {
                var o = n.stamp(t);
                this._layers[o] = {
                    layer: t,
                    name: e,
                    overlay: i
                }, this.options.autoZIndex && t.setZIndex && (this._lastZIndex++, t.setZIndex(this._lastZIndex))
            },
            _update: function() {
                if (this._container) {
                    this._baseLayersList.innerHTML = "", this._overlaysList.innerHTML = "";
                    var t = !1,
                        e = !1;
                    for (var i in this._layers)
                        if (this._layers.hasOwnProperty(i)) {
                            var n = this._layers[i];
                            this._addItem(n), e = e || n.overlay, t = t || !n.overlay
                        }
                    this._separator.style.display = e && t ? "" : "none"
                }
            },
            _onLayerChange: function(t) {
                var e = n.stamp(t.layer);
                this._layers[e] && !this._handlingClick && this._update()
            },
            _createRadioElement: function(t, i) {
                var n = '<input type="radio" class="leaflet-control-layers-selector" name="' + t + '"';
                i && (n += ' checked="checked"'), n += "/>";
                var o = e.createElement("div");
                return o.innerHTML = n, o.firstChild
            },
            _addItem: function(t) {
                var i, o = e.createElement("label"),
                    s = this._map.hasLayer(t.layer);
                t.overlay ? (i = e.createElement("input"), i.type = "checkbox", i.className = "leaflet-control-layers-selector", i.defaultChecked = s) : i = this._createRadioElement("leaflet-base-layers", s), i.layerId = n.stamp(t.layer), n.DomEvent.on(i, "click", this._onInputClick, this);
                var a = e.createElement("span");
                a.innerHTML = " " + t.name, o.appendChild(i), o.appendChild(a);
                var r = t.overlay ? this._overlaysList : this._baseLayersList;
                return r.appendChild(o), o
            },
            _onInputClick: function() {
                var t, e, i, n, o = this._form.getElementsByTagName("input"),
                    s = o.length;
                for (this._handlingClick = !0, t = 0; s > t; t++) e = o[t], i = this._layers[e.layerId], e.checked && !this._map.hasLayer(i.layer) ? (this._map.addLayer(i.layer), i.overlay || (n = i.layer)) : !e.checked && this._map.hasLayer(i.layer) && this._map.removeLayer(i.layer);
                n && (this._map.setZoom(this._map.getZoom()), this._map.fire("baselayerchange", {
                    layer: n
                })), this._handlingClick = !1
            },
            _expand: function() {
                n.DomUtil.addClass(this._container, "leaflet-control-layers-expanded")
            },
            _collapse: function() {
                this._container.className = this._container.className.replace(" leaflet-control-layers-expanded", "")
            }
        }), n.control.layers = function(t, e, i) {
            return new n.Control.Layers(t, e, i)
        }, n.PosAnimation = n.Class.extend({
            includes: n.Mixin.Events,
            run: function(t, e, i, o) {
                this.stop(), this._el = t, this._inProgress = !0, this.fire("start"), t.style[n.DomUtil.TRANSITION] = "all " + (i || .25) + "s cubic-bezier(0,0," + (o || .5) + ",1)", n.DomEvent.on(t, n.DomUtil.TRANSITION_END, this._onTransitionEnd, this), n.DomUtil.setPosition(t, e), n.Util.falseFn(t.offsetWidth), this._stepTimer = setInterval(n.bind(this.fire, this, "step"), 50)
            },
            stop: function() {
                this._inProgress && (n.DomUtil.setPosition(this._el, this._getPos()), this._onTransitionEnd(), n.Util.falseFn(this._el.offsetWidth))
            },
            _transformRe: /(-?[\d\.]+), (-?[\d\.]+)\)/,
            _getPos: function() {
                var e, i, o, s = this._el,
                    a = t.getComputedStyle(s);
                return n.Browser.any3d ? (o = a[n.DomUtil.TRANSFORM].match(this._transformRe), e = parseFloat(o[1]), i = parseFloat(o[2])) : (e = parseFloat(a.left), i = parseFloat(a.top)), new n.Point(e, i, !0)
            },
            _onTransitionEnd: function() {
                n.DomEvent.off(this._el, n.DomUtil.TRANSITION_END, this._onTransitionEnd, this), this._inProgress && (this._inProgress = !1, this._el.style[n.DomUtil.TRANSITION] = "", clearInterval(this._stepTimer), this.fire("step").fire("end"))
            }
        }), n.Map.include({
            setView: function(t, e, i) {
                e = this._limitZoom(e);
                var n = this._zoom !== e;
                if (this._loaded && !i && this._layers) {
                    this._panAnim && this._panAnim.stop();
                    var o = n ? this._zoomToIfClose && this._zoomToIfClose(t, e) : this._panByIfClose(t);
                    if (o) return clearTimeout(this._sizeTimer), this
                }
                return this._resetView(t, e), this
            },
            panBy: function(t, e, i) {
                if (t = n.point(t), !t.x && !t.y) return this;
                this._panAnim || (this._panAnim = new n.PosAnimation, this._panAnim.on({
                    step: this._onPanTransitionStep,
                    end: this._onPanTransitionEnd
                }, this)), this.fire("movestart"), n.DomUtil.addClass(this._mapPane, "leaflet-pan-anim");
                var o = n.DomUtil.getPosition(this._mapPane).subtract(t)._round();
                return this._panAnim.run(this._mapPane, o, e || .25, i), this
            },
            _onPanTransitionStep: function() {
                this.fire("move")
            },
            _onPanTransitionEnd: function() {
                n.DomUtil.removeClass(this._mapPane, "leaflet-pan-anim"), this.fire("moveend")
            },
            _panByIfClose: function(t) {
                var e = this._getCenterOffset(t)._floor();
                return this._offsetIsWithinView(e) ? (this.panBy(e), !0) : !1
            },
            _offsetIsWithinView: function(t, e) {
                var i = e || 1,
                    n = this.getSize();
                return Math.abs(t.x) <= n.x * i && Math.abs(t.y) <= n.y * i
            }
        }), n.PosAnimation = n.DomUtil.TRANSITION ? n.PosAnimation : n.PosAnimation.extend({
            run: function(t, e, i, o) {
                this.stop(), this._el = t, this._inProgress = !0, this._duration = i || .25, this._easeOutPower = 1 / Math.max(o || .5, .2), this._startPos = n.DomUtil.getPosition(t), this._offset = e.subtract(this._startPos), this._startTime = +new Date, this.fire("start"), this._animate()
            },
            stop: function() {
                this._inProgress && (this._step(), this._complete())
            },
            _animate: function() {
                this._animId = n.Util.requestAnimFrame(this._animate, this), this._step()
            },
            _step: function() {
                var t = +new Date - this._startTime,
                    e = 1e3 * this._duration;
                e > t ? this._runFrame(this._easeOut(t / e)) : (this._runFrame(1), this._complete())
            },
            _runFrame: function(t) {
                var e = this._startPos.add(this._offset.multiplyBy(t));
                n.DomUtil.setPosition(this._el, e), this.fire("step")
            },
            _complete: function() {
                n.Util.cancelAnimFrame(this._animId), this._inProgress = !1, this.fire("end")
            },
            _easeOut: function(t) {
                return 1 - Math.pow(1 - t, this._easeOutPower)
            }
        }), n.Map.mergeOptions({
            zoomAnimation: n.DomUtil.TRANSITION && !n.Browser.android23 && !n.Browser.mobileOpera
        }), n.DomUtil.TRANSITION && n.Map.addInitHook(function() {
            n.DomEvent.on(this._mapPane, n.DomUtil.TRANSITION_END, this._catchTransitionEnd, this)
        }), n.Map.include(n.DomUtil.TRANSITION ? {
            _zoomToIfClose: function(t, e) {
                if (this._animatingZoom) return !0;
                if (!this.options.zoomAnimation) return !1;
                var i = this.getZoomScale(e),
                    o = this._getCenterOffset(t)._divideBy(1 - 1 / i);
                if (!this._offsetIsWithinView(o, 1)) return !1;
                n.DomUtil.addClass(this._mapPane, "leaflet-zoom-anim"), this.fire("movestart").fire("zoomstart"), this.fire("zoomanim", {
                    center: t,
                    zoom: e
                });
                var s = this._getCenterLayerPoint().add(o);
                return this._prepareTileBg(), this._runAnimation(t, e, i, s), !0
            },
            _catchTransitionEnd: function() {
                this._animatingZoom && this._onZoomTransitionEnd()
            },
            _runAnimation: function(t, e, i, o, s) {
                this._animateToCenter = t, this._animateToZoom = e, this._animatingZoom = !0, n.Draggable && (n.Draggable._disabled = !0);
                var a = n.DomUtil.TRANSFORM,
                    r = this._tileBg;
                clearTimeout(this._clearTileBgTimer), n.Util.falseFn(r.offsetWidth);
                var h = n.DomUtil.getScaleString(i, o),
                    l = r.style[a];
                r.style[a] = s ? l + " " + h : h + " " + l
            },
            _prepareTileBg: function() {
                var t = this._tilePane,
                    e = this._tileBg;
                if (e && this._getLoadedTilesPercentage(e) > .5 && .5 > this._getLoadedTilesPercentage(t)) return t.style.visibility = "hidden", t.empty = !0, this._stopLoadingImages(t), i;
                e || (e = this._tileBg = this._createPane("leaflet-tile-pane", this._mapPane), e.style.zIndex = 1), e.style[n.DomUtil.TRANSFORM] = "", e.style.visibility = "hidden", e.empty = !0, t.empty = !1, this._tilePane = this._panes.tilePane = e;
                var o = this._tileBg = t;
                n.DomUtil.addClass(o, "leaflet-zoom-animated"), this._stopLoadingImages(o)
            },
            _getLoadedTilesPercentage: function(t) {
                var e, i, n = t.getElementsByTagName("img"),
                    o = 0;
                for (e = 0, i = n.length; i > e; e++) n[e].complete && o++;
                return o / i
            },
            _stopLoadingImages: function(t) {
                var e, i, o, s = Array.prototype.slice.call(t.getElementsByTagName("img"));
                for (e = 0, i = s.length; i > e; e++) o = s[e], o.complete || (o.onload = n.Util.falseFn, o.onerror = n.Util.falseFn, o.src = n.Util.emptyImageUrl, o.parentNode.removeChild(o))
            },
            _onZoomTransitionEnd: function() {
                this._restoreTileFront(), n.DomUtil.removeClass(this._mapPane, "leaflet-zoom-anim"), n.Util.falseFn(this._tileBg.offsetWidth), this._animatingZoom = !1, this._resetView(this._animateToCenter, this._animateToZoom, !0, !0), n.Draggable && (n.Draggable._disabled = !1)
            },
            _restoreTileFront: function() {
                this._tilePane.innerHTML = "", this._tilePane.style.visibility = "", this._tilePane.style.zIndex = 2, this._tileBg.style.zIndex = 1
            },
            _clearTileBg: function() {
                this._animatingZoom || this.touchZoom._zooming || (this._tileBg.innerHTML = "")
            }
        } : {}), n.Map.include({
            _defaultLocateOptions: {
                watch: !1,
                setView: !1,
                maxZoom: 1 / 0,
                timeout: 1e4,
                maximumAge: 0,
                enableHighAccuracy: !1
            },
            locate: function(t) {
                if (t = this._locationOptions = n.extend(this._defaultLocateOptions, t), !navigator.geolocation) return this._handleGeolocationError({
                    code: 0,
                    message: "Geolocation not supported."
                }), this;
                var e = n.bind(this._handleGeolocationResponse, this),
                    i = n.bind(this._handleGeolocationError, this);
                return t.watch ? this._locationWatchId = navigator.geolocation.watchPosition(e, i, t) : navigator.geolocation.getCurrentPosition(e, i, t), this
            },
            stopLocate: function() {
                return navigator.geolocation && navigator.geolocation.clearWatch(this._locationWatchId), this
            },
            _handleGeolocationError: function(t) {
                var e = t.code,
                    i = t.message || (1 === e ? "permission denied" : 2 === e ? "position unavailable" : "timeout");
                this._locationOptions.setView && !this._loaded && this.fitWorld(), this.fire("locationerror", {
                    code: e,
                    message: "Geolocation error: " + i + "."
                })
            },
            _handleGeolocationResponse: function(t) {
                var e = 180 * t.coords.accuracy / 4e7,
                    i = 2 * e,
                    o = t.coords.latitude,
                    s = t.coords.longitude,
                    a = new n.LatLng(o, s),
                    r = new n.LatLng(o - e, s - i),
                    h = new n.LatLng(o + e, s + i),
                    l = new n.LatLngBounds(r, h),
                    u = this._locationOptions;
                if (u.setView) {
                    var c = Math.min(this.getBoundsZoom(l), u.maxZoom);
                    this.setView(a, c)
                }
                this.fire("locationfound", {
                    latlng: a,
                    bounds: l,
                    accuracy: t.coords.accuracy
                })
            }
        })
})(this, document);
var Proj4js = {
    defaultDatum: "WGS84",
    transform: function(source, dest, point) {
        if (!source.readyToUse) {
            this.reportError("Proj4js initialization for:" + source.srsCode + " not yet complete");
            return point
        }
        if (!dest.readyToUse) {
            this.reportError("Proj4js initialization for:" + dest.srsCode + " not yet complete");
            return point
        }
        if (source.datum && dest.datum && ((source.datum.datum_type == Proj4js.common.PJD_3PARAM || source.datum.datum_type == Proj4js.common.PJD_7PARAM) && dest.datumCode != "WGS84" || (dest.datum.datum_type == Proj4js.common.PJD_3PARAM || dest.datum.datum_type == Proj4js.common.PJD_7PARAM) && source.datumCode != "WGS84")) {
            var wgs84 = Proj4js.WGS84;
            this.transform(source, wgs84, point);
            source = wgs84
        }
        if (source.axis != "enu") {
            this.adjust_axis(source, false, point)
        }
        if (source.projName == "longlat") {
            point.x *= Proj4js.common.D2R;
            point.y *= Proj4js.common.D2R
        } else {
            if (source.to_meter) {
                point.x *= source.to_meter;
                point.y *= source.to_meter
            }
            source.inverse(point)
        }
        if (source.from_greenwich) {
            point.x += source.from_greenwich
        }
        point = this.datum_transform(source.datum, dest.datum, point);
        if (dest.from_greenwich) {
            point.x -= dest.from_greenwich
        }
        if (dest.projName == "longlat") {
            point.x *= Proj4js.common.R2D;
            point.y *= Proj4js.common.R2D
        } else {
            dest.forward(point);
            if (dest.to_meter) {
                point.x /= dest.to_meter;
                point.y /= dest.to_meter
            }
        }
        if (dest.axis != "enu") {
            this.adjust_axis(dest, true, point)
        }
        return point
    },
    datum_transform: function(source, dest, point) {
        if (source.compare_datums(dest)) {
            return point
        }
        if (source.datum_type == Proj4js.common.PJD_NODATUM || dest.datum_type == Proj4js.common.PJD_NODATUM) {
            return point
        }
        if (source.es != dest.es || source.a != dest.a || source.datum_type == Proj4js.common.PJD_3PARAM || source.datum_type == Proj4js.common.PJD_7PARAM || dest.datum_type == Proj4js.common.PJD_3PARAM || dest.datum_type == Proj4js.common.PJD_7PARAM) {
            source.geodetic_to_geocentric(point);
            if (source.datum_type == Proj4js.common.PJD_3PARAM || source.datum_type == Proj4js.common.PJD_7PARAM) {
                source.geocentric_to_wgs84(point)
            }
            if (dest.datum_type == Proj4js.common.PJD_3PARAM || dest.datum_type == Proj4js.common.PJD_7PARAM) {
                dest.geocentric_from_wgs84(point)
            }
            dest.geocentric_to_geodetic(point)
        }
        return point
    },
    adjust_axis: function(crs, denorm, point) {
        var xin = point.x,
            yin = point.y,
            zin = point.z || 0;
        var v, t;
        for (var i = 0; i < 3; i++) {
            if (denorm && i == 2 && point.z === undefined) {
                continue
            }
            if (i == 0) {
                v = xin;
                t = "x"
            } else if (i == 1) {
                v = yin;
                t = "y"
            } else {
                v = zin;
                t = "z"
            }
            switch (crs.axis[i]) {
                case "e":
                    point[t] = v;
                    break;
                case "w":
                    point[t] = -v;
                    break;
                case "n":
                    point[t] = v;
                    break;
                case "s":
                    point[t] = -v;
                    break;
                case "u":
                    if (point[t] !== undefined) {
                        point.z = v
                    }
                    break;
                case "d":
                    if (point[t] !== undefined) {
                        point.z = -v
                    }
                    break;
                default:
                    alert("ERROR: unknow axis (" + crs.axis[i] + ") - check definition of " + crs.projName);
                    return null
            }
        }
        return point
    },
    reportError: function(msg) {},
    extend: function(destination, source) {
        destination = destination || {};
        if (source) {
            for (var property in source) {
                var value = source[property];
                if (value !== undefined) {
                    destination[property] = value
                }
            }
        }
        return destination
    },
    Class: function() {
        var Class = function() {
            this.initialize.apply(this, arguments)
        };
        var extended = {};
        var parent;
        for (var i = 0; i < arguments.length; ++i) {
            if (typeof arguments[i] == "function") {
                parent = arguments[i].prototype
            } else {
                parent = arguments[i]
            }
            Proj4js.extend(extended, parent)
        }
        Class.prototype = extended;
        return Class
    },
    bind: function(func, object) {
        var args = Array.prototype.slice.apply(arguments, [2]);
        return function() {
            var newArgs = args.concat(Array.prototype.slice.apply(arguments, [0]));
            return func.apply(object, newArgs)
        }
    },
    scriptName: "proj4js-combined.js",
    defsLookupService: "http://spatialreference.org/ref",
    libPath: null,
    getScriptLocation: function() {
        if (this.libPath) return this.libPath;
        var scriptName = this.scriptName;
        var scriptNameLen = scriptName.length;
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            var src = scripts[i].getAttribute("src");
            if (src) {
                var index = src.lastIndexOf(scriptName);
                if (index > -1 && index + scriptNameLen == src.length) {
                    this.libPath = src.slice(0, -scriptNameLen);
                    break
                }
            }
        }
        return this.libPath || ""
    },
    loadScript: function(url, onload, onfail, loadCheck) {
        var script = document.createElement("script");
        script.defer = false;
        script.type = "text/javascript";
        script.id = url;
        script.src = url;
        script.onload = onload;
        script.onerror = onfail;
        script.loadCheck = loadCheck;
        if (/MSIE/.test(navigator.userAgent)) {
            script.onreadystatechange = this.checkReadyState
        }
        document.getElementsByTagName("head")[0].appendChild(script)
    },
    checkReadyState: function() {
        if (this.readyState == "loaded") {
            if (!this.loadCheck()) {
                this.onerror()
            } else {
                this.onload()
            }
        }
    }
};
Proj4js.Proj = Proj4js.Class({
    readyToUse: false,
    title: null,
    projName: null,
    units: null,
    datum: null,
    x0: 0,
    y0: 0,
    localCS: false,
    queue: null,
    initialize: function(srsCode, callback) {
        this.srsCodeInput = srsCode;
        this.queue = [];
        if (callback) {
            this.queue.push(callback)
        }
        if (srsCode.indexOf("GEOGCS") >= 0 || srsCode.indexOf("GEOCCS") >= 0 || srsCode.indexOf("PROJCS") >= 0 || srsCode.indexOf("LOCAL_CS") >= 0) {
            this.parseWKT(srsCode);
            this.deriveConstants();
            this.loadProjCode(this.projName);
            return
        }
        if (srsCode.indexOf("urn:") == 0) {
            var urn = srsCode.split(":");
            if ((urn[1] == "ogc" || urn[1] == "x-ogc") && urn[2] == "def" && urn[3] == "crs") {
                srsCode = urn[4] + ":" + urn[urn.length - 1]
            }
        } else if (srsCode.indexOf("http://") == 0) {
            var url = srsCode.split("#");
            if (url[0].match(/epsg.org/)) {
                srsCode = "EPSG:" + url[1]
            } else if (url[0].match(/RIG.xml/)) {
                srsCode = "IGNF:" + url[1]
            }
        }
        this.srsCode = srsCode.toUpperCase();
        if (this.srsCode.indexOf("EPSG") == 0) {
            this.srsCode = this.srsCode;
            this.srsAuth = "epsg";
            this.srsProjNumber = this.srsCode.substring(5)
        } else if (this.srsCode.indexOf("IGNF") == 0) {
            this.srsCode = this.srsCode;
            this.srsAuth = "IGNF";
            this.srsProjNumber = this.srsCode.substring(5)
        } else if (this.srsCode.indexOf("CRS") == 0) {
            this.srsCode = this.srsCode;
            this.srsAuth = "CRS";
            this.srsProjNumber = this.srsCode.substring(4)
        } else {
            this.srsAuth = "";
            this.srsProjNumber = this.srsCode
        }
        this.loadProjDefinition()
    },
    loadProjDefinition: function() {
        if (Proj4js.defs[this.srsCode]) {
            this.defsLoaded();
            return
        }
        var url = Proj4js.getScriptLocation() + "defs/" + this.srsAuth.toUpperCase() + this.srsProjNumber + ".js";
        Proj4js.loadScript(url, Proj4js.bind(this.defsLoaded, this), Proj4js.bind(this.loadFromService, this), Proj4js.bind(this.checkDefsLoaded, this))
    },
    loadFromService: function() {
        var url = Proj4js.defsLookupService + "/" + this.srsAuth + "/" + this.srsProjNumber + "/proj4js/";
        Proj4js.loadScript(url, Proj4js.bind(this.defsLoaded, this), Proj4js.bind(this.defsFailed, this), Proj4js.bind(this.checkDefsLoaded, this))
    },
    defsLoaded: function() {
        this.parseDefs();
        this.loadProjCode(this.projName)
    },
    checkDefsLoaded: function() {
        if (Proj4js.defs[this.srsCode]) {
            return true
        } else {
            return false
        }
    },
    defsFailed: function() {
        Proj4js.reportError("failed to load projection definition for: " + this.srsCode);
        Proj4js.defs[this.srsCode] = Proj4js.defs["WGS84"];
        this.defsLoaded()
    },
    loadProjCode: function(projName) {
        if (Proj4js.Proj[projName]) {
            this.initTransforms();
            return
        }
        var url = Proj4js.getScriptLocation() + "projCode/" + projName + ".js";
        Proj4js.loadScript(url, Proj4js.bind(this.loadProjCodeSuccess, this, projName), Proj4js.bind(this.loadProjCodeFailure, this, projName), Proj4js.bind(this.checkCodeLoaded, this, projName))
    },
    loadProjCodeSuccess: function(projName) {
        if (Proj4js.Proj[projName].dependsOn) {
            this.loadProjCode(Proj4js.Proj[projName].dependsOn)
        } else {
            this.initTransforms()
        }
    },
    loadProjCodeFailure: function(projName) {
        Proj4js.reportError("failed to find projection file for: " + projName)
    },
    checkCodeLoaded: function(projName) {
        if (Proj4js.Proj[projName]) {
            return true
        } else {
            return false
        }
    },
    initTransforms: function() {
        Proj4js.extend(this, Proj4js.Proj[this.projName]);
        this.init();
        this.readyToUse = true;
        if (this.queue) {
            var item;
            while (item = this.queue.shift()) {
                item.call(this, this)
            }
        }
    },
    wktRE: /^(\w+)\[(.*)\]$/,
    parseWKT: function(wkt) {
        var wktMatch = wkt.match(this.wktRE);
        if (!wktMatch) return;
        var wktObject = wktMatch[1];
        var wktContent = wktMatch[2];
        var wktTemp = wktContent.split(",");
        var wktName;
        if (wktObject.toUpperCase() == "TOWGS84") {
            wktName = wktObject
        } else {
            wktName = wktTemp.shift()
        }
        wktName = wktName.replace(/^\"/, "");
        wktName = wktName.replace(/\"$/, "");
        var wktArray = new Array;
        var bkCount = 0;
        var obj = "";
        for (var i = 0; i < wktTemp.length; ++i) {
            var token = wktTemp[i];
            for (var j = 0; j < token.length; ++j) {
                if (token.charAt(j) == "[") ++bkCount;
                if (token.charAt(j) == "]") --bkCount
            }
            obj += token;
            if (bkCount === 0) {
                wktArray.push(obj);
                obj = ""
            } else {
                obj += ","
            }
        }
        switch (wktObject) {
            case "LOCAL_CS":
                this.projName = "identity";
                this.localCS = true;
                this.srsCode = wktName;
                break;
            case "GEOGCS":
                this.projName = "longlat";
                this.geocsCode = wktName;
                if (!this.srsCode) this.srsCode = wktName;
                break;
            case "PROJCS":
                this.srsCode = wktName;
                break;
            case "GEOCCS":
                break;
            case "PROJECTION":
                this.projName = Proj4js.wktProjections[wktName];
                break;
            case "DATUM":
                this.datumName = wktName;
                break;
            case "LOCAL_DATUM":
                this.datumCode = "none";
                break;
            case "SPHEROID":
                this.ellps = wktName;
                this.a = parseFloat(wktArray.shift());
                this.rf = parseFloat(wktArray.shift());
                break;
            case "PRIMEM":
                this.from_greenwich = parseFloat(wktArray.shift());
                break;
            case "UNIT":
                this.units = wktName;
                this.unitsPerMeter = parseFloat(wktArray.shift());
                break;
            case "PARAMETER":
                var name = wktName.toLowerCase();
                var value = parseFloat(wktArray.shift());
                switch (name) {
                    case "false_easting":
                        this.x0 = value;
                        break;
                    case "false_northing":
                        this.y0 = value;
                        break;
                    case "scale_factor":
                        this.k0 = value;
                        break;
                    case "central_meridian":
                        this.long0 = value * Proj4js.common.D2R;
                        break;
                    case "latitude_of_origin":
                        this.lat0 = value * Proj4js.common.D2R;
                        break;
                    case "more_here":
                        break;
                    default:
                        break
                }
                break;
            case "TOWGS84":
                this.datum_params = wktArray;
                break;
            case "AXIS":
                var name = wktName.toLowerCase();
                var value = wktArray.shift();
                switch (value) {
                    case "EAST":
                        value = "e";
                        break;
                    case "WEST":
                        value = "w";
                        break;
                    case "NORTH":
                        value = "n";
                        break;
                    case "SOUTH":
                        value = "s";
                        break;
                    case "UP":
                        value = "u";
                        break;
                    case "DOWN":
                        value = "d";
                        break;
                    case "OTHER":
                    default:
                        value = " ";
                        break
                }
                if (!this.axis) {
                    this.axis = "enu"
                }
                switch (name) {
                    case "x":
                        this.axis = value + this.axis.substr(1, 2);
                        break;
                    case "y":
                        this.axis = this.axis.substr(0, 1) + value + this.axis.substr(2, 1);
                        break;
                    case "z":
                        this.axis = this.axis.substr(0, 2) + value;
                        break;
                    default:
                        break
                }
            case "MORE_HERE":
                break;
            default:
                break
        }
        for (var i = 0; i < wktArray.length; ++i) {
            this.parseWKT(wktArray[i])
        }
    },
    parseDefs: function() {
        this.defData = Proj4js.defs[this.srsCode];
        var paramName, paramVal;
        if (!this.defData) {
            return
        }
        var paramArray = this.defData.split("+");
        for (var prop = 0; prop < paramArray.length; prop++) {
            var property = paramArray[prop].split("=");
            paramName = property[0].toLowerCase();
            paramVal = property[1];
            switch (paramName.replace(/\s/gi, "")) {
                case "":
                    break;
                case "title":
                    this.title = paramVal;
                    break;
                case "proj":
                    this.projName = paramVal.replace(/\s/gi, "");
                    break;
                case "units":
                    this.units = paramVal.replace(/\s/gi, "");
                    break;
                case "datum":
                    this.datumCode = paramVal.replace(/\s/gi, "");
                    break;
                case "nadgrids":
                    this.nagrids = paramVal.replace(/\s/gi, "");
                    break;
                case "ellps":
                    this.ellps = paramVal.replace(/\s/gi, "");
                    break;
                case "a":
                    this.a = parseFloat(paramVal);
                    break;
                case "b":
                    this.b = parseFloat(paramVal);
                    break;
                case "rf":
                    this.rf = parseFloat(paramVal);
                    break;
                case "lat_0":
                    this.lat0 = paramVal * Proj4js.common.D2R;
                    break;
                case "lat_1":
                    this.lat1 = paramVal * Proj4js.common.D2R;
                    break;
                case "lat_2":
                    this.lat2 = paramVal * Proj4js.common.D2R;
                    break;
                case "lat_ts":
                    this.lat_ts = paramVal * Proj4js.common.D2R;
                    break;
                case "lon_0":
                    this.long0 = paramVal * Proj4js.common.D2R;
                    break;
                case "alpha":
                    this.alpha = parseFloat(paramVal) * Proj4js.common.D2R;
                    break;
                case "lonc":
                    this.longc = paramVal * Proj4js.common.D2R;
                    break;
                case "x_0":
                    this.x0 = parseFloat(paramVal);
                    break;
                case "y_0":
                    this.y0 = parseFloat(paramVal);
                    break;
                case "k_0":
                    this.k0 = parseFloat(paramVal);
                    break;
                case "k":
                    this.k0 = parseFloat(paramVal);
                    break;
                case "r_a":
                    this.R_A = true;
                    break;
                case "zone":
                    this.zone = parseInt(paramVal, 10);
                    break;
                case "south":
                    this.utmSouth = true;
                    break;
                case "towgs84":
                    this.datum_params = paramVal.split(",");
                    break;
                case "to_meter":
                    this.to_meter = parseFloat(paramVal);
                    break;
                case "from_greenwich":
                    this.from_greenwich = paramVal * Proj4js.common.D2R;
                    break;
                case "pm":
                    paramVal = paramVal.replace(/\s/gi, "");
                    this.from_greenwich = Proj4js.PrimeMeridian[paramVal] ? Proj4js.PrimeMeridian[paramVal] : parseFloat(paramVal);
                    this.from_greenwich *= Proj4js.common.D2R;
                    break;
                case "axis":
                    paramVal = paramVal.replace(/\s/gi, "");
                    var legalAxis = "ewnsud";
                    if (paramVal.length == 3 && legalAxis.indexOf(paramVal.substr(0, 1)) != -1 && legalAxis.indexOf(paramVal.substr(1, 1)) != -1 && legalAxis.indexOf(paramVal.substr(2, 1)) != -1) {
                        this.axis = paramVal
                    }
                    break;
                case "no_defs":
                    break;
                default:
            }
        }
        this.deriveConstants()
    },
    deriveConstants: function() {
        if (this.nagrids == "@null") this.datumCode = "none";
        if (this.datumCode && this.datumCode != "none") {
            var datumDef = Proj4js.Datum[this.datumCode];
            if (datumDef) {
                this.datum_params = datumDef.towgs84 ? datumDef.towgs84.split(",") : null;
                this.ellps = datumDef.ellipse;
                this.datumName = datumDef.datumName ? datumDef.datumName : this.datumCode
            }
        }
        if (!this.a) {
            var ellipse = Proj4js.Ellipsoid[this.ellps] ? Proj4js.Ellipsoid[this.ellps] : Proj4js.Ellipsoid["WGS84"];
            Proj4js.extend(this, ellipse)
        }
        if (this.rf && !this.b) this.b = (1 - 1 / this.rf) * this.a;
        if (this.rf === 0 || Math.abs(this.a - this.b) < Proj4js.common.EPSLN) {
            this.sphere = true;
            this.b = this.a
        }
        this.a2 = this.a * this.a;
        this.b2 = this.b * this.b;
        this.es = (this.a2 - this.b2) / this.a2;
        this.e = Math.sqrt(this.es);
        if (this.R_A) {
            this.a *= 1 - this.es * (Proj4js.common.SIXTH + this.es * (Proj4js.common.RA4 + this.es * Proj4js.common.RA6));
            this.a2 = this.a * this.a;
            this.b2 = this.b * this.b;
            this.es = 0
        }
        this.ep2 = (this.a2 - this.b2) / this.b2;
        if (!this.k0) this.k0 = 1;
        if (!this.axis) {
            this.axis = "enu"
        }
        this.datum = new Proj4js.datum(this)
    }
});
Proj4js.Proj.longlat = {
    init: function() {},
    forward: function(pt) {
        return pt
    },
    inverse: function(pt) {
        return pt
    }
};
Proj4js.Proj.identity = Proj4js.Proj.longlat;
Proj4js.defs = {
    WGS84: "+title=long/lat:WGS84 +proj=longlat +ellps=WGS84 +datum=WGS84 +units=degrees",
    "EPSG:4326": "+title=long/lat:WGS84 +proj=longlat +a=6378137.0 +b=6356752.31424518 +ellps=WGS84 +datum=WGS84 +units=degrees",
    "EPSG:4269": "+title=long/lat:NAD83 +proj=longlat +a=6378137.0 +b=6356752.31414036 +ellps=GRS80 +datum=NAD83 +units=degrees",
    "EPSG:3875": "+title= Google Mercator +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"
};
Proj4js.defs["EPSG:3785"] = Proj4js.defs["EPSG:3875"];
Proj4js.defs["GOOGLE"] = Proj4js.defs["EPSG:3875"];
Proj4js.defs["EPSG:900913"] = Proj4js.defs["EPSG:3875"];
Proj4js.defs["EPSG:102113"] = Proj4js.defs["EPSG:3875"];
Proj4js.common = {
    PI: 3.141592653589793,
    HALF_PI: 1.5707963267948966,
    TWO_PI: 6.283185307179586,
    FORTPI: .7853981633974483,
    R2D: 57.29577951308232,
    D2R: .017453292519943295,
    SEC_TO_RAD: 484813681109536e-20,
    EPSLN: 1e-10,
    MAX_ITER: 20,
    COS_67P5: .3826834323650898,
    AD_C: 1.0026,
    PJD_UNKNOWN: 0,
    PJD_3PARAM: 1,
    PJD_7PARAM: 2,
    PJD_GRIDSHIFT: 3,
    PJD_WGS84: 4,
    PJD_NODATUM: 5,
    SRS_WGS84_SEMIMAJOR: 6378137,
    SIXTH: .16666666666666666,
    RA4: .04722222222222222,
    RA6: .022156084656084655,
    RV4: .06944444444444445,
    RV6: .04243827160493827,
    msfnz: function(eccent, sinphi, cosphi) {
        var con = eccent * sinphi;
        return cosphi / Math.sqrt(1 - con * con)
    },
    tsfnz: function(eccent, phi, sinphi) {
        var con = eccent * sinphi;
        var com = .5 * eccent;
        con = Math.pow((1 - con) / (1 + con), com);
        return Math.tan(.5 * (this.HALF_PI - phi)) / con
    },
    phi2z: function(eccent, ts) {
        var eccnth = .5 * eccent;
        var con, dphi;
        var phi = this.HALF_PI - 2 * Math.atan(ts);
        for (var i = 0; i <= 15; i++) {
            con = eccent * Math.sin(phi);
            dphi = this.HALF_PI - 2 * Math.atan(ts * Math.pow((1 - con) / (1 + con), eccnth)) - phi;
            phi += dphi;
            if (Math.abs(dphi) <= 1e-10) return phi
        }
        alert("phi2z has NoConvergence");
        return -9999
    },
    qsfnz: function(eccent, sinphi) {
        var con;
        if (eccent > 1e-7) {
            con = eccent * sinphi;
            return (1 - eccent * eccent) * (sinphi / (1 - con * con) - .5 / eccent * Math.log((1 - con) / (1 + con)))
        } else {
            return 2 * sinphi
        }
    },
    asinz: function(x) {
        if (Math.abs(x) > 1) {
            x = x > 1 ? 1 : -1
        }
        return Math.asin(x)
    },
    e0fn: function(x) {
        return 1 - .25 * x * (1 + x / 16 * (3 + 1.25 * x))
    },
    e1fn: function(x) {
        return .375 * x * (1 + .25 * x * (1 + .46875 * x))
    },
    e2fn: function(x) {
        return .05859375 * x * x * (1 + .75 * x)
    },
    e3fn: function(x) {
        return x * x * x * (35 / 3072)
    },
    mlfn: function(e0, e1, e2, e3, phi) {
        return e0 * phi - e1 * Math.sin(2 * phi) + e2 * Math.sin(4 * phi) - e3 * Math.sin(6 * phi)
    },
    srat: function(esinp, exp) {
        return Math.pow((1 - esinp) / (1 + esinp), exp)
    },
    sign: function(x) {
        if (x < 0) return -1;
        else return 1
    },
    adjust_lon: function(x) {
        x = Math.abs(x) < this.PI ? x : x - this.sign(x) * this.TWO_PI;
        return x
    },
    adjust_lat: function(x) {
        x = Math.abs(x) < this.HALF_PI ? x : x - this.sign(x) * this.PI;
        return x
    },
    latiso: function(eccent, phi, sinphi) {
        if (Math.abs(phi) > this.HALF_PI) return +Number.NaN;
        if (phi == this.HALF_PI) return Number.POSITIVE_INFINITY;
        if (phi == -1 * this.HALF_PI) return -1 * Number.POSITIVE_INFINITY;
        var con = eccent * sinphi;
        return Math.log(Math.tan((this.HALF_PI + phi) / 2)) + eccent * Math.log((1 - con) / (1 + con)) / 2
    },
    fL: function(x, L) {
        return 2 * Math.atan(x * Math.exp(L)) - this.HALF_PI
    },
    invlatiso: function(eccent, ts) {
        var phi = this.fL(1, ts);
        var Iphi = 0;
        var con = 0;
        do {
            Iphi = phi;
            con = eccent * Math.sin(Iphi);
            phi = this.fL(Math.exp(eccent * Math.log((1 + con) / (1 - con)) / 2), ts)
        } while (Math.abs(phi - Iphi) > 1e-12);
        return phi
    },
    sinh: function(x) {
        var r = Math.exp(x);
        r = (r - 1 / r) / 2;
        return r
    },
    cosh: function(x) {
        var r = Math.exp(x);
        r = (r + 1 / r) / 2;
        return r
    },
    tanh: function(x) {
        var r = Math.exp(x);
        r = (r - 1 / r) / (r + 1 / r);
        return r
    },
    asinh: function(x) {
        var s = x >= 0 ? 1 : -1;
        return s * Math.log(Math.abs(x) + Math.sqrt(x * x + 1))
    },
    acosh: function(x) {
        return 2 * Math.log(Math.sqrt((x + 1) / 2) + Math.sqrt((x - 1) / 2))
    },
    atanh: function(x) {
        return Math.log((x - 1) / (x + 1)) / 2
    },
    gN: function(a, e, sinphi) {
        var temp = e * sinphi;
        return a / Math.sqrt(1 - temp * temp)
    },
    pj_enfn: function(es) {
        var en = new Array;
        en[0] = this.C00 - es * (this.C02 + es * (this.C04 + es * (this.C06 + es * this.C08)));
        en[1] = es * (this.C22 - es * (this.C04 + es * (this.C06 + es * this.C08)));
        var t = es * es;
        en[2] = t * (this.C44 - es * (this.C46 + es * this.C48));
        t *= es;
        en[3] = t * (this.C66 - es * this.C68);
        en[4] = t * es * this.C88;
        return en
    },
    pj_mlfn: function(phi, sphi, cphi, en) {
        cphi *= sphi;
        sphi *= sphi;
        return en[0] * phi - cphi * (en[1] + sphi * (en[2] + sphi * (en[3] + sphi * en[4])))
    },
    pj_inv_mlfn: function(arg, es, en) {
        var k = 1 / (1 - es);
        var phi = arg;
        for (var i = Proj4js.common.MAX_ITER; i; --i) {
            var s = Math.sin(phi);
            var t = 1 - es * s * s;
            t = (this.pj_mlfn(phi, s, Math.cos(phi), en) - arg) * t * Math.sqrt(t) * k;
            phi -= t;
            if (Math.abs(t) < Proj4js.common.EPSLN) return phi
        }
        Proj4js.reportError("cass:pj_inv_mlfn: Convergence error");
        return phi
    },
    C00: 1,
    C02: .25,
    C04: .046875,
    C06: .01953125,
    C08: .01068115234375,
    C22: .75,
    C44: .46875,
    C46: .013020833333333334,
    C48: .007120768229166667,
    C66: .3645833333333333,
    C68: .005696614583333333,
    C88: .3076171875
};
Proj4js.datum = Proj4js.Class({
    initialize: function(proj) {
        this.datum_type = Proj4js.common.PJD_WGS84;
        if (proj.datumCode && proj.datumCode == "none") {
            this.datum_type = Proj4js.common.PJD_NODATUM
        }
        if (proj && proj.datum_params) {
            for (var i = 0; i < proj.datum_params.length; i++) {
                proj.datum_params[i] = parseFloat(proj.datum_params[i])
            }
            if (proj.datum_params[0] != 0 || proj.datum_params[1] != 0 || proj.datum_params[2] != 0) {
                this.datum_type = Proj4js.common.PJD_3PARAM
            }
            if (proj.datum_params.length > 3) {
                if (proj.datum_params[3] != 0 || proj.datum_params[4] != 0 || proj.datum_params[5] != 0 || proj.datum_params[6] != 0) {
                    this.datum_type = Proj4js.common.PJD_7PARAM;
                    proj.datum_params[3] *= Proj4js.common.SEC_TO_RAD;
                    proj.datum_params[4] *= Proj4js.common.SEC_TO_RAD;
                    proj.datum_params[5] *= Proj4js.common.SEC_TO_RAD;
                    proj.datum_params[6] = proj.datum_params[6] / 1e6 + 1
                }
            }
        }
        if (proj) {
            this.a = proj.a;
            this.b = proj.b;
            this.es = proj.es;
            this.ep2 = proj.ep2;
            this.datum_params = proj.datum_params
        }
    },
    compare_datums: function(dest) {
        if (this.datum_type != dest.datum_type) {
            return false
        } else if (this.a != dest.a || Math.abs(this.es - dest.es) > 5e-11) {
            return false
        } else if (this.datum_type == Proj4js.common.PJD_3PARAM) {
            return this.datum_params[0] == dest.datum_params[0] && this.datum_params[1] == dest.datum_params[1] && this.datum_params[2] == dest.datum_params[2]
        } else if (this.datum_type == Proj4js.common.PJD_7PARAM) {
            return this.datum_params[0] == dest.datum_params[0] && this.datum_params[1] == dest.datum_params[1] && this.datum_params[2] == dest.datum_params[2] && this.datum_params[3] == dest.datum_params[3] && this.datum_params[4] == dest.datum_params[4] && this.datum_params[5] == dest.datum_params[5] && this.datum_params[6] == dest.datum_params[6]
        } else if (this.datum_type == Proj4js.common.PJD_GRIDSHIFT || dest.datum_type == Proj4js.common.PJD_GRIDSHIFT) {
            alert("ERROR: Grid shift transformations are not implemented.");
            return false
        } else {
            return true
        }
    },
    geodetic_to_geocentric: function(p) {
        var Longitude = p.x;
        var Latitude = p.y;
        var Height = p.z ? p.z : 0;
        var X;
        var Y;
        var Z;
        var Error_Code = 0;
        var Rn;
        var Sin_Lat;
        var Sin2_Lat;
        var Cos_Lat;
        if (Latitude < -Proj4js.common.HALF_PI && Latitude > -1.001 * Proj4js.common.HALF_PI) {
            Latitude = -Proj4js.common.HALF_PI
        } else if (Latitude > Proj4js.common.HALF_PI && Latitude < 1.001 * Proj4js.common.HALF_PI) {
            Latitude = Proj4js.common.HALF_PI
        } else if (Latitude < -Proj4js.common.HALF_PI || Latitude > Proj4js.common.HALF_PI) {
            Proj4js.reportError("geocent:lat out of range:" + Latitude);
            return null
        }
        if (Longitude > Proj4js.common.PI) Longitude -= 2 * Proj4js.common.PI;
        Sin_Lat = Math.sin(Latitude);
        Cos_Lat = Math.cos(Latitude);
        Sin2_Lat = Sin_Lat * Sin_Lat;
        Rn = this.a / Math.sqrt(1 - this.es * Sin2_Lat);
        X = (Rn + Height) * Cos_Lat * Math.cos(Longitude);
        Y = (Rn + Height) * Cos_Lat * Math.sin(Longitude);
        Z = (Rn * (1 - this.es) + Height) * Sin_Lat;
        p.x = X;
        p.y = Y;
        p.z = Z;
        return Error_Code
    },
    geocentric_to_geodetic: function(p) {
        var genau = 1e-12;
        var genau2 = genau * genau;
        var maxiter = 30;
        var P;
        var RR;
        var CT;
        var ST;
        var RX;
        var RK;
        var RN;
        var CPHI0;
        var SPHI0;
        var CPHI;
        var SPHI;
        var SDPHI;
        var At_Pole;
        var iter;
        var X = p.x;
        var Y = p.y;
        var Z = p.z ? p.z : 0;
        var Longitude;
        var Latitude;
        var Height;
        At_Pole = false;
        P = Math.sqrt(X * X + Y * Y);
        RR = Math.sqrt(X * X + Y * Y + Z * Z);
        if (P / this.a < genau) {
            At_Pole = true;
            Longitude = 0;
            if (RR / this.a < genau) {
                Latitude = Proj4js.common.HALF_PI;
                Height = -this.b;
                return
            }
        } else {
            Longitude = Math.atan2(Y, X)
        }
        CT = Z / RR;
        ST = P / RR;
        RX = 1 / Math.sqrt(1 - this.es * (2 - this.es) * ST * ST);
        CPHI0 = ST * (1 - this.es) * RX;
        SPHI0 = CT * RX;
        iter = 0;
        do {
            iter++;
            RN = this.a / Math.sqrt(1 - this.es * SPHI0 * SPHI0);
            Height = P * CPHI0 + Z * SPHI0 - RN * (1 - this.es * SPHI0 * SPHI0);
            RK = this.es * RN / (RN + Height);
            RX = 1 / Math.sqrt(1 - RK * (2 - RK) * ST * ST);
            CPHI = ST * (1 - RK) * RX;
            SPHI = CT * RX;
            SDPHI = SPHI * CPHI0 - CPHI * SPHI0;
            CPHI0 = CPHI;
            SPHI0 = SPHI
        } while (SDPHI * SDPHI > genau2 && iter < maxiter);
        Latitude = Math.atan(SPHI / Math.abs(CPHI));
        p.x = Longitude;
        p.y = Latitude;
        p.z = Height;
        return p
    },
    geocentric_to_geodetic_noniter: function(p) {
        var X = p.x;
        var Y = p.y;
        var Z = p.z ? p.z : 0;
        var Longitude;
        var Latitude;
        var Height;
        var W;
        var W2;
        var T0;
        var T1;
        var S0;
        var S1;
        var Sin_B0;
        var Sin3_B0;
        var Cos_B0;
        var Sin_p1;
        var Cos_p1;
        var Rn;
        var Sum;
        var At_Pole;
        X = parseFloat(X);
        Y = parseFloat(Y);
        Z = parseFloat(Z);
        At_Pole = false;
        if (X != 0) {
            Longitude = Math.atan2(Y, X)
        } else {
            if (Y > 0) {
                Longitude = Proj4js.common.HALF_PI
            } else if (Y < 0) {
                Longitude = -Proj4js.common.HALF_PI
            } else {
                At_Pole = true;
                Longitude = 0;
                if (Z > 0) {
                    Latitude = Proj4js.common.HALF_PI
                } else if (Z < 0) {
                    Latitude = -Proj4js.common.HALF_PI
                } else {
                    Latitude = Proj4js.common.HALF_PI;
                    Height = -this.b;
                    return
                }
            }
        }
        W2 = X * X + Y * Y;
        W = Math.sqrt(W2);
        T0 = Z * Proj4js.common.AD_C;
        S0 = Math.sqrt(T0 * T0 + W2);
        Sin_B0 = T0 / S0;
        Cos_B0 = W / S0;
        Sin3_B0 = Sin_B0 * Sin_B0 * Sin_B0;
        T1 = Z + this.b * this.ep2 * Sin3_B0;
        Sum = W - this.a * this.es * Cos_B0 * Cos_B0 * Cos_B0;
        S1 = Math.sqrt(T1 * T1 + Sum * Sum);
        Sin_p1 = T1 / S1;
        Cos_p1 = Sum / S1;
        Rn = this.a / Math.sqrt(1 - this.es * Sin_p1 * Sin_p1);
        if (Cos_p1 >= Proj4js.common.COS_67P5) {
            Height = W / Cos_p1 - Rn
        } else if (Cos_p1 <= -Proj4js.common.COS_67P5) {
            Height = W / -Cos_p1 - Rn
        } else {
            Height = Z / Sin_p1 + Rn * (this.es - 1)
        }
        if (At_Pole == false) {
            Latitude = Math.atan(Sin_p1 / Cos_p1)
        }
        p.x = Longitude;
        p.y = Latitude;
        p.z = Height;
        return p
    },
    geocentric_to_wgs84: function(p) {
        if (this.datum_type == Proj4js.common.PJD_3PARAM) {
            p.x += this.datum_params[0];
            p.y += this.datum_params[1];
            p.z += this.datum_params[2]
        } else if (this.datum_type == Proj4js.common.PJD_7PARAM) {
            var Dx_BF = this.datum_params[0];
            var Dy_BF = this.datum_params[1];
            var Dz_BF = this.datum_params[2];
            var Rx_BF = this.datum_params[3];
            var Ry_BF = this.datum_params[4];
            var Rz_BF = this.datum_params[5];
            var M_BF = this.datum_params[6];
            var x_out = M_BF * (p.x - Rz_BF * p.y + Ry_BF * p.z) + Dx_BF;
            var y_out = M_BF * (Rz_BF * p.x + p.y - Rx_BF * p.z) + Dy_BF;
            var z_out = M_BF * (-Ry_BF * p.x + Rx_BF * p.y + p.z) + Dz_BF;
            p.x = x_out;
            p.y = y_out;
            p.z = z_out
        }
    },
    geocentric_from_wgs84: function(p) {
        if (this.datum_type == Proj4js.common.PJD_3PARAM) {
            p.x -= this.datum_params[0];
            p.y -= this.datum_params[1];
            p.z -= this.datum_params[2]
        } else if (this.datum_type == Proj4js.common.PJD_7PARAM) {
            var Dx_BF = this.datum_params[0];
            var Dy_BF = this.datum_params[1];
            var Dz_BF = this.datum_params[2];
            var Rx_BF = this.datum_params[3];
            var Ry_BF = this.datum_params[4];
            var Rz_BF = this.datum_params[5];
            var M_BF = this.datum_params[6];
            var x_tmp = (p.x - Dx_BF) / M_BF;
            var y_tmp = (p.y - Dy_BF) / M_BF;
            var z_tmp = (p.z - Dz_BF) / M_BF;
            p.x = x_tmp + Rz_BF * y_tmp - Ry_BF * z_tmp;
            p.y = -Rz_BF * x_tmp + y_tmp + Rx_BF * z_tmp;
            p.z = Ry_BF * x_tmp - Rx_BF * y_tmp + z_tmp
        }
    }
});
Proj4js.Point = Proj4js.Class({
    initialize: function(x, y, z) {
        if (typeof x == "object") {
            this.x = x[0];
            this.y = x[1];
            this.z = x[2] || 0
        } else if (typeof x == "string" && typeof y == "undefined") {
            var coords = x.split(",");
            this.x = parseFloat(coords[0]);
            this.y = parseFloat(coords[1]);
            this.z = parseFloat(coords[2]) || 0
        } else {
            this.x = x;
            this.y = y;
            this.z = z || 0
        }
    },
    clone: function() {
        return new Proj4js.Point(this.x, this.y, this.z)
    },
    toString: function() {
        return "x=" + this.x + ",y=" + this.y
    },
    toShortString: function() {
        return this.x + ", " + this.y
    }
});
Proj4js.PrimeMeridian = {
    greenwich: 0,
    lisbon: -9.131906111111,
    paris: 2.337229166667,
    bogota: -74.080916666667,
    madrid: -3.687938888889,
    rome: 12.452333333333,
    bern: 7.439583333333,
    jakarta: 106.807719444444,
    ferro: -17.666666666667,
    brussels: 4.367975,
    stockholm: 18.058277777778,
    athens: 23.7163375,
    oslo: 10.722916666667
};
Proj4js.Ellipsoid = {
    MERIT: {
        a: 6378137,
        rf: 298.257,
        ellipseName: "MERIT 1983"
    },
    SGS85: {
        a: 6378136,
        rf: 298.257,
        ellipseName: "Soviet Geodetic System 85"
    },
    GRS80: {
        a: 6378137,
        rf: 298.257222101,
        ellipseName: "GRS 1980(IUGG, 1980)"
    },
    IAU76: {
        a: 6378140,
        rf: 298.257,
        ellipseName: "IAU 1976"
    },
    airy: {
        a: 6377563.396,
        b: 6356256.91,
        ellipseName: "Airy 1830"
    },
    "APL4.": {
        a: 6378137,
        rf: 298.25,
        ellipseName: "Appl. Physics. 1965"
    },
    NWL9D: {
        a: 6378145,
        rf: 298.25,
        ellipseName: "Naval Weapons Lab., 1965"
    },
    mod_airy: {
        a: 6377340.189,
        b: 6356034.446,
        ellipseName: "Modified Airy"
    },
    andrae: {
        a: 6377104.43,
        rf: 300,
        ellipseName: "Andrae 1876 (Den., Iclnd.)"
    },
    aust_SA: {
        a: 6378160,
        rf: 298.25,
        ellipseName: "Australian Natl & S. Amer. 1969"
    },
    GRS67: {
        a: 6378160,
        rf: 298.247167427,
        ellipseName: "GRS 67(IUGG 1967)"
    },
    bessel: {
        a: 6377397.155,
        rf: 299.1528128,
        ellipseName: "Bessel 1841"
    },
    bess_nam: {
        a: 6377483.865,
        rf: 299.1528128,
        ellipseName: "Bessel 1841 (Namibia)"
    },
    clrk66: {
        a: 6378206.4,
        b: 6356583.8,
        ellipseName: "Clarke 1866"
    },
    clrk80: {
        a: 6378249.145,
        rf: 293.4663,
        ellipseName: "Clarke 1880 mod."
    },
    CPM: {
        a: 6375738.7,
        rf: 334.29,
        ellipseName: "Comm. des Poids et Mesures 1799"
    },
    delmbr: {
        a: 6376428,
        rf: 311.5,
        ellipseName: "Delambre 1810 (Belgium)"
    },
    engelis: {
        a: 6378136.05,
        rf: 298.2566,
        ellipseName: "Engelis 1985"
    },
    evrst30: {
        a: 6377276.345,
        rf: 300.8017,
        ellipseName: "Everest 1830"
    },
    evrst48: {
        a: 6377304.063,
        rf: 300.8017,
        ellipseName: "Everest 1948"
    },
    evrst56: {
        a: 6377301.243,
        rf: 300.8017,
        ellipseName: "Everest 1956"
    },
    evrst69: {
        a: 6377295.664,
        rf: 300.8017,
        ellipseName: "Everest 1969"
    },
    evrstSS: {
        a: 6377298.556,
        rf: 300.8017,
        ellipseName: "Everest (Sabah & Sarawak)"
    },
    fschr60: {
        a: 6378166,
        rf: 298.3,
        ellipseName: "Fischer (Mercury Datum) 1960"
    },
    fschr60m: {
        a: 6378155,
        rf: 298.3,
        ellipseName: "Fischer 1960"
    },
    fschr68: {
        a: 6378150,
        rf: 298.3,
        ellipseName: "Fischer 1968"
    },
    helmert: {
        a: 6378200,
        rf: 298.3,
        ellipseName: "Helmert 1906"
    },
    hough: {
        a: 6378270,
        rf: 297,
        ellipseName: "Hough"
    },
    intl: {
        a: 6378388,
        rf: 297,
        ellipseName: "International 1909 (Hayford)"
    },
    kaula: {
        a: 6378163,
        rf: 298.24,
        ellipseName: "Kaula 1961"
    },
    lerch: {
        a: 6378139,
        rf: 298.257,
        ellipseName: "Lerch 1979"
    },
    mprts: {
        a: 6397300,
        rf: 191,
        ellipseName: "Maupertius 1738"
    },
    new_intl: {
        a: 6378157.5,
        b: 6356772.2,
        ellipseName: "New International 1967"
    },
    plessis: {
        a: 6376523,
        rf: 6355863,
        ellipseName: "Plessis 1817 (France)"
    },
    krass: {
        a: 6378245,
        rf: 298.3,
        ellipseName: "Krassovsky, 1942"
    },
    SEasia: {
        a: 6378155,
        b: 6356773.3205,
        ellipseName: "Southeast Asia"
    },
    walbeck: {
        a: 6376896,
        b: 6355834.8467,
        ellipseName: "Walbeck"
    },
    WGS60: {
        a: 6378165,
        rf: 298.3,
        ellipseName: "WGS 60"
    },
    WGS66: {
        a: 6378145,
        rf: 298.25,
        ellipseName: "WGS 66"
    },
    WGS72: {
        a: 6378135,
        rf: 298.26,
        ellipseName: "WGS 72"
    },
    WGS84: {
        a: 6378137,
        rf: 298.257223563,
        ellipseName: "WGS 84"
    },
    sphere: {
        a: 6370997,
        b: 6370997,
        ellipseName: "Normal Sphere (r=6370997)"
    }
};
Proj4js.Datum = {
    WGS84: {
        towgs84: "0,0,0",
        ellipse: "WGS84",
        datumName: "WGS84"
    },
    GGRS87: {
        towgs84: "-199.87,74.79,246.62",
        ellipse: "GRS80",
        datumName: "Greek_Geodetic_Reference_System_1987"
    },
    NAD83: {
        towgs84: "0,0,0",
        ellipse: "GRS80",
        datumName: "North_American_Datum_1983"
    },
    NAD27: {
        nadgrids: "@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat",
        ellipse: "clrk66",
        datumName: "North_American_Datum_1927"
    },
    potsdam: {
        towgs84: "606.0,23.0,413.0",
        ellipse: "bessel",
        datumName: "Potsdam Rauenberg 1950 DHDN"
    },
    carthage: {
        towgs84: "-263.0,6.0,431.0",
        ellipse: "clark80",
        datumName: "Carthage 1934 Tunisia"
    },
    hermannskogel: {
        towgs84: "653.0,-212.0,449.0",
        ellipse: "bessel",
        datumName: "Hermannskogel"
    },
    ire65: {
        towgs84: "482.530,-130.596,564.557,-1.042,-0.214,-0.631,8.15",
        ellipse: "mod_airy",
        datumName: "Ireland 1965"
    },
    nzgd49: {
        towgs84: "59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993",
        ellipse: "intl",
        datumName: "New Zealand Geodetic Datum 1949"
    },
    OSGB36: {
        towgs84: "446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894",
        ellipse: "airy",
        datumName: "Airy 1830"
    }
};
Proj4js.WGS84 = new Proj4js.Proj("WGS84");
Proj4js.Datum["OSB36"] = Proj4js.Datum["OSGB36"];
Proj4js.wktProjections = {
    "Lambert Tangential Conformal Conic Projection": "lcc",
    Mercator: "merc",
    "Popular Visualisation Pseudo Mercator": "merc",
    Mercator_1SP: "merc",
    Transverse_Mercator: "tmerc",
    "Transverse Mercator": "tmerc",
    "Lambert Azimuthal Equal Area": "laea",
    "Universal Transverse Mercator System": "utm"
};
Proj4js.Proj.aea = {
    init: function() {
        if (Math.abs(this.lat1 + this.lat2) < Proj4js.common.EPSLN) {
            Proj4js.reportError("aeaInitEqualLatitudes");
            return
        }
        this.temp = this.b / this.a;
        this.es = 1 - Math.pow(this.temp, 2);
        this.e3 = Math.sqrt(this.es);
        this.sin_po = Math.sin(this.lat1);
        this.cos_po = Math.cos(this.lat1);
        this.t1 = this.sin_po;
        this.con = this.sin_po;
        this.ms1 = Proj4js.common.msfnz(this.e3, this.sin_po, this.cos_po);
        this.qs1 = Proj4js.common.qsfnz(this.e3, this.sin_po, this.cos_po);
        this.sin_po = Math.sin(this.lat2);
        this.cos_po = Math.cos(this.lat2);
        this.t2 = this.sin_po;
        this.ms2 = Proj4js.common.msfnz(this.e3, this.sin_po, this.cos_po);
        this.qs2 = Proj4js.common.qsfnz(this.e3, this.sin_po, this.cos_po);
        this.sin_po = Math.sin(this.lat0);
        this.cos_po = Math.cos(this.lat0);
        this.t3 = this.sin_po;
        this.qs0 = Proj4js.common.qsfnz(this.e3, this.sin_po, this.cos_po);
        if (Math.abs(this.lat1 - this.lat2) > Proj4js.common.EPSLN) {
            this.ns0 = (this.ms1 * this.ms1 - this.ms2 * this.ms2) / (this.qs2 - this.qs1)
        } else {
            this.ns0 = this.con
        }
        this.c = this.ms1 * this.ms1 + this.ns0 * this.qs1;
        this.rh = this.a * Math.sqrt(this.c - this.ns0 * this.qs0) / this.ns0
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        this.sin_phi = Math.sin(lat);
        this.cos_phi = Math.cos(lat);
        var qs = Proj4js.common.qsfnz(this.e3, this.sin_phi, this.cos_phi);
        var rh1 = this.a * Math.sqrt(this.c - this.ns0 * qs) / this.ns0;
        var theta = this.ns0 * Proj4js.common.adjust_lon(lon - this.long0);
        var x = rh1 * Math.sin(theta) + this.x0;
        var y = this.rh - rh1 * Math.cos(theta) + this.y0;
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var rh1, qs, con, theta, lon, lat;
        p.x -= this.x0;
        p.y = this.rh - p.y + this.y0;
        if (this.ns0 >= 0) {
            rh1 = Math.sqrt(p.x * p.x + p.y * p.y);
            con = 1
        } else {
            rh1 = -Math.sqrt(p.x * p.x + p.y * p.y);
            con = -1
        }
        theta = 0;
        if (rh1 != 0) {
            theta = Math.atan2(con * p.x, con * p.y)
        }
        con = rh1 * this.ns0 / this.a;
        qs = (this.c - con * con) / this.ns0;
        if (this.e3 >= 1e-10) {
            con = 1 - .5 * (1 - this.es) * Math.log((1 - this.e3) / (1 + this.e3)) / this.e3;
            if (Math.abs(Math.abs(con) - Math.abs(qs)) > 1e-10) {
                lat = this.phi1z(this.e3, qs)
            } else {
                if (qs >= 0) {
                    lat = .5 * Proj4js.common.PI
                } else {
                    lat = -.5 * Proj4js.common.PI
                }
            }
        } else {
            lat = this.phi1z(this.e3, qs)
        }
        lon = Proj4js.common.adjust_lon(theta / this.ns0 + this.long0);
        p.x = lon;
        p.y = lat;
        return p
    },
    phi1z: function(eccent, qs) {
        var sinphi, cosphi, con, com, dphi;
        var phi = Proj4js.common.asinz(.5 * qs);
        if (eccent < Proj4js.common.EPSLN) return phi;
        var eccnts = eccent * eccent;
        for (var i = 1; i <= 25; i++) {
            sinphi = Math.sin(phi);
            cosphi = Math.cos(phi);
            con = eccent * sinphi;
            com = 1 - con * con;
            dphi = .5 * com * com / cosphi * (qs / (1 - eccnts) - sinphi / com + .5 / eccent * Math.log((1 - con) / (1 + con)));
            phi = phi + dphi;
            if (Math.abs(dphi) <= 1e-7) return phi
        }
        Proj4js.reportError("aea:phi1z:Convergence error");
        return null
    }
};
Proj4js.Proj.sterea = {
    dependsOn: "gauss",
    init: function() {
        Proj4js.Proj["gauss"].init.apply(this);
        if (!this.rc) {
            Proj4js.reportError("sterea:init:E_ERROR_0");
            return
        }
        this.sinc0 = Math.sin(this.phic0);
        this.cosc0 = Math.cos(this.phic0);
        this.R2 = 2 * this.rc;
        if (!this.title) this.title = "Oblique Stereographic Alternative"
    },
    forward: function(p) {
        var sinc, cosc, cosl, k;
        p.x = Proj4js.common.adjust_lon(p.x - this.long0);
        Proj4js.Proj["gauss"].forward.apply(this, [p]);
        sinc = Math.sin(p.y);
        cosc = Math.cos(p.y);
        cosl = Math.cos(p.x);
        k = this.k0 * this.R2 / (1 + this.sinc0 * sinc + this.cosc0 * cosc * cosl);
        p.x = k * cosc * Math.sin(p.x);
        p.y = k * (this.cosc0 * sinc - this.sinc0 * cosc * cosl);
        p.x = this.a * p.x + this.x0;
        p.y = this.a * p.y + this.y0;
        return p
    },
    inverse: function(p) {
        var sinc, cosc, lon, lat, rho;
        p.x = (p.x - this.x0) / this.a;
        p.y = (p.y - this.y0) / this.a;
        p.x /= this.k0;
        p.y /= this.k0;
        if (rho = Math.sqrt(p.x * p.x + p.y * p.y)) {
            var c = 2 * Math.atan2(rho, this.R2);
            sinc = Math.sin(c);
            cosc = Math.cos(c);
            lat = Math.asin(cosc * this.sinc0 + p.y * sinc * this.cosc0 / rho);
            lon = Math.atan2(p.x * sinc, rho * this.cosc0 * cosc - p.y * this.sinc0 * sinc)
        } else {
            lat = this.phic0;
            lon = 0
        }
        p.x = lon;
        p.y = lat;
        Proj4js.Proj["gauss"].inverse.apply(this, [p]);
        p.x = Proj4js.common.adjust_lon(p.x + this.long0);
        return p
    }
};

function phi4z(eccent, e0, e1, e2, e3, a, b, c, phi) {
    var sinphi, sin2ph, tanphi, ml, mlp, con1, con2, con3, dphi, i;
    phi = a;
    for (i = 1; i <= 15; i++) {
        sinphi = Math.sin(phi);
        tanphi = Math.tan(phi);
        c = tanphi * Math.sqrt(1 - eccent * sinphi * sinphi);
        sin2ph = Math.sin(2 * phi);
        ml = e0 * phi - e1 * sin2ph + e2 * Math.sin(4 * phi) - e3 * Math.sin(6 * phi);
        mlp = e0 - 2 * e1 * Math.cos(2 * phi) + 4 * e2 * Math.cos(4 * phi) - 6 * e3 * Math.cos(6 * phi);
        con1 = 2 * ml + c * (ml * ml + b) - 2 * a * (c * ml + 1);
        con2 = eccent * sin2ph * (ml * ml + b - 2 * a * ml) / (2 * c);
        con3 = 2 * (a - ml) * (c * mlp - 2 / sin2ph) - 2 * mlp;
        dphi = con1 / (con2 + con3);
        phi += dphi;
        if (Math.abs(dphi) <= 1e-10) return phi
    }
    Proj4js.reportError("phi4z: No convergence");
    return null
}

function e4fn(x) {
    var con, com;
    con = 1 + x;
    com = 1 - x;
    return Math.sqrt(Math.pow(con, con) * Math.pow(com, com))
}
Proj4js.Proj.poly = {
    init: function() {
        var temp;
        if (this.lat0 == 0) this.lat0 = 90;
        this.temp = this.b / this.a;
        this.es = 1 - Math.pow(this.temp, 2);
        this.e = Math.sqrt(this.es);
        this.e0 = Proj4js.common.e0fn(this.es);
        this.e1 = Proj4js.common.e1fn(this.es);
        this.e2 = Proj4js.common.e2fn(this.es);
        this.e3 = Proj4js.common.e3fn(this.es);
        this.ml0 = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, this.lat0)
    },
    forward: function(p) {
        var sinphi, cosphi;
        var al;
        var c;
        var con, ml;
        var ms;
        var x, y;
        var lon = p.x;
        var lat = p.y;
        con = Proj4js.common.adjust_lon(lon - this.long0);
        if (Math.abs(lat) <= 1e-7) {
            x = this.x0 + this.a * con;
            y = this.y0 - this.a * this.ml0
        } else {
            sinphi = Math.sin(lat);
            cosphi = Math.cos(lat);
            ml = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, lat);
            ms = Proj4js.common.msfnz(this.e, sinphi, cosphi);
            con = sinphi;
            x = this.x0 + this.a * ms * Math.sin(con) / sinphi;
            y = this.y0 + this.a * (ml - this.ml0 + ms * (1 - Math.cos(con)) / sinphi)
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var sin_phi, cos_phi;
        var al;
        var b;
        var c;
        var con, ml;
        var iflg;
        var lon, lat;
        p.x -= this.x0;
        p.y -= this.y0;
        al = this.ml0 + p.y / this.a;
        iflg = 0;
        if (Math.abs(al) <= 1e-7) {
            lon = p.x / this.a + this.long0;
            lat = 0
        } else {
            b = al * al + p.x / this.a * (p.x / this.a);
            iflg = phi4z(this.es, this.e0, this.e1, this.e2, this.e3, this.al, b, c, lat);
            if (iflg != 1) return iflg;
            lon = Proj4js.common.adjust_lon(Proj4js.common.asinz(p.x * c / this.a) / Math.sin(lat) + this.long0)
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.equi = {
    init: function() {
        if (!this.x0) this.x0 = 0;
        if (!this.y0) this.y0 = 0;
        if (!this.lat0) this.lat0 = 0;
        if (!this.long0) this.long0 = 0
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var x = this.x0 + this.a * dlon * Math.cos(this.lat0);
        var y = this.y0 + this.a * lat;
        this.t1 = x;
        this.t2 = Math.cos(this.lat0);
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var lat = p.y / this.a;
        if (Math.abs(lat) > Proj4js.common.HALF_PI) {
            Proj4js.reportError("equi:Inv:DataError")
        }
        var lon = Proj4js.common.adjust_lon(this.long0 + p.x / (this.a * Math.cos(this.lat0)));
        p.x = lon;
        p.y = lat
    }
};
Proj4js.Proj.merc = {
    init: function() {
        if (this.lat_ts) {
            if (this.sphere) {
                this.k0 = Math.cos(this.lat_ts)
            } else {
                this.k0 = Proj4js.common.msfnz(this.es, Math.sin(this.lat_ts), Math.cos(this.lat_ts))
            }
        }
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        if (lat * Proj4js.common.R2D > 90 && lat * Proj4js.common.R2D < -90 && lon * Proj4js.common.R2D > 180 && lon * Proj4js.common.R2D < -180) {
            Proj4js.reportError("merc:forward: llInputOutOfRange: " + lon + " : " + lat);
            return null
        }
        var x, y;
        if (Math.abs(Math.abs(lat) - Proj4js.common.HALF_PI) <= Proj4js.common.EPSLN) {
            Proj4js.reportError("merc:forward: ll2mAtPoles");
            return null
        } else {
            if (this.sphere) {
                x = this.x0 + this.a * this.k0 * Proj4js.common.adjust_lon(lon - this.long0);
                y = this.y0 + this.a * this.k0 * Math.log(Math.tan(Proj4js.common.FORTPI + .5 * lat))
            } else {
                var sinphi = Math.sin(lat);
                var ts = Proj4js.common.tsfnz(this.e, lat, sinphi);
                x = this.x0 + this.a * this.k0 * Proj4js.common.adjust_lon(lon - this.long0);
                y = this.y0 - this.a * this.k0 * Math.log(ts)
            }
            p.x = x;
            p.y = y;
            return p
        }
    },
    inverse: function(p) {
        var x = p.x - this.x0;
        var y = p.y - this.y0;
        var lon, lat;
        if (this.sphere) {
            lat = Proj4js.common.HALF_PI - 2 * Math.atan(Math.exp(-y / this.a * this.k0))
        } else {
            var ts = Math.exp(-y / (this.a * this.k0));
            lat = Proj4js.common.phi2z(this.e, ts);
            if (lat == -9999) {
                Proj4js.reportError("merc:inverse: lat = -9999");
                return null
            }
        }
        lon = Proj4js.common.adjust_lon(this.long0 + x / (this.a * this.k0));
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.utm = {
    dependsOn: "tmerc",
    init: function() {
        if (!this.zone) {
            Proj4js.reportError("utm:init: zone must be specified for UTM");
            return
        }
        this.lat0 = 0;
        this.long0 = (6 * Math.abs(this.zone) - 183) * Proj4js.common.D2R;
        this.x0 = 5e5;
        this.y0 = this.utmSouth ? 1e7 : 0;
        this.k0 = .9996;
        Proj4js.Proj["tmerc"].init.apply(this);
        this.forward = Proj4js.Proj["tmerc"].forward;
        this.inverse = Proj4js.Proj["tmerc"].inverse
    }
};
Proj4js.Proj.eqdc = {
    init: function() {
        if (!this.mode) this.mode = 0;
        this.temp = this.b / this.a;
        this.es = 1 - Math.pow(this.temp, 2);
        this.e = Math.sqrt(this.es);
        this.e0 = Proj4js.common.e0fn(this.es);
        this.e1 = Proj4js.common.e1fn(this.es);
        this.e2 = Proj4js.common.e2fn(this.es);
        this.e3 = Proj4js.common.e3fn(this.es);
        this.sinphi = Math.sin(this.lat1);
        this.cosphi = Math.cos(this.lat1);
        this.ms1 = Proj4js.common.msfnz(this.e, this.sinphi, this.cosphi);
        this.ml1 = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, this.lat1);
        if (this.mode != 0) {
            if (Math.abs(this.lat1 + this.lat2) < Proj4js.common.EPSLN) {
                Proj4js.reportError("eqdc:Init:EqualLatitudes")
            }
            this.sinphi = Math.sin(this.lat2);
            this.cosphi = Math.cos(this.lat2);
            this.ms2 = Proj4js.common.msfnz(this.e, this.sinphi, this.cosphi);
            this.ml2 = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, this.lat2);
            if (Math.abs(this.lat1 - this.lat2) >= Proj4js.common.EPSLN) {
                this.ns = (this.ms1 - this.ms2) / (this.ml2 - this.ml1)
            } else {
                this.ns = this.sinphi
            }
        } else {
            this.ns = this.sinphi
        }
        this.g = this.ml1 + this.ms1 / this.ns;
        this.ml0 = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, this.lat0);
        this.rh = this.a * (this.g - this.ml0)
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var ml = Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, lat);
        var rh1 = this.a * (this.g - ml);
        var theta = this.ns * Proj4js.common.adjust_lon(lon - this.long0);
        var x = this.x0 + rh1 * Math.sin(theta);
        var y = this.y0 + this.rh - rh1 * Math.cos(theta);
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y = this.rh - p.y + this.y0;
        var con, rh1;
        if (this.ns >= 0) {
            rh1 = Math.sqrt(p.x * p.x + p.y * p.y);
            con = 1
        } else {
            rh1 = -Math.sqrt(p.x * p.x + p.y * p.y);
            con = -1
        }
        var theta = 0;
        if (rh1 != 0) theta = Math.atan2(con * p.x, con * p.y);
        var ml = this.g - rh1 / this.a;
        var lat = this.phi3z(ml, this.e0, this.e1, this.e2, this.e3);
        var lon = Proj4js.common.adjust_lon(this.long0 + theta / this.ns);
        p.x = lon;
        p.y = lat;
        return p
    },
    phi3z: function(ml, e0, e1, e2, e3) {
        var phi;
        var dphi;
        phi = ml;
        for (var i = 0; i < 15; i++) {
            dphi = (ml + e1 * Math.sin(2 * phi) - e2 * Math.sin(4 * phi) + e3 * Math.sin(6 * phi)) / e0 - phi;
            phi += dphi;
            if (Math.abs(dphi) <= 1e-10) {
                return phi
            }
        }
        Proj4js.reportError("PHI3Z-CONV:Latitude failed to converge after 15 iterations");
        return null
    }
};
Proj4js.Proj.tmerc = {
    init: function() {
        this.e0 = Proj4js.common.e0fn(this.es);
        this.e1 = Proj4js.common.e1fn(this.es);
        this.e2 = Proj4js.common.e2fn(this.es);
        this.e3 = Proj4js.common.e3fn(this.es);
        this.ml0 = this.a * Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, this.lat0)
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var delta_lon = Proj4js.common.adjust_lon(lon - this.long0);
        var con;
        var x, y;
        var sin_phi = Math.sin(lat);
        var cos_phi = Math.cos(lat);
        if (this.sphere) {
            var b = cos_phi * Math.sin(delta_lon);
            if (Math.abs(Math.abs(b) - 1) < 1e-10) {
                Proj4js.reportError("tmerc:forward: Point projects into infinity");
                return 93
            } else {
                x = .5 * this.a * this.k0 * Math.log((1 + b) / (1 - b));
                con = Math.acos(cos_phi * Math.cos(delta_lon) / Math.sqrt(1 - b * b));
                if (lat < 0) con = -con;
                y = this.a * this.k0 * (con - this.lat0)
            }
        } else {
            var al = cos_phi * delta_lon;
            var als = Math.pow(al, 2);
            var c = this.ep2 * Math.pow(cos_phi, 2);
            var tq = Math.tan(lat);
            var t = Math.pow(tq, 2);
            con = 1 - this.es * Math.pow(sin_phi, 2);
            var n = this.a / Math.sqrt(con);
            var ml = this.a * Proj4js.common.mlfn(this.e0, this.e1, this.e2, this.e3, lat);
            x = this.k0 * n * al * (1 + als / 6 * (1 - t + c + als / 20 * (5 - 18 * t + Math.pow(t, 2) + 72 * c - 58 * this.ep2))) + this.x0;
            y = this.k0 * (ml - this.ml0 + n * tq * als * (.5 + als / 24 * (5 - t + 9 * c + 4 * Math.pow(c, 2) + als / 30 * (61 - 58 * t + Math.pow(t, 2) + 600 * c - 330 * this.ep2)))) + this.y0
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var con, phi;
        var delta_phi;
        var i;
        var max_iter = 6;
        var lat, lon;
        if (this.sphere) {
            var f = Math.exp(p.x / (this.a * this.k0));
            var g = .5 * (f - 1 / f);
            var temp = this.lat0 + p.y / (this.a * this.k0);
            var h = Math.cos(temp);
            con = Math.sqrt((1 - h * h) / (1 + g * g));
            lat = Proj4js.common.asinz(con);
            if (temp < 0) lat = -lat;
            if (g == 0 && h == 0) {
                lon = this.long0
            } else {
                lon = Proj4js.common.adjust_lon(Math.atan2(g, h) + this.long0)
            }
        } else {
            var x = p.x - this.x0;
            var y = p.y - this.y0;
            con = (this.ml0 + y / this.k0) / this.a;
            phi = con;
            for (i = 0; true; i++) {
                delta_phi = (con + this.e1 * Math.sin(2 * phi) - this.e2 * Math.sin(4 * phi) + this.e3 * Math.sin(6 * phi)) / this.e0 - phi;
                phi += delta_phi;
                if (Math.abs(delta_phi) <= Proj4js.common.EPSLN) break;
                if (i >= max_iter) {
                    Proj4js.reportError("tmerc:inverse: Latitude failed to converge");
                    return 95
                }
            }
            if (Math.abs(phi) < Proj4js.common.HALF_PI) {
                var sin_phi = Math.sin(phi);
                var cos_phi = Math.cos(phi);
                var tan_phi = Math.tan(phi);
                var c = this.ep2 * Math.pow(cos_phi, 2);
                var cs = Math.pow(c, 2);
                var t = Math.pow(tan_phi, 2);
                var ts = Math.pow(t, 2);
                con = 1 - this.es * Math.pow(sin_phi, 2);
                var n = this.a / Math.sqrt(con);
                var r = n * (1 - this.es) / con;
                var d = x / (n * this.k0);
                var ds = Math.pow(d, 2);
                lat = phi - n * tan_phi * ds / r * (.5 - ds / 24 * (5 + 3 * t + 10 * c - 4 * cs - 9 * this.ep2 - ds / 30 * (61 + 90 * t + 298 * c + 45 * ts - 252 * this.ep2 - 3 * cs)));
                lon = Proj4js.common.adjust_lon(this.long0 + d * (1 - ds / 6 * (1 + 2 * t + c - ds / 20 * (5 - 2 * c + 28 * t - 3 * cs + 8 * this.ep2 + 24 * ts))) / cos_phi)
            } else {
                lat = Proj4js.common.HALF_PI * Proj4js.common.sign(y);
                lon = this.long0
            }
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.defs["GOOGLE"] = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs";
Proj4js.defs["EPSG:900913"] = Proj4js.defs["GOOGLE"];
Proj4js.Proj.gstmerc = {
    init: function() {
        var temp = this.b / this.a;
        this.e = Math.sqrt(1 - temp * temp);
        this.lc = this.long0;
        this.rs = Math.sqrt(1 + this.e * this.e * Math.pow(Math.cos(this.lat0), 4) / (1 - this.e * this.e));
        var sinz = Math.sin(this.lat0);
        var pc = Math.asin(sinz / this.rs);
        var sinzpc = Math.sin(pc);
        this.cp = Proj4js.common.latiso(0, pc, sinzpc) - this.rs * Proj4js.common.latiso(this.e, this.lat0, sinz);
        this.n2 = this.k0 * this.a * Math.sqrt(1 - this.e * this.e) / (1 - this.e * this.e * sinz * sinz);
        this.xs = this.x0;
        this.ys = this.y0 - this.n2 * pc;
        if (!this.title) this.title = "Gauss Schreiber transverse mercator"
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var L = this.rs * (lon - this.lc);
        var Ls = this.cp + this.rs * Proj4js.common.latiso(this.e, lat, Math.sin(lat));
        var lat1 = Math.asin(Math.sin(L) / Proj4js.common.cosh(Ls));
        var Ls1 = Proj4js.common.latiso(0, lat1, Math.sin(lat1));
        p.x = this.xs + this.n2 * Ls1;
        p.y = this.ys + this.n2 * Math.atan(Proj4js.common.sinh(Ls) / Math.cos(L));
        return p
    },
    inverse: function(p) {
        var x = p.x;
        var y = p.y;
        var L = Math.atan(Proj4js.common.sinh((x - this.xs) / this.n2) / Math.cos((y - this.ys) / this.n2));
        var lat1 = Math.asin(Math.sin((y - this.ys) / this.n2) / Proj4js.common.cosh((x - this.xs) / this.n2));
        var LC = Proj4js.common.latiso(0, lat1, Math.sin(lat1));
        p.x = this.lc + L / this.rs;
        p.y = Proj4js.common.invlatiso(this.e, (LC - this.cp) / this.rs);
        return p
    }
};
Proj4js.Proj.ortho = {
    init: function(def) {
        this.sin_p14 = Math.sin(this.lat0);
        this.cos_p14 = Math.cos(this.lat0)
    },
    forward: function(p) {
        var sinphi, cosphi;
        var dlon;
        var coslon;
        var ksp;
        var g;
        var lon = p.x;
        var lat = p.y;
        dlon = Proj4js.common.adjust_lon(lon - this.long0);
        sinphi = Math.sin(lat);
        cosphi = Math.cos(lat);
        coslon = Math.cos(dlon);
        g = this.sin_p14 * sinphi + this.cos_p14 * cosphi * coslon;
        ksp = 1;
        if (g > 0 || Math.abs(g) <= Proj4js.common.EPSLN) {
            var x = this.a * ksp * cosphi * Math.sin(dlon);
            var y = this.y0 + this.a * ksp * (this.cos_p14 * sinphi - this.sin_p14 * cosphi * coslon)
        } else {
            Proj4js.reportError("orthoFwdPointError")
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var rh;
        var z;
        var sinz, cosz;
        var temp;
        var con;
        var lon, lat;
        p.x -= this.x0;
        p.y -= this.y0;
        rh = Math.sqrt(p.x * p.x + p.y * p.y);
        if (rh > this.a + 1e-7) {
            Proj4js.reportError("orthoInvDataError")
        }
        z = Proj4js.common.asinz(rh / this.a);
        sinz = Math.sin(z);
        cosz = Math.cos(z);
        lon = this.long0;
        if (Math.abs(rh) <= Proj4js.common.EPSLN) {
            lat = this.lat0
        }
        lat = Proj4js.common.asinz(cosz * this.sin_p14 + p.y * sinz * this.cos_p14 / rh);
        con = Math.abs(this.lat0) - Proj4js.common.HALF_PI;
        if (Math.abs(con) <= Proj4js.common.EPSLN) {
            if (this.lat0 >= 0) {
                lon = Proj4js.common.adjust_lon(this.long0 + Math.atan2(p.x, -p.y))
            } else {
                lon = Proj4js.common.adjust_lon(this.long0 - Math.atan2(-p.x, p.y))
            }
        }
        con = cosz - this.sin_p14 * Math.sin(lat);
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.krovak = {
    init: function() {
        this.a = 6377397.155;
        this.es = .006674372230614;
        this.e = Math.sqrt(this.es);
        if (!this.lat0) {
            this.lat0 = .863937979737193
        }
        if (!this.long0) {
            this.long0 = .7417649320975901 - .308341501185665
        }
        if (!this.k0) {
            this.k0 = .9999
        }
        this.s45 = .785398163397448;
        this.s90 = 2 * this.s45;
        this.fi0 = this.lat0;
        this.e2 = this.es;
        this.e = Math.sqrt(this.e2);
        this.alfa = Math.sqrt(1 + this.e2 * Math.pow(Math.cos(this.fi0), 4) / (1 - this.e2));
        this.uq = 1.04216856380474;
        this.u0 = Math.asin(Math.sin(this.fi0) / this.alfa);
        this.g = Math.pow((1 + this.e * Math.sin(this.fi0)) / (1 - this.e * Math.sin(this.fi0)), this.alfa * this.e / 2);
        this.k = Math.tan(this.u0 / 2 + this.s45) / Math.pow(Math.tan(this.fi0 / 2 + this.s45), this.alfa) * this.g;
        this.k1 = this.k0;
        this.n0 = this.a * Math.sqrt(1 - this.e2) / (1 - this.e2 * Math.pow(Math.sin(this.fi0), 2));
        this.s0 = 1.37008346281555;
        this.n = Math.sin(this.s0);
        this.ro0 = this.k1 * this.n0 / Math.tan(this.s0);
        this.ad = this.s90 - this.uq
    },
    forward: function(p) {
        var gfi, u, deltav, s, d, eps, ro;
        var lon = p.x;
        var lat = p.y;
        var delta_lon = Proj4js.common.adjust_lon(lon - this.long0);
        gfi = Math.pow((1 + this.e * Math.sin(lat)) / (1 - this.e * Math.sin(lat)), this.alfa * this.e / 2);
        u = 2 * (Math.atan(this.k * Math.pow(Math.tan(lat / 2 + this.s45), this.alfa) / gfi) - this.s45);
        deltav = -delta_lon * this.alfa;
        s = Math.asin(Math.cos(this.ad) * Math.sin(u) + Math.sin(this.ad) * Math.cos(u) * Math.cos(deltav));
        d = Math.asin(Math.cos(u) * Math.sin(deltav) / Math.cos(s));
        eps = this.n * d;
        ro = this.ro0 * Math.pow(Math.tan(this.s0 / 2 + this.s45), this.n) / Math.pow(Math.tan(s / 2 + this.s45), this.n);
        p.y = ro * Math.cos(eps) / 1;
        p.x = ro * Math.sin(eps) / 1;
        if (this.czech) {
            p.y *= -1;
            p.x *= -1
        }
        return p
    },
    inverse: function(p) {
        var u, deltav, s, d, eps, ro, fi1;
        var ok;
        var tmp = p.x;
        p.x = p.y;
        p.y = tmp;
        if (this.czech) {
            p.y *= -1;
            p.x *= -1
        }
        ro = Math.sqrt(p.x * p.x + p.y * p.y);
        eps = Math.atan2(p.y, p.x);
        d = eps / Math.sin(this.s0);
        s = 2 * (Math.atan(Math.pow(this.ro0 / ro, 1 / this.n) * Math.tan(this.s0 / 2 + this.s45)) - this.s45);
        u = Math.asin(Math.cos(this.ad) * Math.sin(s) - Math.sin(this.ad) * Math.cos(s) * Math.cos(d));
        deltav = Math.asin(Math.cos(s) * Math.sin(d) / Math.cos(u));
        p.x = this.long0 - deltav / this.alfa;
        fi1 = u;
        ok = 0;
        var iter = 0;
        do {
            p.y = 2 * (Math.atan(Math.pow(this.k, -1 / this.alfa) * Math.pow(Math.tan(u / 2 + this.s45), 1 / this.alfa) * Math.pow((1 + this.e * Math.sin(fi1)) / (1 - this.e * Math.sin(fi1)), this.e / 2)) - this.s45);
            if (Math.abs(fi1 - p.y) < 1e-10) ok = 1;
            fi1 = p.y;
            iter += 1
        } while (ok == 0 && iter < 15);
        if (iter >= 15) {
            Proj4js.reportError("PHI3Z-CONV:Latitude failed to converge after 15 iterations");
            return null
        }
        return p
    }
};
Proj4js.Proj.somerc = {
    init: function() {
        var phy0 = this.lat0;
        this.lambda0 = this.long0;
        var sinPhy0 = Math.sin(phy0);
        var semiMajorAxis = this.a;
        var invF = this.rf;
        var flattening = 1 / invF;
        var e2 = 2 * flattening - Math.pow(flattening, 2);
        var e = this.e = Math.sqrt(e2);
        this.R = this.k0 * semiMajorAxis * Math.sqrt(1 - e2) / (1 - e2 * Math.pow(sinPhy0, 2));
        this.alpha = Math.sqrt(1 + e2 / (1 - e2) * Math.pow(Math.cos(phy0), 4));
        this.b0 = Math.asin(sinPhy0 / this.alpha);
        this.K = Math.log(Math.tan(Math.PI / 4 + this.b0 / 2)) - this.alpha * Math.log(Math.tan(Math.PI / 4 + phy0 / 2)) + this.alpha * e / 2 * Math.log((1 + e * sinPhy0) / (1 - e * sinPhy0))
    },
    forward: function(p) {
        var Sa1 = Math.log(Math.tan(Math.PI / 4 - p.y / 2));
        var Sa2 = this.e / 2 * Math.log((1 + this.e * Math.sin(p.y)) / (1 - this.e * Math.sin(p.y)));
        var S = -this.alpha * (Sa1 + Sa2) + this.K;
        var b = 2 * (Math.atan(Math.exp(S)) - Math.PI / 4);
        var I = this.alpha * (p.x - this.lambda0);
        var rotI = Math.atan(Math.sin(I) / (Math.sin(this.b0) * Math.tan(b) + Math.cos(this.b0) * Math.cos(I)));
        var rotB = Math.asin(Math.cos(this.b0) * Math.sin(b) - Math.sin(this.b0) * Math.cos(b) * Math.cos(I));
        p.y = this.R / 2 * Math.log((1 + Math.sin(rotB)) / (1 - Math.sin(rotB))) + this.y0;
        p.x = this.R * rotI + this.x0;
        return p
    },
    inverse: function(p) {
        var Y = p.x - this.x0;
        var X = p.y - this.y0;
        var rotI = Y / this.R;
        var rotB = 2 * (Math.atan(Math.exp(X / this.R)) - Math.PI / 4);
        var b = Math.asin(Math.cos(this.b0) * Math.sin(rotB) + Math.sin(this.b0) * Math.cos(rotB) * Math.cos(rotI));
        var I = Math.atan(Math.sin(rotI) / (Math.cos(this.b0) * Math.cos(rotI) - Math.sin(this.b0) * Math.tan(rotB)));
        var lambda = this.lambda0 + I / this.alpha;
        var S = 0;
        var phy = b;
        var prevPhy = -1e3;
        var iteration = 0;
        while (Math.abs(phy - prevPhy) > 1e-7) {
            if (++iteration > 20) {
                Proj4js.reportError("omercFwdInfinity");
                return
            }
            S = 1 / this.alpha * (Math.log(Math.tan(Math.PI / 4 + b / 2)) - this.K) + this.e * Math.log(Math.tan(Math.PI / 4 + Math.asin(this.e * Math.sin(phy)) / 2));
            prevPhy = phy;
            phy = 2 * Math.atan(Math.exp(S)) - Math.PI / 2
        }
        p.x = lambda;
        p.y = phy;
        return p
    }
};
Proj4js.Proj.stere = {
    ssfn_: function(phit, sinphi, eccen) {
        sinphi *= eccen;
        return Math.tan(.5 * (Proj4js.common.HALF_PI + phit)) * Math.pow((1 - sinphi) / (1 + sinphi), .5 * eccen)
    },
    TOL: 1e-8,
    NITER: 8,
    CONV: 1e-10,
    S_POLE: 0,
    N_POLE: 1,
    OBLIQ: 2,
    EQUIT: 3,
    init: function() {
        this.phits = this.lat_ts ? this.lat_ts : Proj4js.common.HALF_PI;
        var t = Math.abs(this.lat0);
        if (Math.abs(t) - Proj4js.common.HALF_PI < Proj4js.common.EPSLN) {
            this.mode = this.lat0 < 0 ? this.S_POLE : this.N_POLE
        } else {
            this.mode = t > Proj4js.common.EPSLN ? this.OBLIQ : this.EQUIT
        }
        this.phits = Math.abs(this.phits);
        if (this.es) {
            var X;
            switch (this.mode) {
                case this.N_POLE:
                case this.S_POLE:
                    if (Math.abs(this.phits - Proj4js.common.HALF_PI) < Proj4js.common.EPSLN) {
                        this.akm1 = 2 * this.k0 / Math.sqrt(Math.pow(1 + this.e, 1 + this.e) * Math.pow(1 - this.e, 1 - this.e))
                    } else {
                        t = Math.sin(this.phits);
                        this.akm1 = Math.cos(this.phits) / Proj4js.common.tsfnz(this.e, this.phits, t);
                        t *= this.e;
                        this.akm1 /= Math.sqrt(1 - t * t)
                    }
                    break;
                case this.EQUIT:
                    this.akm1 = 2 * this.k0;
                    break;
                case this.OBLIQ:
                    t = Math.sin(this.lat0);
                    X = 2 * Math.atan(this.ssfn_(this.lat0, t, this.e)) - Proj4js.common.HALF_PI;
                    t *= this.e;
                    this.akm1 = 2 * this.k0 * Math.cos(this.lat0) / Math.sqrt(1 - t * t);
                    this.sinX1 = Math.sin(X);
                    this.cosX1 = Math.cos(X);
                    break
            }
        } else {
            switch (this.mode) {
                case this.OBLIQ:
                    this.sinph0 = Math.sin(this.lat0);
                    this.cosph0 = Math.cos(this.lat0);
                case this.EQUIT:
                    this.akm1 = 2 * this.k0;
                    break;
                case this.S_POLE:
                case this.N_POLE:
                    this.akm1 = Math.abs(this.phits - Proj4js.common.HALF_PI) >= Proj4js.common.EPSLN ? Math.cos(this.phits) / Math.tan(Proj4js.common.FORTPI - .5 * this.phits) : 2 * this.k0;
                    break
            }
        }
    },
    forward: function(p) {
        var lon = p.x;
        lon = Proj4js.common.adjust_lon(lon - this.long0);
        var lat = p.y;
        var x, y;
        if (this.sphere) {
            var sinphi, cosphi, coslam, sinlam;
            sinphi = Math.sin(lat);
            cosphi = Math.cos(lat);
            coslam = Math.cos(lon);
            sinlam = Math.sin(lon);
            switch (this.mode) {
                case this.EQUIT:
                    y = 1 + cosphi * coslam;
                    if (y <= Proj4js.common.EPSLN) {
                        Proj4js.reportError("stere:forward:Equit")
                    }
                    y = this.akm1 / y;
                    x = y * cosphi * sinlam;
                    y *= sinphi;
                    break;
                case this.OBLIQ:
                    y = 1 + this.sinph0 * sinphi + this.cosph0 * cosphi * coslam;
                    if (y <= Proj4js.common.EPSLN) {
                        Proj4js.reportError("stere:forward:Obliq")
                    }
                    y = this.akm1 / y;
                    x = y * cosphi * sinlam;
                    y *= this.cosph0 * sinphi - this.sinph0 * cosphi * coslam;
                    break;
                case this.N_POLE:
                    coslam = -coslam;
                    lat = -lat;
                case this.S_POLE:
                    if (Math.abs(lat - Proj4js.common.HALF_PI) < this.TOL) {
                        Proj4js.reportError("stere:forward:S_POLE")
                    }
                    y = this.akm1 * Math.tan(Proj4js.common.FORTPI + .5 * lat);
                    x = sinlam * y;
                    y *= coslam;
                    break
            }
        } else {
            coslam = Math.cos(lon);
            sinlam = Math.sin(lon);
            sinphi = Math.sin(lat);
            var sinX, cosX;
            if (this.mode == this.OBLIQ || this.mode == this.EQUIT) {
                var Xt = 2 * Math.atan(this.ssfn_(lat, sinphi, this.e));
                sinX = Math.sin(Xt - Proj4js.common.HALF_PI);
                cosX = Math.cos(Xt)
            }
            switch (this.mode) {
                case this.OBLIQ:
                    var A = this.akm1 / (this.cosX1 * (1 + this.sinX1 * sinX + this.cosX1 * cosX * coslam));
                    y = A * (this.cosX1 * sinX - this.sinX1 * cosX * coslam);
                    x = A * cosX;
                    break;
                case this.EQUIT:
                    var A = 2 * this.akm1 / (1 + cosX * coslam);
                    y = A * sinX;
                    x = A * cosX;
                    break;
                case this.S_POLE:
                    lat = -lat;
                    coslam = -coslam;
                    sinphi = -sinphi;
                case this.N_POLE:
                    x = this.akm1 * Proj4js.common.tsfnz(this.e, lat, sinphi);
                    y = -x * coslam;
                    break
            }
            x = x * sinlam
        }
        p.x = x * this.a + this.x0;
        p.y = y * this.a + this.y0;
        return p
    },
    inverse: function(p) {
        var x = (p.x - this.x0) / this.a;
        var y = (p.y - this.y0) / this.a;
        var lon, lat;
        var cosphi, sinphi, tp = 0,
            phi_l = 0,
            rho, halfe = 0,
            pi2 = 0;
        var i;
        if (this.sphere) {
            var c, rh, sinc, cosc;
            rh = Math.sqrt(x * x + y * y);
            c = 2 * Math.atan(rh / this.akm1);
            sinc = Math.sin(c);
            cosc = Math.cos(c);
            lon = 0;
            switch (this.mode) {
                case this.EQUIT:
                    if (Math.abs(rh) <= Proj4js.common.EPSLN) {
                        lat = 0
                    } else {
                        lat = Math.asin(y * sinc / rh)
                    }
                    if (cosc != 0 || x != 0) lon = Math.atan2(x * sinc, cosc * rh);
                    break;
                case this.OBLIQ:
                    if (Math.abs(rh) <= Proj4js.common.EPSLN) {
                        lat = this.phi0
                    } else {
                        lat = Math.asin(cosc * this.sinph0 + y * sinc * this.cosph0 / rh)
                    }
                    c = cosc - this.sinph0 * Math.sin(lat);
                    if (c != 0 || x != 0) {
                        lon = Math.atan2(x * sinc * this.cosph0, c * rh)
                    }
                    break;
                case this.N_POLE:
                    y = -y;
                case this.S_POLE:
                    if (Math.abs(rh) <= Proj4js.common.EPSLN) {
                        lat = this.phi0
                    } else {
                        lat = Math.asin(this.mode == this.S_POLE ? -cosc : cosc)
                    }
                    lon = x == 0 && y == 0 ? 0 : Math.atan2(x, y);
                    break
            }
            p.x = Proj4js.common.adjust_lon(lon + this.long0);
            p.y = lat
        } else {
            rho = Math.sqrt(x * x + y * y);
            switch (this.mode) {
                case this.OBLIQ:
                case this.EQUIT:
                    tp = 2 * Math.atan2(rho * this.cosX1, this.akm1);
                    cosphi = Math.cos(tp);
                    sinphi = Math.sin(tp);
                    if (rho == 0) {
                        phi_l = Math.asin(cosphi * this.sinX1)
                    } else {
                        phi_l = Math.asin(cosphi * this.sinX1 + y * sinphi * this.cosX1 / rho)
                    }
                    tp = Math.tan(.5 * (Proj4js.common.HALF_PI + phi_l));
                    x *= sinphi;
                    y = rho * this.cosX1 * cosphi - y * this.sinX1 * sinphi;
                    pi2 = Proj4js.common.HALF_PI;
                    halfe = .5 * this.e;
                    break;
                case this.N_POLE:
                    y = -y;
                case this.S_POLE:
                    tp = -rho / this.akm1;
                    phi_l = Proj4js.common.HALF_PI - 2 * Math.atan(tp);
                    pi2 = -Proj4js.common.HALF_PI;
                    halfe = -.5 * this.e;
                    break
            }
            for (i = this.NITER; i--; phi_l = lat) {
                sinphi = this.e * Math.sin(phi_l);
                lat = 2 * Math.atan(tp * Math.pow((1 + sinphi) / (1 - sinphi), halfe)) - pi2;
                if (Math.abs(phi_l - lat) < this.CONV) {
                    if (this.mode == this.S_POLE) lat = -lat;
                    lon = x == 0 && y == 0 ? 0 : Math.atan2(x, y);
                    p.x = Proj4js.common.adjust_lon(lon + this.long0);
                    p.y = lat;
                    return p
                }
            }
        }
    }
};
Proj4js.Proj.nzmg = {
    iterations: 1,
    init: function() {
        this.A = new Array;
        this.A[1] = +.6399175073;
        this.A[2] = -.1358797613;
        this.A[3] = +.063294409;
        this.A[4] = -.02526853;
        this.A[5] = +.0117879;
        this.A[6] = -.0055161;
        this.A[7] = +.0026906;
        this.A[8] = -.001333;
        this.A[9] = +67e-5;
        this.A[10] = -34e-5;
        this.B_re = new Array;
        this.B_im = new Array;
        this.B_re[1] = +.7557853228;
        this.B_im[1] = 0;
        this.B_re[2] = +.249204646;
        this.B_im[2] = +.003371507;
        this.B_re[3] = -.001541739;
        this.B_im[3] = +.04105856;
        this.B_re[4] = -.10162907;
        this.B_im[4] = +.01727609;
        this.B_re[5] = -.26623489;
        this.B_im[5] = -.36249218;
        this.B_re[6] = -.6870983;
        this.B_im[6] = -1.1651967;
        this.C_re = new Array;
        this.C_im = new Array;
        this.C_re[1] = +1.3231270439;
        this.C_im[1] = 0;
        this.C_re[2] = -.577245789;
        this.C_im[2] = -.007809598;
        this.C_re[3] = +.508307513;
        this.C_im[3] = -.112208952;
        this.C_re[4] = -.15094762;
        this.C_im[4] = +.18200602;
        this.C_re[5] = +1.01418179;
        this.C_im[5] = +1.64497696;
        this.C_re[6] = +1.9660549;
        this.C_im[6] = +2.5127645;
        this.D = new Array;
        this.D[1] = +1.5627014243;
        this.D[2] = +.5185406398;
        this.D[3] = -.03333098;
        this.D[4] = -.1052906;
        this.D[5] = -.0368594;
        this.D[6] = +.007317;
        this.D[7] = +.0122;
        this.D[8] = +.00394;
        this.D[9] = -.0013
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var delta_lat = lat - this.lat0;
        var delta_lon = lon - this.long0;
        var d_phi = delta_lat / Proj4js.common.SEC_TO_RAD * 1e-5;
        var d_lambda = delta_lon;
        var d_phi_n = 1;
        var d_psi = 0;
        for (var n = 1; n <= 10; n++) {
            d_phi_n = d_phi_n * d_phi;
            d_psi = d_psi + this.A[n] * d_phi_n
        }
        var th_re = d_psi;
        var th_im = d_lambda;
        var th_n_re = 1;
        var th_n_im = 0;
        var th_n_re1;
        var th_n_im1;
        var z_re = 0;
        var z_im = 0;
        for (var n = 1; n <= 6; n++) {
            th_n_re1 = th_n_re * th_re - th_n_im * th_im;
            th_n_im1 = th_n_im * th_re + th_n_re * th_im;
            th_n_re = th_n_re1;
            th_n_im = th_n_im1;
            z_re = z_re + this.B_re[n] * th_n_re - this.B_im[n] * th_n_im;
            z_im = z_im + this.B_im[n] * th_n_re + this.B_re[n] * th_n_im
        }
        p.x = z_im * this.a + this.x0;
        p.y = z_re * this.a + this.y0;
        return p
    },
    inverse: function(p) {
        var x = p.x;
        var y = p.y;
        var delta_x = x - this.x0;
        var delta_y = y - this.y0;
        var z_re = delta_y / this.a;
        var z_im = delta_x / this.a;
        var z_n_re = 1;
        var z_n_im = 0;
        var z_n_re1;
        var z_n_im1;
        var th_re = 0;
        var th_im = 0;
        for (var n = 1; n <= 6; n++) {
            z_n_re1 = z_n_re * z_re - z_n_im * z_im;
            z_n_im1 = z_n_im * z_re + z_n_re * z_im;
            z_n_re = z_n_re1;
            z_n_im = z_n_im1;
            th_re = th_re + this.C_re[n] * z_n_re - this.C_im[n] * z_n_im;
            th_im = th_im + this.C_im[n] * z_n_re + this.C_re[n] * z_n_im
        }
        for (var i = 0; i < this.iterations; i++) {
            var th_n_re = th_re;
            var th_n_im = th_im;
            var th_n_re1;
            var th_n_im1;
            var num_re = z_re;
            var num_im = z_im;
            for (var n = 2; n <= 6; n++) {
                th_n_re1 = th_n_re * th_re - th_n_im * th_im;
                th_n_im1 = th_n_im * th_re + th_n_re * th_im;
                th_n_re = th_n_re1;
                th_n_im = th_n_im1;
                num_re = num_re + (n - 1) * (this.B_re[n] * th_n_re - this.B_im[n] * th_n_im);
                num_im = num_im + (n - 1) * (this.B_im[n] * th_n_re + this.B_re[n] * th_n_im)
            }
            th_n_re = 1;
            th_n_im = 0;
            var den_re = this.B_re[1];
            var den_im = this.B_im[1];
            for (var n = 2; n <= 6; n++) {
                th_n_re1 = th_n_re * th_re - th_n_im * th_im;
                th_n_im1 = th_n_im * th_re + th_n_re * th_im;
                th_n_re = th_n_re1;
                th_n_im = th_n_im1;
                den_re = den_re + n * (this.B_re[n] * th_n_re - this.B_im[n] * th_n_im);
                den_im = den_im + n * (this.B_im[n] * th_n_re + this.B_re[n] * th_n_im)
            }
            var den2 = den_re * den_re + den_im * den_im;
            th_re = (num_re * den_re + num_im * den_im) / den2;
            th_im = (num_im * den_re - num_re * den_im) / den2
        }
        var d_psi = th_re;
        var d_lambda = th_im;
        var d_psi_n = 1;
        var d_phi = 0;
        for (var n = 1; n <= 9; n++) {
            d_psi_n = d_psi_n * d_psi;
            d_phi = d_phi + this.D[n] * d_psi_n
        }
        var lat = this.lat0 + d_phi * Proj4js.common.SEC_TO_RAD * 1e5;
        var lon = this.long0 + d_lambda;
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.mill = {
    init: function() {},
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var x = this.x0 + this.a * dlon;
        var y = this.y0 + this.a * Math.log(Math.tan(Proj4js.common.PI / 4 + lat / 2.5)) * 1.25;
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var lon = Proj4js.common.adjust_lon(this.long0 + p.x / this.a);
        var lat = 2.5 * (Math.atan(Math.exp(.8 * p.y / this.a)) - Proj4js.common.PI / 4);
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.gnom = {
    init: function(def) {
        this.sin_p14 = Math.sin(this.lat0);
        this.cos_p14 = Math.cos(this.lat0);
        this.infinity_dist = 1e3 * this.a;
        this.rc = 1
    },
    forward: function(p) {
        var sinphi, cosphi;
        var dlon;
        var coslon;
        var ksp;
        var g;
        var x, y;
        var lon = p.x;
        var lat = p.y;
        dlon = Proj4js.common.adjust_lon(lon - this.long0);
        sinphi = Math.sin(lat);
        cosphi = Math.cos(lat);
        coslon = Math.cos(dlon);
        g = this.sin_p14 * sinphi + this.cos_p14 * cosphi * coslon;
        ksp = 1;
        if (g > 0 || Math.abs(g) <= Proj4js.common.EPSLN) {
            x = this.x0 + this.a * ksp * cosphi * Math.sin(dlon) / g;
            y = this.y0 + this.a * ksp * (this.cos_p14 * sinphi - this.sin_p14 * cosphi * coslon) / g
        } else {
            Proj4js.reportError("orthoFwdPointError");
            x = this.x0 + this.infinity_dist * cosphi * Math.sin(dlon);
            y = this.y0 + this.infinity_dist * (this.cos_p14 * sinphi - this.sin_p14 * cosphi * coslon)
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var rh;
        var z;
        var sinc, cosc;
        var c;
        var lon, lat;
        p.x = (p.x - this.x0) / this.a;
        p.y = (p.y - this.y0) / this.a;
        p.x /= this.k0;
        p.y /= this.k0;
        if (rh = Math.sqrt(p.x * p.x + p.y * p.y)) {
            c = Math.atan2(rh, this.rc);
            sinc = Math.sin(c);
            cosc = Math.cos(c);
            lat = Proj4js.common.asinz(cosc * this.sin_p14 + p.y * sinc * this.cos_p14 / rh);
            lon = Math.atan2(p.x * sinc, rh * this.cos_p14 * cosc - p.y * this.sin_p14 * sinc);
            lon = Proj4js.common.adjust_lon(this.long0 + lon)
        } else {
            lat = this.phic0;
            lon = 0
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.sinu = {
    init: function() {
        if (!this.sphere) {
            this.en = Proj4js.common.pj_enfn(this.es)
        } else {
            this.n = 1;
            this.m = 0;
            this.es = 0;
            this.C_y = Math.sqrt((this.m + 1) / this.n);
            this.C_x = this.C_y / (this.m + 1)
        }
    },
    forward: function(p) {
        var x, y, delta_lon;
        var lon = p.x;
        var lat = p.y;
        lon = Proj4js.common.adjust_lon(lon - this.long0);
        if (this.sphere) {
            if (!this.m) {
                lat = this.n != 1 ? Math.asin(this.n * Math.sin(lat)) : lat
            } else {
                var k = this.n * Math.sin(lat);
                for (var i = Proj4js.common.MAX_ITER; i; --i) {
                    var V = (this.m * lat + Math.sin(lat) - k) / (this.m + Math.cos(lat));
                    lat -= V;
                    if (Math.abs(V) < Proj4js.common.EPSLN) break
                }
            }
            x = this.a * this.C_x * lon * (this.m + Math.cos(lat));
            y = this.a * this.C_y * lat
        } else {
            var s = Math.sin(lat);
            var c = Math.cos(lat);
            y = this.a * Proj4js.common.pj_mlfn(lat, s, c, this.en);
            x = this.a * lon * c / Math.sqrt(1 - this.es * s * s)
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var lat, temp, lon;
        p.x -= this.x0;
        p.y -= this.y0;
        lat = p.y / this.a;
        if (this.sphere) {
            p.y /= this.C_y;
            lat = this.m ? Math.asin((this.m * p.y + Math.sin(p.y)) / this.n) : this.n != 1 ? Math.asin(Math.sin(p.y) / this.n) : p.y;
            lon = p.x / (this.C_x * (this.m + Math.cos(p.y)))
        } else {
            lat = Proj4js.common.pj_inv_mlfn(p.y / this.a, this.es, this.en);
            var s = Math.abs(lat);
            if (s < Proj4js.common.HALF_PI) {
                s = Math.sin(lat);
                temp = this.long0 + p.x * Math.sqrt(1 - this.es * s * s) / (this.a * Math.cos(lat));
                lon = Proj4js.common.adjust_lon(temp)
            } else if (s - Proj4js.common.EPSLN < Proj4js.common.HALF_PI) {
                lon = this.long0
            }
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.vandg = {
    init: function() {
        this.R = 6370997
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var x, y;
        if (Math.abs(lat) <= Proj4js.common.EPSLN) {
            x = this.x0 + this.R * dlon;
            y = this.y0
        }
        var theta = Proj4js.common.asinz(2 * Math.abs(lat / Proj4js.common.PI));
        if (Math.abs(dlon) <= Proj4js.common.EPSLN || Math.abs(Math.abs(lat) - Proj4js.common.HALF_PI) <= Proj4js.common.EPSLN) {
            x = this.x0;
            if (lat >= 0) {
                y = this.y0 + Proj4js.common.PI * this.R * Math.tan(.5 * theta)
            } else {
                y = this.y0 + Proj4js.common.PI * this.R * -Math.tan(.5 * theta)
            }
        }
        var al = .5 * Math.abs(Proj4js.common.PI / dlon - dlon / Proj4js.common.PI);
        var asq = al * al;
        var sinth = Math.sin(theta);
        var costh = Math.cos(theta);
        var g = costh / (sinth + costh - 1);
        var gsq = g * g;
        var m = g * (2 / sinth - 1);
        var msq = m * m;
        var con = Proj4js.common.PI * this.R * (al * (g - msq) + Math.sqrt(asq * (g - msq) * (g - msq) - (msq + asq) * (gsq - msq))) / (msq + asq);
        if (dlon < 0) {
            con = -con
        }
        x = this.x0 + con;
        con = Math.abs(con / (Proj4js.common.PI * this.R));
        if (lat >= 0) {
            y = this.y0 + Proj4js.common.PI * this.R * Math.sqrt(1 - con * con - 2 * al * con)
        } else {
            y = this.y0 - Proj4js.common.PI * this.R * Math.sqrt(1 - con * con - 2 * al * con)
        }
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var lon, lat;
        var xx, yy, xys, c1, c2, c3;
        var al, asq;
        var a1;
        var m1;
        var con;
        var th1;
        var d;
        p.x -= this.x0;
        p.y -= this.y0;
        con = Proj4js.common.PI * this.R;
        xx = p.x / con;
        yy = p.y / con;
        xys = xx * xx + yy * yy;
        c1 = -Math.abs(yy) * (1 + xys);
        c2 = c1 - 2 * yy * yy + xx * xx;
        c3 = -2 * c1 + 1 + 2 * yy * yy + xys * xys;
        d = yy * yy / c3 + (2 * c2 * c2 * c2 / c3 / c3 / c3 - 9 * c1 * c2 / c3 / c3) / 27;
        a1 = (c1 - c2 * c2 / 3 / c3) / c3;
        m1 = 2 * Math.sqrt(-a1 / 3);
        con = 3 * d / a1 / m1;
        if (Math.abs(con) > 1) {
            if (con >= 0) {
                con = 1
            } else {
                con = -1
            }
        }
        th1 = Math.acos(con) / 3;
        if (p.y >= 0) {
            lat = (-m1 * Math.cos(th1 + Proj4js.common.PI / 3) - c2 / 3 / c3) * Proj4js.common.PI
        } else {
            lat = -(-m1 * Math.cos(th1 + Proj4js.common.PI / 3) - c2 / 3 / c3) * Proj4js.common.PI
        }
        if (Math.abs(xx) < Proj4js.common.EPSLN) {
            lon = this.long0
        }
        lon = Proj4js.common.adjust_lon(this.long0 + Proj4js.common.PI * (xys - 1 + Math.sqrt(1 + 2 * (xx * xx - yy * yy) + xys * xys)) / 2 / xx);
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.cea = {
    init: function() {},
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var x = this.x0 + this.a * dlon * Math.cos(this.lat_ts);
        var y = this.y0 + this.a * Math.sin(lat) / Math.cos(this.lat_ts);
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var lon = Proj4js.common.adjust_lon(this.long0 + p.x / this.a / Math.cos(this.lat_ts));
        var lat = Math.asin(p.y / this.a * Math.cos(this.lat_ts));
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.eqc = {
    init: function() {
        if (!this.x0) this.x0 = 0;
        if (!this.y0) this.y0 = 0;
        if (!this.lat0) this.lat0 = 0;
        if (!this.long0) this.long0 = 0;
        if (!this.lat_ts) this.lat_ts = 0;
        if (!this.title) this.title = "Equidistant Cylindrical (Plate Carre)";
        this.rc = Math.cos(this.lat_ts)
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var dlat = Proj4js.common.adjust_lat(lat - this.lat0);
        p.x = this.x0 + this.a * dlon * this.rc;
        p.y = this.y0 + this.a * dlat;
        return p
    },
    inverse: function(p) {
        var x = p.x;
        var y = p.y;
        p.x = Proj4js.common.adjust_lon(this.long0 + (x - this.x0) / (this.a * this.rc));
        p.y = Proj4js.common.adjust_lat(this.lat0 + (y - this.y0) / this.a);
        return p
    }
};
Proj4js.Proj.cass = {
    init: function() {
        if (!this.sphere) {
            this.en = Proj4js.common.pj_enfn(this.es);
            this.m0 = Proj4js.common.pj_mlfn(this.lat0, Math.sin(this.lat0), Math.cos(this.lat0), this.en)
        }
    },
    C1: .16666666666666666,
    C2: .008333333333333333,
    C3: .041666666666666664,
    C4: .3333333333333333,
    C5: .06666666666666667,
    forward: function(p) {
        var x, y;
        var lam = p.x;
        var phi = p.y;
        lam = Proj4js.common.adjust_lon(lam - this.long0);
        if (this.sphere) {
            x = Math.asin(Math.cos(phi) * Math.sin(lam));
            y = Math.atan2(Math.tan(phi), Math.cos(lam)) - this.phi0
        } else {
            this.n = Math.sin(phi);
            this.c = Math.cos(phi);
            y = Proj4js.common.pj_mlfn(phi, this.n, this.c, this.en);
            this.n = 1 / Math.sqrt(1 - this.es * this.n * this.n);
            this.tn = Math.tan(phi);
            this.t = this.tn * this.tn;
            this.a1 = lam * this.c;
            this.c *= this.es * this.c / (1 - this.es);
            this.a2 = this.a1 * this.a1;
            x = this.n * this.a1 * (1 - this.a2 * this.t * (this.C1 - (8 - this.t + 8 * this.c) * this.a2 * this.C2));
            y -= this.m0 - this.n * this.tn * this.a2 * (.5 + (5 - this.t + 6 * this.c) * this.a2 * this.C3)
        }
        p.x = this.a * x + this.x0;
        p.y = this.a * y + this.y0;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var x = p.x / this.a;
        var y = p.y / this.a;
        var phi, lam;
        if (this.sphere) {
            this.dd = y + this.lat0;
            phi = Math.asin(Math.sin(this.dd) * Math.cos(x));
            lam = Math.atan2(Math.tan(x), Math.cos(this.dd))
        } else {
            var ph1 = Proj4js.common.pj_inv_mlfn(this.m0 + y, this.es, this.en);
            this.tn = Math.tan(ph1);
            this.t = this.tn * this.tn;
            this.n = Math.sin(ph1);
            this.r = 1 / (1 - this.es * this.n * this.n);
            this.n = Math.sqrt(this.r);
            this.r *= (1 - this.es) * this.n;
            this.dd = x / this.n;
            this.d2 = this.dd * this.dd;
            phi = ph1 - this.n * this.tn / this.r * this.d2 * (.5 - (1 + 3 * this.t) * this.d2 * this.C3);
            lam = this.dd * (1 + this.t * this.d2 * (-this.C4 + (1 + 3 * this.t) * this.d2 * this.C5)) / Math.cos(ph1)
        }
        p.x = Proj4js.common.adjust_lon(this.long0 + lam);
        p.y = phi;
        return p
    }
};
Proj4js.Proj.gauss = {
    init: function() {
        var sphi = Math.sin(this.lat0);
        var cphi = Math.cos(this.lat0);
        cphi *= cphi;
        this.rc = Math.sqrt(1 - this.es) / (1 - this.es * sphi * sphi);
        this.C = Math.sqrt(1 + this.es * cphi * cphi / (1 - this.es));
        this.phic0 = Math.asin(sphi / this.C);
        this.ratexp = .5 * this.C * this.e;
        this.K = Math.tan(.5 * this.phic0 + Proj4js.common.FORTPI) / (Math.pow(Math.tan(.5 * this.lat0 + Proj4js.common.FORTPI), this.C) * Proj4js.common.srat(this.e * sphi, this.ratexp))
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        p.y = 2 * Math.atan(this.K * Math.pow(Math.tan(.5 * lat + Proj4js.common.FORTPI), this.C) * Proj4js.common.srat(this.e * Math.sin(lat), this.ratexp)) - Proj4js.common.HALF_PI;
        p.x = this.C * lon;
        return p
    },
    inverse: function(p) {
        var DEL_TOL = 1e-14;
        var lon = p.x / this.C;
        var lat = p.y;
        var num = Math.pow(Math.tan(.5 * lat + Proj4js.common.FORTPI) / this.K, 1 / this.C);
        for (var i = Proj4js.common.MAX_ITER; i > 0; --i) {
            lat = 2 * Math.atan(num * Proj4js.common.srat(this.e * Math.sin(p.y), -.5 * this.e)) - Proj4js.common.HALF_PI;
            if (Math.abs(lat - p.y) < DEL_TOL) break;
            p.y = lat
        }
        if (!i) {
            Proj4js.reportError("gauss:inverse:convergence failed");
            return null
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.omerc = {
    init: function() {
        if (!this.mode) this.mode = 0;
        if (!this.lon1) {
            this.lon1 = 0;
            this.mode = 1
        }
        if (!this.lon2) this.lon2 = 0;
        if (!this.lat2) this.lat2 = 0;
        var temp = this.b / this.a;
        var es = 1 - Math.pow(temp, 2);
        var e = Math.sqrt(es);
        this.sin_p20 = Math.sin(this.lat0);
        this.cos_p20 = Math.cos(this.lat0);
        this.con = 1 - this.es * this.sin_p20 * this.sin_p20;
        this.com = Math.sqrt(1 - es);
        this.bl = Math.sqrt(1 + this.es * Math.pow(this.cos_p20, 4) / (1 - es));
        this.al = this.a * this.bl * this.k0 * this.com / this.con;
        if (Math.abs(this.lat0) < Proj4js.common.EPSLN) {
            this.ts = 1;
            this.d = 1;
            this.el = 1
        } else {
            this.ts = Proj4js.common.tsfnz(this.e, this.lat0, this.sin_p20);
            this.con = Math.sqrt(this.con);
            this.d = this.bl * this.com / (this.cos_p20 * this.con);
            if (this.d * this.d - 1 > 0) {
                if (this.lat0 >= 0) {
                    this.f = this.d + Math.sqrt(this.d * this.d - 1)
                } else {
                    this.f = this.d - Math.sqrt(this.d * this.d - 1)
                }
            } else {
                this.f = this.d
            }
            this.el = this.f * Math.pow(this.ts, this.bl)
        }
        if (this.mode != 0) {
            this.g = .5 * (this.f - 1 / this.f);
            this.gama = Proj4js.common.asinz(Math.sin(this.alpha) / this.d);
            this.longc = this.longc - Proj4js.common.asinz(this.g * Math.tan(this.gama)) / this.bl;
            this.con = Math.abs(this.lat0);
            if (this.con > Proj4js.common.EPSLN && Math.abs(this.con - Proj4js.common.HALF_PI) > Proj4js.common.EPSLN) {
                this.singam = Math.sin(this.gama);
                this.cosgam = Math.cos(this.gama);
                this.sinaz = Math.sin(this.alpha);
                this.cosaz = Math.cos(this.alpha);
                if (this.lat0 >= 0) {
                    this.u = this.al / this.bl * Math.atan(Math.sqrt(this.d * this.d - 1) / this.cosaz)
                } else {
                    this.u = -(this.al / this.bl) * Math.atan(Math.sqrt(this.d * this.d - 1) / this.cosaz)
                }
            } else {
                Proj4js.reportError("omerc:Init:DataError")
            }
        } else {
            this.sinphi = Math.sin(this.at1);
            this.ts1 = Proj4js.common.tsfnz(this.e, this.lat1, this.sinphi);
            this.sinphi = Math.sin(this.lat2);
            this.ts2 = Proj4js.common.tsfnz(this.e, this.lat2, this.sinphi);
            this.h = Math.pow(this.ts1, this.bl);
            this.l = Math.pow(this.ts2, this.bl);
            this.f = this.el / this.h;
            this.g = .5 * (this.f - 1 / this.f);
            this.j = (this.el * this.el - this.l * this.h) / (this.el * this.el + this.l * this.h);
            this.p = (this.l - this.h) / (this.l + this.h);
            this.dlon = this.lon1 - this.lon2;
            if (this.dlon < -Proj4js.common.PI) this.lon2 = this.lon2 - 2 * Proj4js.common.PI;
            if (this.dlon > Proj4js.common.PI) this.lon2 = this.lon2 + 2 * Proj4js.common.PI;
            this.dlon = this.lon1 - this.lon2;
            this.longc = .5 * (this.lon1 + this.lon2) - Math.atan(this.j * Math.tan(.5 * this.bl * this.dlon) / this.p) / this.bl;
            this.dlon = Proj4js.common.adjust_lon(this.lon1 - this.longc);
            this.gama = Math.atan(Math.sin(this.bl * this.dlon) / this.g);
            this.alpha = Proj4js.common.asinz(this.d * Math.sin(this.gama));
            if (Math.abs(this.lat1 - this.lat2) <= Proj4js.common.EPSLN) {
                Proj4js.reportError("omercInitDataError")
            } else {
                this.con = Math.abs(this.lat1)
            }
            if (this.con <= Proj4js.common.EPSLN || Math.abs(this.con - Proj4js.common.HALF_PI) <= Proj4js.common.EPSLN) {
                Proj4js.reportError("omercInitDataError")
            } else {
                if (Math.abs(Math.abs(this.lat0) - Proj4js.common.HALF_PI) <= Proj4js.common.EPSLN) {
                    Proj4js.reportError("omercInitDataError")
                }
            }
            this.singam = Math.sin(this.gam);
            this.cosgam = Math.cos(this.gam);
            this.sinaz = Math.sin(this.alpha);
            this.cosaz = Math.cos(this.alpha);
            if (this.lat0 >= 0) {
                this.u = this.al / this.bl * Math.atan(Math.sqrt(this.d * this.d - 1) / this.cosaz)
            } else {
                this.u = -(this.al / this.bl) * Math.atan(Math.sqrt(this.d * this.d - 1) / this.cosaz)
            }
        }
    },
    forward: function(p) {
        var theta;
        var sin_phi, cos_phi;
        var b;
        var c, t, tq;
        var con, n, ml;
        var q, us, vl;
        var ul, vs;
        var s;
        var dlon;
        var ts1;
        var lon = p.x;
        var lat = p.y;
        sin_phi = Math.sin(lat);
        dlon = Proj4js.common.adjust_lon(lon - this.longc);
        vl = Math.sin(this.bl * dlon);
        if (Math.abs(Math.abs(lat) - Proj4js.common.HALF_PI) > Proj4js.common.EPSLN) {
            ts1 = Proj4js.common.tsfnz(this.e, lat, sin_phi);
            q = this.el / Math.pow(ts1, this.bl);
            s = .5 * (q - 1 / q);
            t = .5 * (q + 1 / q);
            ul = (s * this.singam - vl * this.cosgam) / t;
            con = Math.cos(this.bl * dlon);
            if (Math.abs(con) < 1e-7) {
                us = this.al * this.bl * dlon
            } else {
                us = this.al * Math.atan((s * this.cosgam + vl * this.singam) / con) / this.bl;
                if (con < 0) us = us + Proj4js.common.PI * this.al / this.bl
            }
        } else {
            if (lat >= 0) {
                ul = this.singam
            } else {
                ul = -this.singam
            }
            us = this.al * lat / this.bl
        }
        if (Math.abs(Math.abs(ul) - 1) <= Proj4js.common.EPSLN) {
            Proj4js.reportError("omercFwdInfinity")
        }
        vs = .5 * this.al * Math.log((1 - ul) / (1 + ul)) / this.bl;
        us = us - this.u;
        var x = this.x0 + vs * this.cosaz + us * this.sinaz;
        var y = this.y0 + us * this.cosaz - vs * this.sinaz;
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var delta_lon;
        var theta;
        var delta_theta;
        var sin_phi, cos_phi;
        var b;
        var c, t, tq;
        var con, n, ml;
        var vs, us, q, s, ts1;
        var vl, ul, bs;
        var lon, lat;
        var flag;
        p.x -= this.x0;
        p.y -= this.y0;
        flag = 0;
        vs = p.x * this.cosaz - p.y * this.sinaz;
        us = p.y * this.cosaz + p.x * this.sinaz;
        us = us + this.u;
        q = Math.exp(-this.bl * vs / this.al);
        s = .5 * (q - 1 / q);
        t = .5 * (q + 1 / q);
        vl = Math.sin(this.bl * us / this.al);
        ul = (vl * this.cosgam + s * this.singam) / t;
        if (Math.abs(Math.abs(ul) - 1) <= Proj4js.common.EPSLN) {
            lon = this.longc;
            if (ul >= 0) {
                lat = Proj4js.common.HALF_PI
            } else {
                lat = -Proj4js.common.HALF_PI
            }
        } else {
            con = 1 / this.bl;
            ts1 = Math.pow(this.el / Math.sqrt((1 + ul) / (1 - ul)), con);
            lat = Proj4js.common.phi2z(this.e, ts1);
            theta = this.longc - Math.atan2(s * this.cosgam - vl * this.singam, con) / this.bl;
            lon = Proj4js.common.adjust_lon(theta)
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.lcc = {
    init: function() {
        if (!this.lat2) {
            this.lat2 = this.lat0
        }
        if (!this.k0) this.k0 = 1;
        if (Math.abs(this.lat1 + this.lat2) < Proj4js.common.EPSLN) {
            Proj4js.reportError("lcc:init: Equal Latitudes");
            return
        }
        var temp = this.b / this.a;
        this.e = Math.sqrt(1 - temp * temp);
        var sin1 = Math.sin(this.lat1);
        var cos1 = Math.cos(this.lat1);
        var ms1 = Proj4js.common.msfnz(this.e, sin1, cos1);
        var ts1 = Proj4js.common.tsfnz(this.e, this.lat1, sin1);
        var sin2 = Math.sin(this.lat2);
        var cos2 = Math.cos(this.lat2);
        var ms2 = Proj4js.common.msfnz(this.e, sin2, cos2);
        var ts2 = Proj4js.common.tsfnz(this.e, this.lat2, sin2);
        var ts0 = Proj4js.common.tsfnz(this.e, this.lat0, Math.sin(this.lat0));
        if (Math.abs(this.lat1 - this.lat2) > Proj4js.common.EPSLN) {
            this.ns = Math.log(ms1 / ms2) / Math.log(ts1 / ts2)
        } else {
            this.ns = sin1
        }
        this.f0 = ms1 / (this.ns * Math.pow(ts1, this.ns));
        this.rh = this.a * this.f0 * Math.pow(ts0, this.ns);
        if (!this.title) this.title = "Lambert Conformal Conic"
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        if (lat <= 90 && lat >= -90 && lon <= 180 && lon >= -180) {} else {
            Proj4js.reportError("lcc:forward: llInputOutOfRange: " + lon + " : " + lat);
            return null
        }
        var con = Math.abs(Math.abs(lat) - Proj4js.common.HALF_PI);
        var ts, rh1;
        if (con > Proj4js.common.EPSLN) {
            ts = Proj4js.common.tsfnz(this.e, lat, Math.sin(lat));
            rh1 = this.a * this.f0 * Math.pow(ts, this.ns)
        } else {
            con = lat * this.ns;
            if (con <= 0) {
                Proj4js.reportError("lcc:forward: No Projection");
                return null
            }
            rh1 = 0
        }
        var theta = this.ns * Proj4js.common.adjust_lon(lon - this.long0);
        p.x = this.k0 * rh1 * Math.sin(theta) + this.x0;
        p.y = this.k0 * (this.rh - rh1 * Math.cos(theta)) + this.y0;
        return p
    },
    inverse: function(p) {
        var rh1, con, ts;
        var lat, lon;
        var x = (p.x - this.x0) / this.k0;
        var y = this.rh - (p.y - this.y0) / this.k0;
        if (this.ns > 0) {
            rh1 = Math.sqrt(x * x + y * y);
            con = 1
        } else {
            rh1 = -Math.sqrt(x * x + y * y);
            con = -1
        }
        var theta = 0;
        if (rh1 != 0) {
            theta = Math.atan2(con * x, con * y)
        }
        if (rh1 != 0 || this.ns > 0) {
            con = 1 / this.ns;
            ts = Math.pow(rh1 / (this.a * this.f0), con);
            lat = Proj4js.common.phi2z(this.e, ts);
            if (lat == -9999) return null
        } else {
            lat = -Proj4js.common.HALF_PI
        }
        lon = Proj4js.common.adjust_lon(theta / this.ns + this.long0);
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.laea = {
    S_POLE: 1,
    N_POLE: 2,
    EQUIT: 3,
    OBLIQ: 4,
    init: function() {
        var t = Math.abs(this.lat0);
        if (Math.abs(t - Proj4js.common.HALF_PI) < Proj4js.common.EPSLN) {
            this.mode = this.lat0 < 0 ? this.S_POLE : this.N_POLE
        } else if (Math.abs(t) < Proj4js.common.EPSLN) {
            this.mode = this.EQUIT
        } else {
            this.mode = this.OBLIQ
        }
        if (this.es > 0) {
            var sinphi;
            this.qp = Proj4js.common.qsfnz(this.e, 1);
            this.mmf = .5 / (1 - this.es);
            this.apa = this.authset(this.es);
            switch (this.mode) {
                case this.N_POLE:
                case this.S_POLE:
                    this.dd = 1;
                    break;
                case this.EQUIT:
                    this.rq = Math.sqrt(.5 * this.qp);
                    this.dd = 1 / this.rq;
                    this.xmf = 1;
                    this.ymf = .5 * this.qp;
                    break;
                case this.OBLIQ:
                    this.rq = Math.sqrt(.5 * this.qp);
                    sinphi = Math.sin(this.lat0);
                    this.sinb1 = Proj4js.common.qsfnz(this.e, sinphi) / this.qp;
                    this.cosb1 = Math.sqrt(1 - this.sinb1 * this.sinb1);
                    this.dd = Math.cos(this.lat0) / (Math.sqrt(1 - this.es * sinphi * sinphi) * this.rq * this.cosb1);
                    this.ymf = (this.xmf = this.rq) / this.dd;
                    this.xmf *= this.dd;
                    break
            }
        } else {
            if (this.mode == this.OBLIQ) {
                this.sinph0 = Math.sin(this.lat0);
                this.cosph0 = Math.cos(this.lat0)
            }
        }
    },
    forward: function(p) {
        var x, y;
        var lam = p.x;
        var phi = p.y;
        lam = Proj4js.common.adjust_lon(lam - this.long0);
        if (this.sphere) {
            var coslam, cosphi, sinphi;
            sinphi = Math.sin(phi);
            cosphi = Math.cos(phi);
            coslam = Math.cos(lam);
            switch (this.mode) {
                case this.OBLIQ:
                case this.EQUIT:
                    y = this.mode == this.EQUIT ? 1 + cosphi * coslam : 1 + this.sinph0 * sinphi + this.cosph0 * cosphi * coslam;
                    if (y <= Proj4js.common.EPSLN) {
                        Proj4js.reportError("laea:fwd:y less than eps");
                        return null
                    }
                    y = Math.sqrt(2 / y);
                    x = y * cosphi * Math.sin(lam);
                    y *= this.mode == this.EQUIT ? sinphi : this.cosph0 * sinphi - this.sinph0 * cosphi * coslam;
                    break;
                case this.N_POLE:
                    coslam = -coslam;
                case this.S_POLE:
                    if (Math.abs(phi + this.phi0) < Proj4js.common.EPSLN) {
                        Proj4js.reportError("laea:fwd:phi < eps");
                        return null
                    }
                    y = Proj4js.common.FORTPI - phi * .5;
                    y = 2 * (this.mode == this.S_POLE ? Math.cos(y) : Math.sin(y));
                    x = y * Math.sin(lam);
                    y *= coslam;
                    break
            }
        } else {
            var coslam, sinlam, sinphi, q, sinb = 0,
                cosb = 0,
                b = 0;
            coslam = Math.cos(lam);
            sinlam = Math.sin(lam);
            sinphi = Math.sin(phi);
            q = Proj4js.common.qsfnz(this.e, sinphi);
            if (this.mode == this.OBLIQ || this.mode == this.EQUIT) {
                sinb = q / this.qp;
                cosb = Math.sqrt(1 - sinb * sinb)
            }
            switch (this.mode) {
                case this.OBLIQ:
                    b = 1 + this.sinb1 * sinb + this.cosb1 * cosb * coslam;
                    break;
                case this.EQUIT:
                    b = 1 + cosb * coslam;
                    break;
                case this.N_POLE:
                    b = Proj4js.common.HALF_PI + phi;
                    q = this.qp - q;
                    break;
                case this.S_POLE:
                    b = phi - Proj4js.common.HALF_PI;
                    q = this.qp + q;
                    break
            }
            if (Math.abs(b) < Proj4js.common.EPSLN) {
                Proj4js.reportError("laea:fwd:b < eps");
                return null
            }
            switch (this.mode) {
                case this.OBLIQ:
                case this.EQUIT:
                    b = Math.sqrt(2 / b);
                    if (this.mode == this.OBLIQ) {
                        y = this.ymf * b * (this.cosb1 * sinb - this.sinb1 * cosb * coslam)
                    } else {
                        y = (b = Math.sqrt(2 / (1 + cosb * coslam))) * sinb * this.ymf
                    }
                    x = this.xmf * b * cosb * sinlam;
                    break;
                case this.N_POLE:
                case this.S_POLE:
                    if (q >= 0) {
                        x = (b = Math.sqrt(q)) * sinlam;
                        y = coslam * (this.mode == this.S_POLE ? b : -b)
                    } else {
                        x = y = 0
                    }
                    break
            }
        }
        p.x = this.a * x + this.x0;
        p.y = this.a * y + this.y0;
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var x = p.x / this.a;
        var y = p.y / this.a;
        var lam, phi;
        if (this.sphere) {
            var cosz = 0,
                rh, sinz = 0;
            rh = Math.sqrt(x * x + y * y);
            phi = rh * .5;
            if (phi > 1) {
                Proj4js.reportError("laea:Inv:DataError");
                return null
            }
            phi = 2 * Math.asin(phi);
            if (this.mode == this.OBLIQ || this.mode == this.EQUIT) {
                sinz = Math.sin(phi);
                cosz = Math.cos(phi)
            }
            switch (this.mode) {
                case this.EQUIT:
                    phi = Math.abs(rh) <= Proj4js.common.EPSLN ? 0 : Math.asin(y * sinz / rh);
                    x *= sinz;
                    y = cosz * rh;
                    break;
                case this.OBLIQ:
                    phi = Math.abs(rh) <= Proj4js.common.EPSLN ? this.phi0 : Math.asin(cosz * this.sinph0 + y * sinz * this.cosph0 / rh);
                    x *= sinz * this.cosph0;
                    y = (cosz - Math.sin(phi) * this.sinph0) * rh;
                    break;
                case this.N_POLE:
                    y = -y;
                    phi = Proj4js.common.HALF_PI - phi;
                    break;
                case this.S_POLE:
                    phi -= Proj4js.common.HALF_PI;
                    break
            }
            lam = y == 0 && (this.mode == this.EQUIT || this.mode == this.OBLIQ) ? 0 : Math.atan2(x, y)
        } else {
            var cCe, sCe, q, rho, ab = 0;
            switch (this.mode) {
                case this.EQUIT:
                case this.OBLIQ:
                    x /= this.dd;
                    y *= this.dd;
                    rho = Math.sqrt(x * x + y * y);
                    if (rho < Proj4js.common.EPSLN) {
                        p.x = 0;
                        p.y = this.phi0;
                        return p
                    }
                    sCe = 2 * Math.asin(.5 * rho / this.rq);
                    cCe = Math.cos(sCe);
                    x *= sCe = Math.sin(sCe);
                    if (this.mode == this.OBLIQ) {
                        ab = cCe * this.sinb1 + y * sCe * this.cosb1 / rho;
                        q = this.qp * ab;
                        y = rho * this.cosb1 * cCe - y * this.sinb1 * sCe
                    } else {
                        ab = y * sCe / rho;
                        q = this.qp * ab;
                        y = rho * cCe
                    }
                    break;
                case this.N_POLE:
                    y = -y;
                case this.S_POLE:
                    q = x * x + y * y;
                    if (!q) {
                        p.x = 0;
                        p.y = this.phi0;
                        return p
                    }
                    ab = 1 - q / this.qp;
                    if (this.mode == this.S_POLE) {
                        ab = -ab
                    }
                    break
            }
            lam = Math.atan2(x, y);
            phi = this.authlat(Math.asin(ab), this.apa)
        }
        p.x = Proj4js.common.adjust_lon(this.long0 + lam);
        p.y = phi;
        return p
    },
    P00: .3333333333333333,
    P01: .17222222222222222,
    P02: .10257936507936508,
    P10: .06388888888888888,
    P11: .0664021164021164,
    P20: .016415012942191543,
    authset: function(es) {
        var t;
        var APA = new Array;
        APA[0] = es * this.P00;
        t = es * es;
        APA[0] += t * this.P01;
        APA[1] = t * this.P10;
        t *= es;
        APA[0] += t * this.P02;
        APA[1] += t * this.P11;
        APA[2] = t * this.P20;
        return APA
    },
    authlat: function(beta, APA) {
        var t = beta + beta;
        return beta + APA[0] * Math.sin(t) + APA[1] * Math.sin(t + t) + APA[2] * Math.sin(t + t + t)
    }
};
Proj4js.Proj.aeqd = {
    init: function() {
        this.sin_p12 = Math.sin(this.lat0);
        this.cos_p12 = Math.cos(this.lat0)
    },
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var ksp;
        var sinphi = Math.sin(p.y);
        var cosphi = Math.cos(p.y);
        var dlon = Proj4js.common.adjust_lon(lon - this.long0);
        var coslon = Math.cos(dlon);
        var g = this.sin_p12 * sinphi + this.cos_p12 * cosphi * coslon;
        if (Math.abs(Math.abs(g) - 1) < Proj4js.common.EPSLN) {
            ksp = 1;
            if (g < 0) {
                Proj4js.reportError("aeqd:Fwd:PointError");
                return
            }
        } else {
            var z = Math.acos(g);
            ksp = z / Math.sin(z)
        }
        p.x = this.x0 + this.a * ksp * cosphi * Math.sin(dlon);
        p.y = this.y0 + this.a * ksp * (this.cos_p12 * sinphi - this.sin_p12 * cosphi * coslon);
        return p
    },
    inverse: function(p) {
        p.x -= this.x0;
        p.y -= this.y0;
        var rh = Math.sqrt(p.x * p.x + p.y * p.y);
        if (rh > 2 * Proj4js.common.HALF_PI * this.a) {
            Proj4js.reportError("aeqdInvDataError");
            return
        }
        var z = rh / this.a;
        var sinz = Math.sin(z);
        var cosz = Math.cos(z);
        var lon = this.long0;
        var lat;
        if (Math.abs(rh) <= Proj4js.common.EPSLN) {
            lat = this.lat0
        } else {
            lat = Proj4js.common.asinz(cosz * this.sin_p12 + p.y * sinz * this.cos_p12 / rh);
            var con = Math.abs(this.lat0) - Proj4js.common.HALF_PI;
            if (Math.abs(con) <= Proj4js.common.EPSLN) {
                if (this.lat0 >= 0) {
                    lon = Proj4js.common.adjust_lon(this.long0 + Math.atan2(p.x, -p.y))
                } else {
                    lon = Proj4js.common.adjust_lon(this.long0 - Math.atan2(-p.x, p.y))
                }
            } else {
                con = cosz - this.sin_p12 * Math.sin(lat);
                if (Math.abs(con) < Proj4js.common.EPSLN && Math.abs(p.x) < Proj4js.common.EPSLN) {} else {
                    var temp = Math.atan2(p.x * sinz * this.cos_p12, con * rh);
                    lon = Proj4js.common.adjust_lon(this.long0 + Math.atan2(p.x * sinz * this.cos_p12, con * rh))
                }
            }
        }
        p.x = lon;
        p.y = lat;
        return p
    }
};
Proj4js.Proj.moll = {
    init: function() {},
    forward: function(p) {
        var lon = p.x;
        var lat = p.y;
        var delta_lon = Proj4js.common.adjust_lon(lon - this.long0);
        var theta = lat;
        var con = Proj4js.common.PI * Math.sin(lat);
        for (var i = 0; true; i++) {
            var delta_theta = -(theta + Math.sin(theta) - con) / (1 + Math.cos(theta));
            theta += delta_theta;
            if (Math.abs(delta_theta) < Proj4js.common.EPSLN) break;
            if (i >= 50) {
                Proj4js.reportError("moll:Fwd:IterationError")
            }
        }
        theta /= 2;
        if (Proj4js.common.PI / 2 - Math.abs(lat) < Proj4js.common.EPSLN) delta_lon = 0;
        var x = .900316316158 * this.a * delta_lon * Math.cos(theta) + this.x0;
        var y = 1.4142135623731 * this.a * Math.sin(theta) + this.y0;
        p.x = x;
        p.y = y;
        return p
    },
    inverse: function(p) {
        var theta;
        var arg;
        p.x -= this.x0;
        var arg = p.y / (1.4142135623731 * this.a);
        if (Math.abs(arg) > .999999999999) arg = .999999999999;
        var theta = Math.asin(arg);
        var lon = Proj4js.common.adjust_lon(this.long0 + p.x / (.900316316158 * this.a * Math.cos(theta)));
        if (lon < -Proj4js.common.PI) lon = -Proj4js.common.PI;
        if (lon > Proj4js.common.PI) lon = Proj4js.common.PI;
        arg = (2 * theta + Math.sin(2 * theta)) / Proj4js.common.PI;
        if (Math.abs(arg) > 1) arg = 1;
        var lat = Math.asin(arg);
        p.x = lon;
        p.y = lat;
        return p
    }
};
L.Proj = {};
L.Proj._isProj4Proj = function(a) {
    return typeof a["projName"] !== "undefined"
};
L.Proj.Projection = L.Class.extend({
    initialize: function(a, def) {
        if (L.Proj._isProj4Proj(a)) {
            this._proj = a
        } else {
            var code = a;
            Proj4js.defs[code] = def;
            this._proj = new Proj4js.Proj(code)
        }
    },
    project: function(latlng) {
        var point = new L.Point(latlng.lng, latlng.lat);
        return Proj4js.transform(Proj4js.WGS84, this._proj, point)
    },
    unproject: function(point, unbounded) {
        var point2 = Proj4js.transform(this._proj, Proj4js.WGS84, point.clone());
        return new L.LatLng(point2.y, point2.x, unbounded)
    }
});
L.Proj.CRS = L.Class.extend({
    includes: L.CRS,
    options: {
        transformation: new L.Transformation(1, 0, -1, 0)
    },
    initialize: function(a, b, c) {
        var code, proj, def, options;
        if (L.Proj._isProj4Proj(a)) {
            proj = a;
            code = proj.srsCode;
            options = b || {};
            this.projection = new L.Proj.Projection(proj)
        } else {
            code = a;
            def = b;
            options = c || {};
            this.projection = new L.Proj.Projection(code, def)
        }
        L.Util.setOptions(this, options);
        this.code = code;
        this.transformation = this.options.transformation;
        if (this.options.origin) {
            this.transformation = new L.Transformation(1, -this.options.origin[0], -1, this.options.origin[1])
        }
        if (this.options.scales) {
            this.scale = function(zoom) {
                return this.options.scales[zoom]
            }
        } else if (this.options.resolutions) {
            this.scale = function(zoom) {
                return 1 / this.options.resolutions[zoom]
            }
        }
    }
});
L.Proj.CRS.TMS = L.Proj.CRS.extend({
    initialize: function(a, b, c, d) {
        if (L.Proj._isProj4Proj(a)) {
            var proj = a,
                projectedBounds = b,
                options = c || {};
            options.origin = [projectedBounds[0], projectedBounds[3]];
            L.Proj.CRS.prototype.initialize(proj, options)
        } else {
            var code = a,
                def = b,
                projectedBounds = c,
                options = d || {};
            options.origin = [projectedBounds[0], projectedBounds[3]];
            L.Proj.CRS.prototype.initialize(code, def, options)
        }
        this.projectedBounds = projectedBounds
    }
});
L.Proj.TileLayer = {};
L.Proj.TileLayer.TMS = L.TileLayer.extend({
    options: {
        tms: true,
        continuousWorld: true
    },
    initialize: function(urlTemplate, crs, options) {
        if (!(crs instanceof L.Proj.CRS.TMS)) {
            throw new Error("CRS is not L.Proj.CRS.TMS.")
        }
        L.TileLayer.prototype.initialize.call(this, urlTemplate, options);
        this.crs = crs;
        for (var i = this.options.minZoom; i < this.options.maxZoom; i++) {
            var gridHeight = (this.crs.projectedBounds[3] - this.crs.projectedBounds[1]) / this._projectedTileSize(i);
            if (Math.abs(gridHeight - Math.round(gridHeight)) > .001) {
                throw new Error("Projected bounds does not match grid at zoom " + i)
            }
        }
    },
    getTileUrl: function(tilePoint) {
        var gridHeight = Math.round((this.crs.projectedBounds[3] - this.crs.projectedBounds[1]) / this._projectedTileSize(this._map.getZoom()));
        return L.Util.template(this._url, L.Util.extend({
            s: this._getSubdomain(tilePoint),
            z: this._getZoomForUrl(),
            x: tilePoint.x,
            y: gridHeight - tilePoint.y - 1
        }, this.options))
    },
    _projectedTileSize: function(zoom) {
        return this.options.tileSize / this.crs.scale(zoom)
    }
});
if (typeof module !== "undefined") module.exports = L.Proj;
if (typeof L !== "undefined" && typeof L.CRS !== "undefined") {
    L.CRS.proj4js = function() {
        return function(code, def, transformation, options) {
            options = options || {};
            if (transformation) options.transformation = transformation;
            return new L.Proj.CRS(code, def, options)
        }
    }()
}(function(window, document, undefined) {
    L.KSP = {};
    L.KSP.Version = {
        builds: ["0.1", "0.1.1", "0.2", "0.3", "0.3.1", "0.4", "0.5", "0.6"],
        current: 7
    };
    L.KSP.Version.KSP = {
        builds: ["0.7.3", "0.8", "0.8.1", "0.8.2", "0.8.3", "0.8.4", "0.8.5", "0.9", "0.10", "0.10.1", "0.11", "0.11.1", "0.12", "0.13", "0.13.1", "0.13.2", "0.13.3", "0.14", "0.14.1", "0.14.2", "0.14.3", "0.14.4", "0.15", "0.15.1", "0.15.2", "0.16", "0.17", "0.17.1", "0.18", "0.18.1", "0.18.2", "0.18.3", "0.18.4", "0.19", "0.19.1", "0.20", "0.20.1", "0.20.2", "0.21", "0.21.1", "0.22.0"],
        current: 40
    };
    L.KSP.CRS = {};
    L.KSP.CRS.EPSG4326 = new L.Proj.CRS.TMS(new Proj4js.Proj("EPSG:4326"), [-180, -90, 180, 90], {
        resolutions: [.703125, .3515625, .17578125, .087890625, .0439453125, .02197265625]
    });
    L.KSP.CelestialBody = L.Class.extend({
        initialize: function(data) {
            if (!data.hasOwnProperty("id")) {
                throw new Error("must specify id")
            }
            if (!data.hasOwnProperty("name")) {
                throw new Error("must specify name")
            }
            if (!data.hasOwnProperty("crs")) {
                this.crs = L.KSP.CRS.EPSG4326
            } else if (!(data.crs instanceof L.Proj.CRS.TMS)) {
                throw new Error("crs is not an instance of L.Proj.CRS.TMS")
            }
            if (!data.hasOwnProperty("radius")) {
                this.radius = 1
            }
            if (!data.hasOwnProperty("thumbnail")) {
                this.thumbnail = "http://static.kerbalmaps.com/images/body-unknown.png"
            }
            if (!data.hasOwnProperty("baseLayers")) {
                this.baseLayers = {}
            }
            L.Util.extend(this, data)
        },
        addTo: function(map) {
            var oldBody = map._body,
                layer;
            map._body = this;
            map.fire("bodychangestart", {
                body: this,
                oldBody: oldBody
            });
            if (oldBody) {
                for (layer in oldBody.baseLayers) {
                    if (oldBody.baseLayers.hasOwnProperty(layer)) {
                        map.removeLayer(oldBody.baseLayers[layer])
                    }
                }
                for (layer in oldBody.overlays) {
                    if (oldBody.overlays.hasOwnProperty(layer)) {
                        map.removeLayer(oldBody.overlays[layer])
                    }
                }
                for (layer in oldBody.grids) {
                    if (oldBody.grids.hasOwnProperty(layer)) {
                        map.removeLayer(oldBody.grids[layer])
                    }
                }
            }
            var baseLayer = this.defaultLayer || this.baseLayers.Satellite;
            if (baseLayer) {
                for (layer in this.baseLayers) {
                    if (this.baseLayers.hasOwnProperty(layer) && this.baseLayers[layer]._type === map.options.baseLayerType) {
                        baseLayer = this.baseLayers[layer];
                        break
                    }
                }
                map.addLayer(baseLayer);
                map.fire("baselayerchange", {
                    layer: baseLayer
                })
            }
            for (layer in this.overlays) {
                if (this.overlays.hasOwnProperty(layer) && map.options.overlayTypes.indexOf(this.overlays[layer]._type) >= 0) {
                    map.addLayer(this.overlays[layer]);
                    map.fire("layeradd", {
                        layer: this.overlays[layer]
                    })
                }
            }
            map.fire("bodychangeend", {
                body: this,
                oldBody: oldBody
            });
            for (layer in this.grids) {
                if (this.grids.hasOwnProperty(layer)) {
                    map.addLayer(this.grids[layer]);
                    map.fire("layeradd", {
                        layer: this.grids[layer]
                    })
                }
            }
        },
        onAdd: function(map) {
            this.addTo(map)
        },
        removeFrom: function(map) {
            L.KSP.CelestialBody.DUMMY.addTo(map)
        },
        onRemove: function(map) {
            this.removeFrom(map)
        }
    });
    L.KSP.celestialBody = function(data) {
        return new L.KSP.CelestialBody(data)
    };
    L.KSP.CelestialBody.DUMMY = L.KSP.celestialBody({
        id: "",
        name: "",
        crs: L.KSP.CRS.EPSG4326
    });
    L.KSP.CelestialBody.DEFAULT = L.KSP.CelestialBody.DUMMY;
    L.KSP.CelestialBody.ALL_PLANETARY = [L.KSP.CelestialBody.DUMMY];
    L.KSP.Control = L.KSP.control = {};
    L.KSP.Map = L.Map.extend({
        options: {
            crs: L.KSP.CRS.EPSG4326,
            continuousWorld: true,
            layers: [L.KSP.CelestialBody.DEFAULT],
            baseLayerType: 0,
            overlayTypes: []
        },
        initialize: function(id, options) {
            L.Util.setOptions(this, options);
            this.startTrackingLayerState();
            this.on("bodychangestart", this._onBodyChangeStart).on("bodychangeend", this._onBodyChangeEnd);
            L.Map.prototype.initialize.call(this, id, this.options)
        },
        clampZoom: function() {
            var zoom = this.getZoom(),
                minZoom = this.getMinZoom(),
                maxZoom = this.getMaxZoom();
            if (zoom < minZoom) {
                this.setZoom(minZoom)
            } else if (zoom > maxZoom) {
                this.setZoom(maxZoom)
            } else {
                this.fire("zoomend", this)
            }
        },
        _onBodyChangeStart: function() {
            this.stopTrackingLayerState()
        },
        _onBodyChangeEnd: function() {
            this.clampZoom();
            this.startTrackingLayerState()
        },
        _onLayerStateChange: function(e) {
            if (e.type === "layeradd") {
                if (e.layer instanceof L.KSP.TileLayer) {
                    this.options.baseLayerType = e.layer._type
                } else if (e.layer instanceof L.KSP.LayerGroup) {
                    if (this.options.overlayTypes.indexOf(e.layer._type) < 0) {
                        this.options.overlayTypes.push(e.layer._type)
                    }
                }
            } else {
                if (e.layer instanceof L.KSP.LayerGroup) {
                    var type = e.layer._type,
                        types = this.options.overlayTypes,
                        i, v;
                    for (i = types.length - 1; i >= 0; i--) {
                        v = types[i];
                        if (v === type) {
                            types.splice(i, 1)
                        }
                    }
                }
            }
        },
        startTrackingLayerState: function() {
            this.on("layeradd", this._onLayerStateChange).on("layerremove", this._onLayerStateChange)
        },
        stopTrackingLayerState: function() {
            this.off("layeradd", this._onLayerStateChange).off("layerremove", this._onLayerStateChange)
        },
        eachLayer: function(method, context) {
            for (var i in this._layers) {
                if (this._layers.hasOwnProperty(i)) {
                    method.call(context, this._layers[i])
                }
            }
            return this
        }
    });
    L.KSP.map = function(id, options) {
        return new L.KSP.Map(id, options)
    };
    L.KSP.TileLayer = L.Proj.TileLayer.TMS.extend({
        statics: {
            TYPE_SATELLITE: 0,
            TYPE_COLORRELIEF: 1,
            TYPE_SLOPE: 2,
            TYPE_BIOME: 3,
            DEFAULT_URL: "http://tiles.kerbalmaps.com/{body}/{style}/{z}/{x}/{y}.png"
        },
        options: {
            continuousWorld: false,
            noWrap: false,
            minZoom: 0,
            maxZoom: 5,
            attribution: "Map data &copy; Joel Pedraza"
        },
        initialize: function(type, url, crs, options) {
            L.Util.setOptions(this, options);
            this._type = type;
            L.Proj.TileLayer.TMS.prototype.initialize.call(this, url, crs, this.options)
        }
    });
    L.KSP.tileLayer = function(type, url, crs, options) {
        return new L.KSP.TileLayer(type, url, crs, options)
    };
    L.KSP.LayerGroup = L.LayerGroup.extend({
        statics: {
            TYPE_SPACECENTER: 0,
            TYPE_ANOMALY: 1,
            TYPE_POI: 3
        },
        initialize: function(type, layers) {
            this._type = type;
            L.LayerGroup.prototype.initialize.call(this, layers)
        }
    });
    L.KSP.layerGroup = function(type, layers) {
        return new L.KSP.LayerGroup(type, layers)
    };
    L.KSP.Icon = {};
    L.KSP.Icon.SPACECENTER = new L.Icon({
        iconUrl: "http://static.kerbalmaps.com/images/markers-spacecenter.png",
        shadowUrl: "http://static.kerbalmaps.com/images/markers-shadow.png",
        iconSize: [30, 40],
        shadowSize: [35, 16],
        iconAnchor: [15, 40],
        shadowAnchor: [10, 12],
        popupAnchor: [0, -35]
    });
    L.KSP.Icon.ANOMALY = new L.Icon({
        iconUrl: "http://static.kerbalmaps.com/images/markers-anomaly.png",
        shadowUrl: "http://static.kerbalmaps.com/images/markers-shadow.png",
        iconSize: [30, 40],
        shadowSize: [35, 16],
        iconAnchor: [15, 40],
        shadowAnchor: [10, 12],
        popupAnchor: [0, -35]
    });
    L.KSP.Icon.HIGH = new L.Icon({
        iconUrl: "http://static.kerbalmaps.com/images/markers-high.png",
        shadowUrl: "http://static.kerbalmaps.com/images/markers-shadow.png",
        iconSize: [30, 40],
        shadowSize: [35, 16],
        iconAnchor: [15, 40],
        shadowAnchor: [10, 12],
        popupAnchor: [0, -35]
    });
    L.KSP.Icon.LOW = new L.Icon({
        iconUrl: "http://static.kerbalmaps.com/images/markers-low.png",
        shadowUrl: "http://static.kerbalmaps.com/images/markers-shadow.png",
        iconSize: [30, 40],
        shadowSize: [35, 16],
        iconAnchor: [15, 40],
        shadowAnchor: [10, 12],
        popupAnchor: [0, -35]
    });
    L.KSP.Legend = {};
    L.KSP.Legend.SLOPE = {
        "&ge; 60&deg;": "#E19678",
        "&lt; 60&deg;": "#C86464",
        "&lt; 30&deg;": "#965A64",
        "&lt; 15&deg;": "#645064",
        "&lt; 5&deg;": "#325064",
        "0&deg;": "#32465A"
    };
    L.Util.Json = window.JSON;
    if (typeof L.Util.Json !== "object") {
        L.Util.Json = {}
    }(function() {
        "use strict";

        function f(n) {
            return n < 10 ? "0" + n : n
        }
        if (typeof Date.prototype.toJSON !== "function") {
            Date.prototype.toJSON = function() {
                return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null
            };
            String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function() {
                return this.valueOf()
            }
        }
        var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
            escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
            gap, indent, meta = {
                "\b": "\\b",
                "	": "\\t",
                "\n": "\\n",
                "\f": "\\f",
                "\r": "\\r",
                '"': '\\"',
                "\\": "\\\\"
            },
            rep;

        function quote(string) {
            escapable.lastIndex = 0;
            return escapable.test(string) ? '"' + string.replace(escapable, function(a) {
                var c = meta[a];
                return typeof c === "string" ? c : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
            }) + '"' : '"' + string + '"'
        }

        function str(key, holder) {
            var i, k, v, length, mind = gap,
                partial, value = holder[key];
            if (value && typeof value === "object" && typeof value.toJSON === "function") {
                value = value.toJSON(key)
            }
            if (typeof rep === "function") {
                value = rep.call(holder, key, value)
            }
            switch (typeof value) {
                case "string":
                    return quote(value);
                case "number":
                    return isFinite(value) ? String(value) : "null";
                case "boolean":
                case "null":
                    return String(value);
                case "object":
                    if (!value) {
                        return "null"
                    }
                    gap += indent;
                    partial = [];
                    if (Object.prototype.toString.apply(value) === "[object Array]") {
                        length = value.length;
                        for (i = 0; i < length; i += 1) {
                            partial[i] = str(i, value) || "null"
                        }
                        v = partial.length === 0 ? "[]" : gap ? "[\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "]" : "[" + partial.join(",") + "]";
                        gap = mind;
                        return v
                    }
                    if (rep && typeof rep === "object") {
                        length = rep.length;
                        for (i = 0; i < length; i += 1) {
                            if (typeof rep[i] === "string") {
                                k = rep[i];
                                v = str(k, value);
                                if (v) {
                                    partial.push(quote(k) + (gap ? ": " : ":") + v)
                                }
                            }
                        }
                    } else {
                        for (k in value) {
                            if (Object.prototype.hasOwnProperty.call(value, k)) {
                                v = str(k, value);
                                if (v) {
                                    partial.push(quote(k) + (gap ? ": " : ":") + v)
                                }
                            }
                        }
                    }
                    v = partial.length === 0 ? "{}" : gap ? "{\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "}" : "{" + partial.join(",") + "}";
                    gap = mind;
                    return v
            }
        }
        if (typeof L.Util.Json.stringify !== "function") {
            L.Util.Json.stringify = function(value, replacer, space) {
                var i;
                gap = "";
                indent = "";
                if (typeof space === "number") {
                    for (i = 0; i < space; i += 1) {
                        indent += " "
                    }
                } else if (typeof space === "string") {
                    indent = space
                }
                rep = replacer;
                if (replacer && typeof replacer !== "function" && (typeof replacer !== "object" || typeof replacer.length !== "number")) {
                    throw new Error("JSON.stringify")
                }
                return str("", {
                    "": value
                })
            }
        }
        if (typeof L.Util.Json.parse !== "function") {
            L.Util.Json.parse = function(text, reviver) {
                var j;

                function walk(holder, key) {
                    var k, v, value = holder[key];
                    if (value && typeof value === "object") {
                        for (k in value) {
                            if (Object.prototype.hasOwnProperty.call(value, k)) {
                                v = walk(value, k);
                                if (v !== undefined) {
                                    value[k] = v
                                } else {
                                    delete value[k]
                                }
                            }
                        }
                    }
                    return reviver.call(holder, key, value)
                }
                text = String(text);
                cx.lastIndex = 0;
                if (cx.test(text)) {
                    text = text.replace(cx, function(a) {
                        return "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4)
                    })
                }
                if (/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) {
                    j = eval("(" + text + ")");
                    return typeof reviver === "function" ? walk({
                        "": j
                    }, "") : j
                }
                throw new SyntaxError("JSON.parse")
            }
        }
    })();
    L.Util.XmlHttpRequest = function() {
        if (window.XMLHttpRequest) {
            return new XMLHttpRequest
        } else {
            return new ActiveXObject("Microsoft.XMLHTTP")
        }
    };
    L.Util.AJAX_XML = 0;
    L.Util.AJAX_JSON = 1;
    L.Util.ajax = function(url, type, cb) {
        var parser, response, request = new L.Util.XmlHttpRequest;
        if (type === L.Util.AJAX_XML) {
            throw new Error("XML parser not yet implemented")
        } else if (type === L.Util.AJAX_JSON) {
            parser = L.Util.Json
        } else {
            throw new Error("Invalid parser type")
        }
        request.open("GET", url);
        request.onreadystatechange = function() {
            if (request.readyState === 4 && request.status === 200) {
                response = parser.parse(request.responseText);
                cb(response)
            }
        };
        request.send()
    };
    L.UtfGrid = L.Class.extend({
        includes: L.Mixin.Events,
        options: {
            subdomains: "abc",
            minZoom: 0,
            maxZoom: 18,
            tileSize: 256,
            resolution: 4,
            useJsonP: true,
            pointerCursor: true
        },
        _mouseOn: null,
        initialize: function(url, options) {
            L.Util.setOptions(this, options);
            this._url = url;
            this._cache = {};
            var i = 0;
            while (window["lu" + i]) {
                i++
            }
            this._windowKey = "lu" + i;
            window[this._windowKey] = {};
            var subdomains = this.options.subdomains;
            if (typeof this.options.subdomains === "string") {
                this.options.subdomains = subdomains.split("")
            }
        },
        onAdd: function(map) {
            this._map = map;
            this._container = this._map._container;
            this._update();
            var zoom = this._map.getZoom();
            if (zoom > this.options.maxZoom || zoom < this.options.minZoom) {
                return
            }
            map.on("click", this._click, this);
            map.on("mousemove", this._move, this);
            map.on("moveend", this._update, this)
        },
        onRemove: function() {
            var map = this._map;
            this._mouseOn = null;
            map.off("click", this._click, this);
            map.off("mousemove", this._move, this);
            map.off("moveend", this._update, this)
        },
        _click: function(e) {
            this.fire("click", this._objectForEvent(e))
        },
        _move: function(e) {
            var on = this._objectForEvent(e);
            if (on.data !== this._mouseOn) {
                if (this._mouseOn) {
                    this.fire("mouseout", {
                        latlng: e.latlng,
                        data: this._mouseOn
                    });
                    if (this.options.pointerCursor) {
                        this._container.style.cursor = ""
                    }
                }
                this.fire("mouseover", on);
                if (this.options.pointerCursor) {
                    this._container.style.cursor = "pointer"
                }
                this._mouseOn = on.data
            }
            this.fire("mousemove", on)
        },
        _objectForEvent: function(e) {
            var map = this._map,
                point = map.project(e.latlng),
                tileSize = this.options.tileSize,
                resolution = this.options.resolution,
                x = Math.floor(point.x / tileSize),
                y = Math.floor(point.y / tileSize),
                gridX = Math.floor((point.x - x * tileSize) / resolution),
                gridY = Math.floor((point.y - y * tileSize) / resolution),
                maxY = tileSize * Math.pow(2, map.getZoom()) / tileSize,
                maxX = maxY * 2;
            if (x >= maxX || x < 0 || y >= maxY || y < 0) {
                return {
                    latlng: e.latlng,
                    data: null
                }
            }
            var data = this._cache[map.getZoom() + "_" + x + "_" + y];
            if (!data) {
                return {
                    latlng: e.latlng,
                    data: null
                }
            }
            var idx = this._utfDecode(data.grid[gridY].charCodeAt(gridX)),
                key = data.keys[idx],
                result = data.data[key];
            if (!data.data.hasOwnProperty(key)) {
                result = key
            }
            return {
                latlng: e.latlng,
                data: result
            }
        },
        _update: function() {
            var bounds = this._map.getPixelBounds(),
                zoom = this._map.getZoom(),
                tileSize = this.options.tileSize;
            if (zoom > this.options.maxZoom || zoom < this.options.minZoom) {
                return
            }
            var nwTilePoint = new L.Point(Math.floor(bounds.min.x / tileSize), Math.floor(bounds.min.y / tileSize)),
                seTilePoint = new L.Point(Math.floor(bounds.max.x / tileSize), Math.floor(bounds.max.y / tileSize)),
                maxY = tileSize * Math.pow(2, this._map.getZoom()) / tileSize,
                maxX = maxY * 2;
            for (var x = nwTilePoint.x; x <= seTilePoint.x; x++) {
                for (var y = nwTilePoint.y; y <= seTilePoint.y; y++) {
                    var xw = (x + maxX) % maxX,
                        yw = (y + maxY) % maxY;
                    var key = zoom + "_" + xw + "_" + yw;
                    if (!this._cache.hasOwnProperty(key)) {
                        this._cache[key] = null;
                        if (this.options.useJsonP) {
                            this._loadTileP(zoom, xw, yw)
                        } else {
                            this._loadTile(zoom, xw, yw)
                        }
                    }
                }
            }
        },
        _loadTileP: function(zoom, x, y) {
            var head = document.getElementsByTagName("head")[0],
                key = zoom + "_" + x + "_" + y,
                functionName = "lu_" + key,
                wk = this._windowKey,
                self = this;
            var url = L.Util.template(this._url, L.Util.extend({
                s: L.TileLayer.prototype._getSubdomain.call(this, {
                    x: x,
                    y: y
                }),
                z: zoom,
                x: x,
                y: y,
                cb: wk + "." + functionName
            }, this.options));
            var script = document.createElement("script");
            script.setAttribute("type", "text/javascript");
            script.setAttribute("src", url);
            window[wk][functionName] = function(data) {
                self._cache[key] = data;
                delete window[wk][functionName];
                head.removeChild(script)
            };
            head.appendChild(script)
        },
        _loadTile: function(zoom, x, y) {
            var url = L.Util.template(this._url, L.Util.extend({
                s: L.TileLayer.prototype._getSubdomain.call(this, {
                    x: x,
                    y: y
                }),
                z: zoom,
                x: x,
                y: y
            }, this.options));
            var key = zoom + "_" + x + "_" + y,
                self = this,
                map = this._map;
            map.fire("dataloading");
            L.Util.ajax(url, L.Util.AJAX_JSON, function(data) {
                self._cache[key] = data;
                map.fire("dataload")
            })
        },
        _utfDecode: function(c) {
            if (c >= 93) {
                c--
            }
            if (c >= 35) {
                c--
            }
            return c - 32
        }
    });
    L.utfGrid = function(url, options) {
        return new L.UtfGrid(url, options)
    };
    L.KSP.UtfGrid = L.UtfGrid.extend({
        statics: {
            TYPE_ELEVATION: 0,
            TYPE_SLOPE: 1,
            TYPE_BIOME: 2,
            DEFAULT_URL: "http://static.kerbalmaps.com/{body}/{style}/{z}/{x}/{y}.json"
        },
        options: {
            resolution: 2,
            useJsonP: false,
            pointerCursor: false
        },
        initialize: function(type, url, options) {
            L.Util.setOptions(this, options);
            this._type = type;
            L.UtfGrid.prototype.initialize.call(this, url, this.options)
        },
        onAdd: function(map) {
            L.UtfGrid.prototype.onAdd.call(this, map);
            this.on("mouseover", this._onMouseOver, this)
        },
        onRemove: function() {
            L.UtfGrid.prototype.onRemove.call(this);
            this._mouseOn = null;
            this.off("mouseover", this._onMouseOver)
        },
        _onMouseOver: function(e) {
            this._map.fire(this.options.style + "over", e)
        }
    });
    L.KSP.utfGrid = function(type, url, options) {
        return new L.KSP.UtfGrid(type, url, options)
    };
    L.KSP.Control.Legend = L.Control.extend({
        options: {
            position: "bottomright"
        },
        onAdd: function(map) {
            this._container = L.DomUtil.create("div", "leaflet-control-legend");
            map.on("baselayerchange", this._onLayerChange, this);
            return this._container
        },
        _update: function(legend) {
            this._container.innerHTML = "";
            if (legend) {
                for (var entry in legend) {
                    if (legend.hasOwnProperty(entry)) {
                        this._container.innerHTML += '<i style="background-color: ' + legend[entry] + ';"></i>' + entry + "<br>"
                    }
                }
                L.DomUtil.addClass(this._container, "leaflet-control-legend-visible")
            } else {
                this._container.className = this._container.className.replace(" leaflet-control-legend-visible", "")
            }
        },
        _onLayerChange: function(e) {
            this._update(e.layer.options.legend)
        }
    });
    L.Map.mergeOptions({
        legendControl: true
    });
    L.Map.addInitHook(function() {
        if (this.options.bodyControl) {
            this.legendControl = new L.KSP.Control.Legend;
            this.addControl(this.legendControl)
        }
    });
    L.control.legend = function(map) {
        return new L.KSP.Control.Legend(map)
    };
    L.KSP.Control.Scale = L.Control.Scale.extend({
        options: {
            imperial: false
        },
        onAdd: function(map) {
            this._radius = 0;
            if (map._body) {
                this._radius = map._body.radius
            }
            var container = L.Control.Scale.prototype.onAdd.call(this, map);
            map.on("bodychangeend", this._onBodyChangeEnd, this);
            return container
        },
        onRemove: function(map) {
            L.Control.Scale.prototype.onRemove.call(this, map);
            map.off("bodychangeend", this._onBodyChangeEnd)
        },
        _onBodyChangeEnd: function(e) {
            this._radius = e.body.radius;
            this._update()
        },
        _update: function() {
            var bounds = this._map.getBounds(),
                centerLat = bounds.getCenter().lat,
                halfWorldMeters = this._radius * Math.PI * Math.cos(centerLat * Math.PI / 180),
                dist = halfWorldMeters * (bounds.getNorthEast().lng - bounds.getSouthWest().lng) / 180,
                size = this._map.getSize(),
                options = this.options,
                maxMeters = 0;
            if (size.x > 0) {
                maxMeters = dist * (options.maxWidth / size.x)
            }
            this._updateScales(options, maxMeters)
        }
    });
    L.KSP.Map.mergeOptions({
        scaleControl: false
    });
    L.KSP.Map.addInitHook(function() {
        if (this.options.scaleControl) {
            this.scaleControl = new L.KSP.Control.Scale;
            this.addControl(this.scaleControl)
        }
    });
    L.KSP.control.scale = function(options) {
        return new L.KSP.Control.Scale(options)
    };
    L.KSP.Control.CelestialBody = L.Control.extend({
        options: {
            position: "topright",
            collapsed: true
        },
        initialize: function(bodies, options) {
            L.Util.setOptions(this, options);
            this._bodies = bodies;
            this._timeInMillis = (new Date).valueOf();
            this._weekInMillis = 6048e5
        },
        onAdd: function() {
            this._initLayout();
            this._update();
            this._map.on("bodychangeend", this._update, this);
            return this._container
        },
        _initLayout: function() {
            var className = "leaflet-control-celestialbodies",
                container = this._container = L.DomUtil.create("div", className),
                bodies = this._bodies;
            if (this.options.collapsed) {
                L.DomEvent.on(container, "mouseover", this._expand, this).on(container, "mouseout", this._collapse, this);
                var link = this._bodiesLink = L.DomUtil.create("a", className + "-toggle", container);
                link.href = "#";
                link.title = "Celestial Bodies";
                L.DomEvent.on(link, "focus", this._expand, this);
                this._map.on("movestart", this._collapse, this)
            }
            var list = this._list = L.DomUtil.create("ul", className + "-list", container);
            for (var body in bodies) {
                if (bodies.hasOwnProperty(body)) {
                    var planetItem = this._addBody(bodies[body], list);
                    if (bodies[body].children) {
                        var satelliteList = document.createElement("ul");
                        for (var satellite in bodies[body].children) {
                            if (bodies[body].children.hasOwnProperty(satellite)) {
                                this._addBody(bodies[body].children[satellite], satelliteList)
                            }
                        }
                        planetItem.appendChild(satelliteList)
                    }
                }
            }
        },
        _update: function() {
            if (this._map._body) {
                this._bodiesLink.style.backgroundImage = 'url("' + this._map._body.thumbnail + '")'
            }
        },
        _addBody: function(body, list) {
            var bodyItem = document.createElement("li"),
                thumbnail = document.createElement("img"),
                flag;
            thumbnail.src = body.thumbnail;
            thumbnail.alt = bodyItem.title = body.name;
            if (body.addedOn) {
                if (this._timeInMillis - body.addedOn < this._weekInMillis) {
                    flag = L.DomUtil.create("h2", "leaflet-control-celestialbodies-flag leaflet-control-celestialbodies-flag-orange", bodyItem);
                    flag.innerHTML = "new"
                } else if (this._timeInMillis - body.lastUpdated < this._weekInMillis) {
                    flag = L.DomUtil.create("h2", "leaflet-control-celestialbodies-flag", bodyItem);
                    flag.innerHTML = "update"
                }
                var link = document.createElement("a");
                link.href = "#";
                var stop = L.DomEvent.stopPropagation;
                L.DomEvent.on(link, "click", stop).on(link, "mousedown", stop).on(link, "dblclick", stop).on(link, "click", L.DomEvent.preventDefault).on(link, "click", function() {
                    body.addTo(this._map);
                    return false
                }, this);
                link.appendChild(thumbnail);
                bodyItem.appendChild(link)
            } else {
                L.DomUtil.addClass(thumbnail, "disabled");
                bodyItem.appendChild(thumbnail)
            }
            list.appendChild(bodyItem);
            return bodyItem
        },
        _expand: function() {
            L.DomUtil.addClass(this._container, "leaflet-control-celestialbodies-expanded")
        },
        _collapse: function() {
            this._container.className = this._container.className.replace(" leaflet-control-celestialbodies-expanded", "")
        }
    });
    L.KSP.Map.mergeOptions({
        bodyControl: true
    });
    L.KSP.Map.addInitHook(function() {
        if (this.options.bodyControl) {
            this.bodyControl = new L.KSP.Control.CelestialBody(L.KSP.CelestialBody.ALL_PLANETARY);
            this.addControl(this.bodyControl)
        }
    });
    L.KSP.control.celestialBody = function(bodies, options) {
        return new L.KSP.Control.CelestialBody(bodies, options)
    };
    L.KSP.Control.Layers = L.Control.Layers.extend({
        onAdd: function(map) {
            var container = L.Control.Layers.prototype.onAdd.call(this, map);
            if (map._body) {
                this.addBody(map._body)
            }
            map.on("bodychangestart", this._onBodyChangeStart, this);
            return container
        },
        onRemove: function(map) {
            L.Control.Layers.prototype.onRemove.call(this, map);
            map.off("bodychangestart", this._onBodyChangeStart)
        },
        addBody: function(body) {
            var layer;
            for (layer in body.baseLayers) {
                if (body.baseLayers.hasOwnProperty(layer)) {
                    this.addBaseLayer(body.baseLayers[layer], layer)
                }
            }
            for (layer in body.overlays) {
                if (body.overlays.hasOwnProperty(layer)) {
                    this.addOverlay(body.overlays[layer], layer)
                }
            }
        },
        removeBody: function(body) {
            var layer;
            for (layer in body.baseLayers) {
                if (body.baseLayers.hasOwnProperty(layer)) {
                    this.removeLayer(body.baseLayers[layer], layer)
                }
            }
            for (layer in body.overlays) {
                if (body.overlays.hasOwnProperty(layer)) {
                    this.removeLayer(body.overlays[layer], layer)
                }
            }
        },
        _onBodyChangeStart: function(e) {
            if (e.oldBody) {
                this.removeBody(e.oldBody)
            }
            this.addBody(e.body)
        }
    });
    L.KSP.Map.mergeOptions({
        layersControl: true
    });
    L.KSP.Map.addInitHook(function() {
        if (this.options.layersControl) {
            this.layersControl = new L.KSP.Control.Layers;
            this.addControl(this.layersControl)
        }
    });
    L.KSP.control.layers = function(baseLayers, overlays, options) {
        return new L.KSP.Control.Layers(baseLayers, overlays, options)
    };
    L.KSP.Control.Info = L.Control.extend({
        options: {
            position: "bottomleft",
            dms: false
        },
        _decFormatter: function(latlng) {
            return latlng.lat.toFixed(4) + "<br>" + latlng.lng.toFixed(4)
        },
        _dmsFormatter: function(latlng) {
            function decToDMS(coord) {
                var dms = "<td>" + (coord | 0) + "&deg; </td>";
                coord = (coord - (coord | 0)) * 60;
                dms += "<td>" + (coord | 0) + "&#39; </td>";
                coord = coord % 1 * 60;
                dms += "<td>" + Math.round(coord) + "&quot;</td>";
                return dms
            }
            return "<table><tr>" + decToDMS(Math.abs(latlng.lat)) + "<td>" + (latlng.lat >= 0 ? " N" : " S") + "</td>" + "</tr><tr>" + decToDMS(Math.abs(latlng.lng)) + "<td>" + (latlng.lng >= 0 ? " E" : " W") + "</td>" + "</tr></table>"
        },
        onAdd: function(map) {
            var self = this;
            this._container = L.DomUtil.create("div", "leaflet-control-info leaflet-control-info-visible");
            this._position = L.DomUtil.create("div", "latlng", this._container);
            L.DomUtil.create("br", null, this._container);
            this._position.innerHTML = "Unavailable<br>Unavailable";
            this._position.onclick = function() {
                self._togglePositionFormat()
            };
            this._reset();
            map.on("bodychangeend", this._reset, this);
            map.on("mousemove", this._onMouseMove, this);
            return this._container
        },
        onRemove: function(map) {
            map.off("bodychangeend", this._reset);
            map.off("mousemove", this._onMouseMove)
        },
        _onMouseMove: function(e) {
            this._latlng = e.latlng;
            this._updatePosition()
        },
        _updatePosition: function() {
            this._position.innerHTML = this.options.dms ? this._dmsFormatter(this._latlng) : this._decFormatter(this._latlng)
        },
        _togglePositionFormat: function() {
            this.options.dms = !this.options.dms;
            this._updatePosition()
        },
        _reset: function() {
        }
    });
    L.Map.mergeOptions({
        infoControl: true
    });
    L.Map.addInitHook(function() {
        if (this.options.infoControl) {
            this.infoControl = new L.KSP.Control.Info;
            this.addControl(this.infoControl)
        }
    });
    L.Control.info = function(map) {
        return new L.KSP.Control.Info(map)
    };
    L.KSP.CelestialBody.MOHO = L.KSP.celestialBody({
        id: "moho",
        name: "Moho",
        crs: L.KSP.CRS.EPSG4326,
        radius: 25e4,
        addedOn: 13691808e5,
        lastUpdated: 13757472e5,
        lastUpdatedVer: 38,
        lastModifiedVer: 38,
        thumbnail: "http://static.kerbalmaps.com/images/body-moho.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "moho",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "moho",
                style: "color",
                legend: {
                    "7000 m": "#cdbea5",
                    "6000 m": "#a08773",
                    "3000 m": "#786455",
                    "1500 m": "#645046",
                    "500 m": "#4b3c32",
                    "0 m": "#322823"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "moho",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([54.679, 153.49], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>6817.3765 m<br>54.6790 : 153.4900"), L.marker([-19.6545, -166.2341], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>28.5585 m<br>-19.6545 : -166.2341")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "moho",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "moho",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.EVE = L.KSP.celestialBody({
        id: "eve",
        name: "Eve",
        crs: L.KSP.CRS.EPSG4326,
        radius: 7e5,
        addedOn: 13691808e5,
        lastUpdated: 13757472e5,
        lastUpdatedVer: 38,
        lastModifiedVer: 38,
        thumbnail: "http://static.kerbalmaps.com/images/body-eve.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eve",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eve",
                style: "color",
                legend: {
                    "7540 m": "#000000",
                    "6500 m": "#0f0f1e",
                    "6000 m": "#1e1728",
                    "3000 m": "#2d1e37",
                    "1500 m": "#37283c",
                    "500 m": "#3c2841",
                    "5 m": "#4b3c55",
                    "-5 m": "#8c7d9b",
                    "-500 m": "#645573"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eve",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-25.0159, -158.4558], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>7526.0112 m<br>-25.0159 : -158.4558"), L.marker([-44.7473, -107.8528], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-1876.8985 m<br>-44.7473 : -107.8528")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "eve",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "eve",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.GILLY = L.KSP.celestialBody({
        id: "gilly",
        name: "Gilly",
        crs: L.KSP.CRS.EPSG4326,
        radius: 13e3,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 27,
        thumbnail: "http://static.kerbalmaps.com/images/body-gilly.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "gilly",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "gilly",
                style: "color",
                legend: {
                    "6500 m": "#b99b82",
                    "4500 m": "#a08273",
                    "2500 m": "#78695a",
                    "1500 m": "#554b41"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "gilly",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-29.2566, -123.8708], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>6400.6353 m<br>-29.2566 : -123.8708"), L.marker([56.7883, -7.24], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>1493.2832 m<br>56.7883 : -7.2400")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "gilly",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "gilly",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.KERBIN = L.KSP.celestialBody({
        id: "kerbin",
        name: "Kerbin",
        crs: L.KSP.CRS.EPSG4326,
        radius: 6e5,
        addedOn: 1366416e6,
        lastUpdated: 13749696e5,
        lastUpdatedVer: 38,
        lastModifiedVer: 38,
        thumbnail: "http://static.kerbalmaps.com/images/body-kerbin.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "kerbin",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "kerbin",
                style: "color",
                legend: {
                    "6800 m": "#FFFFFF",
                    "6000 m": "#E6E1E1",
                    "4000 m": "#C39B87",
                    "2000 m": "#B97855",
                    "1000 m": "#B99B6E",
                    "600 m": "#5A825A",
                    "200 m": "#1E784B",
                    "50 m": "#0A6437",
                    "0 m": "#004120",
                    "-500 m": "#0F4B9B",
                    "-100 m": "#1E6E9B"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "kerbin",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            }),
            Biome: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_BIOME, "http://tiles.kerbalmaps.com/{body}/{style}/{z}/{x}/{y}.png", L.KSP.CRS.EPSG4326, {
                body: "kerbin",
                style: "biome",
                legend: {
                    Water: "#00245E",
                    Shores: "#B5D3D1",
                    Grasslands: "#4BAC00",
                    Highlands: "#1C7800",
                    Mountains: "#824600",
                    Deserts: "#CCB483",
                    Badlands: "#FCD037",
                    Tundra: "#89FA91",
                    "Ice Caps": "#FEFEFE"
                }
            })
        },
        overlays: {
            "Space Centers": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_SPACECENTER, [L.marker([-.0969, -74.6004], {
                icon: L.KSP.Icon.SPACECENTER
            }).bindPopup("<strong>Kerbal Space Center</strong><br>-0.0969 : -74.6004"), L.marker([20.5829, -146.5116], {
                icon: L.KSP.Icon.SPACECENTER
            }).bindPopup("<strong>Kerbal Space Center 2</strong><br>20.5829 : -146.5116"), L.marker([-1.5409, -71.9099], {
                icon: L.KSP.Icon.SPACECENTER
            }).bindPopup("<strong>Island Airfield</strong><br>-1.5409 : -71.9099")]),
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([.1023, -74.5684], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("0.1023 : -74.5684"), L.marker([20.6709, -146.4968], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("20.6709 : -146.4968"), L.marker([35.5705, -74.9773], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("35.5705 : -74.9773"), L.marker([-.6402, -80.7668], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-0.6402 : -80.7668"), L.marker([-28.8083, -13.4401], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-28.8083 : -13.4401"), L.marker([-6.5057, -141.6856], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-6.5057 : -141.6856"), L.marker([81.9551, -128.518], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-81.9551 : -128.518")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([61.5784, 46.3733], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>6761.0483 m<br>61.5784 : 46.3733"), L.marker([-28.905, -83.1116], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-1390.9353 m<br>-28.9050 : -83.1116")])
        },
        grids: {
            Biome: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_BIOME, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "kerbin",
                style: "biome"
            }),
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "kerbin",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "kerbin",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.MUN = L.KSP.celestialBody({
        id: "mun",
        name: "Mun",
        crs: L.KSP.CRS.EPSG4326,
        radius: 2e5,
        addedOn: 13682304e5,
        lastUpdated: 13749696e5,
        lastUpdatedVer: 38,
        lastModifiedVer: 38,
        thumbnail: "http://static.kerbalmaps.com/images/body-mun.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "mun",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "mun",
                style: "color",
                legend: {
                    "6700 m": "#EBEBEB",
                    "-70 m": "#232323"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "mun",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            }),
            Biome: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_BIOME, "http://tiles.kerbalmaps.com/{body}/{style}/{z}/{x}/{y}.png", L.KSP.CRS.EPSG4326, {
                body: "mun",
                style: "biome",
                legend: {
                    Midlands: "#737373",
                    "Midland Craters": "#4C3B4A",
                    Highlands: "#ACACAC",
                    "Highland Craters": "#9E7FA3",
                    Poles: "#65D4D9",
                    "Polar Lowlands": "#289C93",
                    "Polar Crater": "#2E2E63",
                    "Northern Basin": "#3A5B3B",
                    "East Crater": "#CFCF87",
                    "Northwest Crater": "#580707",
                    "Southwest Crater": "#B12D78",
                    "Farside Crater": "#63A53C",
                    "East Farside Crater": "#AA4848",
                    "Twin Craters": "#B3761A",
                    Canyons: "#534600"
                }
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([-9.8314, 25.9177], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-9.8314 : 25.9177"), L.marker([-82.2063, 102.9305], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-82.2063 : 102.9305"), L.marker([57.6604, 9.1422], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("57.6604 : 9.1422"), L.marker([2.4695, 81.5133], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("2.4695 : 81.5133"), L.marker([12.4432, 39.178], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("12.4432 : 39.1780"), L.marker([-12.4431, -140.822], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-12.4431 : -140.8220"), L.marker([.7027, 22.747], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("0.7027 : 22.7470"), L.marker([-70.9556, -68.1378], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-70.9556,-68.1378")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-82.5183, -152.3254], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>7061.1416 m<br>-82.5183 : -152.3254"), L.marker([35.321, -76.6296], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-247.9042 m<br>35.3210 : -76.6296")])
        },
        grids: {
            Biome: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_BIOME, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "mun",
                style: "biome"
            }),
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "mun",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "mun",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.MINMUS = L.KSP.celestialBody({
        id: "minmus",
        name: "Minmus",
        crs: L.KSP.CRS.EPSG4326,
        radius: 6e4,
        addedOn: 13682304e5,
        lastUpdated: 13682304e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 26,
        thumbnail: "http://static.kerbalmaps.com/images/body-minmus.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "sat",
                body: "minmus"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "color",
                body: "minmus",
                legend: {
                    "5750 m": "#414B41",
                    "2500 m": "#BEE6C3",
                    "1 m": "#96CDB4",
                    "0 m": "#87B9A5"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "slope",
                body: "minmus",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([23.7768, 60.0462], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("23.7768 : 60.0462")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-62.9297, 74.729], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>5724.6001 m<br>-62.9297 : 74.7290")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "minmus",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "minmus",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.DUNA = L.KSP.celestialBody({
        id: "duna",
        name: "Duna",
        crs: L.KSP.CRS.EPSG4326,
        radius: 32e4,
        addedOn: 13688352e5,
        lastUpdated: 13757472e5,
        lastUpdatedVer: 38,
        lastModifiedVer: 38,
        thumbnail: "http://static.kerbalmaps.com/images/body-duna.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "sat",
                body: "duna"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "color",
                body: "duna",
                legend: {
                    "8265 m": "#C3A082",
                    "6640 m": "#966446",
                    "5010 m": "#733219",
                    "3380 m": "#501E14",
                    "1750 m": "#3C140F",
                    "125 m": "#280F0A"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "slope",
                body: "duna",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([17.0483, -85.4717], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("17.0483 : -85.4717"), L.marker([-30.3525, -28.6828], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-30.3525 : -28.6828"), L.marker([-66.1344, -160.7432], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-66.1344 : -160.7432")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([20.885, -106.7981], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>8264.3242 m<br>20.8850 : -106.7981"), L.marker([-5.9436, -50.5481], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>124.5119 m<br>-5.9436 : -50.5481")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "duna",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "duna",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.IKE = L.KSP.celestialBody({
        id: "ike",
        name: "Ike",
        crs: L.KSP.CRS.EPSG4326,
        radius: 13e4,
        addedOn: 13688352e5,
        lastUpdated: 13688352e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 26,
        thumbnail: "http://static.kerbalmaps.com/images/body-ike.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "sat",
                body: "ike"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "color",
                body: "ike",
                legend: {
                    "13000 m": "#828282",
                    "11000 m": "#6E6E6E",
                    "9000 m": "#5A5A5A",
                    "7000 m": "#464646",
                    "5000 m": "#323232",
                    "2500 m": "#191919",
                    "70 m": "#070707"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                style: "slope",
                body: "ike",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([25.2795, 178.2971], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>12735.1406 m<br>25.2795 : 178.2971"), L.marker([-14.425, 25.4553], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>73.1864 m<br>-14.4250 : 25.4553")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "ike",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "ike",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.DRES = L.KSP.celestialBody({
        id: "dres",
        name: "Dres",
        crs: L.KSP.CRS.EPSG4326,
        radius: 138e3,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 28,
        thumbnail: "http://static.kerbalmaps.com/images/body-dres.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "dres",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "dres",
                style: "color",
                legend: {
                    "6000 m": "#beb9b4",
                    "3500 m": "#96918c",
                    "2000 m": "#504646",
                    "500 m": "#2d2828",
                    "25 m": "#191919"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "dres",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-85.0012, 42.6379], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>5669.7266 m<br>-85.0012 : 42.6379"), L.marker([19.01733, -57.1399], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>25.4619 m<br>19.01733 : -57.1399")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "dres",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "dres",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.JOOL = L.KSP.celestialBody({
        id: "jool",
        name: "Jool",
        crs: L.KSP.CRS.EPSG4326,
        thumbnail: "http://static.kerbalmaps.com/images/body-jool.png"
    });
    L.KSP.CelestialBody.LAYTHE = L.KSP.celestialBody({
        id: "laythe",
        name: "Laythe",
        crs: L.KSP.CRS.EPSG4326,
        radius: 5e5,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 26,
        thumbnail: "http://static.kerbalmaps.com/images/body-laythe.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "laythe",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "laythe",
                style: "color",
                legend: {
                    "6050 m": "#cdcd9b",
                    "3000 m": "#aaaa7d",
                    "1500 m": "#8c8c69",
                    "500 m": "#696950",
                    "0.001 m": "#464637",
                    "-0 m": "#46505a",
                    "-50 m": "#1e4173",
                    "-500 m": "#192d55"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "laythe",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-17.5891, 172.5842], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>6044.7422 m<br>-17.5891 : 172.5842"), L.marker([29.4543, 7.3499], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-2799.8879 m<br>29.4543 : 7.3499")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "laythe",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "laythe",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.VALL = L.KSP.celestialBody({
        id: "vall",
        name: "Vall",
        crs: L.KSP.CRS.EPSG4326,
        radius: 3e5,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 26,
        thumbnail: "http://static.kerbalmaps.com/images/body-vall.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "vall",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "vall",
                style: "color",
                legend: {
                    "8000 m": "#e6f0f0",
                    "4000 m": "#bed7dc",
                    "2000 m": "#91b9be",
                    "1000 m": "#87aaaf",
                    "0 m": "#739196",
                    "-400 m": "#647d82"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "vall",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([-60.3289, 84.0579], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-60.3289 : 84.0579")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-57.4915, -144.4592], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>7989.1372 m<br>-57.4915 : -144.4592"), L.marker([11.6345, 145.4919], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-394.3332 m<br>11.6345 : 145.4919")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "vall",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "vall",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.TYLO = L.KSP.celestialBody({
        id: "tylo",
        name: "Tylo",
        crs: L.KSP.CRS.EPSG4326,
        radius: 6e5,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 26,
        thumbnail: "http://static.kerbalmaps.com/images/body-tylo.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "tylo",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "tylo",
                style: "color",
                legend: {
                    "11300 m": "#f5f0f0",
                    "10000 m": "#e6e1dc",
                    "5000 m": "#b4afaa",
                    "2500 m": "#878278",
                    "1000 m": "#645f5a",
                    "250 m": "#322d2d",
                    "1 m": "#141414"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "tylo",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([-8.9969, 17.7375], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("-8.9969 : 17.7375"), L.marker([40.2671, 174.0467], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("40.2671 : 174.0467")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-51.7786, 20.5774], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>11282.5488 m<br>-51.7786 : 20.5774")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "tylo",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "tylo",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.BOP = L.KSP.celestialBody({
        id: "bop",
        name: "Bop",
        crs: L.KSP.CRS.EPSG4326,
        radius: 65e3,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 30,
        thumbnail: "http://static.kerbalmaps.com/images/body-bop.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "bop",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "bop",
                style: "color",
                legend: {
                    "22000 m": "#918c7d",
                    "18000 m": "#645a55",
                    "12000 m": "#413732",
                    "6000 m": "#2d2823",
                    "2000 m": "#1e1914"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "bop",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            Anomalies: L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_ANOMALY, [L.marker([68.211, 118.4473], {
                icon: L.KSP.Icon.ANOMALY
            }).bindPopup("68.211 : 118.4473")]),
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([23.8733, -64.5667], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>21754.9961 m<br>23.8733 : -64.5667"), L.marker([37.5842, -139.2737], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>2003.2421 m<br>37.5842 : -139.2737")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "bop",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "bop",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.POL = L.KSP.celestialBody({
        id: "pol",
        name: "Pol",
        crs: L.KSP.CRS.EPSG4326,
        radius: 44e3,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 30,
        thumbnail: "http://static.kerbalmaps.com/images/body-pol.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "pol",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "pol",
                style: "color",
                legend: {
                    "5600 m": "#ebd296",
                    "5000 m": "#d2b982",
                    "2500 m": "#91785f",
                    "1000 m": "#505055",
                    "780 m": "#4b4b50"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "pol",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([-62.8308, 164.5862], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>5590.2134 m<br>-62.8308 : 164.5862"), L.marker([-25.1257, 173.7708], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>782.5003 m<br>-25.1257 : 173.7708")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "pol",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "pol",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.EELOO = L.KSP.celestialBody({
        id: "eeloo",
        name: "Eeloo",
        crs: L.KSP.CRS.EPSG4326,
        radius: 21e4,
        addedOn: 13691808e5,
        lastUpdated: 13691808e5,
        lastUpdatedVer: 34,
        lastModifiedVer: 30,
        thumbnail: "http://static.kerbalmaps.com/images/body-eeloo.png",
        baseLayers: {
            Satellite: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SATELLITE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eeloo",
                style: "sat"
            }),
            "Color Relief": L.KSP.tileLayer(L.KSP.TileLayer.TYPE_COLORRELIEF, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eeloo",
                style: "color",
                legend: {
                    "3900 m": "#c3cdcd",
                    "3500 m": "#afb9b9",
                    "2000 m": "#879191",
                    "1000 m": "#787878",
                    "500 m": "#4b4637",
                    "-400 m": "#322d23"
                }
            }),
            Slope: L.KSP.tileLayer(L.KSP.TileLayer.TYPE_SLOPE, L.KSP.TileLayer.DEFAULT_URL, L.KSP.CRS.EPSG4326, {
                body: "eeloo",
                style: "slope",
                legend: L.KSP.Legend.SLOPE
            })
        },
        overlays: {
            "Points of Interest": L.KSP.layerGroup(L.KSP.LayerGroup.TYPE_POI, [L.marker([24.3347, 27.9602], {
                icon: L.KSP.Icon.HIGH
            }).bindPopup("<strong>Highest Elevation</strong><br>3873.4644 m<br>24.3347 : 27.9602"), L.marker([51.7786, -32.2888], {
                icon: L.KSP.Icon.LOW
            }).bindPopup("<strong>Lowest Elevation</strong><br>-386.8858 m<br>51.7786 : -32.2888")])
        },
        grids: {
            Elevation: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_ELEVATION, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "eeloo",
                style: "elevation",
                resolution: 4
            }),
            Slope: L.KSP.utfGrid(L.KSP.UtfGrid.TYPE_SLOPE, L.KSP.UtfGrid.DEFAULT_URL, {
                body: "eeloo",
                style: "slope",
                resolution: 4
            })
        }
    });
    L.KSP.CelestialBody.KERBIN.defaultLayer = L.KSP.CelestialBody.KERBIN.baseLayers.Satellite;
    L.KSP.CelestialBody.MUN.defaultLayer = L.KSP.CelestialBody.MUN.baseLayers.Satellite;
    L.KSP.CelestialBody.MINMUS.defaultLayer = L.KSP.CelestialBody.MINMUS.baseLayers.Satellite;
    L.KSP.CelestialBody.EVE.children = [L.KSP.CelestialBody.GILLY];
    L.KSP.CelestialBody.KERBIN.children = [L.KSP.CelestialBody.MUN, L.KSP.CelestialBody.MINMUS];
    L.KSP.CelestialBody.DUNA.children = [L.KSP.CelestialBody.IKE];
    L.KSP.CelestialBody.JOOL.children = [L.KSP.CelestialBody.LAYTHE, L.KSP.CelestialBody.VALL, L.KSP.CelestialBody.TYLO, L.KSP.CelestialBody.BOP, L.KSP.CelestialBody.POL];
    L.KSP.CelestialBody.GILLY.parent = L.KSP.CelestialBody.EVE;
    L.KSP.CelestialBody.MUN.parent = L.KSP.CelestialBody.MINMUS.parent = L.KSP.CelestialBody.KERBIN;
    L.KSP.CelestialBody.IKE.parent = L.KSP.CelestialBody.DUNA;
    L.KSP.CelestialBody.LAYTHE.parent = L.KSP.CelestialBody.VALL.parent = L.KSP.CelestialBody.TYLO.parent = L.KSP.CelestialBody.BOP.parent = L.KSP.CelestialBody.POL.parent = L.KSP.CelestialBody.JOOL;
    L.KSP.CelestialBody.ALL_PLANETARY = [L.KSP.CelestialBody.MOHO, L.KSP.CelestialBody.EVE, L.KSP.CelestialBody.KERBIN, L.KSP.CelestialBody.DUNA, L.KSP.CelestialBody.DRES, L.KSP.CelestialBody.JOOL, L.KSP.CelestialBody.EELOO];
    L.KSP.CelestialBody.DEFAULT = L.KSP.CelestialBody.KERBIN;
    L.KSP.Map.prototype.options.layers = [L.KSP.CelestialBody.DEFAULT]
})(this, document);
L.Control.Loading = L.Control.extend({
    options: {
        position: "topleft",
        separate: false,
        zoomControl: null
    },
    initialize: function(options) {
        L.setOptions(this, options);
        this._dataLoaders = {};
        if (this.options.zoomControl !== null) {
            this.zoomControl = this.options.zoomControl
        }
    },
    onAdd: function(map) {
        this._addLayerListeners(map);
        this._addMapListeners(map);
        if (!this.options.separate && !this.zoomControl) {
            this.zoomControl = map.zoomControl
        }
        var classes = "leaflet-control-loading";
        var container;
        if (this.zoomControl && !this.options.separate) {
            container = this.zoomControl._container;
            classes += " leaflet-bar-part-bottom leaflet-bar-part last"
        } else {
            container = L.DomUtil.create("div", "leaflet-control-zoom leaflet-bar")
        }
        this._indicator = L.DomUtil.create("a", classes, container);
        return container
    },
    onRemove: function(map) {
        this._removeLayerListeners(map);
        this._removeMapListeners(map)
    },
    removeFrom: function(map) {
        if (this.zoomControl && !this.options.separate) {
            this._container.removeChild(this._indicator);
            this._map = null;
            this.onRemove(map);
            return this
        } else {
            return L.Control.prototype.removeFrom.call(this, map)
        }
    },
    addLoader: function(id) {
        this._dataLoaders[id] = true;
        this.updateIndicator()
    },
    removeLoader: function(id) {
        delete this._dataLoaders[id];
        this.updateIndicator()
    },
    updateIndicator: function() {
        if (this.isLoading()) {
            this._showIndicator()
        } else {
            this._hideIndicator()
        }
    },
    isLoading: function() {
        return this._countLoaders() > 0
    },
    _countLoaders: function() {
        var size = 0,
            key;
        for (key in this._dataLoaders) {
            if (this._dataLoaders.hasOwnProperty(key)) size++
        }
        return size
    },
    _showIndicator: function() {
        L.DomUtil.addClass(this._indicator, "is-loading");
        if (this.zoomControl && !this.options.separate) {
            L.DomUtil.removeClass(this.zoomControl._zoomOutButton, "leaflet-bar-part-bottom")
        }
    },
    _hideIndicator: function() {
        L.DomUtil.removeClass(this._indicator, "is-loading");
        if (this.zoomControl && !this.options.separate) {
            L.DomUtil.addClass(this.zoomControl._zoomOutButton, "leaflet-bar-part-bottom")
        }
    },
    _handleLoading: function(e) {
        this.addLoader(this.getEventId(e))
    },
    _handleLoad: function(e) {
        this.removeLoader(this.getEventId(e))
    },
    getEventId: function(e) {
        if (e.id) {
            return e.id
        } else if (e.layer) {
            return e.layer._leaflet_id
        }
        return e.target._leaflet_id
    },
    _layerAdd: function(e) {
        if (!e.layer || !e.layer.on) return;
        e.layer.on({
            loading: this._handleLoading,
            load: this._handleLoad
        }, this)
    },
    _addLayerListeners: function(map) {
        map.eachLayer(function(layer) {
            if (!layer.on) return;
            layer.on({
                loading: this._handleLoading,
                load: this._handleLoad
            }, this)
        }, this);
        map.on("layeradd", this._layerAdd, this)
    },
    _removeLayerListeners: function(map) {
        map.eachLayer(function(layer) {
            if (!layer.off) return;
            layer.off({
                loading: this._handleLoading,
                load: this._handleLoad
            }, this)
        }, this);
        map.off("layeradd", this._layerAdd, this)
    },
    _addMapListeners: function(map) {
        map.on({
            dataloading: this._handleLoading,
            dataload: this._handleLoad
        }, this)
    },
    _removeMapListeners: function(map) {
        map.off({
            dataloading: this._handleLoading,
            dataload: this._handleLoad
        }, this)
    }
});
L.Map.addInitHook(function() {
    if (this.options.loadingControl) {
        this.loadingControl = new L.Control.Loading;
        this.addControl(this.loadingControl)
    }
});
L.Control.loading = function(options) {
    return new L.Control.Loading(options)
};
L.EventTracker = L.Class.extend({
    initialize: function(map, options) {
        L.setOptions(this, options);
        this._map = map
    },
    track: function() {
        if (this._enabled) {
            return
        }
        this._enabled = true;
        this.addListeners()
    },
    untrack: function() {
        if (!this._enabled) {
            return
        }
        this._enabled = false;
        this.removeListeners()
    },
    tracking: function() {
        return !!this._enabled
    }
});
L.eventTracker = function(map, options) {
    return new L.EventTracker(map, options)
};
L.EventTracker.GA = L.EventTracker.extend({
    initialize: function(map, gaq, options) {
        L.EventTracker.prototype.initialize.call(this, map, options);
        this._gaq = gaq
    },
    addListeners: function() {
        this._map.on("zoomend", this._onZoomEnd, this);
        this._map.on("moveend", this._onMoveEnd, this);
        this._map.on("bodychangeend", this._onBodyChangeEnd, this);
        this._map.on("baselayerchange", this._onBaseLayerChange, this);
        this._map.on("layeradd", this._onLayerAdd, this);
        this._map.on("layerremove", this._onLayerRemove, this)
    },
    removeListeners: function() {
        this._map.off("zoomend", this._onZoomEnd, this);
        this._map.off("moveend", this._onMoveEnd, this);
        this._map.off("bodychangeend", this._onBodyChangeEnd, this);
        this._map.off("baselayerchange", this._onBaseLayerChange, this);
        this._map.off("layeradd", this._onLayerAdd, this);
        this._map.off("layerremove", this._onLayerRemove, this)
    },
    _onZoomEnd: function(e) {
        var zoom = "" + this._map.getZoom();
        this._trackEvent("Map", "Zoom", zoom, undefined, true)
    },
    _onMoveEnd: function(e) {
        var b = this._map.getBounds(),
            ne = b.getNorthEast();
        sw = b.getSouthWest();
        bounds = "" + L.Util.formatNum(ne.lat, 2) + ", " + L.Util.formatNum(sw.lng, 2) + " : " + L.Util.formatNum(sw.lat, 2) + ", " + L.Util.formatNum(ne.lng, 2);
        this._trackEvent("Map", "Move", bounds, undefined, true)
    },
    _onBodyChangeEnd: function(e) {
        var body = e.body.id;
        this._trackEvent("Map", "Body Change", body)
    },
    _onBaseLayerChange: function(e) {
        if (e.layer.options.style) {
            this._trackEvent("Map", "Base Layer Change", e.layer.options.style)
        }
    },
    _getOverlayType: function(layer) {
        switch (layer._type) {
            case L.KSP.LayerGroup.TYPE_SPACECENTER:
                return "spacecenter";
            case L.KSP.LayerGroup.TYPE_ANOMALY:
                return "anomaly";
            case L.KSP.LayerGroup.TYPE_FROMURL:
                return "fromurl"
        }
    },
    _onLayerAdd: function(e) {
        if (e.layer instanceof L.KSP.LayerGroup) {
            var type = this._getOverlayType(e.layer);
            this._trackEvent("Map", "Overlay Add", type)
        }
    },
    _onLayerRemove: function(e) {
        if (e.layer instanceof L.KSP.LayerGroup) {
            var type = this._getOverlayType(e.layer);
            this._trackEvent("Map", "Overlay Remove", type)
        }
    },
    _trackEvent: function(category, action, opt_label, opt_value, opt_noninteraction) {
        this._gaq.push(["_trackEvent", category, action, opt_label, opt_value, opt_noninteraction])
    }
});
L.eventTracker.ga = function(map, gaq, options) {
    return new L.EventTracker.GA(map, gaq, options)
};
(function(m, p) {
    "object" === typeof exports ? module.exports = p(require("./punycode"), require("./IPv6"), require("./SecondLevelDomains")) : "function" === typeof define && define.amd ? define(["./punycode", "./IPv6", "./SecondLevelDomains"], p) : m.URI = p(m.punycode, m.IPv6, m.SecondLevelDomains, m)
})(this, function(m, p, t, v) {
    function e(a, b) {
        if (!(this instanceof e)) return new e(a, b);
        void 0 === a && (a = "undefined" !== typeof location ? location.href + "" : "");
        this.href(a);
        return void 0 !== b ? this.absoluteTo(b) : this
    }

    function q(a) {
        return a.replace(/([.*+?^=!:${}()|[\]\/\\])/g, "\\$1")
    }

    function x(a) {
        return void 0 === a ? "Undefined" : String(Object.prototype.toString.call(a)).slice(8, -1)
    }

    function l(a) {
        return "Array" === x(a)
    }

    function w(a, b) {
        var c, e;
        if (l(b)) {
            c = 0;
            for (e = b.length; c < e; c++)
                if (!w(a, b[c])) return !1;
            return !0
        }
        var g = x(b);
        c = 0;
        for (e = a.length; c < e; c++)
            if ("RegExp" === g) {
                if ("string" === typeof a[c] && a[c].match(b)) return !0
            } else if (a[c] === b) return !0;
        return !1
    }

    function z(a, b) {
        if (!l(a) || !l(b) || a.length !== b.length) return !1;
        a.sort();
        b.sort();
        for (var c = 0, e = a.length; c < e; c++)
            if (a[c] !== b[c]) return !1;
        return !0
    }

    function A(a) {
        return escape(a)
    }

    function y(a) {
        return encodeURIComponent(a).replace(/[!'()*]/g, A).replace(/\*/g, "%2A")
    }
    var B = v && v.URI,
        d = e.prototype,
        r = Object.prototype.hasOwnProperty;
    e._parts = function() {
        return {
            protocol: null,
            username: null,
            password: null,
            hostname: null,
            urn: null,
            port: null,
            path: null,
            query: null,
            fragment: null,
            duplicateQueryParameters: e.duplicateQueryParameters,
            escapeQuerySpace: e.escapeQuerySpace
        }
    };
    e.duplicateQueryParameters = !1;
    e.escapeQuerySpace = !0;
    e.protocol_expression = /^[a-z][a-z0-9-+-]*$/i;
    e.idn_expression = /[^a-z0-9\.-]/i;
    e.punycode_expression = /(xn--)/i;
    e.ip4_expression = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
    e.ip6_expression = /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/;
    e.find_uri_expression = /\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?\u00ab\u00bb\u201c\u201d\u2018\u2019]))/gi;
    e.defaultPorts = {
        http: "80",
        https: "443",
        ftp: "21",
        gopher: "70",
        ws: "80",
        wss: "443"
    };
    e.invalid_hostname_characters = /[^a-zA-Z0-9\.-]/;
    e.domAttributes = {
        a: "href",
        blockquote: "cite",
        link: "href",
        base: "href",
        script: "src",
        form: "action",
        img: "src",
        area: "href",
        iframe: "src",
        embed: "src",
        source: "src",
        track: "src",
        input: "src"
    };
    e.getDomAttribute = function(a) {
        if (a && a.nodeName) {
            var b = a.nodeName.toLowerCase();
            return "input" === b && "image" !== a.type ? void 0 : e.domAttributes[b]
        }
    };
    e.encode = y;
    e.decode = decodeURIComponent;
    e.iso8859 = function() {
        e.encode = escape;
        e.decode = unescape
    };
    e.unicode = function() {
        e.encode = y;
        e.decode = decodeURIComponent
    };
    e.characters = {
        pathname: {
            encode: {
                expression: /%(24|26|2B|2C|3B|3D|3A|40)/gi,
                map: {
                    "%24": "$",
                    "%26": "&",
                    "%2B": "+",
                    "%2C": ",",
                    "%3B": ";",
                    "%3D": "=",
                    "%3A": ":",
                    "%40": "@"
                }
            },
            decode: {
                expression: /[\/\?#]/g,
                map: {
                    "/": "%2F",
                    "?": "%3F",
                    "#": "%23"
                }
            }
        },
        reserved: {
            encode: {
                expression: /%(21|23|24|26|27|28|29|2A|2B|2C|2F|3A|3B|3D|3F|40|5B|5D)/gi,
                map: {
                    "%3A": ":",
                    "%2F": "/",
                    "%3F": "?",
                    "%23": "#",
                    "%5B": "[",
                    "%5D": "]",
                    "%40": "@",
                    "%21": "!",
                    "%24": "$",
                    "%26": "&",
                    "%27": "'",
                    "%28": "(",
                    "%29": ")",
                    "%2A": "*",
                    "%2B": "+",
                    "%2C": ",",
                    "%3B": ";",
                    "%3D": "="
                }
            }
        }
    };
    e.encodeQuery = function(a, b) {
        var c = e.encode(a + "");
        return b ? c.replace(/%20/g, "+") : c
    };
    e.decodeQuery = function(a, b) {
        a += "";
        try {
            return e.decode(b ? a.replace(/\+/g, "%20") : a)
        } catch (c) {
            return a
        }
    };
    e.recodePath = function(a) {
        a = (a + "").split("/");
        for (var b = 0, c = a.length; b < c; b++) a[b] = e.encodePathSegment(e.decode(a[b]));
        return a.join("/")
    };
    e.decodePath = function(a) {
        a = (a + "").split("/");
        for (var b = 0, c = a.length; b < c; b++) a[b] = e.decodePathSegment(a[b]);
        return a.join("/")
    };
    var n = {
            encode: "encode",
            decode: "decode"
        },
        h, s = function(a, b) {
            return function(c) {
                return e[b](c + "").replace(e.characters[a][b].expression, function(c) {
                    return e.characters[a][b].map[c]
                })
            }
        };
    for (h in n) e[h + "PathSegment"] = s("pathname", n[h]);
    e.encodeReserved = s("reserved", "encode");
    e.parse = function(a, b) {
        var c;
        b || (b = {});
        c = a.indexOf("#"); - 1 < c && (b.fragment = a.substring(c + 1) || null, a = a.substring(0, c));
        c = a.indexOf("?"); - 1 < c && (b.query = a.substring(c + 1) || null, a = a.substring(0, c));
        "//" === a.substring(0, 2) ? (b.protocol = null, a = a.substring(2), a = e.parseAuthority(a, b)) : (c = a.indexOf(":"), -1 < c && (b.protocol = a.substring(0, c) || null, b.protocol && !b.protocol.match(e.protocol_expression) ? b.protocol = void 0 : "file" === b.protocol ? a = a.substring(c + 3) : "//" === a.substring(c + 1, c + 3) ? (a = a.substring(c + 3), a = e.parseAuthority(a, b)) : (a = a.substring(c + 1), b.urn = !0)));
        b.path = a;
        return b
    };
    e.parseHost = function(a, b) {
        var c = a.indexOf("/"),
            e; - 1 === c && (c = a.length);
        "[" === a.charAt(0) ? (e = a.indexOf("]"), b.hostname = a.substring(1, e) || null, b.port = a.substring(e + 2, c) || null) : a.indexOf(":") !== a.lastIndexOf(":") ? (b.hostname = a.substring(0, c) || null, b.port = null) : (e = a.substring(0, c).split(":"), b.hostname = e[0] || null, b.port = e[1] || null);
        b.hostname && "/" !== a.substring(c).charAt(0) && (c++, a = "/" + a);
        return a.substring(c) || "/"
    };
    e.parseAuthority = function(a, b) {
        a = e.parseUserinfo(a, b);
        return e.parseHost(a, b)
    };
    e.parseUserinfo = function(a, b) {
        var c = a.indexOf("/"),
            f = -1 < c ? a.lastIndexOf("@", c) : a.indexOf("@"); - 1 < f && (-1 === c || f < c) ? (c = a.substring(0, f).split(":"), b.username = c[0] ? e.decode(c[0]) : null, c.shift(), b.password = c[0] ? e.decode(c.join(":")) : null, a = a.substring(f + 1)) : (b.username = null, b.password = null);
        return a
    };
    e.parseQuery = function(a, b) {
        if (!a) return {};
        a = a.replace(/&+/g, "&").replace(/^\?*&*|&+$/g, "");
        if (!a) return {};
        for (var c = {}, f = a.split("&"), g = f.length, d, k, l = 0; l < g; l++) d = f[l].split("="), k = e.decodeQuery(d.shift(), b), d = d.length ? e.decodeQuery(d.join("="), b) : null, c[k] ? ("string" === typeof c[k] && (c[k] = [c[k]]), c[k].push(d)) : c[k] = d;
        return c
    };
    e.build = function(a) {
        var b = "";
        a.protocol && (b += a.protocol + ":");
        a.urn || !b && !a.hostname || (b += "//");
        b += e.buildAuthority(a) || "";
        "string" === typeof a.path && ("/" !== a.path.charAt(0) && "string" === typeof a.hostname && (b += "/"), b += a.path);
        "string" === typeof a.query && a.query && (b += "?" + a.query);
        "string" === typeof a.fragment && a.fragment && (b += "#" + a.fragment);
        return b
    };
    e.buildHost = function(a) {
        var b = "";
        if (a.hostname) e.ip6_expression.test(a.hostname) ? b = a.port ? b + ("[" + a.hostname + "]:" + a.port) : b + a.hostname : (b += a.hostname, a.port && (b += ":" + a.port));
        else return "";
        return b
    };
    e.buildAuthority = function(a) {
        return e.buildUserinfo(a) + e.buildHost(a)
    };
    e.buildUserinfo = function(a) {
        var b = "";
        a.username && (b += e.encode(a.username), a.password && (b += ":" + e.encode(a.password)), b += "@");
        return b
    };
    e.buildQuery = function(a, b, c) {
        var f = "",
            g, d, k, h;
        for (d in a)
            if (r.call(a, d) && d)
                if (l(a[d]))
                    for (g = {}, k = 0, h = a[d].length; k < h; k++) void 0 !== a[d][k] && void 0 === g[a[d][k] + ""] && (f += "&" + e.buildQueryParameter(d, a[d][k], c), !0 !== b && (g[a[d][k] + ""] = !0));
                else void 0 !== a[d] && (f += "&" + e.buildQueryParameter(d, a[d], c));
        return f.substring(1)
    };
    e.buildQueryParameter = function(a, b, c) {
        return e.encodeQuery(a, c) + (null !== b ? "=" + e.encodeQuery(b, c) : "")
    };
    e.addQuery = function(a, b, c) {
        if ("object" === typeof b)
            for (var f in b) r.call(b, f) && e.addQuery(a, f, b[f]);
        else if ("string" === typeof b) void 0 === a[b] ? a[b] = c : ("string" === typeof a[b] && (a[b] = [a[b]]), l(c) || (c = [c]), a[b] = a[b].concat(c));
        else throw new TypeError("URI.addQuery() accepts an object, string as the name parameter")
    };
    e.removeQuery = function(a, b, c) {
        var f;
        if (l(b))
            for (c = 0, f = b.length; c < f; c++) a[b[c]] = void 0;
        else if ("object" === typeof b)
            for (f in b) r.call(b, f) && e.removeQuery(a, f, b[f]);
        else if ("string" === typeof b)
            if (void 0 !== c)
                if (a[b] === c) a[b] = void 0;
                else {
                    if (l(a[b])) {
                        f = a[b];
                        var g = {},
                            d, k;
                        if (l(c))
                            for (d = 0, k = c.length; d < k; d++) g[c[d]] = !0;
                        else g[c] = !0;
                        d = 0;
                        for (k = f.length; d < k; d++) void 0 !== g[f[d]] && (f.splice(d, 1), k--, d--);
                        a[b] = f
                    }
                } else a[b] = void 0;
        else throw new TypeError("URI.addQuery() accepts an object, string as the first parameter")
    };
    e.hasQuery = function(a, b, c, f) {
        if ("object" === typeof b) {
            for (var d in b)
                if (r.call(b, d) && !e.hasQuery(a, d, b[d])) return !1;
            return !0
        }
        if ("string" !== typeof b) throw new TypeError("URI.hasQuery() accepts an object, string as the name parameter");
        switch (x(c)) {
            case "Undefined":
                return b in a;
            case "Boolean":
                return a = Boolean(l(a[b]) ? a[b].length : a[b]), c === a;
            case "Function":
                return !!c(a[b], b, a);
            case "Array":
                return l(a[b]) ? (f ? w : z)(a[b], c) : !1;
            case "RegExp":
                return l(a[b]) ? f ? w(a[b], c) : !1 : Boolean(a[b] && a[b].match(c));
            case "Number":
                c = String(c);
            case "String":
                return l(a[b]) ? f ? w(a[b], c) : !1 : a[b] === c;
            default:
                throw new TypeError("URI.hasQuery() accepts undefined, boolean, string, number, RegExp, Function as the value parameter")
        }
    };
    e.commonPath = function(a, b) {
        var c = Math.min(a.length, b.length),
            e;
        for (e = 0; e < c; e++)
            if (a.charAt(e) !== b.charAt(e)) {
                e--;
                break
            }
        if (1 > e) return a.charAt(0) === b.charAt(0) && "/" === a.charAt(0) ? "/" : "";
        if ("/" !== a.charAt(e) || "/" !== b.charAt(e)) e = a.substring(0, e).lastIndexOf("/");
        return a.substring(0, e + 1)
    };
    e.withinString = function(a, b) {
        return a.replace(e.find_uri_expression, b)
    };
    e.ensureValidHostname = function(a) {
        if (a.match(e.invalid_hostname_characters)) {
            if (!m) throw new TypeError("Hostname '" + a + "' contains characters other than [A-Z0-9.-] and Punycode.js is not available");
            if (m.toASCII(a).match(e.invalid_hostname_characters)) throw new TypeError("Hostname '" + a + "' contains characters other than [A-Z0-9.-]")
        }
    };
    e.noConflict = function(a) {
        if (a) return a = {
            URI: this.noConflict()
        }, URITemplate && "function" == typeof URITemplate.noConflict && (a.URITemplate = URITemplate.noConflict()), p && "function" == typeof p.noConflict && (a.IPv6 = p.noConflict()), SecondLevelDomains && "function" == typeof SecondLevelDomains.noConflict && (a.SecondLevelDomains = SecondLevelDomains.noConflict()), a;
        v.URI === this && (v.URI = B);
        return this
    };
    d.build = function(a) {
        if (!0 === a) this._deferred_build = !0;
        else if (void 0 === a || this._deferred_build) this._string = e.build(this._parts), this._deferred_build = !1;
        return this
    };
    d.clone = function() {
        return new e(this)
    };
    d.valueOf = d.toString = function() {
        return this.build(!1)._string
    };
    n = {
        protocol: "protocol",
        username: "username",
        password: "password",
        hostname: "hostname",
        port: "port"
    };
    s = function(a) {
        return function(b, c) {
            if (void 0 === b) return this._parts[a] || "";
            this._parts[a] = b || null;
            this.build(!c);
            return this
        }
    };
    for (h in n) d[h] = s(n[h]);
    n = {
        query: "?",
        fragment: "#"
    };
    s = function(a, b) {
        return function(c, e) {
            if (void 0 === c) return this._parts[a] || "";
            null !== c && (c += "", c.charAt(0) === b && (c = c.substring(1)));
            this._parts[a] = c;
            this.build(!e);
            return this
        }
    };
    for (h in n) d[h] = s(h, n[h]);
    n = {
        search: ["?", "query"],
        hash: ["#", "fragment"]
    };
    s = function(a, b) {
        return function(c, e) {
            var d = this[a](c, e);
            return "string" === typeof d && d.length ? b + d : d
        }
    };
    for (h in n) d[h] = s(n[h][1], n[h][0]);
    d.pathname = function(a, b) {
        if (void 0 === a || !0 === a) {
            var c = this._parts.path || (this._parts.hostname ? "/" : "");
            return a ? e.decodePath(c) : c
        }
        this._parts.path = a ? e.recodePath(a) : "/";
        this.build(!b);
        return this
    };
    d.path = d.pathname;
    d.href = function(a, b) {
        var c;
        if (void 0 === a) return this.toString();
        this._string = "";
        this._parts = e._parts();
        var f = a instanceof e,
            d = "object" === typeof a && (a.hostname || a.path || a.pathname);
        a.nodeName && (d = e.getDomAttribute(a), a = a[d] || "", d = !1);
        !f && d && void 0 !== a.pathname && (a = a.toString());
        if ("string" === typeof a) this._parts = e.parse(a, this._parts);
        else if (f || d)
            for (c in f = f ? a._parts : a, f) r.call(this._parts, c) && (this._parts[c] = f[c]);
        else throw new TypeError("invalid input");
        this.build(!b);
        return this
    };
    d.is = function(a) {
        var b = !1,
            c = !1,
            f = !1,
            d = !1,
            u = !1,
            k = !1,
            l = !1,
            h = !this._parts.urn;
        this._parts.hostname && (h = !1, c = e.ip4_expression.test(this._parts.hostname), f = e.ip6_expression.test(this._parts.hostname), b = c || f, u = (d = !b) && t && t.has(this._parts.hostname), k = d && e.idn_expression.test(this._parts.hostname), l = d && e.punycode_expression.test(this._parts.hostname));
        switch (a.toLowerCase()) {
            case "relative":
                return h;
            case "absolute":
                return !h;
            case "domain":
            case "name":
                return d;
            case "sld":
                return u;
            case "ip":
                return b;
            case "ip4":
            case "ipv4":
            case "inet4":
                return c;
            case "ip6":
            case "ipv6":
            case "inet6":
                return f;
            case "idn":
                return k;
            case "url":
                return !this._parts.urn;
            case "urn":
                return !!this._parts.urn;
            case "punycode":
                return l
        }
        return null
    };
    var C = d.protocol,
        D = d.port,
        E = d.hostname;
    d.protocol = function(a, b) {
        if (void 0 !== a && a && (a = a.replace(/:(\/\/)?$/, ""), a.match(/[^a-zA-z0-9\.+-]/))) throw new TypeError("Protocol '" + a + "' contains characters other than [A-Z0-9.+-]");
        return C.call(this, a, b)
    };
    d.scheme = d.protocol;
    d.port = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 !== a && (0 === a && (a = null), a && (a += "", ":" === a.charAt(0) && (a = a.substring(1)), a.match(/[^0-9]/)))) throw new TypeError("Port '" + a + "' contains characters other than [0-9]");
        return D.call(this, a, b)
    };
    d.hostname = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 !== a) {
            var c = {};
            e.parseHost(a, c);
            a = c.hostname
        }
        return E.call(this, a, b)
    };
    d.host = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a) return this._parts.hostname ? e.buildHost(this._parts) : "";
        e.parseHost(a, this._parts);
        this.build(!b);
        return this
    };
    d.authority = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a) return this._parts.hostname ? e.buildAuthority(this._parts) : "";
        e.parseAuthority(a, this._parts);
        this.build(!b);
        return this
    };
    d.userinfo = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a) {
            if (!this._parts.username) return "";
            var c = e.buildUserinfo(this._parts);
            return c.substring(0, c.length - 1)
        }
        "@" !== a[a.length - 1] && (a += "@");
        e.parseUserinfo(a, this._parts);
        this.build(!b);
        return this
    };
    d.resource = function(a, b) {
        var c;
        if (void 0 === a) return this.path() + this.search() + this.hash();
        c = e.parse(a);
        this._parts.path = c.path;
        this._parts.query = c.query;
        this._parts.fragment = c.fragment;
        this.build(!b);
        return this
    };
    d.subdomain = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a) {
            if (!this._parts.hostname || this.is("IP")) return "";
            var c = this._parts.hostname.length - this.domain().length - 1;
            return this._parts.hostname.substring(0, c) || ""
        }
        c = this._parts.hostname.length - this.domain().length;
        c = this._parts.hostname.substring(0, c);
        c = RegExp("^" + q(c));
        a && "." !== a.charAt(a.length - 1) && (a += ".");
        a && e.ensureValidHostname(a);
        this._parts.hostname = this._parts.hostname.replace(c, a);
        this.build(!b);
        return this
    };
    d.domain = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        "boolean" === typeof a && (b = a, a = void 0);
        if (void 0 === a) {
            if (!this._parts.hostname || this.is("IP")) return "";
            var c = this._parts.hostname.match(/\./g);
            if (c && 2 > c.length) return this._parts.hostname;
            c = this._parts.hostname.length - this.tld(b).length - 1;
            c = this._parts.hostname.lastIndexOf(".", c - 1) + 1;
            return this._parts.hostname.substring(c) || ""
        }
        if (!a) throw new TypeError("cannot set domain empty");
        e.ensureValidHostname(a);
        !this._parts.hostname || this.is("IP") ? this._parts.hostname = a : (c = RegExp(q(this.domain()) + "$"), this._parts.hostname = this._parts.hostname.replace(c, a));
        this.build(!b);
        return this
    };
    d.tld = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        "boolean" === typeof a && (b = a, a = void 0);
        if (void 0 === a) {
            if (!this._parts.hostname || this.is("IP")) return "";
            var c = this._parts.hostname.lastIndexOf("."),
                c = this._parts.hostname.substring(c + 1);
            return !0 !== b && t && t.list[c.toLowerCase()] ? t.get(this._parts.hostname) || c : c
        }
        if (a)
            if (a.match(/[^a-zA-Z0-9-]/))
                if (t && t.is(a)) c = RegExp(q(this.tld()) + "$"), this._parts.hostname = this._parts.hostname.replace(c, a);
                else throw new TypeError("TLD '" + a + "' contains characters other than [A-Z0-9]");
        else {
            if (!this._parts.hostname || this.is("IP")) throw new ReferenceError("cannot set TLD on non-domain host");
            c = RegExp(q(this.tld()) + "$");
            this._parts.hostname = this._parts.hostname.replace(c, a)
        } else throw new TypeError("cannot set TLD empty");
        this.build(!b);
        return this
    };
    d.directory = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a || !0 === a) {
            if (!this._parts.path && !this._parts.hostname) return "";
            if ("/" === this._parts.path) return "/";
            var c = this._parts.path.length - this.filename().length - 1,
                c = this._parts.path.substring(0, c) || (this._parts.hostname ? "/" : "");
            return a ? e.decodePath(c) : c
        }
        c = this._parts.path.length - this.filename().length;
        c = this._parts.path.substring(0, c);
        c = RegExp("^" + q(c));
        this.is("relative") || (a || (a = "/"), "/" !== a.charAt(0) && (a = "/" + a));
        a && "/" !== a.charAt(a.length - 1) && (a += "/");
        a = e.recodePath(a);
        this._parts.path = this._parts.path.replace(c, a);
        this.build(!b);
        return this
    };
    d.filename = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a || !0 === a) {
            if (!this._parts.path || "/" === this._parts.path) return "";
            var c = this._parts.path.lastIndexOf("/"),
                c = this._parts.path.substring(c + 1);
            return a ? e.decodePathSegment(c) : c
        }
        c = !1;
        "/" === a.charAt(0) && (a = a.substring(1));
        a.match(/\.?\//) && (c = !0);
        var d = RegExp(q(this.filename()) + "$");
        a = e.recodePath(a);
        this._parts.path = this._parts.path.replace(d, a);
        c ? this.normalizePath(b) : this.build(!b);
        return this
    };
    d.suffix = function(a, b) {
        if (this._parts.urn) return void 0 === a ? "" : this;
        if (void 0 === a || !0 === a) {
            if (!this._parts.path || "/" === this._parts.path) return "";
            var c = this.filename(),
                d = c.lastIndexOf(".");
            if (-1 === d) return "";
            c = c.substring(d + 1);
            c = /^[a-z0-9%]+$/i.test(c) ? c : "";
            return a ? e.decodePathSegment(c) : c
        }
        "." === a.charAt(0) && (a = a.substring(1));
        if (c = this.suffix()) d = a ? RegExp(q(c) + "$") : RegExp(q("." + c) + "$");
        else {
            if (!a) return this;
            this._parts.path += "." + e.recodePath(a)
        }
        d && (a = e.recodePath(a), this._parts.path = this._parts.path.replace(d, a));
        this.build(!b);
        return this
    };
    d.segment = function(a, b, c) {
        var e = this._parts.urn ? ":" : "/",
            d = this.path(),
            u = "/" === d.substring(0, 1),
            d = d.split(e);
        void 0 !== a && "number" !== typeof a && (c = b, b = a, a = void 0);
        if (void 0 !== a && "number" !== typeof a) throw Error("Bad segment '" + a + "', must be 0-based integer");
        u && d.shift();
        0 > a && (a = Math.max(d.length + a, 0));
        if (void 0 === b) return void 0 === a ? d : d[a];
        if (null === a || void 0 === d[a])
            if (l(b)) {
                d = [];
                a = 0;
                for (var k = b.length; a < k; a++)
                    if (b[a].length || d.length && d[d.length - 1].length) d.length && !d[d.length - 1].length && d.pop(), d.push(b[a])
            } else {
                if (b || "string" === typeof b) "" === d[d.length - 1] ? d[d.length - 1] = b : d.push(b)
            } else b || "string" === typeof b && b.length ? d[a] = b : d.splice(a, 1);
        u && d.unshift("");
        return this.path(d.join(e), c)
    };
    d.segmentCoded = function(a, b, c) {
        var d, g;
        "number" !== typeof a && (c = b, b = a, a = void 0);
        if (void 0 === b) {
            a = this.segment(a, b, c);
            if (l(a))
                for (d = 0, g = a.length; d < g; d++) a[d] = e.decode(a[d]);
            else a = void 0 !== a ? e.decode(a) : void 0;
            return a
        }
        if (l(b))
            for (d = 0, g = b.length; d < g; d++) b[d] = e.decode(b[d]);
        else b = "string" === typeof b ? e.encode(b) : b;
        return this.segment(a, b, c)
    };
    var F = d.query;
    d.query = function(a, b) {
        if (!0 === a) return e.parseQuery(this._parts.query, this._parts.escapeQuerySpace);
        if ("function" === typeof a) {
            var c = e.parseQuery(this._parts.query, this._parts.escapeQuerySpace),
                d = a.call(this, c);
            this._parts.query = e.buildQuery(d || c, this._parts.duplicateQueryParameters, this._parts.escapeQuerySpace);
            this.build(!b);
            return this
        }
        return void 0 !== a && "string" !== typeof a ? (this._parts.query = e.buildQuery(a, this._parts.duplicateQueryParameters, this._parts.escapeQuerySpace), this.build(!b), this) : F.call(this, a, b)
    };
    d.setQuery = function(a, b, c) {
        var d = e.parseQuery(this._parts.query, this._parts.escapeQuerySpace);
        if ("object" === typeof a)
            for (var g in a) r.call(a, g) && (d[g] = a[g]);
        else if ("string" === typeof a) d[a] = void 0 !== b ? b : null;
        else throw new TypeError("URI.addQuery() accepts an object, string as the name parameter");
        this._parts.query = e.buildQuery(d, this._parts.duplicateQueryParameters, this._parts.escapeQuerySpace);
        "string" !== typeof a && (c = b);
        this.build(!c);
        return this
    };
    d.addQuery = function(a, b, c) {
        var d = e.parseQuery(this._parts.query, this._parts.escapeQuerySpace);
        e.addQuery(d, a, void 0 === b ? null : b);
        this._parts.query = e.buildQuery(d, this._parts.duplicateQueryParameters, this._parts.escapeQuerySpace);
        "string" !== typeof a && (c = b);
        this.build(!c);
        return this
    };
    d.removeQuery = function(a, b, c) {
        var d = e.parseQuery(this._parts.query, this._parts.escapeQuerySpace);
        e.removeQuery(d, a, b);
        this._parts.query = e.buildQuery(d, this._parts.duplicateQueryParameters, this._parts.escapeQuerySpace);
        "string" !== typeof a && (c = b);
        this.build(!c);
        return this
    };
    d.hasQuery = function(a, b, c) {
        var d = e.parseQuery(this._parts.query, this._parts.escapeQuerySpace);
        return e.hasQuery(d, a, b, c)
    };
    d.setSearch = d.setQuery;
    d.addSearch = d.addQuery;
    d.removeSearch = d.removeQuery;
    d.hasSearch = d.hasQuery;
    d.normalize = function() {
        return this._parts.urn ? this.normalizeProtocol(!1).normalizeQuery(!1).normalizeFragment(!1).build() : this.normalizeProtocol(!1).normalizeHostname(!1).normalizePort(!1).normalizePath(!1).normalizeQuery(!1).normalizeFragment(!1).build()
    };
    d.normalizeProtocol = function(a) {
        "string" === typeof this._parts.protocol && (this._parts.protocol = this._parts.protocol.toLowerCase(), this.build(!a));
        return this
    };
    d.normalizeHostname = function(a) {
        this._parts.hostname && (this.is("IDN") && m ? this._parts.hostname = m.toASCII(this._parts.hostname) : this.is("IPv6") && p && (this._parts.hostname = p.best(this._parts.hostname)), this._parts.hostname = this._parts.hostname.toLowerCase(), this.build(!a));
        return this
    };
    d.normalizePort = function(a) {
        "string" === typeof this._parts.protocol && this._parts.port === e.defaultPorts[this._parts.protocol] && (this._parts.port = null, this.build(!a));
        return this
    };
    d.normalizePath = function(a) {
        if (this._parts.urn || !this._parts.path || "/" === this._parts.path) return this;
        var b, c = this._parts.path,
            d, g;
        "/" !== c.charAt(0) && (b = !0, c = "/" + c);
        for (c = c.replace(/(\/(\.\/)+)|(\/\.$)/g, "/").replace(/\/{2,}/g, "/");;) {
            d = c.indexOf("/../");
            if (-1 === d) break;
            else if (0 === d) {
                c = c.substring(3);
                break
            }
            g = c.substring(0, d).lastIndexOf("/"); - 1 === g && (g = d);
            c = c.substring(0, g) + c.substring(d + 3)
        }
        b && this.is("relative") && (c = c.substring(1));
        c = e.recodePath(c);
        this._parts.path = c;
        this.build(!a);
        return this
    };
    d.normalizePathname = d.normalizePath;
    d.normalizeQuery = function(a) {
        "string" === typeof this._parts.query && (this._parts.query.length ? this.query(e.parseQuery(this._parts.query, this._parts.escapeQuerySpace)) : this._parts.query = null, this.build(!a));
        return this
    };
    d.normalizeFragment = function(a) {
        this._parts.fragment || (this._parts.fragment = null, this.build(!a));
        return this
    };
    d.normalizeSearch = d.normalizeQuery;
    d.normalizeHash = d.normalizeFragment;
    d.iso8859 = function() {
        var a = e.encode,
            b = e.decode;
        e.encode = escape;
        e.decode = decodeURIComponent;
        this.normalize();
        e.encode = a;
        e.decode = b;
        return this
    };
    d.unicode = function() {
        var a = e.encode,
            b = e.decode;
        e.encode = y;
        e.decode = unescape;
        this.normalize();
        e.encode = a;
        e.decode = b;
        return this
    };
    d.readable = function() {
        var a = this.clone();
        a.username("").password("").normalize();
        var b = "";
        a._parts.protocol && (b += a._parts.protocol + "://");
        a._parts.hostname && (a.is("punycode") && m ? (b += m.toUnicode(a._parts.hostname), a._parts.port && (b += ":" + a._parts.port)) : b += a.host());
        a._parts.hostname && a._parts.path && "/" !== a._parts.path.charAt(0) && (b += "/");
        b += a.path(!0);
        if (a._parts.query) {
            for (var c = "", d = 0, g = a._parts.query.split("&"), l = g.length; d < l; d++) {
                var k = (g[d] || "").split("="),
                    c = c + ("&" + e.decodeQuery(k[0], this._parts.escapeQuerySpace).replace(/&/g, "%26"));
                void 0 !== k[1] && (c += "=" + e.decodeQuery(k[1], this._parts.escapeQuerySpace).replace(/&/g, "%26"))
            }
            b += "?" + c.substring(1)
        }
        return b += e.decodeQuery(a.hash(), !0)
    };
    d.absoluteTo = function(a) {
        var b = this.clone(),
            c = ["protocol", "username", "password", "hostname", "port"],
            d, g;
        if (this._parts.urn) throw Error("URNs do not have any generally defined hierarchical components");
        a instanceof e || (a = new e(a));
        b._parts.protocol || (b._parts.protocol = a._parts.protocol);
        if (this._parts.hostname) return b;
        for (d = 0; g = c[d]; d++) b._parts[g] = a._parts[g];
        c = ["query", "path"];
        for (d = 0; g = c[d]; d++) !b._parts[g] && a._parts[g] && (b._parts[g] = a._parts[g]);
        "/" !== b.path().charAt(0) && (a = a.directory(), b._parts.path = (a ? a + "/" : "") + b._parts.path, b.normalizePath());
        b.build();
        return b
    };
    d.relativeTo = function(a) {
        var b = this.clone().normalize(),
            c, d, g, l;
        if (b._parts.urn) throw Error("URNs do not have any generally defined hierarchical components");
        a = new e(a).normalize();
        c = b._parts;
        d = a._parts;
        g = b.path();
        l = a.path();
        if ("/" !== g.charAt(0)) throw Error("URI is already relative");
        if ("/" !== l.charAt(0)) throw Error("Cannot calculate a URI relative to another relative URI");
        c.protocol === d.protocol && (c.protocol = null);
        if (c.username === d.username && c.password === d.password && null === c.protocol && null === c.username && null === c.password && c.hostname === d.hostname && c.port === d.port) c.hostname = null, c.port = null;
        else return b.build();
        if (g === l) return c.path = "", b.build();
        a = e.commonPath(b.path(), a.path());
        if (!a) return b.build();
        d = d.path.substring(a.length).replace(/[^\/]*$/, "").replace(/.*?\//g, "../");
        c.path = d + c.path.substring(a.length);
        return b.build()
    };
    d.equals = function(a) {
        var b = this.clone();
        a = new e(a);
        var c = {},
            d = {},
            g = {},
            h;
        b.normalize();
        a.normalize();
        if (b.toString() === a.toString()) return !0;
        c = b.query();
        d = a.query();
        b.query("");
        a.query("");
        if (b.toString() !== a.toString() || c.length !== d.length) return !1;
        c = e.parseQuery(c, this._parts.escapeQuerySpace);
        d = e.parseQuery(d, this._parts.escapeQuerySpace);
        for (h in c)
            if (r.call(c, h)) {
                if (!l(c[h])) {
                    if (c[h] !== d[h]) return !1
                } else if (!z(c[h], d[h])) return !1;
                g[h] = !0
            }
        for (h in d)
            if (r.call(d, h) && !g[h]) return !1;
        return !0
    };
    d.duplicateQueryParameters = function(a) {
        this._parts.duplicateQueryParameters = !!a;
        return this
    };
    d.escapeQuerySpace = function(a) {
        this._parts.escapeQuerySpace = !!a;
        return this
    };
    return e
});