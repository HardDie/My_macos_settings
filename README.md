# My macOS settings

Set up a fresh Mac with the same settings and apps as my current one, and carry over browser data.
Everything after the first command is done by [mise](https://mise.jdx.dev).

## Fresh Mac: quick start

Open Terminal, go to the folder where the repo should live, and run:

```sh
curl -fsSL https://raw.githubusercontent.com/HardDie/My_macos_settings/main/install_mise.sh | bash
```

The script:

1. Installs mise into `~/.local/bin/mise`.
2. Downloads this repo into `./My_macos_settings` (no git needed).
3. Trusts the repo's `mise.toml`.
4. Shows what bootstrap will do and asks `Run it now? [y/N]`.

Answering `y` runs bootstrap, which:

1. Installs Homebrew. It asks for your password once and also installs the Xcode Command Line Tools (this brings `git`).
2. Turns `./My_macos_settings` into a git clone, so `git pull` works.
3. Applies macOS settings (dark mode, Dock, keyboard, input sources and more; see `mise.toml`).
4. Installs apps: Core always, then asks about each optional group (see [Apps](#apps)).

Then log out and back in, so the keyboard layouts (ABC and Russian) and the Caps Lock → fn remap take effect.

## If you answered "no"

Run bootstrap later:

```sh
cd My_macos_settings
~/.local/bin/mise run bootstrap
```

Until your shell config adds `~/.local/bin` to `PATH`, call mise by its full path as shown.

## Tasks

| Command | What it does |
|---|---|
| `mise run bootstrap` | Runs every setup step below |
| `mise run install-brew` | Installs Homebrew if missing |
| `mise run git-init` | Turns the downloaded folder into a git clone |
| `mise run macos-settings` | Applies macOS settings, reloads the Dock and menu bar |
| `mise run apps` | Installs Core apps and asks about optional groups |
| `mise run install-github-app -- <repo> <regex> <App>` | Installs an app from the latest GitHub release |

Check which settings are applied with `mise bootstrap macos defaults status`.

List them any time with `mise tasks`.

## Apps

| Group | Apps | Installed |
|---|---|---|
| Core | Firefox, KeePassXC, Obsidian, VLC, Telegram, Discord, Transmission, Scroll Reverser, Alacritty | always |
| Dev | Godot, IntelliJ IDEA, Meld | if chosen |
| Media | GIMP, Audacity | if chosen |
| Streaming | OBS, Google Chrome, ytmemchat | if chosen |

Install a group later, without questions:

```sh
mise run apps -- dev media
```

Alacritty and ytmemchat come from their latest GitHub releases; the rest are Homebrew casks.
Apps installed by hand are taken over when they match the cask, so re-running is safe.

## Manual steps

Things that cannot be set from the command line:

1. Home folder in the Finder sidebar: Finder → Settings (⌘,) → Sidebar → under Favorites, tick your user name (house icon).
2. Scroll Reverser: allow it in System Settings → Privacy & Security → Accessibility.
3. LiveSplit One (Streaming): open https://one.livesplit.org in Google Chrome → ⋮ → Cast, save and share → Install page as app.

## Notes

- Safe to re-run: each step skips what is already done.
- mise never runs in the background. It works only when you call it.
- Plan and progress: [docs/roadmap.md](docs/roadmap.md).
