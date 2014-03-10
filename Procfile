web:         sh -c 'cd web && bundle exec rails server'
exports_rpc: sh -c 'cd exports_rpc && bundle exec shotgun config.ru'
rabbitmq:    ./rabbitmq_server-3.2.4/sbin/rabbitmq-server
auditor:     sh -c 'cd auditor && ruby app.rb'
mongo:       ./mongodb-osx-x86_64-2.4.9/bin/mongod --dbpath mongodb-osx-x86_64-2.4.9/db
