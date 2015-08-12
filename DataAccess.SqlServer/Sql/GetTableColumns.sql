﻿SELECT * FROM
(
	SELECT col.ORDINAL_POSITION, col.TABLE_SCHEMA 'Schema', col.TABLE_NAME AS TableName, 
		   col.COLUMN_NAME AS ColumnName, Data_Type as DataType, 
		   col.Table_Schema + '.' + col.TABLE_NAME as FullName,
		   CASE 
			WHEN col.Data_Type = 'datetime' THEN NULL
			ELSE 
			CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, DATETIME_PRECISION) 
				WHEN -1 THEN 'MAX' 
				ELSE convert(varchar, ISNULL(CHARACTER_MAXIMUM_LENGTH, DATETIME_PRECISION)) 
			END 
		   END as 'ColumnLength',
		   COLUMN_DEFAULT as 'DefaultValue', 
		   CASE(
					SELECT const2.CONSTRAINT_TYPE	
					FROM  INFORMATION_SCHEMA.KEY_COLUMN_USAGE const	
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS const2 on const2.TABLE_NAME = col.TABLE_NAME AND 
																	const2.TABLE_SCHEMA = col.TABLE_SCHEMA AND 
																	const2.TABLE_CATALOG = col.TABLE_CATALOG AND 
																	const2.CONSTRAINT_NAME = const.CONSTRAINT_NAME AND 
																	const2.CONSTRAINT_SCHEMA = const.CONSTRAINT_SCHEMA AND
																	const2.CONSTRAINT_TYPE = 'PRIMARY KEY'	
					WHERE const.COLUMN_NAME = col.COLUMN_NAME)
		  WHEN 'Primary Key' then 1 else 0 end as 'PrimaryKey' 
	FROM INFORMATION_SCHEMA.COLUMNS col 	
) a
WHERE FullName IN(SELECT TABLE_SCHEMA + '.' + TABLE_NAME FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE')