# Search Feature

Search now supports:
- Course search through `GET /api/Course`
- Recent searches through `GET /api/Me/searches?limit=...`
- Most-used searches through `GET /api/Course/search/most-used?limit=...&days=...`

The Swagger documents both suggestion endpoints but does not define their
200-response schemas, so the datasource uses tolerant parsing for common
string/object response shapes without changing the API contract.

The search page:
- loads recent + most-used searches when opened
- lets the user tap a suggestion to search immediately
- keeps the existing debounced course search
- keeps the existing anti-stale-response generation guard
- supports retry when suggestions fail
- preserves dark-mode colors through Theme.of(context).colorScheme
