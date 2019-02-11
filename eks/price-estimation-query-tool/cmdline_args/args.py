import argparse


def parse_args():
    """
    parses the args passed from the cmd line and returns the obj
    holding them

    :returns argparse: the cmd line argument values
    """
    parser = argparse.ArgumentParser(
        description='Query the TICK stack to estimate prices for k8s')

    # Optional
    parser.add_argument(
        '-s', '--source', type=int,
        help=('The source db to use. Only need to specify this if you are '
              'using more than one in chronograf.'))
    parser.add_argument(
        '--from', type=str, dest='from_time',
        help=('The date to start the query/calculation from. '
              'Default: 30 days ago. Can specify using influxql syntax.')
    )
    parser.add_argument(
        '--to', type=str, dest='to_time',
        help=('The date to end the query/calculation with. Default: Now. '
              'Can specify using influxql syntax.')
    )
    parser.add_argument(
        '--namespace', type=str, action='append',
        help='Print out specified namespace. Multiple allowed'
    )
    parser.add_argument(
        '--csv', action='store_true',
        help='Output the results in csv format'
    )
    parser.add_argument(
        '--email', action='store_true',
        help='Output the results in text format for email body'
    )

    # Required
    parser.add_argument(
        'host', type=str, help='The chronograf url. Include the port/protocol')

    return parser.parse_args()
