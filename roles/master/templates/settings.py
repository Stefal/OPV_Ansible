"""
A module that contains all necessary settings
"""

"""The path were to find the DB"""
engine_path = "postgresql+psycopg2://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv"
debug = True
