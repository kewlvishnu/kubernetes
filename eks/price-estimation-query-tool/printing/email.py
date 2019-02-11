def email_print_ns(ns_name, ns_percentage, ec2_cost):
    print(('The {} namespace used {:.2f}% of the cluster compared to the rest'
           ' of the namespaces. Given the price of the EC2 instances, that'
           ' equates to ${:,.2f}.').format(ns_name, ns_percentage*100,
                                           ns_percentage*ec2_cost))
