# Simple tSQLt Unit Tests for Views
- Some SQL Code needs painstaking unit testing of conditional control flow logic.
- Some SQL Code needs a bunch of simple tests of views as you pick apart a legacy data flow and recreate it in a stable way.
  - This project is for the latter case.
  - It will help you make simple, straightforward unit tests that work with tSQLt: https://tsqlt.org/

## Writing your tests

- I suggest you write your tests in VSCode.
  - There is a JSON schema (.\unitTestsOfViews.schema.json)) in this project you can use to validate your setup, one test per json file.
  - There is an example in .\unitTestsOfViews.test1.json
- The basic test pattern supported is:
  - Assemble
    - Fake one or more tables or views.
    - Add one or a few rows of test data to those faked objects.
    - Remember, tSQLt faking replaces the table with an empty table with no data validation constraints beyond basic data types.
  - Act
    - Select relevant columns into a new table.
  - Assert
    - Check the output against one or a few rows of expected output.
- The JSON schema is not structured to support many rows of faked input or many rows of expected output.
  - You need to specify all the values for each column in an array, and get your array indices aligned for all rows by hand across all columns.
  - So stick to the minimum number of rows, as is good practice for unit testing anyway.
- Version control the JSON, but if these are your ONLY tests, you might not need to version control your tSQLt project since you can rebuild the tests from here.

## Textrude prerequisites, from chocolatey
```powershell
Write-Verbose -Verbose "Download Dotnet 5 for textrude...";
choco install dotnet-5.0-runtime -y;

Write-Verbose -Verbose "Download textrude cli...";
choco install textrude -y;
```

## Building your tests with textrude
```powershell
$directoryOfUnitTestJson = ".\your\path\here\";
$directoryOfUnitTestSql  = ".\your\tsqlt\sqlproj\path\here\"; #try this if you need a buildable tSQLt project: https://github.com/sdoubleday/tSQLt_SampleDbproj
ls $directoryOfUnitTestJson | ForEach-Object {
    $json = Get-Content $_.FullName | ConvertFrom-Json;
    textrude render --models $_.Fullname --template $PSScriptRoot\unitTestOfViews_textrudetemplate.txt --output "$directoryOfUnitTestSql\$($json.sutSchema)__$($json.sutObject)__$($json.testName).sql" ;
    textrude render --definitions sutSchema=$($json.sutSchema), sutObject=$($json.sutObject) --template $PSScriptRoot\unitTestClass_textrudetemplate.txt --output "$directoryOfUnitTestSql\$($json.sutSchema)__$($json.sutObject)_classschema.sql";
}
```

## Importing into Visual Studio SSDT

- Output the sql code into a folder in your tSQLt project (which references your main SQL project - remember, test code doesn't go in the production application!).
- Right click on the tSQLt project in Visual Studio SSDT, click Add > Existing Items > and then ```Ctrl + A``` to select all unit tests and schemas from the output folder and add them to the project.
  - Sure, it is messy, but such is life. Also, if you are versioning the tests elsewhere then just don't version control the mess that you just imported into the tSQLt project.
- Build, deploy, and run.
