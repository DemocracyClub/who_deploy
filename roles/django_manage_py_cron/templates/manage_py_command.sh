# This is a script that makes runnning manage.py inside a virtualenv from
# cron easier.
# It does a few thigns:
#     1. It wraps comands in `output-on-error`
#     2. It calls the manage.py with the virtualenv's python
# It required a var `{{ project_name }}` and for the project to be at
# /var/www/{{ project_name }}
/usr/local/bin/output-on-error /var/www/{{ project_name }}/env/bin/python /var/www/{{ project_name }}/code/manage.py "$@"
