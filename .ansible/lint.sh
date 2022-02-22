#!/bin/bash
yamllint . > lint.log
ansible-lint >> lint.log
