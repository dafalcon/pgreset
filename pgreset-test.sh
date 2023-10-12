#!/usr/bin/env bash

# This is a simple script to test pgreset against different versions of ruby and rails.
# Right now it expects to connect to postgres through a socket in /tmp as a given user
# with no password.

function die
{
  echo "$*" >&2
  exit 1
}

if [[ ! -f "pgreset.gemspec" ]]; then
  die "This script must be run from the pgreset source directory"
fi

if [[ -z "$3" ]]; then
  die "Usage: $0 RUBY_VERSION RAILS_VERSION POSTGRES_USERNAME"
fi


source "$HOME/.rvm/scripts/rvm"

set -e

PGRESET_DIR="$(pwd)"
RUBY_VERSION="ruby-$1"
RAILS_VERSION="$2"
PG_USER="$3"

# can't have periods in the database name
TEST_NAME="$(echo pgreset-test-rails-$RAILS_VERSION | sed 's/\./-/g')"

rvm install "$RUBY_VERSION"
rvm use "$RUBY_VERSION"
rvm --force gemset delete "$TEST_NAME"
rvm gemset create "$TEST_NAME"
rvm gemset use "$TEST_NAME"
cd /tmp
rm -rf "$TEST_NAME"
gem install rails -N -v "$RAILS_VERSION"
rails new "$TEST_NAME"
cd "$TEST_NAME"
echo "gem 'pg'" >> Gemfile
echo "gem 'pgreset', path: \"${PGRESET_DIR}\"" >> Gemfile
bundle install
rails g model user name:string

echo "development: 
  adapter: postgresql
  encoding: UTF8
  username: $PG_USER
  host: /tmp
  database: $TEST_NAME
" > config/database.yml

dropdb --if-exists -f "$TEST_NAME"
rails db:create
rails db:migrate


# Start a connection to the database.
# If pgreset works properly, this will automatically be disconnected
# with an error saying the server closed the connection unexpectedly.
psql -U "$PG_USER" "$TEST_NAME" -c 'select pg_sleep(120);' >log/psql.log 2>&1 &  
sleep 1 # make sure psql is fully connected

rails db:reset

if grep 'terminating connection due to administrator command' log/psql.log >/dev/null ; then
  echo "pgreset successfully terminated the postgres connection!"
else
  echo "Hmm something doesn't look right.  Here's the psql output:"
  echo
  cat log/psql.log
fi
