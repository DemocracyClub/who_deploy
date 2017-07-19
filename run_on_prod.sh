ansible -u sym -i dynamic-inventory/ -b --become-user wcivf tag_Env_prod -m shell -a "$@"
