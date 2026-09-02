-- Personal window rules.

-- ── Video overlays ────────────────────────────────────────────────────────────
-- `plex-float`, `twitch-float` and `youtube-float` all launch mpv with a
-- dedicated --wayland-app-id. That app id is what keeps these windows out of
-- Omarchy's generic centered floating rules for mpv, so video lands in the
-- corner instead of mid-screen.
--
-- pin is the part that matters: a pinned floating window stays put while you
-- switch workspaces, so the video is visible on all of them.
--
-- Sizes are derived from monitor_w rather than hardcoded, so the overlay covers
-- the same share of either 4K panel: a quarter of the width, 16:9
-- (monitor_w*9/64 is monitor_w/4 * 9/16), inset 40px from the bottom-right.
--
-- This rule only sets the opening size. Once mpv reports the real video aspect,
-- `plex-float` resizes the window to match it, so a 2.40:1 film gets a 2.40:1
-- window rather than one with black bars. SUPER+ALT+O cycles the preset and
-- SUPER + right-drag resizes it freehand; keep_aspect_ratio holds the shape
-- during a drag.
o.window("^(PlexFloat|TwitchFloat|YouTubeFloat)$", {
  tag = "-default-opacity",
  float = true,
  pin = true,
  no_initial_focus = true,
  keep_aspect_ratio = true,
  no_dim = true,
  border_size = 0,
  opacity = "1 1",

  -- Don't blank the screen or lock while something is playing.
  idle_inhibit = "always",

  size = { "(monitor_w/4)", "(monitor_w*9/64)" },
  move = { "(monitor_w-monitor_w/4-40)", "(monitor_h-monitor_w*9/64-40)" },
})

-- ── Overlay menus (plex / twitch / youtube) ─────────────────────────────────
-- The menus are fzf running in a ghostty window, because a terminal is what can
-- draw real thumbnails (Kitty graphics protocol) in the preview pane. Floated,
-- centred and stripped of chrome, it reads as a launcher panel rather than a
-- terminal. Ghostty is launched with --class=com.float.Picker.
o.window("^com\\.float\\.Picker$", {
  tag = "-default-opacity",
  float = true,
  center = true,
  border_size = 0,
  rounding = 12,
  opacity = "1 1",
  no_dim = true,
  size = { "(monitor_w*54/100)", "(monitor_h*60/100)" },
})
