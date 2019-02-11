def get_percentages(costs):
    """
    given a dictionary of costs, create a new dictionary of
    names with the percentage of their cost against the total
    estimated amount

    :param costs dict: the dictionary of the costs
    """
    # Get ns percentages of cost
    total_cost = sum(costs.values())
    percentages = {}
    for name, cost in costs.items():
        if total_cost == 0:
            percentages[name] = 0
        else:
            percentages[name] = cost/total_cost
    return percentages


def reverse_sort_dict(d):
    """
    given a dictionary, reverse sort the dictionary by the value
    and return a list of the key value pairs

    :param d dict: the dictionary to reverse sort
    :returns list: a list of tuples of (key, value) in reverse sorted
        order
    """
    rows = []
    for name, val in d.items():
        rows.append((name, val))
    rows.sort(key=lambda x: x[1], reverse=True)
    return rows
