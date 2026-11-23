# My_macos_settings

Bootstrap a fresh Mac to match this one.
Plan and step status: [docs/roadmap.md](docs/roadmap.md).

## Rules for agents

1. Working mode
   1. Before implementing, describe the plan and wait for approval.
   2. Do one roadmap step at a time.
   3. After each step, report what was done and stop for review.
2. Decisions
   1. Record decisions here or in `docs/roadmap.md`.
   2. Do not create `docs/architecture/` or `docs/use-cases/`.
3. Lines
   1. Keep lines in this file and in `docs/` short.
   2. Append new list items; do not renumber old ones.
4. Git commits
   1. Never add Claude to commits or PRs.
   2. No `Co-Authored-By` trailer, no "Generated with" line.
   3. Only the default git author.

## Purpose

1. Same macOS settings on every Mac.
2. Same applications on every Mac.
3. Carry user data over to a fresh system.
   1. Firefox profile, so the browser continues seamlessly.
   2. SSH keys.

## Tools

1. `install_mise.sh` is the only non-mise script.
   1. Installs mise via the official `https://mise.run` installer.
   2. Downloads this repo as a GitHub tarball (no git needed).
   3. Unpacks it into `./My_macos_settings` under the current folder.
   4. Runs `mise trust` on the repo config.
   5. Explains what `mise run bootstrap` will do, asks to run it.
   6. Reads the answer from `/dev/tty` (stdin is the curl pipe).
2. mise does everything else.
   1. Installs Homebrew (this also brings Xcode CLT and git).
   2. Converts the unpacked folder into a git clone.
   3. Installs apps via `mise bootstrap` packages (brew, cask, mas).
   4. Applies macOS settings via `mise bootstrap` settings.
   5. Runs backup and restore tasks.
3. mise never runs in the background.
   1. No `[bootstrap.services]`, no launchd agents.
   2. No `mise activate` prompt hook.
   3. Tools reach PATH through the shims directory only.

## Fresh Mac flow

```sh
curl -fsSL https://raw.githubusercontent.com/HardDie/My_macos_settings/main/install_mise.sh | bash
```

1. The script installs mise and unpacks the repo.
2. It asks before running `mise run bootstrap`.
3. Restores run as separate tasks after bootstrap.

## Dotfiles

1. Dotfiles live in `HardDie/My_linux_settings`, not here.
2. A mise task clones it into `~/My_linux_settings`.
3. Its `makelinks.sh` creates the links.

## Backups

1. Format: `.tar.zst`.
2. Archives are never committed to this repo.
3. The user copies archives to the new Mac by hand.
4. Tasks:
   1. `mise run backup-firefox` / `mise run restore-firefox`.
   2. `mise run backup-ssh` / `mise run restore-ssh`.

## Layout

```
install_mise.sh   # curl entry point: mise + repo tarball
mise.toml         # tools, bootstrap packages and settings, short tasks
mise-tasks/       # longer file tasks
docs/roadmap.md   # steps, status, decisions
README.md         # user guide
.github/workflows/ci.yml  # CI: step 1 on a macOS runner
```
