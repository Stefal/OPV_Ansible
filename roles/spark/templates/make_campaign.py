# Author: Christophe NOUCHET
# Email: nouchet.christophe@gmail.com
# Documentation: Scrit to launch OPV_Task with Spark.
# Todo:
#  * Allow to launch make campaign with the id not only the name

from pyspark.sql import SparkSession

import sys
import json
from opv_api_client import RestClient
from opv_api_client.ressources import Campaign
from opv_tasks.__main__ import run
from opv_directorymanagerclient import DirectoryManagerClient, Protocol


def get_campagain_by_id(campaign_id, id_malette):
    # Get all the campaigns
    db_client = RestClient("http://OPV_Master:5000")
    # campaigns = db_client.make_all(Campaign)
    campaigns = db_client.make(Campaign, campaign_id, id_malette)

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
    campaign_id = 1
    if len(sys.argv) >= 3:
        campaign_id = int(sys.argv[1])
        id_malette = int(sys.argv[2])

    campaign = get_campagain_by_id(campaign_id, id_malette)

    spark = SparkSession \
        .builder \
        .appName("Make Campaign '{}' (id: {})".format(campaign.name, campaign.id_campaign)) \
        .getOrCreate()

    sc = spark.sparkContext

    results = [json.dumps({"id_malette": lot.id_malette, "id_lot": lot.id_lot}) for lot in campaign.lots]

    lots = sc.parallelize(results, len(results))

    print("%s panorama to make!" % len(results))

    lots.map(lambda x: launchAllOPVTask(x)).collect()
