/*
Cleaning data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


--standardize SaleDate

Select SaleDate
From PortfolioProject.dbo.NashvilleHousing

Select SaleDateConverted, CONVERT(date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date,SaleDate)

alter table NashvilleHousing
Add SaleDateConverted date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate)

--populate property address data

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] -- not the same row (each row is unique)
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] -- not the same row (each row is unique)
where a.PropertyAddress is null


--breaking out address into individual columns (address, city, state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as address
from PortfolioProject.dbo.NashvilleHousing	


alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing	


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing	


select
parsename(REPLACE(owneraddress, ',', '.'), 3),
parsename(REPLACE(owneraddress, ',', '.'), 2),
parsename(REPLACE(owneraddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing	


alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = parsename(REPLACE(owneraddress, ',', '.'), 3)


alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = parsename(REPLACE(owneraddress, ',', '.'), 2)


alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = parsename(REPLACE(owneraddress, ',', '.'), 1)

select *
from PortfolioProject.dbo.NashvilleHousing	

--change Y and N to yes and no in "sold as vacant" field

select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject.dbo.NashvilleHousing	
group by SoldAsVacant
order by 2



select SoldAsVacant,
case	when SoldAsVacant = 'Y'then 'Yes'
		when SoldAsVacant = 'N'then 'No'
		else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing	


Update NashvilleHousing
Set SoldAsVacant = case	when SoldAsVacant = 'Y'then 'Yes'
		when SoldAsVacant = 'N'then 'No'
		else SoldAsVacant
end

--remove duplicates -----------> not to raw data

select *,
	ROW_NUMBER() over (
	partition by parcelID,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by uniqueID
				) row_num
from PortfolioProject.dbo.NashvilleHousing	
order by ParcelID

--=> CTE =>>> like a temp table

With rownumCTE as(
select *,
	ROW_NUMBER() over (
	partition by parcelID,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by uniqueID
				) row_num
from PortfolioProject.dbo.NashvilleHousing	
--order by ParcelID
)
select *
from rownumCTE
where row_num > 1

--=> delete row num 2

--delete
--from rownumCTE
--where row_num > 1



--delete unused columns -----------> not to raw data

select *
from PortfolioProject.dbo.NashvilleHousing	

alter table PortfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column saledate




