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
