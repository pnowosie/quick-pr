# Script installation directory (default: `$HOME/.quick-pr`)
BASE_DIR="${HOME}/.quick-pr"
# Let's use GitHub login as a branch prefix
BRANCH_PREFIX="$(gh api user | jq -r .login)/"

# prepare commit text that pr will be filled with
bash ${BASE_DIR}/whats-on-me.sh "$1" > /tmp/jira-commit-template
cat ${BASE_DIR}/pull_request_template.md >> /tmp/jira-commit-template

# NOTE: The following `/tmp/jira-*` are written by `whats-on-me` tool
SLUG=$(cat /tmp/jira-ticket-slug)
JKEY=$(cat /tmp/jira-ticket-key)

BRANCH="${BRANCH_PREFIX}${SLUG}-${JKEY}"
read -r -p "branch: (${BRANCH}): ${BRANCH_PREFIX}" USER_BRANCH
[[ -n "${USER_BRANCH}" ]] && BRANCH="${BRANCH_PREFIX}${USER_BRANCH}-${JKEY}"

git checkout master
git pull
git checkout -b "${BRANCH}"

git commit --allow-empty -t /tmp/jira-commit-template \
&& gh pr create --fill --draft
