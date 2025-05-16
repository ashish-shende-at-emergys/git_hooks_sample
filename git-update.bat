@echo off
REM This batch file automates the process of updating your current Git branch
REM with the latest changes from various branches based on your current branch.

echo.
echo ===============================================================================
echo Starting the process to update your current branch...
echo ===============================================================================
echo.

REM Step 1: Check for current branch
echo Checking the current Git branch...
for /f "delims=" %%a in ('git branch --show-current') do set "current_branch=%%a"
if errorlevel 1 (
    echo.
    echo ERROR: Could not determine the current Git branch.
    echo        Please ensure you are in a Git repository.
    echo ===============================================================================
    pause
    exit /b 1
)
echo Current branch is: %current_branch%
echo.
pause

REM Step 2: Handle main, qa, or dev branch
if "%current_branch%"=="main" (
    echo On 'main' branch. Proceeding to fetch and pull...
    goto :fetch_pull_main_qa_dev
) else if "%current_branch%"=="qa" (
    echo On 'qa' branch. Proceeding to fetch and pull...
    goto :fetch_pull_main_qa_dev
) else if "%current_branch%"=="dev" (
    echo On 'dev' branch. Proceeding to fetch and pull...
    goto :fetch_pull_main_qa_dev
) else (
    echo On a feature branch ('%current_branch%'). Proceeding with feature branch update...
    goto :handle_feature_branch
)

:fetch_pull_main_qa_dev
    REM 2.1 git fetch --all
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

    REM 2.2 Git checkout main branch pull latest changes
    echo Checking out and pulling latest changes on main branch...
    git checkout main
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to checkout main branch. Please resolve any conflicts or errors.
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

    REM 2.3 Git checkout qa branch pull latest changes
    echo Checking out and pulling latest changes on qa branch...
    git checkout qa
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to checkout qa branch. Please resolve any conflicts or errors.
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

    REM 2.4 Git checkout dev branch pull latest changes
    echo Checking out and pulling latest changes on dev branch...
    git checkout dev
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to checkout dev branch. Please resolve any conflicts or errors.
        echo ===============================================================================
    ) else (
        git pull origin dev
        if errorlevel 1 (
            echo.
            echo WARNING: Failed to pull latest changes on dev.
            echo ===============================================================================
        ) else (
            echo.
            echo SUCCESS: Successfully pulled latest changes on dev.
            echo ===============================================================================
        )
    )
    echo.
    pause

    REM Go to the final step
    goto :final_pause

:handle_feature_branch
    REM 3.1 Check Git status, store current branch name in variable '@work-branch'
    echo.
    echo Checking Git status and storing current branch name...
    git status --porcelain
    if errorlevel 1 (
        echo.
        echo WARNING: Could not get Git status.
        echo ===============================================================================
    )
    set "work_branch=%current_branch%"
    echo Current work branch is: %work_branch%
    echo.
    pause

    REM 3.2 stash current changes
    echo Stashing any uncommitted changes on '%work_branch%'...
    git stash push -u -m "Stash before update on %work_branch%"
    if errorlevel 1 (
        echo.
        echo WARNING: Could not stash changes on '%work_branch%'.
        echo          Please resolve any issues manually before proceeding.
        echo          You may need to run 'git stash' manually.
        echo ===============================================================================
    ) else (
        echo.
        echo SUCCESS: Successfully stashed current changes on '%work_branch%'.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.3 git fetch all changes
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

    REM 3.4 Checkout qa branch
    echo Checking out qa branch...
    git checkout qa
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to checkout qa branch. Please resolve any issues.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Checked out qa branch.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.4 Pull latest changes on qa
    echo Pulling latest changes on qa branch...
    git pull origin qa
    if errorlevel 1 (
        echo.
        echo WARNING: Failed to pull latest changes on qa. Please resolve any conflicts.
        echo ===============================================================================
    ) else (
        echo.
        echo SUCCESS: Successfully pulled latest changes on qa.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.5 Checkout dev branch
    echo Checking out dev branch...
    git checkout dev
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to checkout dev branch. Please resolve any issues.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Checked out dev branch.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.6 update dev branch by merging changes from qa branch [merge qa to dev]
    echo Merging changes from qa branch into dev branch...
    git merge origin/qa --no-edit
    if errorlevel 1 (
        echo.
        echo WARNING: Merge conflicts encountered while merging qa into dev.
        echo          Please resolve the conflicts manually on the dev branch.
        echo          Run 'git status' on dev to see the conflicting files.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Successfully merged changes from qa branch into dev branch.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.8 Checkout '@work-branch' [which created for card for new enhancement or bug from which changes are stashed]
    echo Checking out your work branch '%work_branch%'...
    git checkout "%work_branch%"
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to checkout your work branch '%work_branch%'.
        echo        Please check your Git status or branch name.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Checked out your work branch '%work_branch%'.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.9.Update '@work-branch' by merging changes from dev branch [merge dev to '@work-branch']
    echo Merging changes from dev branch into your work branch '%work_branch%'...
    git merge origin/dev --no-edit
    if errorlevel 1 (
        echo.
        echo WARNING: Merge conflicts encountered while merging dev into '%work_branch%'.
        echo          Please resolve the conflicts manually on '%work_branch%'.
        echo          Run 'git status' to see the conflicting files.
        echo ===============================================================================
        pause
        exit /b 1
    ) else (
        echo.
        echo SUCCESS: Successfully merged changes from dev branch into '%work_branch%'.
        echo ===============================================================================
    )
    echo.
    pause

    REM 3.11 Stash pop changes on checkout branch
    echo Attempting to reapply your stashed changes on '%work_branch%'...
    git stash pop
    if errorlevel 1 (
        echo.
        echo WARNING: Could not automatically reapply your stashed changes on '%work_branch%'.
        echo          You may have merge conflicts with your stashed changes.
        echo          Run 'git status' and then 'git stash apply' to attempt manual merge,
        echo          or 'git stash drop' to discard the stashed changes.
        echo ===============================================================================
    ) else (
        echo.
        echo SUCCESS: Successfully reapplied your stashed changes on '%work_branch%'.
        echo ===============================================================================
    )
    echo.
    pause

:final_pause
    REM 3.13 Wait for user to enter any key last branch
    echo.
    echo ===============================================================================
    echo Finished updating your branch '%current_branch%'.
    echo Please review any merge conflicts or warnings.
    echo Press any key to exit...
    echo ===============================================================================
    echo.
    pause > nul
    exit /b 0