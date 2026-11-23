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

## Steps

| # | Step | Status |
|---|---|---|
| 0 | Docs: `CLAUDE.md`, this roadmap | Done |
| 1 | Entry point: `install_mise.sh`, README, `bootstrap` task | Done |
| 2 | macOS settings | Planned |
| 3 | Applications | Planned |
| 4 | Runtimes and CLI tools in mise | Planned |
| 5 | Dotfiles | Planned |
| 6 | Firefox backup and restore | Planned |
| 7 | SSH backup and restore | Planned |
| 8 | Other data backups | Planned |
| 9 | End-to-end test | Planned |

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

### 3. Applications

1. Goal: apps installed by `[bootstrap.packages]`.
2. Discuss first:
   1. Keep or drop each app.
   2. Install method: brew, cask, mas, or manual.
3. Apps without a cask go into a manual list in the README.

### 4. Runtimes and CLI tools

1. Goal: language runtimes and CLIs pinned in mise `[tools]`.
2. Discuss first:
   1. What moves from brew to mise.
   2. Adding the shims line to `.zshrc` in `My_linux_settings`.

### 5. Dotfiles

1. Goal: `mise run dotfiles` clones and links.
2. Discuss first: HTTPS or SSH clone (SSH needs step 7 first).
3. `makelinks.sh` uses `stow`; install it before linking.
4. PATH check after linking:
   1. Need `~/.local/bin` (mise) and `/opt/homebrew/bin`.
   2. Missing entries get appended to the end of `.zshrc`.
   3. `.zshrc` is a symlink into `My_linux_settings`.
   4. Appending changes that repo; decide where to commit it.

### 6. Firefox

1. Goal: `backup-firefox` and `restore-firefox`.
2. Backup: Firefox closed, profile folder to `.tar.zst`.
3. Restore: unpack, write `profiles.ini` and `installs.ini`.
4. Discuss first:
   1. What to exclude (caches, crash reports, telemetry).
   2. Where the archive is written.
   3. The empty leftover profile `48q00cyt.default`.

### 7. SSH

1. Goal: `backup-ssh` and `restore-ssh`.
2. Restore must set strict permissions (700 dir, 600 keys).
3. Discuss first: plain archive or passphrase-protected.

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

### 9. End-to-end test

1. Goal: the full flow works on a clean system.
2. Discuss first: new user account or a VM.
