-- EXECUTE sys.sp_configure 'external scripts enabled'
-- EXECUTE sys.sp_configure 'external scripts enabled', 1
-- Need to cycle instance if run_value is 0

EXECUTE sys.sp_execute_external_script @language = N'Python', 
	@script = N'
import pkg_resources
installed_packages = pkg_resources.working_set
installed_packages_list = sorted(["%s==%s" % (i.key, i.version) for i in installed_packages])
d = {"packagename":[], "version":[]}
for i in installed_packages:
    d["packagename"].append(i.key)
    d["version"].append(i.version)
df = pandas.DataFrame.from_dict(d)
'
,	@output_data_1_name = N'df'
WITH RESULT SETS ((packagename nvarchar(200), version nvarchar(200)));
