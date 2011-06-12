--
-- rizumu's xmonad-config
-- git://github.com/rizumu/rizumu-xmonad.git
--
-- Adapted from:
-- git://github.com/davidbeckingsale/xmonad-config.git
-- git://github.com/pbrisbin/xmonad-config.git

--{{{ Imports
import XMonad

-- <http://pbrisbin.com/xmonad/docs/Utils.html>
import Utils
import Dzen (DzenConf(..), TextAlign(..), defaultDzenXft,
                spawnDzen, spawnToDzen, defaultDzen)
import Data.List (isInfixOf, isPrefixOf)

import ScratchPadKeys (scratchPadList, manageScratchPads, scratchPadKeys)
import System.IO (hPutStrLn)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, PP(..), dzenColor, wrap, shorten, dzenStrip, defaultPP, pad)
import XMonad.Hooks.ManageHelpers (doFullFloat, doCenterFloat, isFullscreen)
import XMonad.Hooks.UrgencyHook (withUrgencyHookC, withUrgencyHook, dzenUrgencyHook)
import XMonad.Util.EZConfig -- (additionalKeysP)

import XMonad.Core

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run (spawnPipe)

import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile

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
    xmonad $ defaultConfig
        { terminal = "urxvtcd"
        , normalBorderColor = myInactiveBorderColor
        , focusedBorderColor = myActiveBorderColor
        , borderWidth = myBorderWidth
        , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = smartBorders $ avoidStruts $ myLayoutHook
        , logHook = dynamicLogWithPP $ myDzenPP myStatusBarPipe
        , modMask = mod4Mask
        , mouseBindings = myMouseBindings
        , XMonad.Core.workspaces = myWorkspaces
        , startupHook = setWMName "LG3D"
        , focusFollowsMouse = True
        } `additionalKeysP` myKeys

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
-- myUrgencyHook = withUrgencyHook dzenUrgencyHook
--   { args =
--       [ "-x", "0", "-y", "1180", "-h", "20", "-w", "1920"
--       , "-ta", "c"
--       , "-fg", "" ++ myUrgencyHintFgColor ++ ""
--       , "-bg", "" ++ myUrgencyHintBgColor ++ ""
--       , "-fn", "" ++ myFont ++ ""
--       ]
--   }

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

--{{{ Keybindings
myKeys :: [(String, X())]
myKeys =
    [ ("M4-o", spawn "dmenu_run -nb '#222222' -nf '#aaaaaa' -sb '#93d44f' -sf '#222222'")  --Uses a colourscheme with dmenu
    , ("M4-w", spawn "firefox")
    -- , ("M4-c", spawn "chromium --app='https://calendar.google.com'")
    , ("M4-f", spawn "urxvt -e mc")
    , ("M4-r", spawn "urxvt --title irssi -e screen irssi")
    , ("M4-o", spawn "urxvt --title ncmpcpp -e ncmpcpp")
    , ("M4-m", spawn "chromium --app='https://mail.google.com'")
    -- , ((modm, xK_n), spawn "chromium --app='https://simple-note.appspot.com'")
    -- , ((modm, xK_g), spawn "chromium --app='https://app.nirvanahq.com'")
    , ("xK_Print", spawn "scrot")
    -- , ((modm, xK_v), spawn "VirtualBox")
    , ("xF86XK_AudioMute", spawn "amixer -q set PCM toggle")
    , ("xF86XK_AudioRaiseVolume", spawn "amixer -q set PCM 2+")
    , ("xF86XK_AudioLowerVolume", spawn "amixer -q set PCM 2-")
    , ("xF86XK_AudioPlay", spawn "exaile -t")
    , ("xF86XK_AudioStop", spawn "exaile -s")
    , ("xF86XK_AudioNext", spawn "exaile -n")
    , ("xF86XK_AudioPrev", spawn "exaile -p")
    , ("M4y", sendMessage ToggleStruts)
    , ("M4u", sendMessage MirrorShrink)
    , ("M4i", sendMessage MirrorExpand)
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
    , ppLayout = dzenColor myFgColor"" .
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

