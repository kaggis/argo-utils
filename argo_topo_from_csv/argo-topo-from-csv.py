#!/usr/bin/env python

import sys
import argparse
import logging
import csv
import json
import urllib2

from io import StringIO


log = logging.getLogger(__name__)



def get_remote_csv(url):
    response = urllib2.urlopen(url)
    content = response.read()
    return content


def csv_to_json(content):
    f = StringIO(content.decode('utf-8'))
    reader = csv.reader(f, delimiter=',')

    num_row = 0
    results = []
    header = []
    for row in reader:
        if num_row == 0:
            header = row
            num_row = num_row + 1
            continue
        num_item = 0
        datum = {}
        for item in header:
            datum[item] = row[num_item]
            num_item = num_item + 1
        results.append(datum)
        
    return results

def save_json(json_object, path):
    with open(path, 'w') as outfile:
        json.dump(json_object, outfile)

def main(args=None):

    # get the resource
    csv_content = get_remote_csv(args.url)

    # transform it
    json_obj = csv_to_json(csv_content)

    # save it
    save_json(json_obj, args.output)


if __name__ == "__main__":

    # To run it from command line make sure is executable with chmod and issue:
    # ./argo-topo-from-csv -i "https://path/to/online/csv" -o ./output.json

    parser = argparse.ArgumentParser(description="Get argo topology in json from csv online source")
    parser.add_argument(
        "-u", "--url", metavar="STRING", help="url endpoint of csv source", required=True, dest="url")
    parser.add_argument(
        "-o", "--output", metavar="STRING", help="filename path to output json to", required=True, dest="output")

    # Pass the arguments to main method
    sys.exit(main(parser.parse_args()))