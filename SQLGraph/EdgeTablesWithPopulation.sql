/*===========================================================
   PERSON → PHONE EDGE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PersonPhoneEdge')
BEGIN
    CREATE TABLE PersonPhoneEdge AS EDGE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PersonPhoneEdge)
BEGIN
    INSERT INTO PersonPhoneEdge ($from_id, $to_id)
    SELECT 
        p.$node_id,
        ph.$node_id
    FROM Person.PersonPhone pp
    JOIN PersonNode p 
        ON p.BusinessEntityID = pp.BusinessEntityID
    JOIN PhoneNode ph 
        ON ph.PhoneNumber = pp.PhoneNumber
       AND ph.PhoneNumberTypeID = pp.PhoneNumberTypeID;

END
GO


/*===========================================================
   PERSON → ADDRESS EDGE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PersonAddressEdge')
BEGIN
    CREATE TABLE PersonAddressEdge AS EDGE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PersonAddressEdge)
BEGIN
   INSERT INTO PersonAddressEdge ($from_id, $to_id)
    SELECT 
        p.$node_id,
        a.$node_id
    FROM Person.BusinessEntityAddress bea
    JOIN PersonNode p 
        ON p.BusinessEntityID = bea.BusinessEntityID   -- ensures person exists
    JOIN AddressNode a 
        ON a.AddressID = bea.AddressID;                -- ensures address exists

END
GO


/*===========================================================
   PERSON → EMAIL EDGE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PersonEmailEdge')
BEGIN
    CREATE TABLE PersonEmailEdge AS EDGE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PersonEmailEdge)
BEGIN
    INSERT INTO PersonEmailEdge ($from_id, $to_id)
    SELECT 
        (SELECT $node_id FROM PersonNode WHERE BusinessEntityID = ea.BusinessEntityID),
        (SELECT $node_id FROM EmailNode WHERE EmailAddressID = ea.EmailAddressID)
    FROM Person.EmailAddress ea;
END
GO

/*===========================================================
   PERSON → CountryRegion Edge
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PersonCountryRegionEdge')
BEGIN
    CREATE TABLE PersonCountryRegionEdge AS EDGE;
END
GO

IF NOT EXISTS (SELECT 1 FROM PersonCountryRegionEdge)
BEGIN
    INSERT INTO PersonCountryRegionEdge ($from_id, $to_id)
    SELECT 
        p.$node_id,
        cr.$node_id
    FROM PersonNode p
    JOIN Person.BusinessEntityAddress bea 
        ON p.BusinessEntityID = bea.BusinessEntityID
    JOIN AddressNode a 
        ON a.AddressID = bea.AddressID
    JOIN Person.StateProvince sp 
        ON a.StateProvinceID = sp.StateProvinceID
    JOIN CountryRegionNode cr 
        ON sp.CountryRegionCode = cr.CountryRegionCode;

END
GO


/*===========================================================
   ADDRESS → COUNTRY REGION EDGE
===========================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AddressCountryRegionEdge')
BEGIN
    CREATE TABLE AddressCountryRegionEdge AS EDGE;
END
GO

IF NOT EXISTS (SELECT 1 FROM AddressCountryRegionEdge)
BEGIN
    INSERT INTO AddressCountryRegionEdge ($from_id, $to_id)
    SELECT 
        a.$node_id,
        cr.$node_id
    FROM AddressNode a
    JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
    JOIN CountryRegionNode cr ON sp.CountryRegionCode = cr.CountryRegionCode;
END
GO
