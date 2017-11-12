# Author: Christophe NOUCHET
# Email: nouchet.christophe@gmail.com
# Documentation: Scrit to launch OPV_Task with Spark.
# Todo:
#  * Allow to launch make campaign with the id not only the name

from pyspark.sql import SparkSession

import sys
import json
from opv_api_client import RestClient, Filter
from opv_api_client.ressources import Campaign
from opv_tasks.utils import find_task
from opv_tasks.__main__ import run
from opv_directorymanagerclient import DirectoryManagerClient, Protocol

def get_campagain_by_name(campaign_name):
    # Get all the campaigns
    db_client = RestClient("http://OPV_Master:5000")
    #campaigns = db_client.make_all(Campaign)
    campaigns = db_client.make_all(Campaign, filters=(Filter("name") == campaign_name))

    return campaigns

def launchAllOPVTask(data):

    options = json.loads(data)

    # Get the address to Directory Manager
    # Variable.setdefault("OPV-DM", "http://OPV_Master:5005")
    # opv_dm = Variable.get("OPV-DM")
    opv_dm = "http://OPV_Master:5005"

    # Get the address to DB rest API
    # Variable.setdefault("OPV-API", "http://OPV_Master:5000")
    # opv_api = Variable.get("OPV-API")
    opv_api = "http://OPV_Master:5000"

    dir_manager_client = DirectoryManagerClient(
        api_base=opv_dm, default_protocol=Protocol.FTP
    )

    db_client = RestClient(opv_api)

    try:
        run(dir_manager_client, db_client, "makeall", options)
    except Exception as e:
        print(str(e))

if __name__ == "__main__":
    # Ce searit mieu avec les ID
    campaign_name = "testCampaign"
    if len(sys.argv) >= 2:
        campaign_name = sys.argv[1]

    spark = SparkSession \
        .builder \
        .appName("Make Campaign '%s'" % campaign_name) \
        .getOrCreate()

    sc = spark.sparkContext

    campaigns = get_campagain_by_name(campaign_name)

    results = [[json.dumps({"id_malette": lot.id_malette,"id_lot": lot.id_lot}) for lot in campaign.lots] for campaign in campaigns]

    if len(results) == 0:
        raise Exception("No '%s' campaing found!" % campaign_name)

    lots = sc.parallelize(results[0], len(results[0]))

    print("%s panorama to make!" % len(results[0]))

    lots.map(lambda x: launchAllOPVTask(x)).collect()
