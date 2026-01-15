--Find each person, their phones, and their country

SELECT p.FirstName, p.LastName, ph.PhoneNumber, cr.Name AS Country
FROM PersonNode p,
     PersonPhoneEdge e1,
     PhoneNode ph,
     PersonAddressEdge e2,
     AddressNode a,
     AddressCountryRegionEdge e3,
     CountryRegionNode cr
WHERE MATCH(p-(e1)->ph AND p-(e2)->a-(e3)->cr);

--Find people who share the same country
-- ToDo: figure out why it took so long to finish
/*
SELECT DISTINCT p1.FirstName, p1.LastName, p2.FirstName, p2.LastName, cr.Name
FROM PersonNode p1,
     PersonCountryRegionEdge e1,
     CountryRegionNode cr,
     PersonCountryRegionEdge e2,
     PersonNode p2
WHERE MATCH(p1-(e1)->cr<-(e2)-p2)
  AND p1.BusinessEntityID <> p2.BusinessEntityID
  AND p1.BusinessEntityID < p2.BusinessEntityID;
*/
--Find all emails for people in Canada
SELECT p.FirstName, p.LastName, e.EmailAddress
FROM CountryRegionNode cr,
     AddressCountryRegionEdge e1,
     AddressNode a,
     PersonAddressEdge e2,
     PersonNode p,
     PersonEmailEdge e3,
     EmailNode e
WHERE MATCH(cr<-(e1)-a<-(e2)-p-(e3)->e)
  AND cr.CountryRegionCode = 'CA';

