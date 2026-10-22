# Caching strategy for the Rick and Morty client (iOS and Android)

*Based on the GET request logs for `/api/character/2` and `/api/character/avatar/2.jpeg`, captured on 21 October 2026.*

## What the logs show

Both the JSON and the image are served with ideal HTTP caching headers:

|  | JSON `/character/2` | Image `avatar/2.jpeg` |
| --- | --- | --- |
| `cache-control` | `public, max-age=7776000, immutable` (90 days) | same |
| Validators | weak `ETag` only | weak `ETag` and `Last-Modified` (2021) |
| `age` | 7,333,700 s (about 85 days) | 7,263,482 s (about 84 days) |
| Freshness left | about 5.1 days | about 5.9 days |
| Size | n/a | 15 KB |

1. **The “90 days” is misleading.** A cache subtracts `Age`, because Cloudflare has already held the copy for about 85 days. So a client’s copy is only fresh for roughly 5 to 6 more days. After that, a conditional GET with `If-None-Match` follows, which should come back as a cheap 304. That revalidation still counts as a request against Cloudflare’s rate limit, which matters after the 1015 errors.
2. **`immutable` can’t make anything perpetual.** It only tells caches not to revalidate while the copy is fresh.
3. **Images and JSON have identical policies.** This is a single-resource response, so the headers on list or search endpoints haven’t been seen. Log one before relying on the native cache for them.
4. **Error pages won’t be cached.** The 429 response carried `no-store`.

## JSON

- **Native HTTP cache.** On both platforms, turn it on and leave it alone. It sends `If-None-Match` itself and serves the cached body on a 304, and the app just sees a 200. Don’t add validators or `Cache-Control: no-cache` yourself, except for an explicit user refresh.
- **In-memory TTL layer in the service.** Use `AsyncCache` keyed by URL, holding the parsed results.
  - It serves repeat requests without touching the client at all.
  - It gives the time-aware behaviour that was asked for, independent of server headers. Something like 10 to 30 minutes for lists and search, and longer for single characters.
  - Invalidate it on pull-to-refresh and on failures.
- **Placement matters.** If the TTL cache sits above `RateLimitedClient`, cache hits keep working during a 429 pause. A hit inside the native cache can’t, because the pause rejects the request before it reaches the native client.

## Images

- **Route images through the injected `Client`.** `Image.network` uses `dart:io`, so it gets no native HTTP cache and none of the rate-limit handling. A custom `ImageProvider` built on the client fixes that.
- **A perpetual cache needs your own store.** HTTP caches evict by size and revalidate after about 6 days here, so neither is “perpetual”. Add a Dart-side file store keyed by URL, since these images are immutable:
  - The provider reads from the file store first.
  - On a miss, it fetches through the client and writes the file.
  - It never revalidates.
  - It behaves the same on iOS, Android, Windows and Linux.
- **Sizing.** All avatars are about 13 MB, so the store isn’t under any size pressure.
- **Memory.** Flutter’s `ImageCache` already holds decoded images. Decode at tile size, for example with `ResizeImage`, so a 300 px image shown at 40 px doesn’t waste memory.

## Platform settings

- **iOS (`cupertino_http`).**
  - Use `defaultSessionConfiguration()`. The ephemeral configuration keeps no persistent cache.
  - Size the `URLCache` explicitly, roughly 8 MB memory and 128 MB disk. As far as I know the default shared cache is only about 10 MB on disk, which is near the size of all the avatars.
  - There’s a session-wide cache policy, `returnCacheDataElseLoad`, that ignores staleness. It could be used on a separate image-only client, but the file store makes it unnecessary.
  - It isn’t certain whether `NSURLCache` accounts for `Age` the way Chromium does.
- **Android (`cronet_http`).** Use `CacheMode.disk` with `cacheMaxSize` of about 128 MB. Chromium’s cache honors `max-age`, `Age` and validators. Build one engine and register it as a singleton.
- **Both.** Don’t set `Accept-Encoding` yourself, because the native stacks negotiate and decode it. The browser got `zstd` in the logs, but the app’s client may get something else.
