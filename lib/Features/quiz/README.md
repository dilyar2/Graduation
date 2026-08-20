# Quiz Feature

The Quiz feature follows the same layered architecture used by the other
features in the student app.

quiz/
├── data/
│   ├── datasources/
│   │   └── quiz_data_source.dart
│   ├── models/
│   │   └── quiz_model.dart
│   └── repositories/
│       └── quiz_repo_impl.dart
├── domain/
│   ├── repositories/
│   │   └── quiz_repo.dart
│   └── usecases/
│       └── get_section_quiz_use_case.dart
└── presentation/
    ├── manager/
    │   └── bloc/
    │       ├── quiz_bloc.dart
    │       ├── quiz_event.dart
    │       └── quiz_state.dart
    └── pages/
        └── quiz_page.dart

No API contract was invented for submitting answers. Swagger exposes
POST /api/Student/submit-test as multipart/form-data with `testId` and `file`,
but does not document the answer-file format.
