@echo off
REM Usage: do_commits.bat <git_repo_url>
if "%1"=="" (
  echo Usage: do_commits.bat ^<git_repo_url^>
  pause
  exit /b 1
)
set REPO_URL=%1

echo Initializing git repository...
git init
git checkout -b main

echo Committing .gitignore...
if exist .gitignore (
  git add .gitignore
  git commit -m "chore: init repo and add .gitignore"
) else (
  echo .gitignore not found, skipping
)

echo Adding project skeleton (pubspec + platforms)...
git add pubspec.yaml android ios web windows linux macos
git commit -m "chore: add project skeleton and pubspec" || echo "No changes to commit"

echo Adding entrypoint and routing...
git add lib/main.dart lib/core/root
git commit -m "feat(app): add main entrypoint and routing" || echo "No changes to commit"

echo Adding core modules...
git add lib/core/di lib/core/networking lib/core/localization lib/core/theme lib/core/helpers lib/core/widgets
git commit -m "feat(core): add DI, networking, localization, theme, helpers" || echo "No changes to commit"

echo Committing each feature folder separately...

if exist lib\features\explore (
  echo Committing explore subfolders...
  if exist lib\features\explore\ui (
    git add lib/features/explore\ui
    git commit -m "feat(explore/ui): add UI for explore" || echo "No changes in explore/ui"
  )
  if exist lib\features\explore\domain (
    git add lib/features/explore\domain
    git commit -m "feat(explore/domain): add domain models for explore" || echo "No changes in explore/domain"
  )
  if exist lib\features\explore\data (
    git add lib/features/explore\data
    git commit -m "feat(explore/data): add data layer for explore" || echo "No changes in explore/data"
  )
  git add lib/features/explore
  git commit -m "feat(explore): add remaining explore feature files" || echo "No remaining explore changes"
)
if exist lib\features\favorites (
  echo Committing favorites subfolders...
  if exist lib\features\favorites\ui (
    git add lib/features/favorites\ui
    git commit -m "feat(favorites/ui): add UI for favorites" || echo "No changes in favorites/ui"
  )
  if exist lib\features\favorites\domain (
    git add lib/features/favorites\domain
    git commit -m "feat(favorites/domain): add domain models for favorites" || echo "No changes in favorites/domain"
  )
  if exist lib\features\favorites\data (
    git add lib/features/favorites\data
    git commit -m "feat(favorites/data): add data layer for favorites" || echo "No changes in favorites/data"
  )
  git add lib/features/favorites
  git commit -m "feat(favorites): add remaining favorites feature files" || echo "No remaining favorites changes"
)
if exist lib\features\news (
  echo Committing news subfolders...
  if exist lib\features\news\ui (
    git add lib/features/news\ui
    git commit -m "feat(news/ui): add UI for news" || echo "No changes in news/ui"
  )
  if exist lib\features\news\domain (
    git add lib/features/news\domain
    git commit -m "feat(news/domain): add domain models for news" || echo "No changes in news/domain"
  )
  if exist lib\features\news\data (
    git add lib/features/news\data
    git commit -m "feat(news/data): add data layer for news" || echo "No changes in news/data"
  )
  git add lib/features/news
  git commit -m "feat(news): add remaining news feature files" || echo "No remaining news changes"
)
if exist lib\features\notifications (
  echo Committing notifications subfolders...
  if exist lib\features\notifications\ui (
    git add lib/features/notifications\ui
    git commit -m "feat(notifications/ui): add UI for notifications" || echo "No changes in notifications/ui"
  )
  if exist lib\features\notifications\domain (
    git add lib/features/notifications\domain
    git commit -m "feat(notifications/domain): add domain models for notifications" || echo "No changes in notifications/domain"
  )
  if exist lib\features\notifications\data (
    git add lib/features/notifications\data
    git commit -m "feat(notifications/data): add data layer for notifications" || echo "No changes in notifications/data"
  )
  git add lib/features/notifications
  git commit -m "feat(notifications): add remaining notifications feature files" || echo "No remaining notifications changes"
)
if exist lib\features\profile (
  echo Committing profile subfolders...
  if exist lib\features\profile\ui (
    git add lib/features/profile\ui
    git commit -m "feat(profile/ui): add UI for profile" || echo "No changes in profile/ui"
  )
  if exist lib\features\profile\domain (
    git add lib/features/profile\domain
    git commit -m "feat(profile/domain): add domain models for profile" || echo "No changes in profile/domain"
  )
  if exist lib\features\profile\data (
    git add lib/features/profile\data
    git commit -m "feat(profile/data): add data layer for profile" || echo "No changes in profile/data"
  )
  git add lib/features/profile
  git commit -m "feat(profile): add remaining profile feature files" || echo "No remaining profile changes"
)
if exist lib\features\startup_profile (
  echo Committing startup_profile subfolders...
  if exist lib\features\startup_profile\ui (
    git add lib/features/startup_profile\ui
    git commit -m "feat(startup_profile/ui): add UI for startup_profile" || echo "No changes in startup_profile/ui"
  )
  if exist lib\features\startup_profile\domain (
    git add lib/features/startup_profile\domain
    git commit -m "feat(startup_profile/domain): add domain models for startup_profile" || echo "No changes in startup_profile/domain"
  )
  if exist lib\features\startup_profile\data (
    git add lib/features/startup_profile\data
    git commit -m "feat(startup_profile/data): add data layer for startup_profile" || echo "No changes in startup_profile/data"
  )
  git add lib/features/startup_profile
  git commit -m "feat(startup_profile): add remaining startup_profile feature files" || echo "No remaining startup_profile changes"
)

echo Adding assets...
git add assets/fonts assets/icons assets/images
git commit -m "chore(assets): add fonts, icons, images" || echo "No assets changes to commit"

echo Adding native platform files (if any)...
git add android ios windows linux macos
git commit -m "chore(platform): update native platform files" || echo "No native platform changes to commit"

echo Adding tests, analysis, and CI config...
git add test analysis_options.yaml devtools_options.yaml .github/workflows
git commit -m "test(ci): add tests, lint rules and CI workflow" || echo "No tests/CI changes to commit"

echo Adding docs...
git add README.md QUICK_REFERENCE.md STARTUP_DETAILS_FEATURE.md COMMIT_PLAN.md
git commit -m "docs: add README and project documentation" || echo "No docs changes to commit"

echo Tagging and pushing...
git tag -a v0.1.0 -m "Initial release"
git remote add origin %REPO_URL%
git push -u origin main --tags

echo Done. Press any key to exit.
pause
