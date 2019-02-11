from tick.chronograf import ChronografAPI
from tick import chronograf, influx_time
from cmdline_args import args
from printing import csv, pprint, email
from helpers import helpers


def main():
    """
    get the cmdline flags, get the data from influx, and then
    print the data back
    """
    cmdargs = args.parse_args()

    # Get sources and pick one
    sources = chronograf.get_sources(cmdargs.host)
    source_to_use = pick_source(sources, cmdargs.source)

    # Get time ranges
    from_time, to_time = influx_time.parse_time(
        cmdargs.from_time, cmdargs.to_time)

    # Make API obj and get ns_costs
    api = ChronografAPI(cmdargs.host, source_to_use)
    ns_costs = get_cost_per_namespace(api, from_time, to_time)
    percents = helpers.get_percentages(ns_costs)
    ec2_cost = get_actual_ec2_cost(api, from_time, to_time)

    # Exit if no ns are specified
    if len(ns_costs) == 0:
        print('No results returned...')
        exit(0)

    if cmdargs.namespace is None:
        cmdargs.namespace = ns_costs.keys()

    # Print out the results
    print_results(cmdargs, ns_costs, api, from_time,
                  to_time, percents, ec2_cost)


def print_results(cmdargs, ns_costs, api, from_time,
                  to_time, percents, ec2_cost):
    """
    prints out the results to the screen

    params are all passed from the main function
    """
    # Different printing methods for csv vs table pprint vs email txt
    if cmdargs.csv:
        rows = helpers.reverse_sort_dict(ns_costs)
        for row in rows:
            ns, cost = row
            if ns not in cmdargs.namespace:
                continue
            cost = ns_costs[ns]
            dp_costs = get_cost_per_deployment(api, ns, from_time, to_time)
            csv.csv_print_deployments(ns, cost, dp_costs)
            print('\n', end='')
        print('\n', end='')
        csv.csv_print_ec2(ec2_cost, ns_costs, cmdargs.namespace)
    elif cmdargs.email:
        rows = helpers.reverse_sort_dict(percents)
        for row in rows:
            ns, percent = row
            if ns in cmdargs.namespace:
                email.email_print_ns(ns, percent, ec2_cost)
    else:
        rows = helpers.reverse_sort_dict(ns_costs)
        for row in rows:
            ns, cost = row
            if ns not in cmdargs.namespace:
                continue
            cost = ns_costs[ns]
            dp_costs = get_cost_per_deployment(api, ns, from_time, to_time)
            pprint.pprint_namespace(ns, cost, dp_costs)
        pprint.pprint_ec2(ec2_cost, percents, cmdargs.namespace)


def pick_source(sources, cmdline_source):
    """
    given a list of db sources, pick either the only one or whichever
    specified on the cmdline

    :param sources list: the list of sources returned from the api
    :param cmdline_source int or None: The cmdline argument from argparse
    :returns int: the id of the source
    """
    if cmdline_source is not None:
        for s in sources:
            if s['id'] == cmdline_source:
                return s
        raise ValueError('Source {} not found'.format(cmdline_source))
    else:
        check_sources(sources)
        return sources[0]


def check_sources(sources):
    """
    Makes sure that the len of the sources list isn't >1 or 0

    :param sources list: the list of sources returned from the api
    :raises ValueError: if length of sources list != 1
    """
    if len(sources) == 0:
        raise ValueError('No sources configured on chronograf')
    elif len(sources) > 1:
        print('Found sources:')
        for s in sources:
            print(s)
        raise ValueError('More than 1 source in chronograf. '
                         'Please use the command line flag to '
                         'pass in the id to the correct source.')


def get_cost_per_namespace(api, from_time, to_time):
    """
    queries the db and returns an estimate cost of each namespace from
    from_time to to_time

    :param api tick.ChronografAPI: the api object to use
    :param from_time str: the time to start from
    :param to_time str: the time to stop at
    :returns dict: {ns_name:cost}
    """
    query = """
        SELECT sum("mean_price") FROM
            (SELECT mean("price") AS "mean_price"
             FROM "telegraf"."price-estimation-rp"."price-estimation_namespace-prices"
             WHERE {} AND {}
             GROUP BY time(1h) FILL(0))
        GROUP BY "namespace"
    """.format(from_time, to_time)  # NOQA
    r = api.query(query)
    if len(r['results']) == 0 or 'series' not in r['results'][0]:
        return {}
    # pull the data out of the response
    data = {}
    for nsdata in r['results'][0]['series']:
        nsname = nsdata['tags']['namespace']
        index = nsdata['columns'].index('sum')
        val = float(nsdata['values'][0][index])
        data[nsname] = val
    return data


def get_cost_per_deployment(api, namespace, from_time, to_time):
    """
    queries the db and returns an estimate cost of each deployment from
    the given namespace from from_time to to_time

    :param api tick.ChronografAPI: the api object to use
    :param namespace str: the namespace to use
    :param from_time str: the time to start from
    :param to_time str: the time to stop at
    :returns dict: {deployment_name:cost}
    """
    query = """
        SELECT sum("mean_price") FROM
            (SELECT mean("price") AS "mean_price"
             FROM "telegraf"."price-estimation-rp"."price-estimation_deployment-prices"
             WHERE {} AND {} AND namespace='{}'
             GROUP BY time(1h) FILL(0))
        GROUP BY "deployment"
    """.format(from_time, to_time, namespace)  # NOQA
    r = api.query(query)
    if len(r['results']) == 0 or 'series' not in r['results'][0]:
        return {}
    # pull the data out of the response
    data = {}
    for dpdata in r['results'][0]['series']:
        dpname = dpdata['tags']['deployment']
        index = dpdata['columns'].index('sum')
        val = float(dpdata['values'][0][index])
        data[dpname] = val
    return data


def get_actual_ec2_cost(api, from_time, to_time):
    """
    queries the db and returns the estimate cost of this cluster's
    instances from from_time to to_time

    :param api tick.ChronografAPI: the api object to use
    :param from_time str: the time to start from
    :param to_time str: the time to stop at
    :returns float: estimated ec2 price
    """
    query = """
        SELECT sum("price")
        FROM "telegraf"."price-estimation-rp"."price-estimation_node-prices"
        WHERE {} AND {}
    """.format(from_time, to_time)
    r = api.query(query)
    if len(r['results']) == 0 or 'series' not in r['results'][0]:
        return 0
    # pull the price out of the response
    index = r['results'][0]['series'][0]['columns'].index('sum')
    return r['results'][0]['series'][0]['values'][0][index]


# Run the main function
main()
