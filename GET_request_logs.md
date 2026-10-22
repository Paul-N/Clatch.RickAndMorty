# GET Request logs:

## GET https://rickandmortyapi.com/api/character/2

### Response headers:

```
server: cloudflare
date: Wed, 21 Oct 2026 23:06:30 GMT
content-type: application/json; charset=utf-8
reporting-endpoints: cf-csp-endpoint="https://csp-reporting.cloudflare.com/cdn-cgi/script_monitor/report?m=aHZO97MkSHVcRTKyiMPosZEH.bi0FT1Y5dysk2OrHl4-1792623990.833213-1.0.1.1-f5bKhSAqvSEv6amw2npmLp5PDmzFUowBRQqp0Q6CbjRe3w.alc.tGOqNr57PUvHXwG_PqQxdOLZRRlnHZfgwe4o..kTO7MCsflpQZty41HPdtPKh8MyepghtLL.2hFxWbBidpd7EmhNs3NiBh6kG9fcz.B6HRSbjxPW4TPQhF13LROBhDXY.vQI0FK9vZb7t"
priority: u=0,i=?0
nel: {"report_to":"cf-nel","success_fraction":0.0,"max_age":604800}
access-control-allow-origin: *
etag: W/"a6e-zQHAPIKFfD+Wv+P+4aCju24Mapw"
x-proxy-cache: HIT
cache-control: public, max-age=7776000, immutable
x-xss-protection: 1; mode=block
age: 7333700
cf-cache-status: HIT
content-encoding: zstd
content-security-policy-report-only: script-src 'unsafe-inline' 'unsafe-eval'; connect-src 'none'; report-uri https://csp-reporting.cloudflare.com/cdn-cgi/script_monitor/report?m=aHZO97MkSHVcRTKyiMPosZEH.bi0FT1Y5dysk2OrHl4-1792623990.833213-1.0.1.1-f5bKhSAqvSEv6amw2npmLp5PDmzFUowBRQqp0Q6CbjRe3w.alc.tGOqNr57PUvHXwG_PqQxdOLZRRlnHZfgwe4o..kTO7MCsflpQZty41HPdtPKh8MyepghtLL.2hFxWbBidpd7EmhNs3NiBh6kG9fcz.B6HRSbjxPW4TPQhF13LROBhDXY.vQI0FK9vZb7t; report-to cf-csp-endpoint
report-to: {"group":"cf-nel","max_age":604800,"endpoints":[{"url":"https://a.nel.cloudflare.com/report/v4?s=%2BYcLyUX4r1REKGRfU4DxjTvKXJt7AArePZEuaqV1DK%2FKEasyARHeDOJ0pzouVXcaWrfmFPMJXr%2FVe1UgUtT%2B6XRfEx36Un9elEgZ1F2F1akyrg1qW9td2j5WSGv8oCwRH0kJRf6R"}]}, {"group":"cf-csp-endpoint","max_age":86400,"endpoints":[{"url":"https://csp-reporting.cloudflare.com/cdn-cgi/script_monitor/report?m=aHZO97MkSHVcRTKyiMPosZEH.bi0FT1Y5dysk2OrHl4-1792623990.833213-1.0.1.1-f5bKhSAqvSEv6amw2npmLp5PDmzFUowBRQqp0Q6CbjRe3w.alc.tGOqNr57PUvHXwG_PqQxdOLZRRlnHZfgwe4o..kTO7MCsflpQZty41HPdtPKh8MyepghtLL.2hFxWbBidpd7EmhNs3NiBh6kG9fcz.B6HRSbjxPW4TPQhF13LROBhDXY.vQI0FK9vZb7t"}]}
expect-ct: max-age=86400, enforce
referrer-policy: same-origin
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
cf-ray: a4e3e9c6affe5b2b-VIE
alt-svc: h3=":443"; ma=86400
server-timing: cfExtPri
X-Firefox-Http3: h3

```

### Response body:

