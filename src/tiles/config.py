import logging.config

from logstash_formatter import LogstashFormatterV1


DEBUG = True


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            '()': LogstashFormatterV1
        },
    },
    'handlers': {
        'console': {
            'level': logging.DEBUG if DEBUG else logging.INFO,
            'class': 'logging.StreamHandler',
            'formatter': 'standard',
        },
    },
    'loggers': {
        '': {
            'handlers': ['console', ],
            'level': logging.DEBUG,
            'propagate': True,
        },
    }
}

logging.config.dictConfig(LOGGING)
