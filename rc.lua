--[[

     Awesome WM configuration template
     https://github.com/awesomeWM

     Copycats themes : https://github.com/lcpz/awesome-copycats

     lain : https://github.com/lcpz/lain

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

--https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html
-- Standard awesome library
local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment
                      require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")

awful.button.names = {
    LEFT        = 1,-- The left mouse button.
    MIDDLE      = 2,-- The scrollwheel button.
    RIGHT       = 3,-- The context menu button.
    SCROLL_UP   = 4,-- A scroll up increment.
    SCROLL_DOWN = 5,-- A scroll down increment.
}

-- Theme handling library
local beautiful     = require("beautiful")

-- Notification library
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100
naughty.config.defaults['timeout'] = 20

--local menubar       = require("menubar")

local lain          = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}


-- }}}

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local themes = {
    "multicolor",        -- 1
    "powerarrow",              -- 2
    "powerarrow-blue",         -- 3 good
    "blackburn",        -- 4
    "copland",        -- 5
}

-- choose your theme here
local chosen_theme = themes[1]

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- modkey or mod4 = super key
local modkey       = "Mod4"
local altkey       = "Mod1"
local ctrlkey      = "Control"

-- personal variables
--change these variables if you want
local browser1          = "brave"
local browser2          = "firefox"
local browser3          = "chromium -no-default-browser-check"
local editor            = os.getenv("EDITOR") or "vim"
local editorgui         = "code"
local filemanager       = "pcmanfm"
local mailclient        = "thunderbird"
local mediaplayer       = "spotify"
local terminal          = "xfce4-terminal"
local virtualmachine    = "virtualbox"

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = {  "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" }
--awful.util.tagnames = { "⠐", "⠡", "⠲", "⠵", "⠻", "⠿" }
--awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
--awful.util.tagnames = { "www", "edit", "gimp", "inkscape", "music" }
-- Use this : https://fontawesome.com/cheatsheet
--awful.util.tagnames = { "", "", "", "", "" }
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

-- Tag list is on the top left
awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)



local function click_focus_client(c)
    if c == client.focus then
        c.minimized = true
    else
        c.minimized = false
        if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:emit_signal('request::activate')
        c:raise()
    end
end


-- Tasklist is the bottom bar
awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, click_focus_client),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "arandr", "arandr" },
}


-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = beautiful.border_width
        end
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s)
    s.systray = wibox.widget.systray()
    s.systray.visible = true
 end)
-- }}}



-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.spawn( "xfce4-appfinder" ) end)
))
-- }}}


local function run_or_raise(cmd, class)
    class = class:lower()
    local matcher = function (c)
        if not c.class then
            return false
        end
        local client_class = c.class:lower()
        if client_class:find(class) then
            return true
        end
        return false
    end
    awful.client.run_or_raise(cmd, matcher)
end

local function run_or_raise_name(cmd, name)
    name = name:lower()
    local matcher = function (c)
        if not c.name then
            return false
        end
        local client_class = c.name:lower()
        if client_class:find(name) then
            return true
        end
        return false
    end
    awful.client.run_or_raise(cmd, matcher)
end

local function dmenu_run()
    awful.spawn(string.format("dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn NotoMonoRegular:bold:pixelsize=14",
        beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus
    ))
end

local function conf_monitor()
    awful.spawn.easy_async(
        "bootstrap-linux monitor",
        function (stdout, stderr, exitreason, exitcode)
            awesome.restart()
        end
    )
end


