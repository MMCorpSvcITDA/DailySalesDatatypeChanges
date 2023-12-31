

----------------------- ALTER DYNAMIC SCRIPT -------------------------------

SELECT * 
FROM (

SELECT CASE 
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME] not like '%hier%' and bb.[CONSTRAINT_NAME] is not null
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(',CHARACTER_MAXIMUM_LENGTH,') NOT NULL')
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME] not like '%hier%' and bb.[CONSTRAINT_NAME] is null
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(',CHARACTER_MAXIMUM_LENGTH,')')		
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME]  like '%hier%' and bb.[CONSTRAINT_NAME] is not null and [CHARACTER_MAXIMUM_LENGTH] = 8
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(18) NOT NULL')	
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME] like '%hier%' and bb.[CONSTRAINT_NAME] is null and [CHARACTER_MAXIMUM_LENGTH] = 8
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(18)')	
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME]  like '%hier%' and bb.[CONSTRAINT_NAME] is not null and [CHARACTER_MAXIMUM_LENGTH] != 8
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(',CHARACTER_MAXIMUM_LENGTH,') NOT NULL')	
		WHEN [DATA_TYPE] = 'varchar' and aa.[TABLE_NAME] like '%hier%' and bb.[CONSTRAINT_NAME] is null and [CHARACTER_MAXIMUM_LENGTH] != 8
		THEN
		CONCAT('ALTER TABLE ' , aa.[TABLE_SCHEMA] ,'.', aa.[TABLE_NAME] , ' ALTER COLUMN ', aa.[COLUMN_NAME] , ' NVARCHAR(',CHARACTER_MAXIMUM_LENGTH,')')	

		END as alterColumnScript
FROM INFORMATION_SCHEMA.COLUMNS aa
LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE bb
ON aa.TABLE_SCHEMA = bb.TABLE_SCHEMA and aa.TABLE_NAME = bb.TABLE_NAME and aa.COLUMN_NAME = bb.COLUMN_NAME 
WHERE aa.[TABLE_SCHEMA] = 'LANDING' 
) aa

WHERE aa.[alterColumnScript] is not null



/* draft

SELECT CASE 
		WHEN [DATA_TYPE] = 'varchar' and [TABLE_NAME] not like '%hier%' and CONCAT([TABLE_NAME],[COLUMN_NAME]) not in (SELECT CONCAT([TABLE_NAME],[COLUMN_NAME]) FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE )
		THEN
		CONCAT('ALTER TABLE ' , [TABLE_SCHEMA] ,'.', [TABLE_NAME] , ' ALTER COLUMN ', [COLUMN_NAME] , ' NVARCHAR(',CHARACTER_MAXIMUM_LENGTH,')')
		END
FROM INFORMATION_SCHEMA.COLUMNS	


*/


------------------------- ADD CONSTRAINT DYNAMIC SCRIPT -------------------------------------

SELECT * , 
		CONCAT('ALTER TABLE ' , [TABLE_SCHEMA] ,'.',[TABLE_NAME] , ' DROP CONSTRAINT ' , [CONSTRAINT_NAME] )  as alterTableDropConstraintScript ,
		CONCAT('ALTER TABLE ',bb.TABLE_SCHEMA , '.', bb.TABLE_NAME , ' ADD CONSTRAINT ',bb.CONSTRAINT_NAME, ' PRIMARY KEY (',bb.ConcatColumn,')')  as addConstraintScript
FROM (
SELECT DISTINCT(ipk.TABLE_SCHEMA) , ipk.TABLE_NAME  , ipk.CONSTRAINT_NAME 
     ,
   STUFF((SELECT ',' + ipks.COLUMN_NAME 
          FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ipks
          WHERE ipks.[TABLE_NAME] = ipk.[TABLE_NAME]
          --ORDER BY USR_NAME
          FOR XML PATH('')), 1, 1, '') as ConcatColumn -- [SECTORS/USERS]
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ipk
WHERE [TABLE_SCHEMA] = 'LANDING'
GROUP BY ipk.TABLE_SCHEMA , ipk.TABLE_NAME , ipk.CONSTRAINT_NAME

) bb

------------------------------- DROP CONSTRAINT DYNAMIC SCRIPT -----------------------------------------------------


SELECT DISTINCT(CONCAT('ALTER TABLE ' , [TABLE_SCHEMA] ,'.',[TABLE_NAME] , ' DROP CONSTRAINT ' , [CONSTRAINT_NAME] ) ) as alterTableDropConstraintScript 
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE [TABLE_SCHEMA] = 'LANDING'

/*
ALTER TABLE <tablename>
ADD CONSTRAINT <constraintname> PRIMARY KEY (col,col...)

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE [TABLE_SCHEMA] not in ('LOG','ERROR')

SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE [TABLE_SCHEMA] = 'LANDING'

*/





