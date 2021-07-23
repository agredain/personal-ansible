# Kills all docker containers running
alias docker-kill-all='docker kill `docker ps -aq`'

# Deletes all docker containers
alias docker-rm-all='docker rm `docker ps -aq`'