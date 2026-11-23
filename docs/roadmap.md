# Roadmap

Status values: Planned, In progress, Done.
Each step: discuss, approve, implement, review.

## Decisions

1. mise is the single entry point after `install_mise.sh`.
2. `install_mise.sh` installs only mise and fetches the repo tarball.
3. Homebrew is installed by a mise task, not by the script.
4. The repo is public on GitHub: `HardDie/My_macos_settings`.
5. The repo unpacks into `./My_macos_settings` where curl runs.
6. The script asks before running `mise run bootstrap`.
7. mise never runs as a daemon.
   1. No services, no launchd agents, no `mise activate`.
   2. Shims on PATH instead.
8. Dotfiles stay in `My_linux_settings`, linked by `makelinks.sh`.
9. Backup archives are `.tar.zst`, never committed.
10. Task names: `backup-<thing>` and `restore-<thing>`.
11. No ADR or use-case folders; decisions live here.
12. No GPG: `~/.gnupg` does not exist on the source Mac.
13. Always use the latest mise; no `min_version` pin.
14. `git-init` uses the HTTPS remote (no SSH keys yet).
15. CI covers step 1 only; decide CI for each later step.
16. `install_mise.sh` takes `REF` (branch or SHA), default `main`.
17. `[env] _.path` adds `~/.local/bin` so tasks can call `mise`.
18. Never run plain `mise bootstrap`; it runs our `bootstrap` task (loop).
19. No App Store apps; Homebrew casks and GitHub releases only.
20. App groups are `env` tags in `[bootstrap.packages]`.
21. `bootstrap` runs its steps one by one, not as parallel `depends`.

## Steps

| # | Step | Status |
|---|---|---|
| 0 | Docs: `CLAUDE.md`, this roadmap | Done |
| 1 | Entry point: `install_mise.sh`, README, `bootstrap` task | Done |
| 1b | CI on GitHub Actions for step 1 | Done |
| 2 | macOS settings | Done |
| 3 | Applications | Done |
| 4 | Runtimes and CLI tools in mise | Planned |
| 5 | Dotfiles | Planned |
| 6 | Firefox backup and restore | Planned |
| 7 | SSH backup and restore | Planned |
| 8 | Other data backups | Planned |
| 9 | End-to-end test | Planned |
| 10 | Launchpad folders | Planned |

### 0. Docs

1. Goal: agree on purpose, tools and plan.
2. Deliverables: `CLAUDE.md`, `docs/roadmap.md`.

### 1. Entry point

1. Goal: one curl command starts everything.
2. Deliverables:
   1. `install_mise.sh`: mise, repo tarball, `mise trust`, ask.
   2. Minimal `mise.toml`.
   3. `bootstrap` task: install Homebrew if missing.
   4. `bootstrap` task: convert the folder into a git clone.
   5. `README.md`: steps and how to run them.
3. Discuss first:
   1. Is `mise bootstrap` experimental in the installed mise?
   2. Pin a mise version or take latest?
4. Done when: the script runs twice without harm.
5. Answers:
   1. `mise bootstrap` needs no experimental flag (to confirm in step 2).
   2. No version pin; always latest.
6. Tested with a sandboxed `HOME` and a tarball copy.

### 1b. CI

1. Goal: verify step 1 on a GitHub macOS runner.
2. Workflow: `.github/workflows/ci.yml`, on every push.
3. Jobs:
   1. `lint`: shellcheck on Ubuntu.
   2. `fresh-mac`: `macos-latest`.
4. `fresh-mac` flow:
   1. Uninstall Homebrew to simulate a fresh Mac.
   2. Run the one-liner pinned to the pushed commit.
   3. Run `mise run bootstrap`.
   4. Check brew, the git remote and upstream.
   5. Re-run both; each step must report a skip.
5. Not covered: Xcode CLT install (preinstalled on runners).
6. No README badge.

### 2. macOS settings

1. Goal: settings applied by `[bootstrap.settings.macos]`.
2. Discuss first: the list of settings, one by one.
3. Candidates found so far:
   1. Dark mode.
   2. 24-hour clock; menu bar shows day of week, no date.
   3. Key repeat instead of accent popup.
   4. Autocorrect off.
   5. Dock autohide, icon size 64.
   6. Input sources ABC and RussianWin; Globe key switches.
   7. Control Center items shown and hidden.
   8. Custom keyboard shortcuts (`symbolichotkeys`).
4. Done when: a fresh account matches after bootstrap.
5. Discuss first: CI check or not.
6. Applied (task `macos-settings`):
   1. Dark mode.
   2. 24-hour time.
   3. Key repeat instead of the accent popup.
   4. Autocorrect off (apps and web).
   5. Caps Lock changes input source via the fn remap (item 11).
   6. Dock autohide; no recent apps.
   7. Screen recordings show clicks.
   8. Globe key changes input source.
   9. Input sources ABC and RussianWin (needs a logout).
   10. F4 opens Launchpad (shortcut 160).
   11. Built-in keyboard: Caps Lock → fn, fn/Globe → Control.
7. Skipped:
   1. Menu bar clock: values equal macOS defaults.
   2. Dock icon size: default 48 is fine.
   3. Finder list view: easy to change by hand.
   4. Control Center items: macOS writes them itself.
   5. Language and region: Setup Assistant asks.
   6. Other keyboard shortcuts: all at defaults.
   7. Trackpad: all at defaults.
   8. `TISRomanSwitchState`: no effect while Caps Lock is fn.