```json
{
    "id": 2,
    "name": "Morty Smith",
    "status": "Alive",
    "species": "Human",
    "type": "",
    "gender": "Male",
    "origin": {
        "name": "unknown",
        "url": ""
    },
    "location": {
        "name": "Citadel of Ricks",
        "url": "https://rickandmortyapi.com/api/location/3"
    },
    "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
    "episode": [
        "https://rickandmortyapi.com/api/episode/1",
        "https://rickandmortyapi.com/api/episode/2",
        "https://rickandmortyapi.com/api/episode/3",
        "https://rickandmortyapi.com/api/episode/4",
        "https://rickandmortyapi.com/api/episode/5",
        "https://rickandmortyapi.com/api/episode/6",
        "https://rickandmortyapi.com/api/episode/7",
        "https://rickandmortyapi.com/api/episode/8",
        "https://rickandmortyapi.com/api/episode/9",
        "https://rickandmortyapi.com/api/episode/10",
        "https://rickandmortyapi.com/api/episode/11",
        "https://rickandmortyapi.com/api/episode/12",
        "https://rickandmortyapi.com/api/episode/13",
        "https://rickandmortyapi.com/api/episode/14",
        "https://rickandmortyapi.com/api/episode/15",
        "https://rickandmortyapi.com/api/episode/16",
        "https://rickandmortyapi.com/api/episode/17",
        "https://rickandmortyapi.com/api/episode/18",
        "https://rickandmortyapi.com/api/episode/19",
        "https://rickandmortyapi.com/api/episode/20",
        "https://rickandmortyapi.com/api/episode/21",
        "https://rickandmortyapi.com/api/episode/22",
        "https://rickandmortyapi.com/api/episode/23",
        "https://rickandmortyapi.com/api/episode/24",
        "https://rickandmortyapi.com/api/episode/25",
        "https://rickandmortyapi.com/api/episode/26",
        "https://rickandmortyapi.com/api/episode/27",
        "https://rickandmortyapi.com/api/episode/28",
        "https://rickandmortyapi.com/api/episode/29",
        "https://rickandmortyapi.com/api/episode/30",
        "https://rickandmortyapi.com/api/episode/31",
        "https://rickandmortyapi.com/api/episode/32",
        "https://rickandmortyapi.com/api/episode/33",
        "https://rickandmortyapi.com/api/episode/34",
        "https://rickandmortyapi.com/api/episode/35",
        "https://rickandmortyapi.com/api/episode/36",
        "https://rickandmortyapi.com/api/episode/37",
        "https://rickandmortyapi.com/api/episode/38",
        "https://rickandmortyapi.com/api/episode/39",
        "https://rickandmortyapi.com/api/episode/40",
        "https://rickandmortyapi.com/api/episode/41",
        "https://rickandmortyapi.com/api/episode/42",
        "https://rickandmortyapi.com/api/episode/43",
        "https://rickandmortyapi.com/api/episode/44",
        "https://rickandmortyapi.com/api/episode/45",
        "https://rickandmortyapi.com/api/episode/46",
        "https://rickandmortyapi.com/api/episode/47",
        "https://rickandmortyapi.com/api/episode/48",
        "https://rickandmortyapi.com/api/episode/49",
        "https://rickandmortyapi.com/api/episode/50",
        "https://rickandmortyapi.com/api/episode/51"
    ],
    "url": "https://rickandmortyapi.com/api/character/2",
    "created": "2017-11-04T18:50:21.651Z"
}
```

## GET https://rickandmortyapi.com/api/character/avatar/2.jpeg

### Response headers:

```
server: cloudflare
date: Wed, 21 Oct 2026 22:49:41 GMT
content-type: image/jpeg
server-timing: cfExtPri
priority: u=0,i=?0
nel: {"report_to":"cf-nel","success_fraction":0.0,"max_age":604800}
access-control-allow-origin: *
last-modified: Wed, 03 Nov 2021 16:20:52 GMT
etag: W/"3cd2-17ce69a6dfd"
x-proxy-cache: MISS
cache-control: public, max-age=7776000, immutable
accept-ranges: bytes
age: 7263482
cf-cache-status: HIT
x-frame-options: SAMEORIGIN
x-xss-protection: 1; mode=block
report-to: {"group":"cf-nel","max_age":604800,"endpoints":[{"url":"https://a.nel.cloudflare.com/report/v4?s=WXYdl81Y7Gpb%2BvCSE1goM%2F6NaZMaodTlmf6EI2faMIw6Xbtq07npHotnZ%2FdXWNNGt8tlzu1wvePg2hh2AhjZSvihaFZA3XLfF6Khw%2F5mUxEbW%2FtFpc9cRB1mrJofN%2BtsbT37G1vg"}]}
expect-ct: max-age=86400, enforce
referrer-policy: same-origin
x-content-type-options: nosniff
cf-ray: a4e3d1244f6b8eb1-VIE
alt-svc: h3=":443"; ma=86400
content-length: 15570
X-Firefox-Http3: h3

```

