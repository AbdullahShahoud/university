# Commit Plan

This file documents the set of commits the `scripts/do_commits.bat` script will create.

1. chore: init repo and add .gitignore
   - Files: `.gitignore`

2. chore: add project skeleton and pubspec
   - Files: `pubspec.yaml`, `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`

3. feat(app): add main entrypoint and routing
   - Files: `lib/main.dart`, `lib/core/root`

4. feat(core): add DI, networking, localization, theme, helpers
   - Files: `lib/core/di`, `lib/core/networking`, `lib/core/localization`, `lib/core/theme`, `lib/core/helpers`, `lib/core/widgets`

5. feat(explore): add `explore` feature (split commits)
   - Files: `lib/features/explore/ui`, `lib/features/explore/domain`, `lib/features/explore/data`

6. feat(favorites): add `favorites` feature (split commits)
   - Files: `lib/features/favorites/ui`, `lib/features/favorites/domain`, `lib/features/favorites/data`

7. feat(news): add `news` feature (split commits)
   - Files: `lib/features/news/ui`, `lib/features/news/domain`, `lib/features/news/data`

8. feat(notifications): add `notifications` feature (split commits)
   - Files: `lib/features/notifications/ui`, `lib/features/notifications/domain`, `lib/features/notifications/data`

9. feat(profile): add `profile` feature (split commits)
   - Files: `lib/features/profile/ui`, `lib/features/profile/domain`, `lib/features/profile/data`

10. feat(startup_profile): add `startup_profile` feature (split commits)
   - Files: `lib/features/startup_profile/ui`, `lib/features/startup_profile/domain`, `lib/features/startup_profile/data`

11. chore(assets): add fonts, icons, images
   - Files: `assets/fonts`, `assets/icons`, `assets/images`

12. chore(platform): update native platform files
   - Files: `android/`, `ios/`, `windows/`, `linux/`, `macos/` (only if modified)

13. test(ci): add tests, lint rules and CI workflow
   - Files: `test/`, `analysis_options.yaml`, `.github/workflows/`

14. docs: add README and project documentation
   - Files: `README.md`, `QUICK_REFERENCE.md`, `STARTUP_DETAILS_FEATURE.md`, `COMMIT_PLAN.md`

15. Tag and push: `v0.1.0` and push to remote

---

How to run:

Open a terminal in the project root and run:

```bat
scripts\do_commits.bat https://github.com/your_username/your_repo.git
```

Notes:
- The script assumes `git` is installed and available in PATH.
- It will attempt to add and commit the listed paths; adjust the script if you want finer-grained feature-by-feature commits.
