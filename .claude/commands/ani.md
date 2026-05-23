You are working on the `ani` script — a bash CLI (~880 lines) for streaming anime from AllAnime.

**Always read the full script first** before making changes:
```
Read bin/ani
```
$ARGUMENTS

---

## Setup Globals (lines ~648-680)

| Variable | Default | Env Override | Purpose |
|----------|---------|-------------|---------|
| `agent` | Firefox UA | — | HTTP User-Agent |
| `allanime_refr` | `https://allmanga.to` | — | Referrer header |
| `allanime_base` | `allanime.day` | — | API base domain |
| `allanime_api` | `https://api.allanime.day/api` | — | GraphQL endpoint |
| `allanime_key` | SHA256 of `Xot36i3lK3:v1` | — | AES-256-CTR key for decrypting source URLs |
| `mode` | `sub` | `ANI_CLI_MODE` | sub/dub preference |
| `quality` | `best` | `ANI_CLI_QUALITY` | Video quality |
| `player_function` | platform-dependent | `ANI_CLI_PLAYER` | mpv, vlc, iina, download, debug, etc. |
| `download_dir` | `.` | `ANI_CLI_DOWNLOAD_DIR` | Download target |
| `histfile` | `~/.local/state/ani-cli/ani-hsts` | `ANI_CLI_HIST_DIR` | History file path |
| `no_detach` | `0` | `ANI_CLI_NO_DETACH` | Don't background player |
| `exit_after_play` | `0` | `ANI_CLI_EXIT_AFTER_PLAY` | Exit after single episode |
| `skip_intro` | `0` | `ANI_CLI_SKIP_INTRO` | Use ani-skip |
| `use_external_menu` | `0` | `ANI_CLI_EXTERNAL_MENU` | 0=fzf, 1=rofi, 2=dmenu |
| `multi_selection_flag` | `-m` / `-multi-select` | `ANI_CLI_MULTI_SELECTION` | fzf/rofi multi-select flag |
| `has_image_preview` | `0` (1 in kitty) | — | Kitty icat thumbnail preview |

## CLI Flags (lines ~683-754)

| Flag | Sets variable | Effect |
|------|-------------|--------|
| `-c` | `search=history` | Continue from history |
| `-u` | `search=history` + `unwatched_only=1` | History with new episodes only |
| `-d` | `player_function=download` | Download mode |
| `-D` | — | Clear history |
| `-q <res>` | `quality` | Set video quality (best/worst/720p/1080p) |
| `-S <n>` | `index` | Select nth result directly |
| `-e/-r <n>` | `ep_no` | Episode number/range (e.g., `5`, `5-8`, `"5 6"`) |
| `--dub` | `mode=dub` | Dubbed audio |
| `--skip` | `skip_intro=1` | Skip intros with ani-skip |
| `--skip-title` | `skip_title` | Custom ani-skip query |
| `--no-detach` | `no_detach=1` | Foreground playback |
| `--exit-after-play` | `exit_after_play=1` | Exit after one episode |
| `--rofi` | `use_external_menu=1` | Use rofi |
| `--dmenu` | `use_external_menu=2` | Use dmenu |
| `-v` | `player_function=vlc` | Use VLC |
| `-s` | `player_function=syncplay` | Use Syncplay |
| `-N` | `search=nextep` | Next episode countdown |
| `-U` | — | Self-update |
| `<query>` | `query` | Search string |

## API — GraphQL over POST

All calls go to `POST https://api.allanime.day/api` with `Content-Type: application/json`, referrer `https://allmanga.to`.

### Queries

**Search** (`search_anime`):
```graphql
shows(search: $search, limit: 40, page: 1, translationType: $mode, countryOrigin: "ALL") {
  edges { _id name thumbnail availableEpisodes { sub dub raw } status __typename }
}
```
Output: `id \t title (X sub Y dub) \t thumbnail \t status`

**Episode list** (`episodes_list`):
```graphql
show(_id: $showId) { _id availableEpisodesDetail { sub: ["1","2",...] dub: [...] raw: [...] } status }
```
Sets globals: `latest_sub`, `latest_dub`, `show_status`, `mode`, `list_sub`, `list_dub`
Output: episode numbers (one per line) + mode on last line

