/*===========================================================
   PERSON NODE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PersonNode')
BEGIN
    CREATE TABLE PersonNode (
        BusinessEntityID INT PRIMARY KEY,
        PersonType NCHAR(2),
        Title NVARCHAR(8),
        FirstName NVARCHAR(50),
        MiddleName NVARCHAR(50),
        LastName NVARCHAR(50)
    ) AS NODE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PersonNode)
BEGIN
    INSERT INTO PersonNode (BusinessEntityID, PersonType, Title, FirstName, MiddleName, LastName)
    SELECT BusinessEntityID, PersonType, Title, FirstName, MiddleName, LastName
    FROM Person.Person;
END
GO


/*===========================================================
   PHONE NODE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PhoneNode')
BEGIN
    CREATE TABLE PhoneNode (
        PhoneID INT IDENTITY PRIMARY KEY,
        PhoneNumber NVARCHAR(25),
        PhoneNumberTypeID INT
    ) AS NODE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PhoneNode)
BEGIN
    INSERT INTO PhoneNode (PhoneNumber, PhoneNumberTypeID)
    SELECT PhoneNumber, PhoneNumberTypeID
    FROM Person.PersonPhone;
END
GO


/*===========================================================
   ADDRESS NODE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AddressNode')
BEGIN
    CREATE TABLE AddressNode (
        AddressID INT PRIMARY KEY,
        AddressLine1 NVARCHAR(60),
        AddressLine2 NVARCHAR(60),
        City NVARCHAR(30),
        StateProvinceID INT,
        PostalCode NVARCHAR(15)
    ) AS NODE;
END
GO

IF NOT EXISTS (SELECT 1 FROM AddressNode)
BEGIN
    INSERT INTO AddressNode (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode)
    SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode
    FROM Person.Address;
END
GO


/*===========================================================
   COUNTRY REGION NODE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CountryRegionNode')
BEGIN
    CREATE TABLE CountryRegionNode (
        CountryRegionCode NVARCHAR(5) PRIMARY KEY,
        Name NVARCHAR(100)
    ) AS NODE;
END
GO

IF NOT EXISTS (SELECT 1 FROM CountryRegionNode)
BEGIN
    INSERT INTO CountryRegionNode (CountryRegionCode, Name)
    SELECT CountryRegionCode, Name
    FROM Person.CountryRegion;
END
GO


/*===========================================================
   EMAIL NODE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'EmailNode')
BEGIN
    CREATE TABLE EmailNode (
        EmailAddressID INT PRIMARY KEY,
        BusinessEntityID INT,
        EmailAddress NVARCHAR(50)
    ) AS NODE;
END
GO

IF NOT EXISTS (SELECT 1 FROM EmailNode)
BEGIN
    INSERT INTO EmailNode (EmailAddressID, BusinessEntityID, EmailAddress)
    SELECT EmailAddressID, BusinessEntityID, EmailAddress
    FROM Person.EmailAddress;
END
GO




