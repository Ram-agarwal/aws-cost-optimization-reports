#!/bin/bash

########################################
# Author: Ram Agarwal
# Version: v1
# Description: Azure Daily Resource + Cost Audit Report
# Mode: READ-ONLY (Safe)
########################################

SUBSCRIPTION=$(az account show --query name -o tsv)
DATE=$(date)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================="
echo " AZURE DAILY RESOURCE & COST REPORT"
echo " Subscription: $SUBSCRIPTION"
echo " Date: $DATE"
echo "======================================="

########################################
# RESOURCE GROUPS
########################################
echo -e "\n📦 RESOURCE GROUPS:"
az group list --query "[].name" -o table

########################################
# VIRTUAL MACHINES (RUNNING)
########################################
echo -e "\n🖥️ RUNNING VMs:"
az vm list -d \
--query "[?powerState=='VM running'].{Name:name,RG:resourceGroup,Size:hardwareProfile.vmSize,IP:publicIps}" \
-o table

########################################
# STOPPED VMs (COST RISK)
########################################
echo -e "\n⛔ STOPPED VMs (Still Disk Cost):"
az vm list -d \
--query "[?powerState!='VM running'].{Name:name,RG:resourceGroup,State:powerState}" \
-o table

########################################
# UNATTACHED MANAGED DISKS
########################################
echo -e "\n💥 UNATTACHED MANAGED DISKS (DELETE IF NOT NEEDED):"
az disk list \
--query "[?managedBy==null].{Disk:name,SizeGB:diskSizeGb,RG:resourceGroup}" \
-o table

########################################
# PUBLIC IPs NOT ATTACHED
########################################
echo -e "\n💸 UNUSED PUBLIC IPs:"
az network public-ip list \
--query "[?ipConfiguration==null].{IP:name,RG:resourceGroup}" \
-o table

########################################
# STORAGE ACCOUNTS
########################################
echo -e "\n📦 STORAGE ACCOUNTS:"
az storage account list \
--query "[].{Name:name,RG:resourceGroup,SKU:sku.name}" \
-o table

########################################
# LOAD BALANCERS
########################################
echo -e "\n🌐 LOAD BALANCERS:"
az network lb list \
--query "[].{LB:name,RG:resourceGroup}" \
-o table

########################################
# APPLICATION GATEWAYS (HIGH COST)
########################################
echo -e "\n🚨 APPLICATION GATEWAYS (HIGH COST):"
az network application-gateway list \
--query "[].{AppGW:name,RG:resourceGroup}" \
-o table

########################################
# AZURE SQL DATABASES
########################################
echo -e "\n🗄️ AZURE SQL DATABASES:"
az sql db list \
--query "[].{DB:name,Server:serverName,Status:status}" \
-o table

########################################
# AZURE FUNCTIONS
########################################
echo -e "\n⚡ AZURE FUNCTIONS:"
az functionapp list \
--query "[].{Name:name,RG:resourceGroup,Plan:appServicePlanId}" \
-o table

########################################
# VIRTUAL NETWORKS
########################################
echo -e "\n🌐 VIRTUAL NETWORKS:"
az network vnet list \
--query "[].{VNET:name,RG:resourceGroup,Address:addressSpace.addressPrefixes}" \
-o table

########################################
# NETWORK SECURITY GROUPS
########################################
echo -e "\n🔐 NETWORK SECURITY GROUPS:"
az network nsg list \
--query "[].{NSG:name,RG:resourceGroup}" \
-o table

########################################
# COST MANAGEMENT (LAST 7 DAYS)
########################################
echo -e "\n💰 COST SUMMARY (LAST 7 DAYS):"
az costmanagement query \
--type ActualCost \
--timeframe Last7Days \
--query "rows[][0]" -o table

########################################
# END
########################################
echo -e "\n${GREEN}======================================="
echo " AZURE DAILY REPORT COMPLETED SUCCESSFULLY"
echo " Review OUTPUT to reduce Azure COST"
echo "=======================================${NC}"
