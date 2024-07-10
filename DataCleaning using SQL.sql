--Cleaning data in sql queries
select* from MySSqlPortfolioProject1..NashvilleHousing

--change the sale date
select SaleDate,CONVERT(date, saledate) as SalesDate from MySSqlPortfolioProject1..NashvilleHousing


alter table nashvillehousing add SaleDateConverted Date
 
 update NashvilleHousing set SaleDateConverted = CONVERT(date, saledate) 
 
 select saledateconverted from MySSqlPortfolioProject1..NashvilleHousing

 --Populate property address data
 select* from MySSqlPortfolioProject1..NashvilleHousing
 --where PropertyAddress is null 
 order by ParcelID

 select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
 from MySSqlPortfolioProject1..NashvilleHousing a
 join MySSqlPortfolioProject1..NashvilleHousing b
 on a.ParcelID = b.ParcelID and a.[UniqueID ]!= b.[UniqueID ]
 where a.PropertyAddress is null

 update a 
 set propertyaddress = ISNULL(a.propertyAddress,b.PropertyAddress)
 from MySSqlPortfolioProject1..NashvilleHousing a
 join MySSqlPortfolioProject1..NashvilleHousing b
 on a.ParcelID = b.ParcelID and a.[UniqueID ]!= b.[UniqueID ]
 where a.PropertyAddress is null

 --since the parcelID matches the propertyaddress the above command fills the parcelid in places where property address is null

 --breaking out individual columns (address,city,state)

 select PropertyAddress from MySSqlPortfolioProject1..NashvilleHousing

 select SUBSTRING(propertyaddress, 1 ,charindex(',', propertyaddress) -1) as address,
  SUBSTRING(propertyaddress, charindex(',', propertyaddress) +1,len(propertyaddress)) as address
 --charindex(',', propertyaddress)
 from MySSqlPortfolioProject1..NashvilleHousing


alter table nashvillehousing add propertysplitaddress nvarchar(255)
 update NashvilleHousing set propertysplitaddress = SUBSTRING(propertyaddress, 1 ,charindex(',', propertyaddress) -1) 

 alter table nashvillehousing add propertysplitcity nvarchar(255)
update NashvilleHousing set propertysplitcity = SUBSTRING(propertyaddress, charindex(',', propertyaddress) +1,len(propertyaddress))                         

select* from MySSqlPortfolioProject1..NashvilleHousing

     -------OR--------

select OwnerAddress from MySSqlPortfolioProject1..NashvilleHousing

select PARSENAME(replace(OwnerAddress, ',', '.') ,3) as Propertylocation,  
PARSENAME(replace(OwnerAddress, ',', '.') ,2) as City,
PARSENAME(replace(OwnerAddress, ',', '.') ,1) as State
from MySSqlPortfolioProject1..NashvilleHousing


alter table nashvillehousing add Ownersplitaddress nvarchar(255)
 update NashvilleHousing set Ownersplitaddress  = PARSENAME(replace(OwnerAddress, ',', '.') ,3)

 alter table nashvillehousing add Ownersplitcity nvarchar(255)
update NashvilleHousing set Ownersplitcity  = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

 alter table nashvillehousing add OwnersplitState nvarchar(255)
update NashvilleHousing set OwnersplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)

select* from MySSqlPortfolioProject1..NashvilleHousing


    -----changing Y and N into yes and no in column sold as vacant ----

select distinct(SoldAsVacant),COUNT(soldasvacant) from MySSqlPortfolioProject1..NashvilleHousing
group by SoldAsVacant order by SoldAsVacant


select SoldAsVacant, 
(case when SoldAsVacant = 'y' then 'Yes' 
     when SoldAsVacant = 'n' then 'No' 
	 else SoldAsVacant 
	 end) as SoldAs_Vacant
from MySSqlPortfolioProject1..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'Yes' 
						when SoldAsVacant = 'n' then 'No' 
						else SoldAsVacant 
					    end 


						----remove duplicates----

 with ROwnumCTE as (
select*,
	row_number() over(
	 partition by parcelID, propertyaddress, saleprice, saledate, legalreference
	 order by uniqueID) row_num
from MySSqlPortfolioProject1..NashvilleHousing
-- order by ParcelID
)
select* from ROwnumCTE
where row_num > 1
--order by PropertyAddress


---delete unused columns 

select* 
from MySSqlPortfolioProject1..NashvilleHousing	

alter table MySSqlPortfolioProject1..NashvilleHousing	
drop column owneraddress, taxdistrict, propertyaddress


alter table MySSqlPortfolioProject1..NashvilleHousing	
drop column saledate




