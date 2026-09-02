# omarchy-media-float

Source for three [Omarchy](https://omarchy.org/) plugins that play media in a
small window floating above everything, pinned so it follows you across
workspaces.

| Tool | Repo | What it picks from |
|---|---|---|
| Plex | [omarchy-media-float-plex](https://github.com/jcputney/omarchy-media-float-plex) | your library, poster art and synopsis while you type |
| Twitch | [omarchy-media-float-twitch](https://github.com/jcputney/omarchy-media-float-twitch) | live follows first, then categories, top, search |
| YouTube | [omarchy-media-float-youtube](https://github.com/jcputney/omarchy-media-float-youtube) | Watch Later and part-watched, subscriptions, search |

They install and work separately. Installed together they share one player
window, one set of overlay controls and one Hyprland rules file.

## Install

Pick the one you want — nothing here depends on the others. Plex, for example:

```bash
omarchy plugin add https://github.com/jcputney/omarchy-media-float-plex.git --enable
~/.config/omarchy/plugins/io.github.jcputney.media-float-plex/setup
omarchy restart shell
```

Swap `plex` for `twitch` or `youtube` in both lines. Each repo's README covers
signing in and the keybindings to add.

`omarchy plugin add` hands the shell the picker overlay; `setup` installs the
command, the Hyprland window rules, and checks your dependencies. The restart is
needed because the shell caches plugin QML once it has loaded it.

This repo is the source. You do not install from it.

## Why three repos out of one

`omarchy plugin add` is a plain `git clone`, and `omarchy plugin update` is
`fetch` + `merge --ff-only`. Neither runs `git submodule update`, so shared code
behind a submodule would arrive as an empty directory. There is also no
dependency field in the plugin manifest — a plugin cannot ask for another one.

So the shared code lives here once and is copied into each published repo:

```bash
tools/publish            # build all three into dist/
tools/publish plex       # build one
```

`publish` runs `omarchy-plugin-validate` on each result, which is the same check
`omarchy plugin add` runs before it will install anything.

## Layout

```
core/
  float-overlay.sh       shared machinery: mpv session, window, picker
  float-overlay          the hide/show/resize/quit command
  Picker.qml             the overlay picker the shell loads
  setup                  the installer each published repo ships
  hypr/media-float.lua   the Hyprland rules setup writes
plex/  twitch/  youtube/
  <tool>-float           the front end
  manifest.json          plugin manifest
  README.md              that repo's readme
tools/publish            builds dist/
```

## How a menu works

The tools do not know which picker they are drawing on. Each menu level is one
call to `pick <rows-file> <prompt>`, and rows are TSV:

```
<display>  <image-url|->  <info|->  <value…>
```

`pick` goes one of two ways:

- **Overlay** — when this tool's plugin is installed and enabled. Rows are
  converted to JSON, `omarchy-shell shell summon` opens `Picker.qml`, and the
  chosen row's value comes back through a file.
- **fzf** — otherwise. The same rows go to fzf inside a floating ghostty window,
  which draws thumbnails with the Kitty graphics protocol.

The mode is decided once per invocation by the parent process and inherited, so
a menu cannot flip backends halfway through a drill-down.

## Licence

MIT.
