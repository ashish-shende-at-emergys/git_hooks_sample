@echo off
REM This batch file automates the process of updating your current Git branch
REM with the latest changes from the 'dev' branch, while preserving your
REM local work.

echo.
echo ===============================================================================
echo Starting the process to update your current branch...
echo ===============================================================================
echo.

REM Step 0: Verify current branch (for informational purposes)
echo Checking the current Git branch...
git branch --show-current
if errorlevel 1 (
    echo.
    echo ERROR: Could not determine the current Git branch.
    echo        Please ensure you are in a Git repository.
    echo ===============================================================================
    pause
    exit /b 1
)
echo.

REM Step 1: Stash current changes
echo Stashing any uncommitted changes...
git stash push -u -m "Stash before update"
if errorlevel 1 (
    echo.
    echo WARNING: Could not stash changes.
    echo          Please resolve any issues manually before proceeding.
    echo          You may need to run 'git stash' manually.
    echo ===============================================================================
) else (
    echo.
    echo SUCCESS: Successfully stashed current changes.
    echo ===============================================================================
)
echo.
pause

REM Step 2: Git fetch all changes
echo Fetching all remote changes...
git fetch --all
if errorlevel 1 (
    echo.
    echo ERROR: Failed to fetch all remote changes.
    echo        Please check your network connection.
    echo ===============================================================================
    pause
    exit /b 1
) else (
    echo.
    echo SUCCESS: Successfully fetched all remote changes.
    echo ===============================================================================
)
echo.
pause

REM Step 3: Pull changes on main, qa, dev branch
echo Pulling latest changes on main branch...
git checkout main
if errorlevel 1 (
    echo.
    echo WARNING: Failed to checkout main branch.
    echo          Please resolve any conflicts or errors.
    echo ===============================================================================
) else (
    git pull origin main
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to pull latest changes on main.
        echo ===============================================================================
    ) else (
        echo.
        echo SUCCESS: Successfully pulled latest changes on main.
        echo ===============================================================================
    )
)
echo.
pause

echo Pulling latest changes on qa branch...
git checkout qa
if errorlevel 1 (
    echo.
    echo WARNING: Failed to checkout qa branch.
    echo          Please resolve any conflicts or errors.
    echo ===============================================================================
) else (
    git pull origin qa
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to pull latest changes on qa.
        echo ===============================================================================
    ) else (
        echo.
        echo SUCCESS: Successfully pulled latest changes on qa.
        echo ===============================================================================
    )
)
echo.
pause

echo Pulling latest changes on dev branch...
git checkout dev
if errorlevel 1 (
    echo.
    echo ERROR: Failed to checkout dev branch.
    echo        Please resolve any conflicts or errors.
    echo ===============================================================================
    pause
    exit /b 1
) else (
    git pull origin dev
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to pull latest changes on dev.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Successfully pulled latest changes on dev.
        echo ===============================================================================
    )
)
echo.
pause

REM Step 4: Update current branch by merging changes from dev branch
echo.
echo Switching back to your feature branch...
git checkout -
if errorlevel 1 (
    echo.
    echo ERROR: Failed to switch back to your previous branch.
    echo        Please check your Git status.
    echo ===============================================================================
    pause
    exit /b 1
)
echo.
pause

echo Merging changes from dev branch into your current branch...
git merge origin/dev --no-edit
if errorlevel 1 (
    echo.
    echo WARNING: Merge conflicts encountered.
    echo          Please resolve the conflicts manually.
    echo          Run 'git status' to see the conflicting files.
    echo ===============================================================================
) else (
    echo.
    echo SUCCESS: Successfully merged changes from dev branch.
    echo ===============================================================================
)
echo.
pause

REM Step 5: Stash pop changes
echo Attempting to reapply your stashed changes...
git stash pop
if errorlevel 1 (
    echo.
    echo WARNING: Could not automatically reapply your stashed changes.
    echo          You may have merge conflicts with your stashed changes.
    echo          Run 'git status' and then 'git stash apply' to attempt manual merge,
    echo          or 'git stash drop' to discard the stashed changes.
    echo ===============================================================================
) else (
    echo.
    echo SUCCESS: Successfully reapplied your stashed changes.
    echo ===============================================================================
)
echo.

REM Step 6: Wait for user to enter any key
echo.
echo ===============================================================================
echo Finished updating your branch.
echo Please review any merge conflicts or warnings.
echo Press any key to exit...
echo ===============================================================================
echo.
pause > nul
exit /b 0