You are working on the `ani` script — a bash CLI for streaming anime from AllAnime.

**Always read the full script first** before making changes:
```
Read bin/ani
```
$ARGUMENTS

---

## Architecture

- **API**: GraphQL POST to AllAnime — search, episode list, embed URL resolution
- **Providers**: 5 video providers tried in parallel. Provider IDs are hex-encoded. Some use AES-256-CTR encryption.
- **Caching**: Episodes downloaded to temp dir with `.done` marker. Prefetch downloads next episode while watching.
- **Playback loop**: After play, fzf menu (next/replay/previous/select/change_quality/quit). Uses `fzf --listen` for live header updates.
- **History**: Tab-separated file at `~/.local/state/ani-cli/ani-hsts`

## Gotchas

- **`$(...)` loses globals**: Command substitution creates a subshell. Use file redirects to preserve globals.
- **`while` condition exit codes**: The playback loop's last command determines if the body runs. Functions used there must always return 0.
- **Background subshells**: `( ... ) &` used for prefetch, poller, providers. Each is isolated.
- **`ffmpeg -y`**: Overwrites output files — be careful with parallel downloads to the same path.
- **History field positions**: Differ between search and history display contexts.
- **Player filtering**: vlc/android/iSH can't handle m3u8 with custom referrer — filtered in `select_quality`.
