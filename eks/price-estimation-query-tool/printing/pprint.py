from prettytable import PrettyTable
from helpers import helpers


def pprint_namespace(namespace, ns_cost, dp_costs):
    """
    print out a table for a namespace costs in "pretty" format

    :param namespace str: the name of the namespace
    :param ns_cost float: the cost of the namespace
    :param dp_costs dict: the dictionary of the deployment names and their
        costs for this namespace
    """
    table = PrettyTable()
    table.title = namespace
    table.field_names = ['Deployment', 'Percent of Cost']

    not_in_dp = ns_cost - sum(cost for cost in dp_costs.values())
    if not_in_dp < 0:
        not_in_dp = 0
    dp_costs['Pods not in Deployment'] = not_in_dp
    dp_percents = helpers.get_percentages(dp_costs)

    rows = helpers.reverse_sort_dict(dp_percents)
    for row in rows:
        dp, percent = row
        table.add_row([dp, '{:.2f}%'.format(percent*100)])
    print(table)


def pprint_ec2(ec2_cost, percentages, namespaces_to_print):
    """
    print out a table for the ec2 costs in "pretty" format

    :param ec2_cost float: the total ec2 cost
    :param ns_costs dict: the dict of name of namespace to its cost
    """
    rows = helpers.reverse_sort_dict(percentages)

    table = PrettyTable()
    table.title = 'Overall EC2 Cost = ${:,.2f}'.format(ec2_cost)
    table.field_names = ['Namespace', 'Comparative Utilization', 'Price']
    for row in rows:
        ns, percent = row
        if ns not in namespaces_to_print:
            continue
        table.add_row([
            ns,
            '{:.2f}%'.format(percent*100),
            '${:,.2f}'.format(percent*ec2_cost)
        ])
    print(table)
