
[ -z "$NODE_ENV" ] && export NODE_ENV=production
[ -z "$COUCH_HOST" ] && export COUCH_HOST=localhost
[ -z "$COUCH_PORT" ] && export COUCH_PORT=5984
[ -z "$COUCH_DB_NAME" ] && export COUCH_DB_NAME=caliper
[ -z "$HOST_PROTOCOL" ] && export HOST_PROTOCOL=http
[ -z "$HOST_DOMAIN" ] && export HOST_DOMAIN=localhost
[ -z "$HOST_PORT" ] && export HOST_PORT=9000

[ -z "$GOOGLE_CLIENT_ID" ] && export GOOGLE_CLIENT_ID=test_id
[ -z "$GOOGLE_CLIENT_SECRET" ] && export GOOGLE_CLIENT_SECRET=test_secret
#configure couchdb
echo -e "\n[query_server_config]\nreduce_limit = false" >> /etc/couchdb/local.ini

#run couchdb
couchdb &

# wait for couchdb to be up, pulled from: http://stackoverflow.com/questions/11904772/how-to-create-a-loop-in-bash-that-is-waiting-for-a-webserver-to-respond
printf 'waiting for couchdb to get up'
until $(curl --output /dev/null --silent --head --fail http://localhost:5984); do
    printf '.'
    sleep 5
done

#run the app:
node /app/dist/server/app.js
