module Main where

import           XMonad
import           XMonad.Actions.UpdatePointer
import           XMonad.Hooks.ManageDocks
import qualified XMonad.Hooks.EwmhDesktops      as Ewmh
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Spiral
import           XMonad.Layout.PerWorkspace
import           XMonad.Util.EZConfig


main :: IO ()
main  = xmonad $ Ewmh.ewmh def
  { terminal    = myTerminal
  , modMask     = mod4Mask
  , borderWidth = 2
  , manageHook  = composeAll
        [ manageHook def
        , role =? "browser"     --> doShift "2"
        , role =? "pop-up"      --> doFloat
        , appName =? "Steam"    --> doShift "9"
        , appName =? "zenity"   --> doFloat
        , appName =? "emacs"    --> doShift "1"
        , fullscreenManageHook
        ]
  , layoutHook  = let full = noBorders (fullscreenFull Full)
                   in onWorkspace "9" full $ smartBorders $ avoidStruts $
                       Tall 1 (3/100) (1/2) ||| spiral (6/7) ||| full
  , logHook     = dynamicLogWithPP def >> updatePointer (0.75, 0.75) (0.75, 0.75)
  , handleEventHook = mconcat
        [ handleEventHook def
        , fullscreenEventHook
        ]
  , startupHook = setWMName "LG3D"
  }
  `additionalKeysP`
  [ ("M-p",                     spawn menu)
  , ("M-q",                     spawn "xmonad --restart")
  , ("M-S-l",                   spawn "i3lock -c 000000")
  , ("<XF86AudioMute>",         spawn "pamixer -t")
  , ("<XF86AudioRaiseVolume>",  spawn "pamixer -i 5")
  , ("<XF86AudioLowerVolume>",  spawn "pamixer -d 5")
  ]

    where
        role = stringProperty "WM_WINDOW_ROLE"
        menu = "dmenu_run -fn 'FiraCode-10' -b"
        myTerminal = "kitty"
