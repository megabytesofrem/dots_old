import XMonad hiding ( (|||) )

-- Extended Window Manager Hints (EWMH)
import XMonad.Hooks.EwmhDesktops

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CycleWS

-- Util
import XMonad.Util.Ungrab
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

-- Layout
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Renamed
import XMonad.Layout (Tall)

-- Hask
import Data.Monoid (mempty)
import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal = "xfce4-terminal"
myModMask = mod4Mask -- Super
myBorderWidth = 3

-- Default workspaces
-- Tagging: ["a", "b", "c"] ++ map show [4..9]
-- myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 -- workspaces
 [((m .|. modm, k), windows $ onCurrentScreen f i)
       | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
       , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
  [
    -- mod+button1 - set to floating mode, and move by dragging 
    ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                    >> windows W.shiftMaster)
    -- mod+button3 - set to floating mode, resize by dragging
  , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                    >> windows W.shiftMaster)
  ]

-- Layouts
-- More info: https://wiki.haskell.org/Xmonad/Config_archive/Template_xmonad.hs_(0.9)
myLayout = renamed [Replace "[||=]"] tall ||| renamed [Replace "[M=]"] (Mirror tall) ||| renamed [Replace "[F]"] Full
  where
    -- Custom layouts
    tall = Tall 1 (3/100) (1/2)

-- Window rules
myManageHook = composeAll
  [ className =? "Krita"          --> doFloat 
  , className =? "Nemo"           --> doFloat 
  , resource  =? "desktop_window" --> doIgnore ]

-- Event handling
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

-- For now since we don't care, use mempty from Data.Monoid
myEventHook = mempty

myStartupHook = do
  -- spawn stuff when xmonad starts up
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom &"

  -- start polkit-gnome
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = " "
    , ppTitle           = wrap (white    "[") (white    "]") . ppWindow 
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap (purple     "[") (purple     "]") . ppWindow
    , ppHidden          = white . wrap " " " "
    , ppHiddenNoWindows = lowWhite . wrap " " " "
    , ppUrgent          = red
    }
    where
      ppWindow :: String -> String
      ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

      white    = xmobarColor "#ffffff" ""
      lowWhite = xmobarColor "#fbfbfb" ""
      purple   = xmobarColor "#c678dd" ""
      red      = xmobarColor "#ff0000" ""

-- Two status bars for each monitor
leftSB = statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 0 ~/.config/xmobar/xmobar_left" (pure . marshallPP 0 $ myXmobarPP)
rightSB = statusBarPropTo "_XMONAD_LOG_2" "xmobar -x 1 ~/.config/xmobar/xmobar_right" (pure . marshallPP 1 $ myXmobarPP)

main = do
    --hRight <- spawnPipe "xmobar -x 1"

    xmonad . ewmh . ewmhFullscreen . withSB (leftSB <> rightSB) $ docks def 
        { terminal = myTerminal
        , workspaces = withScreens 2 ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        , modMask  = mod4Mask
        , borderWidth = myBorderWidth
        -- key bindings
        , keys = myKeys
        , mouseBindings = myMouseBindings
        -- hooks and layouts
        , layoutHook = avoidStruts $ myLayout
        , handleEventHook = myEventHook
        , startupHook = myStartupHook
        }
        `additionalKeysP`
        [ ("M-<Return>", spawn "xfce4-terminal")  
        , ("M-r",        spawn "rofi -show drun -show-icons")
        , ("M-p",        unGrab *> spawn "maim -s -u | xclip -selection clipboard -t image/png -i")

        -- move focus to previous/next window
        , ("M-<Left>",   windows W.focusUp)
        , ("M-<Right>",  windows W.focusDown)
        , ("M-S-<Left>", sendMessage Shrink)
        , ("M-S-<Right>",sendMessage Expand)

        -- swap windows
        , ("M-S-j", windows W.swapDown)
        , ("M-S-k", windows W.swapUp) -- swap with previous

        -- switch screens/ws
        , ("M-,",   prevScreen)
        , ("M-S-,", prevWS)

        , ("M-.",   nextScreen)
        , ("M-S-.", nextWS)

        -- switch between layouts
        , ("M-t", withFocused $ windows . W.sink)
        , ("M-g", sendMessage $ JumpToLayout "[||=]")
        , ("M-m", sendMessage $ JumpToLayout "[M=]")
        , ("M-f", sendMessage $ JumpToLayout "[F]")

        , ("M-q", kill)

        -- recompile/restart/quit xmonad
        , ("M-S-c", spawn "xmonad --recompile")
        , ("M-S-r", spawn "xmonad --restart")
        , ("M-S-q", io (exitWith ExitSuccess)) -- quit
        ] 
