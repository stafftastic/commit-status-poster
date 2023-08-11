# commit-status-poster
Posts a GitHub Commit Status using a GitHub App to a given reference

## Running
Requires the following environment variables:
* `GITHUB_APP_ID`
* `GITHUB_APP_INSTALLATION_ID`
* `GITHUB_APP_PRIVATE_KEY_FILE`: Path pointing to a file containing the private key.
* `GITHUB_COMMIT_STATUS_STATE`: One of `error`, `failure`, `pending`, `success`.
* `GITHUB_COMMIT_STATUS_TARGET_URL`: URL for the "Details" link appearing next to the status.
* `GITHUB_COMMIT_STATUS_DESCRIPTION`: Description describing the current status, e.g. "Deploying..."
* `GITHUB_COMMIT_STATUS_CONTEXT`: The name that appears on GitHub. Must be the same when updating an
	existing status.
* `GITHUB_OWNER`
* `GITHUB_REPO`
* `GITHUB_REF`: The commit hash the status applies to.
