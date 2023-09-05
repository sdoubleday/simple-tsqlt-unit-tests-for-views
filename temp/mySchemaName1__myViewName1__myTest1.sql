CREATE PROCEDURE [mySchemaName1__myViewName1].[myTest1]
AS
BEGIN
	--ASSEMBLE
	IF OBJECT_ID('[mySchemaName1__myViewName1].ACTUAL') IS NOT NULL DROP TABLE [mySchemaName1__myViewName1].ACTUAL;
	IF OBJECT_ID('[mySchemaName1__myViewName1].EXPECTED') IS NOT NULL DROP TABLE [mySchemaName1__myViewName1].EXPECTED;


	EXECUTE tSQLt.FakeTable @TableName = '[dbo].[sourcetable]';

    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '1' ,@payments = '0.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '2' ,@payments = '0.1' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '3' ,@payments = '3.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '3' ,@payments = '-1.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '4' ,@payments = '9.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '4' ,@payments = '-9.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '4' ,@payments = '4.0' ;
    EXECUTE [TestHelpers].[DataBuilder_dbo_sourcetable] @id = '4' ,@payments = '5.0' ;

	
	--ACT
	SELECT
     [id]
    ,[payments]	
    INTO [mySchemaName1__myViewName1].ACTUAL
	FROM [mySchemaName1].[myViewName1];

	--ASSERT
	CREATE TABLE [mySchemaName1__myViewName1].EXPECTED (
        
         [id] NVARCHAR(4000)
        ,[payments] DECIMAL(38,20)
    );
	INSERT INTO [mySchemaName1__myViewName1].EXPECTED (
        
         [id]
        ,[payments]
    ) VALUES

         ('1' ,'0.0' )
        ,('2' ,'0.1' )
        ,('3' ,'2.0' )
        ,('4' ,'9.0' )
	;

	EXECUTE [tSQLt].[AssertEqualsTable] @Expected = '[mySchemaName1__myViewName1].EXPECTED', @Actual = '[mySchemaName1__myViewName1].ACTUAL';

END

/****
Script autogenerated from JSON and textrude.
This test compares the contents of EXPECTED and ACTUAL.
****/
