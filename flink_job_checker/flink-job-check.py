#!/usr/bin/env python

import argparse
import logging
import json
import requests
import sys
import re



log = logging.getLogger(__name__)



def read_check_json(check_file_path):
    with open(check_file_path, 'r') as check_file:
        return json.load(check_file)

def read_flink_jobs(flink_url):
    flink_url = flink_url + "/joboverview/running"
    return requests.get(flink_url).json()
    
def check_flink_jobs(flink_json, checklist):
    for item in flink_json["jobs"]:
        job_txt = item["name"]
        m = re.search(r"\/projects\/(\w+)", job_txt)
        if m:
            tenant = m.group(1)
            if tenant in checklist:
                if job_txt.startswith("Ingesting metric data"):
                    checklist[tenant]["ingest_metric"] = True
                elif job_txt.startswith("Ingesting sync data"):
                    checklist[tenant]["ingest_sync"] = True
                elif job_txt.startswith("Streaming status using data"):
                    m2 = re.search(r",([a-z]+)_[a-z]+]$", job_txt)
                    
                    if m2:
                        source = m2.group(1)
                        checklist[tenant]["streaming"][source] = True
    return checklist







def gen_checklist(check_json):
    tenants = {}
    for item in check_json:
        tenant_body = {}
        stream_body = {}
        for stream_name in item["streaming"]:
            stream_body[stream_name] = False
        tenant_body["streaming"] = stream_body
        tenant_body["ingest_metric"] = False
        tenant_body["ingest_sync"] = False
        tenants[item["tenant"]] = tenant_body
    return tenants

def summarize(results):
    summary = "OK"
    for tenant in results:
        if results[tenant]["ingest_sync"] == False:
            summary = "ERROR"
        if results[tenant]["ingest_metric"] == False:
            summary = "ERROR"
        for item in results[tenant]["streaming"]:
            if results[tenant]["streaming"][item] == False:
                summary = "ERROR"
    return summary 


def main(args=None):

    checklist = gen_checklist(read_check_json(args.check))
    jobs = read_flink_jobs(args.url)
    result = check_flink_jobs(jobs,checklist)
    if args.output == "all":
        print(summarize(result))
    print(result)


   


if __name__ == "__main__":

   

    parser = argparse.ArgumentParser(description="Get argo topology in json from csv online source")
    parser.add_argument(
        "-u", "--url", metavar="STRING", help="url endpoint of flink", required=True, dest="url")
    parser.add_argument(
        "-c", "--check", metavar="STRING", help="check filename", required=True, dest="check")
    parser.add_argument(
        "-o", "--output", metavar="STRING", help="check filename", required=False, dest="output", default="json")

    # Pass the arguments to main method
    sys.exit(main(parser.parse_args()))