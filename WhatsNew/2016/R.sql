EXECUTE sys.sp_execute_external_script
    @language = N'R'
,   @script = N'iris_data <- iris;'
,   @output_data_1_name = N'iris_data'
WITH RESULT SETS
(
    (
        "Sepal.Length" float NOT NULL
    ,   "Sepal.Width" float NOT NULL
    ,   "Petal.Length" float NOT NULL
    ,   "Petal.Width" float NOT NULL
    ,   "Species" varchar(100)
    )
);
