# Final IT Project — Four-Person Roles, Teacher Q&A and Submission

## Work allocation for four members (proposed; not proof of completed work)

| Member | Responsible modules | Demonstrate to teacher | Suggested authentic GitHub contribution |
|---|---|---|---|
| Asyifa | Calendar, data persistence and integration; group coordination | Choose deadline on Calendar; refresh app and explain local storage | Add a calendar empty-state improvement or a persistence test |
| Moza | Login, Sign Up, Dashboard UI | Register a local account; log in, explain form validation and summary widgets | Improve login form accessibility or add a sign-in test |
| Sheika | Assignment Details, Reminder | Review and save an assignment; explain priority and reminder | Improve reminders for overdue items or write reminder tests |
| Seyna | Add Assignment, ListView, Task View, Completed | Create a new task, show dynamic list, mark as done | Add an input validation test or improve the completed screen |

DO NOT tell the teacher each member committed unless their own commit is actually visible in GitHub history.

## Explaining the code simply (English, with quick Indonesian help)

**Q1. What problem does your application solve?**
It helps students organize school assignments, deadlines and priorities in one place, so they can track pending and completed tasks.

**Q2. What is Flutter?**
Flutter is a UI framework; we write Dart code to build screens for multiple platforms.

**Q3. What do `MaterialApp` and `Scaffold` do?**
`MaterialApp` sets up the app theme and navigation environment. `Scaffold` provides the page structure, including AppBar, body and navigation.

**Q4. Why use multiple files in `lib/screens`?**
To separate responsibilities for each screen and make collaboration easier. Login, Dashboard, Calendar, and Add Assignment use separate widgets.

**Q5. How does navigation work?**
`Navigator.push` opens a new page; `Navigator.pop` returns. We pass the shared TaskStore into screen constructors so all pages work with the same task data while signed in.

**Q6. Why use TextEditingController and dispose?**
A controller reads what users type in a TextField. `dispose()` releases resources when the screen is closed.

**Q7. Why is `StatefulWidget` necessary?**
Because selected dates, form values and UI state can change. `setState` triggers a rebuild when local UI values change.

**Q8. Where do you use `if/else`?**
For login validation, empty assignment warnings, priority logic, upcoming vs completed tasks, and navigation choices.

**Q9. How do you generate the assignment list?**
`ListView.builder` uses `itemCount` and `itemBuilder` to build task cards from the current saved list.

**Q10. How does task storage work?**
The TaskStore converts tasks to JSON and saves them with shared_preferences. When a local user logs in, it loads that user's saved tasks. The data persists when Chrome closes, as long as the same browser profile, origin and site storage are retained.

**Q11. Is registration real?**
It is functional **local account registration**: it stores a local account record and verifies credentials on subsequent logins. It is not an online authentication server or cross-device login. Passwords are salted and hashed locally, but we should not use it for sensitive production data.

**Q12. Are deadline reminders automatic phone notifications?**
No. The reminder screen lists close deadlines within the app. Push notifications need extra platform permissions and a different implementation.

**Q13. What is the difference between Git and GitHub?**
Git tracks code versions and commits locally. GitHub hosts the shared remote repository so the team can collaborate. We use `git add`, `git commit` and `git push`.

**Q14. How do you confirm the app works?**
We use `flutter analyze` for static issues, `flutter test` for automated tests, and manual flow checks such as signing up, adding an assignment, changing status and refreshing the browser. Never say every feature is automatically tested if only two tests run.

**Q15. Who did what?**
Explain your *actual* contribution and show commits from each member. The table above is the intended division, not a fabricated history.

**Q16. What can be improved?**
A real backend (such as Firebase) for cross-device synchronization, email verification, stronger auth, secure session management, file attachments and push reminders.

## Classroom private comment (copy and adjust based on actual evidence)

**Project:** Assignment & Deadline Management App
**Members:** Asyifa Karlina Ginanjar, Moza, Sheika, Seyna
**Repository:** https://github.com/asyifakar/assignment-deadline-manager

We built a Flutter assignment management app from our Figma wireframe, including local account registration and login, a dashboard, assignment creation, calendar, in-app reminders and task completion. The application uses TextField, controllers, Navigator, StatefulWidget/setState, conditions and ListView.builder, with JSON-based local persistence using shared_preferences. Our repository contains the source code and commit history. We have completed the main coding flow and are documenting final integration tests and individual member contributions. The current version runs locally; cloud synchronization, file attachments, and device push notifications are not implemented.

**Required submission evidence:** 1) GitHub link and commit history, 2) screenshots of **each working screen with editor visible** as required by teacher, 3) all four names, 4) honest 3–5 sentence progress comment, 5) four authentic GitHub contributor commits if required.

## Do not forget
- Copy the screenshots and submit the group comment in Google Classroom yourself.
- Add the teacher as collaborator if the repository is private (teacher username provided: Azmi1180).
- Do not claim 100% guaranteed grade, cloud sync, production security, or commits that do not exist.
