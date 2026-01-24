# Renovate "needs-approval" Issue Resolution

## Root Cause - ACTUAL ISSUE FOUND

**The `ignorePresets: [":all"]` setting was breaking Renovate's PR creation!**

This setting tells Renovate to ignore **ALL** presets, including `config:recommended`. This means that even though the config extended `config:recommended`, none of its settings (including PR creation behavior) were being applied.

### Why This Caused "needs-approval"

1. `ignorePresets: [":all"]` prevented `config:recommended` from applying its settings
2. Without proper preset configuration, Renovate couldn't determine when/how to create PRs
3. PRs remained in "needs-approval" state (`"prNo": null`) indefinitely
4. The weekend schedule was working correctly, but PR creation logic was broken

### The Fix

**Removed `ignorePresets: [":all"]` from renovate.json5**

This allows `config:recommended` preset to properly configure PR creation behavior. The original intent (per comment) was to ignore repository-level config presets, but `:all` was too broad and disabled everything.

## Previous Misdiagnosis

The initial analysis incorrectly attributed "needs-approval" to schedule restrictions. While the schedule does restrict PR creation to weekends, the actual blocker was the `ignorePresets` setting preventing PRs from being created at all.

### Status Terminology

- **"needs-approval" in logs** (`"result": "needs-approval"`, `"prNo": null`):
  - PR has **NOT been created yet**
  - Renovate is blocked from creating the PR
  - Could be waiting for schedule OR dashboard approval

- **"Awaiting Schedule" in Dashboard**:
  - Update is ready but waiting for the configured time window
  - Will be created automatically when schedule allows
  - Can be manually triggered by checking the checkbox

### 1. Schedule Restrictions (THIS REPO'S ISSUE)

**Current configuration:** `schedule: ["* * * * 0,6"]`
- Means: Run **weekends only** (Saturday=6, Sunday=0)  
- Updates show "Awaiting Schedule" in Dependency Dashboard
- PRs will be created automatically on weekends
- **Manual bypass:** Check boxes in issue #23 to create PRs immediately

**Why this causes "needs-approval":**
- During weekdays (Mon-Fri), Renovate skips processing
- Updates queue up and show `"result": "needs-approval"` in logs
- Really means "needs schedule approval" (waiting for weekend)

### 2. Dependency Dashboard Approval

If `dependencyDashboardApproval: true` is set, PRs won't be created until you manually check approval boxes.

**Current config:** `dependencyDashboardApproval: false` globally ✓ (NOT the issue)

### 3. Branch Protection Rules (Affects automerge AFTER PR creation)

If branch protection requires PR reviews before merging, Renovate **cannot automerge** PRs even with `automerge: true`.

**Repository Settings Required for Automerge:**
- Settings → Branches → Branch protection rules
- Either:
  - Disable "Require approvals" for Renovate PRs
  - Install [renovate-approve](https://github.com/apps/renovate-approve) bot
  - Manually approve PRs after creation

**Note:** This only affects merging, not PR creation.

### 4. Renovate App Permissions (Required for ANY PR creation)

For Renovate to create PRs at all:
- Settings → Installed GitHub Apps → Renovate → Configure
- **Required permissions:**
  - Contents: Read and write
  - Pull requests: Read and write  
  - Checks: Read (optional, for status checks)

## Diagnosis for This Repository

Based on the issue description showing `"result": "needs-approval"` for:
- Digest updates (BOSL2, GitHub Actions)
- Patch updates (OpenSCAD-Windows)

**Root Cause:** Updates are waiting for the **weekend schedule** (`schedule: ["* * * * 0,6"]`)

**Evidence:**
- Dependency Dashboard (issue #23) shows "Awaiting Schedule" section
- All updates listed with checkboxes under "Awaiting Schedule"
- Config has `dependencyDashboardApproval: false` (correct)
- `prNo: null` in logs confirms PRs not created yet

## Solution Options

### Option 1: Allow Weekday PR Creation (Recommended)

Modify the schedule to allow PR creation during weekdays:

**In `renovate.json5`:**
```json
"schedule": ["* * * * *"],  // Run every day instead of weekends only
```

Or for business hours only:
```json
"schedule": ["after 5pm every weekday", "before 9am every weekday", "every weekend"],
```

### Option 2: Manual Bypass (One-time Fix)

Create PRs immediately without changing config:

1. Open Dependency Dashboard issue (#23)
2. Check the boxes under "Awaiting Schedule" section
3. PRs will be created immediately (bypassing schedule)

### Option 3: Keep Weekend Schedule (No Change)

PRs will be created automatically on next Saturday/Sunday. No action needed.

**Note:** Even after PRs are created, they may need manual approval for merging if branch protection requires reviews.

## Testing Your Configuration

To validate your Renovate configuration locally:
```bash
cmd/test/test-renovate-local.sh
```

**Important:** Changes MUST be pushed to the branch before running the test (script runs in Docker context).
