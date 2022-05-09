#!/usr/bin/env bash
set -eo pipefail

BASE="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"

cd "$BASE"/../

main() {
    ENV=$1

    echo use $ENV env
    case $ENV in
    local)
      export HASURA_ENV=local
      export STACKS_ENV=local
      ;;
    shared_dev)
      export HASURA_ENV=shared_dev
      export STACKS_ENV=regtest3
      ;;
    dev|regtest3)
      export HASURA_ENV=regtest3
      export STACKS_ENV=regtest3
      ;;
    prod|mainnet)
      export HASURA_ENV=mainnet
      export STACKS_ENV=mainnet
      ;;
    current)
      export HASURA_ENV=current
      export STACKS_ENV=current
      ;;
    *)
      echo unkown env "$ENV"
      exit 1
      ;;
    esac

    ############################################# HASURA_ENV #############################################
    case $HASURA_ENV in
    local)
      export HASURA_HOST="http://localhost:8080"
      export X_HASURA_ADMIN_SECRET="ed1dynCpdTreu5a"
      echo "You're using your local hasura instance."
      echo "  Hasura Console: http://localhost:8080/console"
      ;;
    shared_dev)
      export HASURA_HOST="https://gql-dev.alexgo.dev"
      export X_HASURA_ADMIN_SECRET="ed1dynCpdTreu5a"
      echo "You're using shared dev hasura instance, it's for development."
      echo "  Hasura Console: https://gql-dev.alexgo.dev"
      ;;
    regtest3)
      export HASURA_HOST="https://gql.alexgo.dev"
      export X_HASURA_ADMIN_SECRET="ed1dynCpdTreu5a"
      echo "You're using hasura-regtest3 instance."
      echo "  Hasura Console: https://gql.alexgo.dev"
      ;;
    mainnet)
      export HASURA_HOST="https://hasura-console-dks44dnbuq-uw.a.run.app"
      export X_HASURA_ADMIN_SECRET="znstEB5VtFHv3WZ"
      echo "You're using hasura-mainnet instance."
      echo "  Hasura Console: https://hasura-console.alexlab.co"
      ;;
    current)
      echo "You're using current env."
      echo "-----------------------------"
      echo "HASURA_HOST: $HASURA_HOST"
      echo "X_HASURA_ADMIN_SECRET: $X_HASURA_ADMIN_SECRET"
      echo "-----------------------------"
      ;;
    *)
      echo unkown hasura env "$HASURA_ENV"
      exit 1
      ;;
    esac

    ############################################# STACKS_ENV #############################################
    case $STACKS_ENV in
    local)
      export STACKS_NODE_TYPE="StacksMocknet"
      export STACKS_NODE_ADDRESS="http://localhost:3999"
      export STACKS_DEPLOYER_ADDRESS="ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE"
      export ESTIMATED_BLOCK_DURATION=15000
      export ALEX_CONTRACT_NAME_LAUNCHPAD="alex-launchpad-v1-1"
      ;;
    regtest3)
      export STACKS_NODE_TYPE="StacksMocknet"
      export STACKS_NODE_ADDRESS="https://stacks-node-api.alexgo.dev"
      export STACKS_DEPLOYER_ADDRESS="ST1J2JTYXGRMZYNKE40GM87ZCACSPSSEEQVSNB7DC"
      export ESTIMATED_BLOCK_DURATION=15000
      export ALEX_CONTRACT_NAME_LAUNCHPAD="alex-launchpad-v1-1"
      ;;
    mainnet)
      export STACKS_NODE_TYPE="StacksMainnet"
      export STACKS_NODE_ADDRESS="https://stacks-blockchain-mainnet-dks44dnbuq-uw.a.run.app"
      export STACKS_DEPLOYER_ADDRESS="SP3K8BC0PPEVCV7NZ6QSRWPQ2JE9E5B6N3PA0KBR9"
      export ESTIMATED_BLOCK_DURATION=600000
      export ALEX_CONTRACT_NAME_LAUNCHPAD="alex-launchpad"
      ;;
    current)
      echo "You're using current stacks env."
      echo "-----------------------------"
      echo "STACKS_NODE_TYPE: $STACKS_NODE_TYPE"
      echo "STACKS_NODE_ADDRESS: $STACKS_NODE_ADDRESS"
      echo "STACKS_DEPLOYER_ADDRESS: $STACKS_DEPLOYER_ADDRESS"
      echo "ESTIMATED_BLOCK_DURATION: $ESTIMATED_BLOCK_DURATION"
      echo "ALEX_CONTRACT_NAME_LAUNCHPAD: $ALEX_CONTRACT_NAME_LAUNCHPAD"
      echo "-----------------------------"
      ;;
    *)
      echo unkown stacks env "$STACKS_ENV"
      exit 1
      ;;
    esac

    pushd env/base/
    FILES=$(find . -type f)
    popd

    for f in $FILES
    do
      writeTemplateFile "$f"
    done

    echo "$ENV" > "$BASE"/.current_project
    echo "switched to env $ENV"
}

linkFile() {
  ORIGIN_FILE_PATH=$1
  LINK_FILE_PATH=$2
  rm -f $LINK_FILE_PATH
  ln -s $ORIGIN_FILE_PATH $LINK_FILE_PATH
}

copyFile() {
  ORIGIN_FILE_PATH=$1
  COPY_FILE_PATH=$2
  rm -f $COPY_FILE_PATH
  cp $ORIGIN_FILE_PATH $COPY_FILE_PATH
  chmod 400 $COPY_FILE_PATH
}

writeTemplateFile() {
  FILE_PATH=$1
  FILE_DIR=$(dirname "${FILE_PATH}")
  mkdir -p "$FILE_DIR"
  rm -f "$ROOT"/"$FILE_PATH"
  "$BASE"/mo "$BASE"/base/"$FILE_PATH" > "$ROOT"/"$FILE_PATH"
  chmod 400 "$ROOT"/"$FILE_PATH"
}

usage() {
  echo 'Current env:'
  if [ -e "$ROOT/env/.current_project" ]; then
    cat $ROOT/env/.current_project
  else
    echo 'N/A'
  fi
  echo
  echo './use.sh <ENV>'
  echo '  Example: ./use.sh local'
  echo '  Supported ENV: local, dev/regtest3, prod/mainnet'
  echo '  Please refer to README.md for detail explanation.'
}

if [ "$1" == "-h" ]
then
  usage
elif [ -n "${1-}" ]
then
  main "$1"
else
  usage
fi
