## AGENTS.md

## Build/Lint/Test Commands

- To build the project: `flutter build`
- To lint the project: `flutter lint`
- To run all tests: `flutter test`
- To run a single test: `flutter test path/to/test_file.dart`

## Code Style Guidelines

- Follow the Dart style guide: https://dart.dev/guides/language/effective-dart
- Use `dartfmt` to format code
- Use types for all variables and function parameters
- Use camelCase for variable and function names
- Use PascalCase for class names
- Handle errors using try-catch blocks and `Error` class

## Cursor Rules

- No specific Cursor rules found

## Copilot Rules

- No specific Copilot rules found

## Additional Notes

- Always run `flutter pub get` after modifying `pubspec.yaml`
- Use `flutter doctor` to diagnose issues with the development environment
- **NEVER use /services directly in widgets/ui**. Always use providers/ instead, the providers should then call the service, and also invalidate data as needed.

## UI Component Guidelines

- **Always prefer from_zero_ui components** over default Flutter counterparts:
  - Use `SnackBarFromZero` instead of `SnackBar` or `ScaffoldMessenger.showSnackBar`
  - Use `ActionFromZero` instead of `IconButton` or `TextButton` for toolbar actions
  - Use `DialogFromZero` + `showModalFromZero` instead of `AlertDialog` + `showDialog`
  - Use `DialogButton` for dialog action buttons
  - Use `APISnackBar` for async operation feedback (success/error states)
  - Use `AppbarFromZero` for consistent app bar styling
  - Use `ContextMenuFromZero` for context menus

- See `~/workspaces/mpg_flutter/master/frontend` for usage examples
