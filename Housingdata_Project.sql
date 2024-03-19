--Cleaning data

select *
from NashvilleHousing

--Standadize date

select SaleDateConverted , CONVERT(date,saledate)
from NashvilleHousing

UPDATE NashvilleHousing
set saledate = CONVERT(date,saledate)


alter table NashvilleHousing
add SaleDateConverted DATE

UPDATE NashvilleHousing
set SaleDateConverted = CONVERT(date,saledate)


--Populate Property Address

select *
from [NashvilleHousing]
order by parcelID

--where propertyaddress is null

select a.parcelId,a.propertyaddress,b.parcelid,b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from [NashvilleHousing] a
join [NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.uniqueId <> b.UniqueID
where a.propertyaddress is null

update a 
set PropertyAddress = isnull(a.propertyaddress,b.propertyaddress)
from [NashvilleHousing] a 
join [NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.uniqueId <> b.UniqueID
where a.propertyaddress is null

--Breakdown address into city,address using SUBSTRING
select propertyaddress
from [NashvilleHousing]

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress)) as City
from [NashvilleHousing]

alter TABLE NashvilleHousing
add PropertySplitAddress nvarchar(300)

update [NashvilleHousing]
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter TABLE NashvilleHousing
add PropertySplitCity nvarchar(300)


update [NashvilleHousing]
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))

select * from [NashvilleHousing]

--using PARSENAME
select OwnerAddress
from [NashvilleHousing]

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

alter TABLE NashvilleHousing
add OwnerSplitAddress nvarchar(300)

update [NashvilleHousing]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter TABLE NashvilleHousing
add OwnerSplitCity nvarchar(300)

update [NashvilleHousing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter TABLE NashvilleHousing
add OwnerSplitState nvarchar(300)

update [NashvilleHousing]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
from [NashvilleHousing]

--Change Y and N to Yes and No
SELECT distinct(SoldAsVacant),count(SoldAsVacant)
from [NashvilleHousing]
group by soldasvacant
order by 2

select SoldAsVacant
,case when SoldAsVacant ='Y' then 'Yes'
      when SoldAsVacant ='N' then 'No'
      else SoldAsVacant
      END
from [NashvilleHousing]

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
      when SoldAsVacant ='N' then 'No'
      else SoldAsVacant
      END

      select * from [NashvilleHousing]

--Removing Duplicates
with RownumCTE as (
select *,ROW_NUMBEr () OVER( 
      partition by parcelid ,
      propertyaddress,
      saledate,
      saleprice,
      legalreference
      order by
      uniqueId
 )row_num
from NashvilleHousing
--order by ParcelID
)
Select *        --to delete these duplicates insert delete inplace of select and this deletes
from RownumCTE
where row_num >1
order by propertyaddress

--Delete unused columns
select * FROM
NashvilleHousing

alter table NashvilleHousing
drop column owneraddress,Taxdistrict






      