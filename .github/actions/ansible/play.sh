#!/usr/bin/env bash

./lint.sh

if [[ -z $(grep '[^[:space:]]' lint.log) ]] ; then

ansible-playbook -vv \
	-i inventory/local.ini \
	-k -K \
	playbook.yml \
	-b --ask-vault-pass

fi
