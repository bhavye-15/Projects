SELECT *
FROM HousingNashville;


----Standardizing SaleDate format

SELECT SaleDateConverted
FROM HousingNashville;

UPDATE HousingNashville
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE HousingNashville
ADD SaleDateConverted date;

UPDATE HousingNashville
SET SaleDateConverted = CONVERT(date,SaleDate)


----Populating NULL values in PropertyAddress

SELECT PropertyAddress
FROM HousingNashville
WHERE PropertyAddress IS NULL;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) --ISNULL will fill the a.propertyaddress with value in b.propertyaddress
FROM HousingNashville AS a
JOIN HousingNashville AS b
	on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingNashville AS a
JOIN HousingNashville AS b
	on a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


----Breaking address (Property and Onwer) into seperate columns (Address, City, State)

SELECT * FROM HousingNashville;

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address, --CHARINDEX(',',PropertyAddress) This shows the index of comma which can be used to remove column from the table
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address2
FROM HousingNashville

ALTER TABLE HousingNashville
ADD HouseAddress NVARCHAR(255);

UPDATE HousingNashville
SET HouseAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE HousingNashville
ADD City NVARCHAR(255);

UPDATE HousingNashville
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress));

SELECT HouseAddress, City FROM HousingNashville;




SELECT OwnerAddress FROM HousingNashville;

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) As OwnerHouseAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) As OwnerCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS OwnerState
FROM HousingNashville;

ALTER TABLE HousingNashville
ADD OwnerHouseAddress NVARCHAR(255);

UPDATE HousingNashville
SET OwnerHouseAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE HousingNashville
ADD OwnerCity NVARCHAR(255);

UPDATE HousingNashville
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE HousingNashville
ADD OwnerState NVARCHAR(255);

UPDATE HousingNashville
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

SELECT OwnerHouseAddress, OwnerCity, OwnerState FROM HousingNashville;


----Replacing Y and N to Yes and No in SoldAsVacant Column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingNashville
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM HousingNashville;

UPDATE HousingNashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END;


----Removing Duplicates

WITH row_dup AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS row_num
FROM HousingNashville
)
SELECT * FROM row_dup
WHERE row_num > 1;


WITH row_dup AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) AS row_num
FROM HousingNashville
)
DELETE FROM row_dup
WHERE row_num > 1;




----Removing Unused Columns

SELECT * FROM HousingNashville

ALTER TABLE HousingNashville
DROP COLUMN PropertyAddress, TaxDistrict, OwnerAddress;

ALTER TABLE HousingNashville
DROP COLUMN SaleDate;
