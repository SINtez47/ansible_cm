#!/usr/bin/env bash

ansible-playbook -vv \
	-i inventory/local.yml \
	-k -K \
	playbook.yml \
	-b --ask-vault-pass

