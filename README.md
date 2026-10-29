# Signup Form Quest
A Flutter demo signup form with private, deterministic offline guidance. Track: Undergraduate. Completed feature: Local Signup Tips.

Repository: https://github.com/ReddyR1105/mad4360-activity10

## Implementation
`SignupPage` owns a `GlobalKey<FormState>` and three text controllers. Name is required, email must match a basic address pattern, and password must contain at least six characters. Password entry is obscured. Valid input displays a green demo-success SnackBar; invalid input displays inline errors. Scrolling and a maximum form width support small screens. No account is created.

## Recorded verification
`flutter analyze --no-pub`: no issues. `flutter test --no-pub`: five tests passed. The tests covered valid/invalid validators, deterministic tips up to 240 characters, local service failure and recovery, empty-form messages, visible tip loading/error/retry, and a green success SnackBar after valid input. See `evidence/test-results.txt` and `evidence/analyze-results.txt`.

The rebuilt release APK was installed on the Pixel 4a Android emulator and launched successfully with Android Activity Manager reporting `Status: ok`. The automated success test submits using the password keyboard Done action. The tip service has no network code; an airplane-mode check is not presented as completed.

## Team
Rohan (`ReddyR1105`) and Het (`het1406`). Track: Undergraduate.

Rohan’s repository work covers the form, validation, local tips, keyboard shortcuts, build configuration, and verification. The keyboard workflow update is recorded on `rohan/form-and-integration` and integrated into `main`. Het’s assigned area is the welcome/success screens, animation lifecycle, and evidence review; his individual contribution must be committed from `het1406`.

## Run and build
Install Flutter and Android SDK tools. Use JDK 25 with the checked-in Gradle 9.3.1 / Android Gradle Plugin 9.1.0 configuration, matching the installed Flutter 3.47 toolchain. The Android app targets API 36.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`. This classroom release uses the template's debug signing key; it is not a Play Store release. If needed, `flutter build apk --debug` is the allowed fallback.

## Privacy and local tips
The app has no backend or account database. It never saves profile fields or passwords. `LocalTipService.getTip` accepts only a simulated-failure flag and has no access to form controllers. The fixed category `password_help` selects the first tip in its fixed local list, so the result is deterministic and less than 240 characters. A loading indicator appears first. Turn on **Simulate next tip failure**, then request a tip to reproduce an error; **Retry** clears the simulated failure and loads the normal tip. Tips cannot approve signup. No runtime network calls are implemented; release manifests have no INTERNET permission.

## Code explanations for the demo
### Rohan
1. The tip button calls `_load`, which clears old messages, sets loading, and waits for the local service. Success displays the preset label and tip; failure displays an error and Retry. The retry path requests the same deterministic tip without the failure flag.
2. Validation and guidance have different jobs. `Form.validate()` checks whether the entered values meet the form rules. The tip service offers general advice without receiving any entered values, so it cannot accidentally treat advice as approval.

### Het
1. The helper intentionally receives no name, email, or password. Its result depends only on the fixed category and the deliberate failure flag. This keeps personal information outside the guidance feature and makes tests repeatable.
2. Loading and error states need to be tested separately from success. The widget test taps the failure switch, observes a loading indicator and Retry, then verifies that Retry displays a preset tip. Both students should be able to trace these code paths during the demo.

## Contribution history
Do not change Git author settings to impersonate a teammate. Each teammate should clone the repository, create their own branch, make a substantive reviewed change, run checks, and push using their own account. See `TEAM_HANDOFF.md` for the division of work. Inviting a collaborator alone does not establish participation.

## Completed keyboard workflow
The password field uses the Done keyboard action to validate and submit, and a successful submit dismisses the keyboard. The existing success test verifies the keyboard submission path.
