# GH tool demo for Golem!

## Abstract

- switching context harms productivity
- switching windows (to internet browser) may harm it as well
- let's use `gh` to never need to switch away from the terminal (vim)


## JIRA <-> GitHub integration
(current version)

- when PR is drafted -> ticked moves to `IN PROGRESS`
- when PR is merged -> ticket changes to `DONE`
- :( no way to change status to `IN REVIEW`

👉 We should open PRs as soon as posible!
...but how, when no real work has been done?
...and there is no branch to commit?


## Commands

### - `whats-on-me`
Shows list of tickets assigned to me or if called with a part of the ticket key
shows the description and writes `/tmp/jira-ticket-key` and `tmp/jira-ticket-slug` files.

### - `quick-pr`
`Quick PR` does the following:
- changes current folder's repo to _master_
- pulls the latest changes
- creates new branch on top of the master
- commits empty commit with text template and allows edition
- creates draft pull request


## Prerequisities

Scripts assuemes the following commands are available in the PATH
- `git` command
- `gh` - the [GitHub CLI](https://cli.github.com/) tool
- `jq` - [jq is like sed for JSON data](https://stedolan.github.io/jq/)
- `html2text` - [html2text man page](https://linux.die.net/man/1/html2text)


The following environment variables are assumed to be set
- `JIRA_API_TOKEN` - browse to [Jira Api tokens](https://id.atlassian.com/manage-profile/security/api-tokens) and create one
- `JIRA_TENANT` - browse to project board and pay attention to the page's url. It's here: `https://<JIRA_TENANT>.atlassian.net/...`

Write permission in `/tmp` directory.


## Instalation

```bash
cd
git clone https://github.com/pnowosie/quick-pr.git .quick-pr
```

For the convenient usage put these 2 scripts under the path or create an aliases
```bash
alias whats-on-me="bash $HOME/.quick-pr/whats-on-me.sh"
alias quick-pr="bash $HOME/.quick-pr/quick-pr.sh"
```

:exclamation: Make sure you set env vars mentioned in previous section.


## Usage

- Get list of the tasks assigned to me
```bash
> whats-on-me
{
	...
	"APPS-491": [
		"None",
		"Opensource quick-pr tool"
	]
}
```

- More about the task
```bash
> whats-on-me 491 # part of the task key
Opensource quick-pr tool # (TASK SUMMARY)

https://<JIRA_TENANT>.atlassian.net/browse/APPS-491 # (URL)

As discussed during Team Contract review. # (TASK DESCRIPTION)
```

- Create draft PR 
(run inside git repo folder)

```bash
> quick-pr 491

:mage: magic will happen 
```
