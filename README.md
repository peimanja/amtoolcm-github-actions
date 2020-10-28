# amomtool GitHub Actions

amomtool GitHub Actions allow you to check Prometheus Alertmanager config within GitHub Actions.

The output of the actions can be viewed from the Actions tab in the main repository view. If the actions are executed on a pull request event, a comment may be posted on the pull request.

## Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

amomtool GitHub Actions are a single GitHub Action that executes amtool check-config subcommand.

```yaml
name: Check Prometheus Alertmanager Config

on:
  pull_request:
    paths:
    - 'alertmanager/config.yml'

jobs:
  on-pull-request:
    name: On Pull Request
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Repo
      uses: actions/checkout@master

    - name: Check Prometheus Alertmanager Config
      uses: peimanja/amtool-github-actions@master
      with:
        amtool_actions_config: 'alertmanager/config.yml'
        amtool_actions_version: '0.21.0'
        amtool_actions_comment: true
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

Inputs configure amtool GitHub Actions to perform different actions.

* `amtool_actions_config` - (Required) Path to Alertmanager config file. 
* `amtool_actions_version` - (Optional) amtool version to install and execute (Alertmanager bundle version). The default is set to `latest` and the latest stable version will be pulled down automatically.
* `amtool_actions_comment` - (Optional) Whether or not to comment on GitHub pull requests. Defaults to `true`.

## Secrets

Secrets are similar to inputs except that they are encrypted and only used by GitHub Actions. It's a convenient way to keep sensitive data out of the GitHub Actions workflow YAML file.

* `GITHUB_TOKEN` - (Optional) The GitHub API token used to post comments to pull requests. Not required if the `amtool_actions_comment` input is set to `false`.