-- {{{ Key bindings
globalkeys = my_table.join(

    -- awful.key({ modkey }, "space", dmenu_run, {description = "show run menu", group = "hotkeys"}),
    awful.key({ modkey }, "space", function () awful.spawn("rofi -show drun") end, {description = "show run menu", group = "hotkeys"}),

    -- Function keys
    awful.key({ }, "F12", function () awful.util.spawn( "xfce4-terminal --drop-down" ) end, {description = "dropdown terminal" , group = "function keys"}),

    -- super + ... function keys
    awful.key({ modkey }, "F1", hotkeys_popup.show_help, {description = "show help", group="awesome"}),
    awful.key({ modkey }, "F11", function () awful.util.spawn("rofi -theme-str -show drun") end, {description="rofi fullscreen", group="function keys"}),
    awful.key({ modkey }, "F12", function () awful.util.spawn( "rofi -show drun" ) end, {description = "rofi" , group = "function keys" }),


    -- super + ...
    awful.key({ modkey }, "Return", function () run_or_raise(terminal, "terminal") end, { description = "open existing or new terminal", group = "launcher" }),
    awful.key({ modkey }, "d", function () run_or_raise_name("libreoffice Documents/DEADLINES.ods", "DEADLINES.ods") end, { description = "open new terminal", group = "launcher" }),
    awful.key({ modkey }, "q", function () run_or_raise(browser1, browser1) end, { description = "open browser1", group = "launcher" }),
    awful.key({ modkey }, "e", function () run_or_raise(filemanager, filemanager) end, { description = "open filemanager", group = "launcher" } ),
    awful.key({ modkey }, "t", function () run_or_raise("thunderbird", "thunderbird") end, { description = "open thunderbird", group = "launcher" } ),
    awful.key({ modkey }, "w", function () run_or_raise("whatsapp-natifier", "whatsapp") end, { description = "open whatsapp", group = "launcher" } ),
    awful.key({ modkey }, "a", function () run_or_raise("signal-desktop", "signal") end, { description = "open signal", group = "launcher" } ),
    awful.key({ modkey }, "s", function () run_or_raise("slack", "slack") end, { description = "open slack", group = "launcher" } ),
    awful.key({ modkey }, "z", function () run_or_raise("zoom", "zoom") end, { description = "open zoom", group = "launcher" } ),
    awful.key({ modkey }, "v", function () awful.spawn.with_shell("copyq show") end, { description = "open clipboard manager", group = "launcher" } ),
    awful.key({ modkey }, "c", function () run_or_raise(editorgui, editorgui) end, { description = "open development editor", group = "launcher" } ),
    awful.key({ modkey }, "g", function () run_or_raise("galculator", "galculator") end, { description = "open galculator", group = "launcher" } ),
    awful.key({ modkey }, "r", function () awful.spawn("rofi -show drun") end, { description = "run prompt", group = "launcher" } ),
    awful.key({ modkey }, "Escape", function () awful.util.spawn( "xkill" ) end, {description = "Kill proces", group = "hotkeys"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),


    -- super + shift + ...
    awful.key({ ctrlkey, modkey }, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({ ctrlkey, modkey }, "w", conf_monitor, {description="autoconfigure monitors", group = "hotkeys" }),

    -- ctrl + shift + ...
    awful.key({ ctrlkey, "Shift" }, "Escape", function() awful.util.spawn("xfce4-taskmanager") end),


    -- ctrl+alt +  ...
    awful.key({ ctrlkey, altkey }, "w", function() awful.util.spawn( "arcolinux-welcome-app" ) end, {description = "ArcoLinux Welcome App", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "e", function() awful.util.spawn( "arcolinux-tweak-tool" ) end, {description = "ArcoLinux Tweak Tool", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "a", function() awful.util.spawn( "xfce4-appfinder" ) end, {description = "Xfce appfinder", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "o", function() awful.spawn.with_shell("$HOME/.config/awesome/scripts/picom-toggle.sh") end, {description = "Picom toggle", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "s", function() awful.util.spawn( mediaplayer ) end, {description = mediaplayer, group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "u", function() awful.util.spawn( "pavucontrol" ) end, {description = "pulseaudio control", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "m", function() awful.util.spawn( "xfce4-settings-manager" ) end, {description = "Xfce settings manager", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "p", function() awful.util.spawn( "pamac-manager" ) end, {description = "Pamac Manager", group = "alt+ctrl"}),
    awful.key({ ctrlkey, altkey }, "Delete", function () awful.util.spawn("arcolinux-logout") end, {description = "exit", group = "hotkeys"}),

    -- alt + ...
    awful.key({ altkey }, "F2", function () awful.util.spawn( "xfce4-appfinder --collapsed" ) end, {description = "Xfce appfinder", group = "altkey"}),
    awful.key({ altkey }, "F3", function () awful.util.spawn( "xfce4-appfinder" ) end, {description = "Xfce appfinder", group = "altkey"}),
    awful.key({ altkey }, "Tab", function () awful.spawn("rofi -show window -kb-accept-entry '!Alt-Tab,Return' -kb-row-down 'Alt-Tab,Down' -kb-cancel 'Alt+Escape,Escape'") end, { description = "Select Open client", group = "layout" } ),


    awful.key({ }, "Print", function() awful.spawn.with_shell("flameshot gui") end, { description = "print screen", group = "hotkeys" }),
    -- XF86
    awful.key({ }, "XF86PowerOff", function () awful.util.spawn("arcolinux-logout") end, {description = "exit", group = "hotkeys"}),
    awful.key({ }, "XF86PowerDown", function () awful.util.spawn("arcolinux-logout") end, {description = "exit", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end, {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end, {description = "-10%", group = "hotkeys"}),
    awful.key({ }, "XF86AudioRaiseVolume", function () os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel)) beautiful.volume.update() end),
    awful.key({ }, "XF86AudioLowerVolume", function () os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel)) beautiful.volume.update() end),
    awful.key({ }, "XF86AudioMute", function () os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel)) beautiful.volume.update() end)

)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c) c:emit_signal('request::activate') c:raise() end),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize),
    awful.button({modkey}, 4, function() awful.layout.inc(1) end),
    awful.button({modkey}, 5, function() awful.layout.inc(-1) end)
)

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },
          -- Set applications to always map on the tag 2 on screen 1.
    --{ rule = { class = "Subl" },
        --properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },


    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command
    --{ rule = { class = browser2 },
      --properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true  } },

    --{ rule = { class = browser1 },
      --properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true  } },

    --{ rule = { class = "Vivaldi-stable" },
        --properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true } },

    --{ rule = { class = "Chromium" },
      --properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true  } },

    --{ rule = { class = "Opera" },
      --properties = { screen = 1, tag = awful.util.tagnames[1],switchtotag = true  } },

    -- Set applications to always map on the tag 2 on screen 1.
    --{ rule = { class = "Subl" },
        --properties = { screen = 1, tag = awful.util.tagnames[2],switchtotag = true  } },

    --{ rule = { class = editorgui },
        --properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

    --{ rule = { class = "Brackets" },
        --properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

    --{ rule = { class = "Code" },
        --properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

    --    { rule = { class = "Geany" },
         --  properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },


    -- Set applications to always map on the tag 3 on screen 1.
    --{ rule = { class = "Inkscape" },
        --properties = { screen = 1, tag = awful.util.tagnames[3], switchtotag = true  } },

    -- Set applications to always map on the tag 4 on screen 1.
    --{ rule = { class = "Gimp" },
        --properties = { screen = 1, tag = awful.util.tagnames[4], switchtotag = true  } },

    -- Set applications to always map on the tag 5 on screen 1.
    --{ rule = { class = "Meld" },
        --properties = { screen = 1, tag = awful.util.tagnames[5] , switchtotag = true  } },


    -- Set applications to be maximized at startup.
    -- find class or role via xprop command

    { rule = { class = editorgui },
          properties = { maximized = true } },

    { rule = { class = "Geany" },
          properties = { maximized = false, floating = false } },

    -- { rule = { class = "Thunar" },
    --     properties = { maximized = false, floating = false } },

    { rule = { class = "Gimp*", role = "gimp-image-window" },
          properties = { maximized = true } },

    { rule = { class = "Gnome-disks" },
          properties = { maximized = true } },

    { rule = { class = "inkscape" },
          properties = { maximized = true } },

    { rule = { class = mediaplayer },
          properties = { maximized = true } },

    { rule = { class = "Vlc" },
          properties = { maximized = true } },

    { rule = { class = "VirtualBox Manager" },
          properties = { maximized = true } },

    { rule = { class = "VirtualBox Machine" },
          properties = { maximized = true } },

    { rule = { class = "Vivaldi-stable" },
          properties = { maximized = false, floating = false } },

    { rule = { class = "Vivaldi-stable" },
          properties = { callback = function (c) c.maximized = false end } },

    --IF using Vivaldi snapshot you must comment out the rules above for Vivaldi-stable as they conflict
    -- { rule = { class = "Vivaldi-snapshot" },
    --         properties = { maximized = false, floating = false } },

    -- { rule = { class = "Vivaldi-snapshot" },
    --         properties = { callback = function (c) c.maximized = false end } },

    { rule = { class = "Xfce4-settings-manager" },
          properties = { floating = false } },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Arcolinux-welcome-app.py",
          "Blueberry",
          "Galculator",
          "Gnome-font-viewer",
          "Gpick",
          "Imagewriter",
          "Font-manager",
          "Kruler",
          "MessageWin",  -- kalarm.
          "arcolinux-logout",
          "Peek",
          "Skype",
          "System-config-printer.py",
          "Sxiv",
          "Unetbootin.elf",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "Xfce4-appfinder",
          "Xfce4-terminal"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},

          -- Floating clients but centered in screen
    { rule_any = {
           class = {
               "Polkit-gnome-authentication-agent-1",
            "Arcolinux-calamares-tool.py"
                },
                },
          properties = { floating = true },
              callback = function (c)
              awful.placement.centered(c,nil)
               end }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(21)}) : setup {
        { -- Right
            awful.titlebar.widget.closebutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Left
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.iconwidget(c),
            layout  = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- }}}

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
awful.spawn.with_shell("picom -b --config $HOME/.config/awesome/picom.conf")


run_on_start_up = {
    "picom -b --config $HOME/.config/awesome/picom.conf",
    "nm-applet",
    "pamac-tray",
    "variety",
    "xfce4-power-manager",
    "blueberry-tray",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    "volumeicon",
    "xautolock -detectsleep -time 60 -locker 'betterlockscreen -l'",
    "xfce4-clipman",
}

