--This script searches all char and varchar fields for instances of 
--the specified character(s) within the current database context and 
--reports back a count of instances found.
--  Examples: 
--    SET @SearchStr = '%' + Char(13) + '%'  fields that contain a carriage return
--    SET @SearchStr = '%"%'                 fields that contain a double-quote
--    SET @SearchStr = 'ABC%'                fields that start with ABC
--    SET @SearchStr = '%.'                  fields that end with a period
SET nocount ON

DECLARE @SearchStr varchar(255), @SchemaName varchar(255), @TableName varchar(255), @FieldName varchar(255)

SET @SearchStr = '%Personal Injury Protection%' --Enter the search character(s) here.

CREATE TABLE #Report (SchemaName varchar(255), TableName varchar(255), FieldName varchar(255), NbrOfInstances int)

DECLARE curTables CURSOR FOR
	SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
	FROM information_schema.columns
	WHERE DATA_TYPE IN ('char','varchar','nchar','nvarchar')
	ORDER BY TABLE_NAME, ORDINAL_POSITION

OPEN curTables
FETCH NEXT FROM curTables INTO @SchemaName, @TableName, @FieldName
WHILE @@Fetch_Status = 0
BEGIN
	EXEC ('INSERT #Report SELECT ''' + @SchemaName + ''',''' + @TableName + ''',''' + @FieldName + 
			''', Count(*) FROM [' + @SchemaName + '].[' + @TableName + '] WITH (NOLOCK) WHERE [' + @FieldName + 
			'] LIKE ''' + @SearchStr + '''')
	FETCH NEXT FROM curTABLES INTO @SchemaName, @TableName, @FieldName
END
CLOSE curTables
DEALLOCATE curTables

SELECT SchemaName, TableName, FieldName, NbrOfInstances FROM #Report ORDER BY NbrOfInstances DESC

DROP TABLE #Report

SET nocount OFF
