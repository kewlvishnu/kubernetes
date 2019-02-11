import re

# ex: 1m
duration_regex = re.compile(r'[1-9][0-9]*(ns|u|ms|µ|s|m|h|d|w)')
# ex: 2006-01-02 15:04:05.999999
datetime_regex = re.compile(r'[1-2][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])( (0[1-9]|1[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\.[0-9]{6})?)?')  # NOQA


def parse_time(from_time, to_time):
    """
    parses the from_time and to_time to return the when statement
    for the query

    :param from_time str: the from time string
    :param to_time str: the to time string
    :returns str, str: the when blocks for the from, to times
    :raises ValueError: if the times are invalid format
    """
    final_from = 'time >= '
    if from_time is None:
        final_from += 'now() - 30d'
    elif duration_regex.match(from_time):
        final_from += 'now() - '+from_time
    elif datetime_regex.match(from_time):
        final_from += "'{}'".format(from_time)
    else:
        raise ValueError('The passed "from" time is not a valid format.')

    final_to = 'time <= '
    if to_time is None:
        final_to += 'now()'
    elif duration_regex.match(to_time):
        final_to += 'now() - '+to_time
    elif datetime_regex.match(to_time):
        final_to += "'{}'".format(to_time)
    else:
        raise ValueError('The passed "to" time is not a valid format.')

    return final_from, final_to
