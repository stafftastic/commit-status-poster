package main

import (
	"context"
	"fmt"
	"os"
	"net/http"
	"strconv"

	"github.com/bradleyfalzon/ghinstallation/v2"
	"github.com/google/go-github/v53/github"
)

func envAsInt64(envVar string) int64 {
	i, err := strconv.ParseInt(os.Getenv(envVar), 10, 64)
	if err != nil {
		panic(err)
	}
	return i
}

func newGithubClient() *github.Client {
	appId := envAsInt64("GITHUB_APP_ID")
	installationId := envAsInt64("GITHUB_APP_INSTALLATION_ID")
	privateKeyFile := os.Getenv("GITHUB_APP_PRIVATE_KEY_FILE")
	itr, err := ghinstallation.NewKeyFromFile(http.DefaultTransport, appId, installationId, privateKeyFile)
	if err != nil {
		panic(err)
	}
	return github.NewClient(&http.Client{Transport: itr})
}

func newStatus() *github.RepoStatus {
	return &github.RepoStatus{
		State: github.String(os.Getenv("GITHUB_COMMIT_STATUS_STATE")),
		TargetURL: github.String(os.Getenv("GITHUB_COMMIT_STATUS_TARGET_URL")),
		Description: github.String(os.Getenv("GITHUB_COMMIT_STATUS_DESCRIPTION")),
		Context: github.String(os.Getenv("GITHUB_COMMIT_STATUS_CONTEXT")),
	}
}

func main() {
	client := newGithubClient()
	status := newStatus()
	returnedStatus, _, err := client.Repositories.CreateStatus(
		context.Background(),
		os.Getenv("GITHUB_OWNER"),
		os.Getenv("GITHUB_REPO"),
		os.Getenv("GITHUB_REF"),
		status,
	)
	if err != nil {
		panic(err)
	}
	fmt.Println(returnedStatus.String())
}
