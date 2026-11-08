# Assignment & Deadline Management App

Flutter project based on the group's 8-screen Figma wireframe for the IT Final Project.

## Functional scope
- Offline local account **Sign Up** and **Log In** with form validation.
- Each local account has a separate saved assignment list on the same browser/device.
- Add an assignment, set subject, platform, due date, priority, and notes.
- Review details before saving; view assignments in a dynamic ListView.
- Calendar by date; upcoming deadlines and in-app reminders.
- Check subtasks and mark assignments as completed.
- Responsive purple-themed Dashboard, navigation, and profile/logout.

## Setup (existing Flutter project)
```bash
flutter pub get
flutter run -d web-server --web-port 8081
```
Then open `http://localhost:8081` in your normal Chrome profile.

## Quality checks
```bash
flutter analyze
flutter test
```
Tests cover form and navigation validation. Manual testing is still required for authentication, saving tasks, and browser restart persistence.

## Storage and authentication limits
Accounts and assignments are stored locally in shared_preferences / browser storage. Passwords are *salted and hashed* for this school project, but this is **not a production-secure account system**: there is no server-side verification, email verification, cloud sync, password reset, or cross-device login. Never enter a reused or sensitive password. Clearing browser site data can delete local records. Reminders are in-app lists, not device push notifications. File attachments are not supported.

## Source code map
- `lib/main.dart`: MaterialApp/theme and root.
- `lib/data/local_auth_service.dart`: local registration/login and password hashing.
- `lib/data/task_store.dart`: task persistence per local account.
- `lib/models/assignment.dart`: Assignment model + Priority enum.
- `lib/screens/`: Flutter pages, navigation, controllers and validation.
- `lib/widgets/task_tile.dart`: reused deadline card.

## Collaboration
Asyifa, Moza, Sheika, Seyna. **Each member must contribute authentic edits and make their own GitHub commit before claiming completion of the group Git requirement.** See `TEAM_ROLES_AND_TEACHER_QA.md`.
