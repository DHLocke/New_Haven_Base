# created by Dexter H. Locke, PhD.
# for summarizing tree canopy within various spatial units of analysis

# create file geodatabase
# only need to do this once
# this makes Arc run a little faster than a shapefile, but more importantly
# were are going to use some custom tools created by the Spatial Analysis Lab
# at the University of Vermont to summarize tree canopy data within each Census
# block group polygon
# the path ways will need to be modified for your computer
arcpy.CreateFileGDB_management(out_folder_path="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base", out_name="tree_canopy_gdb.gdb", out_version="CURRENT")

# these next two commands are two two things at once:
# 1: they are projecting the data to match the land cover
# 2: they are moving the data from shapefile to geodatabase for performance and compatability
# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "NH_2009_2013_5year_ACS"
arcpy.Project_management(in_dataset="NH_2009_2013_5year_ACS", out_dataset="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb/NH_2009_2013_5year_ACS", out_coor_system="PROJCS['NAD_1983_StatePlane_Connecticut_FIPS_0600_Feet',GEOGCS['GCS_North_American_1983',DATUM['D_North_American_1983',SPHEROID['GRS_1980',6378137.0,298.257222101]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Lambert_Conformal_Conic'],PARAMETER['False_Easting',999999.999996],PARAMETER['False_Northing',499999.999998],PARAMETER['Central_Meridian',-72.75],PARAMETER['Standard_Parallel_1',41.2],PARAMETER['Standard_Parallel_2',41.86666666666667],PARAMETER['Latitude_Of_Origin',40.83333333333334],UNIT['Foot_US',0.3048006096012192]]", transform_method="", in_coor_system="GEOGCS['GCS_North_American_1983',DATUM['D_North_American_1983',SPHEROID['GRS_1980',6378137.0,298.257222101]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]]", preserve_shape="NO_PRESERVE_SHAPE", max_deviation="", vertical="NO_VERTICAL")

# repeat for the newer data
# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "NH_2009_2013_5year_ACS"
arcpy.Project_management(in_dataset="NH_2013_2017_5year_ACS", out_dataset="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb/NH_2013_2017_5year_ACS", out_coor_system="PROJCS['NAD_1983_StatePlane_Connecticut_FIPS_0600_Feet',GEOGCS['GCS_North_American_1983',DATUM['D_North_American_1983',SPHEROID['GRS_1980',6378137.0,298.257222101]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Lambert_Conformal_Conic'],PARAMETER['False_Easting',999999.999996],PARAMETER['False_Northing',499999.999998],PARAMETER['Central_Meridian',-72.75],PARAMETER['Standard_Parallel_1',41.2],PARAMETER['Standard_Parallel_2',41.86666666666667],PARAMETER['Latitude_Of_Origin',40.83333333333334],UNIT['Foot_US',0.3048006096012192]]", transform_method="", in_coor_system="GEOGCS['GCS_North_American_1983',DATUM['D_North_American_1983',SPHEROID['GRS_1980',6378137.0,298.257222101]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]]", preserve_shape="NO_PRESERVE_SHAPE", max_deviation="", vertical="NO_VERTICAL")



LandCover_NewHaven_2008.img



arcpy.Metrics2(Input_Land_Cover_Raster="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/lc/LandCover_NewHaven_2008.img", Input_Geography_Feature_Class="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb/NH_2009_2013_5year_ACS", TC_ID_Geography_Identifier_Field="TC_ID", Output_Land_Cover_Metrics_Table="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb/NH_2009_2013_5year_ACS_lc_tbl", Output_Tree_Canopy_Metrics_Table="C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb/NH_2009_2013_5year_ACS_tc_tbl")


# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "NH_2009_2013_5year_ACS", "NH_2009_2013_5year_ACS_tc_tbl"
arcpy.JoinField_management(in_data="NH_2009_2013_5year_ACS", in_field="TC_ID", join_table="NH_2009_2013_5year_ACS_tc_tbl", join_field="TC_ID", fields="TC_E_A;TC_Pv_A;TC_Land_A;TC_Pi_A;TC_P_A;TC_E_P;TC_Pv_P;TC_P_P;TC_Pi_P")


# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
# The following inputs are layers or table views: "NH_2009_2013_5year_ACS", "NH_2009_2013_5year_ACS_lc_tbl"
arcpy.JoinField_management(in_data="NH_2009_2013_5year_ACS", in_field="TC_ID", join_table="NH_2009_2013_5year_ACS_lc_tbl", join_field="TC_ID", fields="Total_A;Can_A;Grass_A;Soil_A;Water_A;Build_A;Road_A;Paved_A;Perv_A;Imperv_A;Can_P;Grass_P;Soil_P;Water_P;Build_P;Road_P;Paved_P;Perv_P;Imperv_P")

