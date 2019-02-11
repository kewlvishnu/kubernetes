from helpers import helpers


def csv_print_namespace(ns_costs):
    """
    print out all estimated namespace prices in a tabular csv format

    :param ns_costs dict: The dictionary of the namespace costs
    """
    print('NAMESPACE, COST')
    rows = helpers.reverse_sort_dict(ns_costs)

    for row in rows:
        ns_name, cost = row
        print('{}, ${:,.2f}'.format(ns_name, cost))


def csv_print_deployments(ns_name, ns_cost, dp_costs):
    """
    print out all estimated deployment prices for a namespace
    in a tabular csv format

    :param ns_name str: the name of the namespace
    :param ns_cost float: the cost of the namespace
    :param dp_costs dict: the dictionary of the deployment names and their
        costs for this namespace
    """
    print('{} Deployments'.format(ns_name, ns_cost))

    print('DEPLOYMENT, COST')
    not_in_dp = ns_cost - sum(cost for cost in dp_costs.values())
    if not_in_dp < 0:
        not_in_dp = 0
    dp_costs['Pods not in Deployment'] = not_in_dp
    percents = helpers.get_percentages(dp_costs)
    rows = helpers.reverse_sort_dict(percents)
    for row in rows:
        dp, percent = row
        print('{}, {:.2f}%'.format(dp, percent))


def csv_print_ec2(ec2_cost, ns_costs, namespaces_to_print):
    """
    print out a table for the ec2 costs in tabular csv format

    :param ec2_cost float: the total ec2 cost
    :param ns_costs dict: the dict of name of namespace to its cost
    """
    percentages = helpers.get_percentages(ns_costs)

    if len(ns_costs) == len(namespaces_to_print):
        print('Overall EC2 Cost, ${:,.2f}'.format(ec2_cost))
    else:
        print('Overall EC2 Cost')
    print('NAMESPACE, COMPARATIVE UTILIZATION, PRICE')

    rows = helpers.reverse_sort_dict(percentages)
    for row in rows:
        ns, percent = row
        if ns not in namespaces_to_print:
            continue
        print(
            '{}, {:.2f}%, ${:,.2f}'.format(ns, percent*100, percent*ec2_cost))
