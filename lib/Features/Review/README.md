# Review Feature

The Review feature follows the project's layered architecture:

- data/dataSource
- data/repositories
- domain/repo
- domain/usecases
- presentation/manager/bloc
- presentation/pages

Current API support is the documented student review submission:
`POST /api/Student/review`.

The current API contract in the project does not expose a review-list GET
endpoint, so this phase does not invent a reviews feed. The UI focuses on
submitting a rating/comment for an existing enrollment.

Behavior:
- rating is required (1–5)
- comment is optional
- comment is limited to 500 characters client-side
- loading disables submit
- success closes the sheet and refreshes course info
- 409 is shown as "already reviewed" (or the server's own message)
- server error details are surfaced when available
