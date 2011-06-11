--
-- rizumu's xmonad config
--
-- Taken from github.com/davidbeckingsale/xmonad-config
-- Started out as avandael's xmonad.hs
-- Also uses stuff from pbrisbin.com:8080/
--

--{{{ Imports
import Data.List

import Graphics.X11.ExtraTypes.XF86
import Graphics.X11.Xlib

import System.IO

import XMonad

import XMonad.Actions.GridSelect

import XMonad.Core

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile

import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell

import XMonad.Util.EZConfig
import XMonad.Util.Run

import qualified XMonad.StackSet as W
import qualified Data.Map as M
--}}}

--{{{ Helper Functions
stripIM s = if ("IM " `isPrefixOf` s) then drop (length "IM ") s else s

wrapIcon icon = "^p(5)^i(" ++ icons ++ icon ++ ")^p(5)"
--}}}

--{{{ Path variables
icons = "/home/rizumu/.icons/"
--}}}

main = do
   --myXmobar <- spawnPipe "xmobar"
   myStatusBarPipe <- spawnPipe myStatusBar
   --conkyBar <- spawnPipe myConkyBar
   xmonad $ myUrgencyHook $ defaultConfig
      { terminal = "urxvtcd"
      , normalBorderColor = myInactiveBorderColor
      , focusedBorderColor = myActiveBorderColor
      , borderWidth = myBorderWidth
      , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
      , layoutHook = smartBorders $ avoidStruts $ myLayoutHook
      , logHook = dynamicLogWithPP $ myDzenPP myStatusBarPipe
      , modMask = mod4Mask
      , keys = myKeys
      , mouseBindings = myMouseBindings
      , XMonad.Core.workspaces = myWorkspaces
      , startupHook = setWMName "LG3D"
      , focusFollowsMouse = True
     }

--{{{ Theme

--Font
--myFont = "xft:inconsolata:size=9:antialias=true:hinting=true:hintstyle=hintfull"
myFontName = "Inconsolata"
myFontSize = "11"
myFont = "-*-terminus-medium-*-*-*-12-*-*-*-*-*-iso8859-1"

-- Colors

--- Main Colours
myFgColor = "#DCDCCC"
myBgColor = "#2F2F2F"
myHighlightedFgColor = myFgColor
myHighlightedBgColor = "#93d44f"

--- Borders
myActiveBorderColor = myCurrentWsBgColor
myInactiveBorderColor = "#555753"
myBorderWidth = 2

--- Ws Stuff
myCurrentWsFgColor = "#FFFFFF"
myCurrentWsBgColor = myHighlightedBgColor
myVisibleWsFgColor = myBgColor
myVisibleWsBgColor = "#c8e7a8"
myHiddenWsFgColor = "#CCDC90"
myHiddenEmptyWsFgColor = "#8F8F8F"
myUrgentWsBgColor = "#ff6565"
myTitleFgColor = myFgColor


--- Urgency
myUrgencyHintFgColor = "#000000"
myUrgencyHintBgColor = "#ff6565"

-- }}}

-- dzen general options
myDzenGenOpts = "-fg '" ++ myFgColor ++ "' -bg '" ++ myBgColor ++ "' -h '18'" ++ " -e 'onstart=lower' -fn '" ++ myFont ++ "'"

-- Status Bar
myStatusBar = "dzen2 -w 3040 -ta l " ++ myDzenGenOpts

-- Conky Bar
myConkyBar = "conky -c ~/.conky_bar | dzen2 -x 0 -y 1500 -w 1920 -ta c " ++ myDzenGenOpts
-- myMPDBar = "conky -c ~/.conky_mpd | dzen2 -x 1700 -w 320 -ta r " ++ myDzenGenOpts

-- Layouts
myLayoutHook = avoidStruts $ onWorkspace " 4 im " imLayout $ standardLayouts
               where standardLayouts = tiled ||| Mirror tiled ||| Full
                     imLayout = withIM (2/10) (Role "buddy_list") (standardLayouts)
                     tiled = ResizableTall nmaster delta ratio []
                     nmaster = 1
                     delta = 0.03
                     ratio = 0.5
-- Workspaces
myWorkspaces = [" sh ", " emacs ", " www ", " mail ", " irc ", " im ", " ongaku ", " stats ", " . "]

