# Rick and Morty


### Key layers:

- **Pages** — pure UI, no business logic. React to ViewModel state changes.
- **ViewModels** — encapsulate business logic, handle pagination, search, error states.
- **Services** — coordinate between REST API and ViewModels, handle cancellation.
- **REST API** — thin HTTP layer, parses responses, handles errors.
- **Infrastructure** — HTTP client with throttling, caching, platform-specific implementations (Cronet for Android, Cupertino for iOS/macOS).

## Features

- **Searchable character list** with debounced search input
- **Infinite scrolling** (pagination via `info.next`)
- **Rate limit handling** — automatic retry with exponential backoff on 429 responses
- **Cloudflare error parsing** — extracts `error_code`, `error_name`, `retry_after`, etc.
- **Platform-native HTTP** — uses `Cronet` (Android) and `CupertinoClient` (iOS/macOS) for optimal caching
- **Request throttling** — prevents rate limiting with configurable intervals and priority queuing
- **Error handling** — structured error types with user-friendly messages
- **Localization** — support for multiple languages (en, ru, es)

## Packages

| Package | Purpose |
|---|---|
| `http` | HTTP client (base) |
| `cronet_http` | Android native HTTP engine |
| `cupertino_http` | iOS/macOS native HTTP engine |
| `freezed` + `freezed_annotation` | Immutable data classes with codegen |
| `json_serializable` + `json_annotation` | JSON serialization |
| `extension_type_unions` | Type-safe union types (result monad) |
| `problem_details` | RFC 9457 Problem Details support |
| `clock` | Injectable time source (for testing) |
| `async` | `CancelableCompleter` for request cancellation |
| `http_parser` | HTTP header parsing |
| `logging` | Structured logging |
| `intl` | Internationalization |

## Running

Use the **main (Dev)** run configuration in your IDE. It configures:
- Development backend URL
- Debug logging enabled
- Hot reload support

## Build

```bash
# Generate Freezed/JSON code
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze
dart analyze