8. Manual (README): home folder in Finder sidebar Favorites.
   1. Stored in a protected binary file, not in `defaults`.
9. `mise bootstrap macos defaults` needs no experimental flag.
10. CI: yes.
   1. `status` must show no `differs`.
   2. The re-run must write nothing.
11. Modifier remaps live in the current-host domain (per Mac).

### 3. Applications

1. Goal: apps installed by `[bootstrap.packages]`.
2. Discuss first:
   1. Keep or drop each app.
   2. Install method: brew, cask, mas, or manual.
3. Apps without a cask go into a manual list in the README.
4. Discuss first: CI check or not (`mas` cannot run in CI).
5. Groups (task `mise run apps`):
   1. Core, always: Firefox, KeePassXC, Obsidian, VLC.
   2. Core, always: Telegram, Discord, Transmission, Scroll Reverser.
   3. Core, always: Alacritty (GitHub release).
   4. Dev: Godot, IntelliJ IDEA, Meld.
   5. Media: GIMP, Audacity.
   6. Streaming: OBS, Google Chrome, ytmemchat (GitHub release).
6. Selection:
   1. `mise run apps` asks y/N per optional group.
   2. `mise run apps -- dev media` skips the questions.
7. Casks: mise `brew-cask` with `adopt` and `homebrew_metadata`.
   1. `adopt` takes over hand-installed apps that match.
   2. `homebrew_metadata` lets `brew upgrade` update them.
8. GitHub apps: `mise-tasks/install-github-app`.
   1. Takes the latest release; skips if the version matches.
   2. Checks `SHA256SUMS.txt` when the release has one.
   3. Alacritty cask is disabled (Gatekeeper); its release has no sums.
9. Manual (README):
   1. LiveSplit One: Chrome → Install page as app (web app).
   2. Scroll Reverser: Accessibility permission.
10. Dropped: Brave, Cursor, Antigravity, IINA, Shotcut, Mp3tag.
11. Dropped: TIDAL, Jellyfin, Final Cut Pro, Telegram Desktop.
12. Dropped: LocalSend, balenaEtcher, Pages, Numbers, Shadowrocket.
13. Dropped: Steam, Battle.net, Whisky, Rulka, FourSouls, socialstream.
14. CI: no. `bootstrap` in CI sets `BOOTSTRAP_SKIP_APPS=1`.

### 4. Runtimes and CLI tools

1. Goal: language runtimes and CLIs pinned in mise `[tools]`.
2. Discuss first:
   1. What moves from brew to mise.
   2. Adding the shims line to `.zshrc` in `My_linux_settings`.
3. Discuss first: CI check or not.
4. Core Go tools via the mise `go:` backend (from step 3):
   1. `github.com/HardDie/myTldr`.
   2. `github.com/HardDie/gsplitter`.
   3. `github.com/HardDie/ghashdeep`.

### 5. Dotfiles

1. Goal: `mise run dotfiles` clones and links.
2. Discuss first: HTTPS or SSH clone (SSH needs step 7 first).
3. `makelinks.sh` uses `stow`; install it before linking.
4. PATH check after linking:
   1. Need `~/.local/bin` (mise) and `/opt/homebrew/bin`.
   2. Missing entries get appended to the end of `.zshrc`.
   3. `.zshrc` is a symlink into `My_linux_settings`.
   4. Appending changes that repo; decide where to commit it.
5. Discuss first: CI check or not.

### 6. Firefox

1. Goal: `backup-firefox` and `restore-firefox`.
2. Backup: Firefox closed, profile folder to `.tar.zst`.
3. Restore: unpack, write `profiles.ini` and `installs.ini`.
4. Discuss first:
   1. What to exclude (caches, crash reports, telemetry).
   2. Where the archive is written.
   3. The empty leftover profile `48q00cyt.default`.
5. Discuss first: CI check or not.

### 7. SSH

1. Goal: `backup-ssh` and `restore-ssh`.
2. Restore must set strict permissions (700 dir, 600 keys).
3. Discuss first: plain archive or passphrase-protected.
4. Discuss first: CI check or not.

### 8. Other data backups

1. Goal: pick more data worth carrying over.
2. Candidates (size on the source Mac):
   1. Shell history `~/.zsh_history` (228K).
   2. User fonts `~/Library/Fonts` (Hack, 1.2M).
   3. OBS scenes and profiles (622M with logs and cache).
   4. VSCodium settings and extension list (520K).
   5. Cursor settings (5.8G, mostly cache).
   6. JetBrains settings (2.8G, mostly cache).
   7. Obsidian vaults in `~/Project/obsidian`.
   8. Transmission and GIMP settings.
   9. Claude Code config `~/.claude` (738M).
   10. Project folders under `~/Project`.
3. Not worth it:
   1. Telegram, Discord, TIDAL: cloud-synced, just log in.
   2. Steam, Battle.net games: download again.
   3. Keychain: sync via iCloud Keychain instead.
   4. Colima VM: recreate.
4. Discuss first: which candidates to keep.
5. Discuss first: CI check or not.

### 9. End-to-end test

1. Goal: the full flow works on a clean system.
2. Discuss first: new user account or a VM.

### 10. Launchpad folders

1. Goal: same Launchpad layout on every Mac.
2. Folders:
   1. Other, Other2: hide the default macOS apps.
   2. Tools, Games: group the installed apps.
3. Works on macOS 15 only; macOS 26 removed Launchpad.
4. Assumption: the new Mac runs the same macOS version.
5. Discuss first: how to script the layout; CI check or not.
