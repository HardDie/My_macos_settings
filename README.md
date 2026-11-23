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

List them any time with `mise tasks`.

## Notes

- Safe to re-run: each step skips what is already done.
- mise never runs in the background. It works only when you call it.
- Plan and progress: [docs/roadmap.md](docs/roadmap.md).