-- Urgency hint configuration
myUrgencyHook = withUrgencyHook dzenUrgencyHook
  { args =
      [ "-x", "0", "-y", "1180", "-h", "20", "-w", "1920"
      , "-ta", "c"
      , "-fg", "" ++ myUrgencyHintFgColor ++ ""
      , "-bg", "" ++ myUrgencyHintBgColor ++ ""
      , "-fn", "" ++ myFont ++ ""
      ]
  }

--{{{ Hook for managing windows
myManageHook = composeAll
  [ resource  =? "Do"               --> doIgnore              -- Ignore GnomeDo
  , className =? "Pidgin"           --> doShift " im "        -- Shift Pidgin to im desktop
  , className =? "Skype"            --> doShift " im "        -- Shift Pidgin to im desktop
  , className =? "Chrome"           --> doShift " mail "      -- Shift Chromium to www
  , className =? "Firefox"          --> doShift " www "       -- Shift Firefox to www
  , className =? "Emacs"            --> doShift " emacs "     -- Shift emacs to ed workspace
  , className =? "irssi"            --> doShift " irc "       -- Shift emacs to ed workspace
  , className =? "ncmpcpp"          --> doShift " ongaku "    -- Shift ncmcpp to ongaku workspace
  , className =? "Htop"             --> doShift " stats "     -- Shift htop to stats workspace
  , className =? "Wicd-client.py"   --> doFloat               -- Float Wicd window
  , isFullscreen                    --> (doF W.focusDown <+> doFullFloat)
  ]
--}}}

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

--{{{ Keybindings
--    Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) =
  [ ((modm, xK_p), spawn "dmenu_run -nb '#222222' -nf '#aaaaaa' -sb '#93d44f' -sf '#222222'")  --Uses a colourscheme with dmenu
  , ((modm, xK_w), spawn "firefox")
  , ((modm, xK_s), spawn "firefox manage.sugarstats.com/stats/today")
  -- , ((modm, xK_c), spawn "chromium --app='https://calendar.google.com'")
  , ((modm, xK_f), spawn "urxvt -e mc")
  , ((modm, xK_r), spawn "urxvt --title irssi -e screen irssi")
  , ((modm, xK_o), spawn "urxvt --title ncmpcpp -e ncmpcpp")
  , ((modm, xK_m), spawn "chromium --app='https://mail.google.com'")
  -- , ((modm, xK_n), spawn "chromium --app='https://simple-note.appspot.com'")
  -- , ((modm, xK_g), spawn "chromium --app='https://app.nirvanahq.com'")
  , ((0, xK_Print), spawn "scrot")
  -- , ((modm, xK_v), spawn "VirtualBox")
  , ((0, xF86XK_AudioMute), spawn "amixer -q set PCM toggle")
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set PCM 2+")
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set PCM 2-")
  , ((0, xF86XK_AudioPlay), spawn "exaile -t")
  , ((0, xF86XK_AudioStop), spawn "exaile -s")
  , ((0, xF86XK_AudioNext), spawn "exaile -n")
  , ((0, xF86XK_AudioPrev), spawn "exaile -p")
  , ((modm, xK_y), sendMessage ToggleStruts)
  , ((modm, xK_u), sendMessage MirrorShrink)
  , ((modm, xK_i), sendMessage MirrorExpand)
  -- , ((modm, xK_z), spawn "chromium --app='http://www.evernote.com/Home.action'")
  ]
--}}}

--{{{ Mousebindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
--}}}

---{{{ Dzen Config
myDzenPP h = defaultPP
  { ppOutput = hPutStrLn h
  , ppSep = (wrapFg myHighlightedBgColor "|")
  , ppWsSep = ""
  , ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor
  , ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor
  , ppHidden = wrapFg myHiddenWsFgColor
  , ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor
  , ppUrgent = wrapBg myUrgentWsBgColor
  , ppTitle = (\x -> "  " ++ wrapFg myTitleFgColor x)
  , ppLayout  = dzenColor myFgColor"" .
                (\x -> case x of
                    "ResizableTall" -> wrapIcon "dzen_bitmaps/tall.xbm"
                    "Mirror ResizableTall" -> wrapIcon "dzen_bitmaps/mtall.xbm"
                    "Full" -> wrapIcon "dzen_bitmaps/full.xbm"
                ) . stripIM
  }
  where
    wrapFgBg fgColor bgColor content= wrap ("^fg(" ++ fgColor ++ ")^bg(" ++ bgColor ++ ")") "^fg()^bg()" content
    wrapFg color content = wrap ("^fg(" ++ color ++ ")") "^fg()" content
    wrapBg color content = wrap ("^bg(" ++ color ++ ")") "^bg()" content
--}}}

--{{{ GridSelect

