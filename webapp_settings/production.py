from .base import *

DEBUG = False

SECRET_KEY = '{{ vault_django_secret }}'

ADMINS = (
    ('WCIVF Developers', 'developers@democracyclub.org.uk'),
)

MANAGERS = ADMINS

ALLOWED_HOSTS = [
    "*"
]

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': '{{ project_name }}',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
        'CONN_MAX_AGE': 300,
    },
    'logger': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'wcivf_logger',
        'USER': 'wcivf',
        'PASSWORD': '{{ vault_logger_db_password }}',
        'HOST': '{{ vault_logger_db_host }}',
        'PORT': '',
    }

}

DATABASE_ROUTERS = [
    'core.db_routers.LoggerRouter',
]

SESSION_ENGINE = "django.contrib.sessions.backends.signed_cookies"

WDIV_API_KEY = "{{ vault_wdiv_api_key }}"
SLACK_FEEDBACK_WEBHOOK_URL = "{{ vault_slack_feedback_webhook_url }}"  # noqa


GOCARDLESS_APP_ID="{{ vault_gocardless_app_id }}"
GOCARDLESS_APP_SECRET="{{ vault_gocardless_app_secret }}"
GOCARDLESS_ACCESS_TOKEN="{{ vault_gocardless_access_token }}"
GOCARDLESS_MERCHANT_ID="{{ vault_gocardless_merchant_id }}"
GOCARDLESS_ACCESS_TOKEN = "{{ vault_gocardless_access_token }}"

CHECK_HOST_DIRTY = True
DIRTY_FILE_PATH = "~/server_dirty"
EE_BASE = "http://localhost:8000"


EMAIL_SIGNUP_ENDPOINT = 'https://democracyclub.org.uk/mailing_list/api_signup/v1/'
EMAIL_SIGNUP_API_KEY = '{{ vault_email_signup_api_key }}'

import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration

sentry_sdk.init(
    dsn="{{ vault_sentry_dsn }}",
    integrations=[DjangoIntegration()]
)