ALTER TABLE LANDING.M_WWG1C DROP CONSTRAINT PK__M_WWG1C__C56B73FDD4CFC291
ALTER TABLE LANDING.T001W DROP CONSTRAINT PK__T001W__A5F9BFADE3238AFF
ALTER TABLE LANDING.T023T DROP CONSTRAINT PK__T023T__672975E485FFC5FC
ALTER TABLE LANDING.VBRK DROP CONSTRAINT PK_VBRK
ALTER TABLE LANDING.VBRP DROP CONSTRAINT PK_VBRP
ALTER TABLE LANDING.WRF1 DROP CONSTRAINT PK__WRF1__B5DA90BF1468BCFE

ALTER TABLE LANDING.M_WWG1C ALTER COLUMN CLASS NVARCHAR(18) NOT NULL
ALTER TABLE LANDING.M_WWG1C ALTER COLUMN KLART NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.M_WWG1C ALTER COLUMN KSCHG NVARCHAR(40) NOT NULL
ALTER TABLE LANDING.M_WWG1C ALTER COLUMN KSCHL NVARCHAR(40) NOT NULL
ALTER TABLE LANDING.M_WWG1C ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.M_WWG1C ALTER COLUMN SPRAS NVARCHAR(1) NOT NULL
ALTER TABLE LANDING.T001W ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.T001W ALTER COLUMN WERKS NVARCHAR(4) NOT NULL
ALTER TABLE LANDING.T023T ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.T023T ALTER COLUMN MATKL NVARCHAR(9) NOT NULL
ALTER TABLE LANDING.T023T ALTER COLUMN SPRAS NVARCHAR(1) NOT NULL
ALTER TABLE LANDING.WRF1 ALTER COLUMN LOCNR NVARCHAR(10) NOT NULL
ALTER TABLE LANDING.WRF1 ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.VBRK ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.VBRK ALTER COLUMN VBELN NVARCHAR(10) NOT NULL
ALTER TABLE LANDING.VBRP ALTER COLUMN MANDT NVARCHAR(3) NOT NULL
ALTER TABLE LANDING.VBRP ALTER COLUMN VBELN NVARCHAR(10) NOT NULL
ALTER TABLE LANDING.VBRP ALTER COLUMN MATKL NVARCHAR(9)
ALTER TABLE LANDING.T001W ALTER COLUMN PSTLZ NVARCHAR(10)
ALTER TABLE LANDING.T001W ALTER COLUMN ADRNR NVARCHAR(10)
ALTER TABLE LANDING.VBRP ALTER COLUMN ALAND NVARCHAR(3)
ALTER TABLE LANDING.T023T ALTER COLUMN WGBEZ60 NVARCHAR(60)
ALTER TABLE LANDING.T001W ALTER COLUMN ORT01 NVARCHAR(25)
ALTER TABLE LANDING.VBRP ALTER COLUMN WAERK NVARCHAR(5)
ALTER TABLE LANDING.VBRK ALTER COLUMN FKART NVARCHAR(4)
ALTER TABLE LANDING.T001W ALTER COLUMN NAME2 NVARCHAR(30)
ALTER TABLE LANDING.T001W ALTER COLUMN PFACH NVARCHAR(10)
ALTER TABLE LANDING.T001W ALTER COLUMN STRAS NVARCHAR(30)
ALTER TABLE LANDING.VBRP ALTER COLUMN WERKS NVARCHAR(4)
ALTER TABLE LANDING.T023T ALTER COLUMN WGBEZ NVARCHAR(20)
ALTER TABLE LANDING.VBRP ALTER COLUMN PSTYV NVARCHAR(4)
ALTER TABLE LANDING.VBRP ALTER COLUMN MATNR NVARCHAR(18)
ALTER TABLE LANDING.T001W ALTER COLUMN REGIO NVARCHAR(3)
ALTER TABLE LANDING.T001W ALTER COLUMN NAME1 NVARCHAR(30)


ALTER TABLE LANDING.M_WWG1C ADD CONSTRAINT PK__M_WWG1C__C56B73FDD4CFC291 PRIMARY KEY (CLASS,CLINT,KLART,KLPOS,KSCHG,KSCHL,MANDT,SPRAS)
ALTER TABLE LANDING.T001W ADD CONSTRAINT PK__T001W__A5F9BFADE3238AFF PRIMARY KEY (MANDT,WERKS)
ALTER TABLE LANDING.T023T ADD CONSTRAINT PK__T023T__672975E485FFC5FC PRIMARY KEY (MANDT,MATKL,SPRAS)
ALTER TABLE LANDING.VBRK ADD CONSTRAINT PK_VBRK PRIMARY KEY (MANDT,VBELN)
ALTER TABLE LANDING.VBRP ADD CONSTRAINT PK_VBRP PRIMARY KEY (MANDT,POSNR,VBELN)
ALTER TABLE LANDING.WRF1 ADD CONSTRAINT PK__WRF1__B5DA90BF1468BCFE PRIMARY KEY (LOCNR,MANDT)