**Episode embed** (`get_episode_url`):
```graphql
episode(showId: $showId, translationType: $mode, episodeString: $ep_no) { episodeString sourceUrls }
```
Two strategies: (1) persisted query hash via GET, (2) fallback to POST with GraphQL

**Thumbnail** (`fetch_thumbnail`):
```graphql
show(_id: $showId) { thumbnail }
```

### Response field: `status`
- `"Releasing"` — still airing
- `"Finished"` — completed

## Provider System (lines ~169-271)

5 providers tried in parallel (`generate_link` 1-5):

| # | Name | ID pattern | Format | Notes |
|---|------|-----------|--------|-------|
| 1 | wixmp | `Default :` | m3u8 (multi-quality) | Default provider, requires referrer |
| 2 | mp4upload | `Mp4 :` | mp4 | Direct link extraction |
| 3 | youtube | `Yt-mp4 :` | mp4 | Direct URL passthrough |
| 4 | sharepoint | `S-mp4 :` | mp4 | Direct download |
| 5 | filemoon | `Fm-mp4 :` | m3u8 | Encrypted payload, needs AES decryption |

Provider IDs are hex-encoded and decoded via `decode_provider_id` (custom hex-to-char map).

### Encryption
- `decode_tobeparsed()`: AES-256-CTR decryption using `allanime_key` — decodes base64 blob from API
- `get_filemoon_links()`: Separate AES-256-CTR with key_parts + iv from JSON payload
- `b64url_to_hex()`: Base64url → hex conversion for filemoon key/iv

### Quality Selection (`select_quality`)
Filters links by player compatibility (no m3u8 for vlc/android/iSH), then selects:
- `best` → first link (highest resolution)
- `worst` → last numeric resolution link
- Specific → grep match (e.g., `720p`)

Sets `$episode`, `$subs_flag`, `$refr_flag` based on selected link type.

## History File

**Path:** `~/.local/state/ani-cli/ani-hsts`
**Format:** Tab-separated, 5 fields:
```
ep_no \t id \t title (X sub Y dub) \t thumbnail_url \t status
```
- Old entries (4 fields, no status): auto-migrated by `migrate_status()`
- `status` is `"Releasing"` or `"Finished"` (may be empty for unmigrated entries)

## Key Functions

| Function | Lines | Purpose |
|----------|-------|---------|
| `nth()` | 40-64 | fzf/rofi/dmenu selection. Input: `num \t id \t title \t ...`. Returns: `id \t title` (fields 2,3). With preview: awk adds `$5="$1 $3"` for display, `{4}` = thumbnail for preview |
| `format_titles()` | 485-506 | AWK — truncates long names while preserving `(X sub Y dub)` and `- episode N` suffixes on `$3` |
| `search_anime()` | 372-388 | GraphQL search. Regex parses `_id`, `name`, `thumbnail`, `sub`, `dub`, `status` from JSON |
| `episodes_list()` | 405-437 | Fetches episode detail + status. Sets `latest_sub`, `latest_dub`, `show_status` globals. Outputs: ep_list + mode |
| `migrate_status()` | 465-506 | Runs on `ani -c`. Detects entries without status, fetches fresh data in parallel, updates title + status in history file. Uses inlined GraphQL query (doesn't depend on `$episodes_list_gql`) |
| `migrate_thumbnails()` | 447-463 | Validates thumbnail URLs, re-fetches broken ones. Preserves 5th field (status) |
| `process_hist_entry()` | 508-525 | Per history entry. Caching: if `status=="Finished"` AND `sub==dub`, skip API (construct ep_list from count). Else: `episodes_list` via file redirect (preserves globals), update title + status. Output: `id \t title - episode N \t thumbnail \t latest_ep \t status` |
| `update_history()` | 536-548 | Writes `ep_no \t id \t title \t thumbnail \t status` to history file (atomic via temp file + mv) |
| `get_episode_url()` | 328-369 | Resolves embed URL → direct stream. Tries persisted query (GET) then fallback (POST). Decrypts `tobeparsed` blobs. Runs 5 providers in parallel, selects by quality |
| `generate_link()` | 233-248 | Dispatches to provider. Decodes provider ID, calls `get_links` or `get_filemoon_links` |
| `get_links()` | 178-219 | Scrapes stream URLs from provider pages. Handles wixmp (m3u8), mp4upload, sharepoint. Extracts subtitles for wixmp |
| `select_quality()` | 250-271 | Filters by player compatibility, picks resolution. Sets `$episode`, `$subs_flag`, `$refr_flag` |
| `download()` | 550-568 | yt-dlp or ffmpeg for m3u8, aria2c for direct URLs |
| `play_episode()` | 570-619 | Logs, fetches URL if needed, launches player. Calls `update_history()` after |
| `play()` | 621-644 | Handles single episode and range playback (e.g., `-e 5-8`). Loops through range calling `play_episode()` |
| `time_until_next_ep()` | 389-400 | Queries animeschedule.net for next episode countdown |

## Data Flows

### Search path (`ani "query"`)
```
search_anime() → anime_list (4 fields: id, title, thumbnail, status)
  → nl + format_titles + nth (fzf selection)
  → extract id($1), title($2), thumbnail($3), status($4) from anime_list
  → episodes_list() → ep_list, mode
  → select episode → play_episode() → update_history()
```

### History path (`ani -c`)
```
migrate_status()      ← backfill missing status + refresh sub/dub counts
migrate_thumbnails()  ← fix broken thumbnail URLs
  → read history (5 fields per entry, parallel subshells)
  → process_hist_entry() per entry
    → if Finished && sub==dub: cached (no API call)
    → else: episodes_list() via file redirect, update title + status
  → anime_list (5 fields: id, title-ep, thumbnail, latest_ep, status)
  → nl + format_titles + nth (fzf selection)
  → extract id($1), title($2), thumbnail($3), status($5) from anime_list
  → episodes_list() → ep_list, mode (fresh fetch for playback)
  → select episode → play_episode() → update_history()
```

### Episode URL resolution
```
get_episode_url()
  → try persisted query (GET with SHA256 hash)
  → fallback to GraphQL POST
  → if "tobeparsed": decode_tobeparsed() (AES-256-CTR)
  → else: regex extract sourceUrl/sourceName
  → generate_link() ×5 providers in parallel → cache_dir files
  → cat + sort all links → select_quality() → $episode
```

### Playback loop (lines ~850-864)
After initial play, shows menu: next / replay / previous / select / change_quality / quit

## Important Patterns & Gotchas

- **`$(...)` vs `> file`**: Command substitution creates a subshell — globals (`latest_sub`, `latest_dub`, `show_status`) are lost. Use file redirect (`func > file`) to preserve globals.
- **`process_hist_entry`** runs in `( ... ) &` background subshells — each is isolated, safe to modify globals within.
- **`nth()`** returns fields 2,3 (`id \t title`). Preview uses `{4}` (thumbnail). The awk `$5="$1 $3"` for display overwrites whatever was in field 5.
- **`format_titles`** only modifies `$3` (title). Adding new tab-separated fields at the end is safe.
- **History field positions** differ between contexts:
  - Search `anime_list`: `$4` = status
  - History display `anime_list`: `$5` = status (because `$4` = `latest_ep`)
- **`$episodes_list_gql`** is set inside `episodes_list()` — undefined before first call. Inline queries if needed earlier (like in `migrate_status`).
- **Parallel writes**: Multiple subshells writing to the same file requires temp file per entry + merge pattern (used by `migrate_*` and `process_hist_entry`).
- **Title sed patterns** must match `(X sub Y dub)` format, not `N episodes`.
- **`allanime_key`** is SHA256 of hardcoded string — used for AES decryption of source URLs. Don't change without updating decryption logic.
- **Bash `read -r`** with `IFS=$'\t'` assigns remaining fields to last variable. Old 4-field entries → `status` is empty.
- **Player-specific link filtering**: vlc/android/iSH can't handle m3u8 with custom referrer or soft subs — `select_quality` removes those links.
