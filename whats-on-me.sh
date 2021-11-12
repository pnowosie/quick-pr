# Assumes environment variables
if [ -z "$JIRA_API_TOKEN" ]; then
  echo "JIRA_API_TOKEN envvar not set"
  exit 1
fi

if [ -z "$JIRA_TENANT" ]; then
  echo "JIRA_TENANT envvar not set"
  exit 1
fi

# Here is a JIRA user email for auth, possibly same as committer email
GOLEM_EMAIL=$(git config user.email)
JIRA_API_URL="https://${JIRA_TENANT}.atlassian.net/rest/api/3"
JIRA_WEB_URL="https://${JIRA_TENANT}.atlassian.net/browse"

# Excuse the magic numbers and my ignorance in jira api
JQL="project=10020 \
and status!=done and status!=10031 \
and assignee=currentuser()"

FIELDS="key,description,priority,summary,status"

RESPONSE=$(http --json -b \
     -a "${GOLEM_EMAIL}:${JIRA_API_TOKEN}" \
     "${JIRA_API_URL}/search?jql=${JQL}&fields=${FIELDS}&expand=renderedFields")

if [ -z "$1" ]; then
  # Gets simple list of key: summary
  echo ${RESPONSE} | jq '.issues[] | { (.key): [.fields.priority.name, .fields.summary] }' | jq -sS 'add'
else
  KEY=$(echo $RESPONSE | jq -r '.issues[].key' | ag "$1")
  if [ "$KEY" ]; then
    TICKET_DATA=$(echo $RESPONSE | jq -r --arg KEY "$KEY" '.issues[] | select(.key==$KEY)')
    TICKET_TITLE=$(echo $TICKET_DATA | jq -r '.fields.summary')
    ## see: https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
    SLUG=$(echo "$TICKET_TITLE" \
      | iconv -t ascii//TRANSLIT \
      | sed -r s/[^a-zA-Z0-9]+/-/g \
      | sed -r s/^-+\|-+$//g \
      | tr A-Z a-z)

    printf "${KEY}" > /tmp/jira-ticket-key
    printf "$SLUG" > /tmp/jira-ticket-slug


    echo "${TICKET_TITLE}"
    echo ""
    echo "${JIRA_WEB_URL}/$KEY"
    echo ""
    #echo $TICKET_DATA | jq
    echo $TICKET_DATA \
      | jq -r '.renderedFields.description' \
      | html2text -nobs -ascii
  else
    echo "Not found $1. Keys:"
    echo $RESPONSE | jq -r '.issues[].key' 
  fi
fi
