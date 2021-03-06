#!/bin/bash
clear
read -p 'SFDX Alias: ' SFDXALIAS
read -p 'Deploy Datapack [y/n]: ' DEPLOYDP

# EDIT the USRPREFIX variable to better represent your SFDX project
USRPREFIX='thido-uber-'$(date +%s)
USRNAME=$USRPREFIX'@example.com'

# The below passwords - SCRATCH_PWD is for dataloader as it is run in batch mode - https://help.salesforce.com/articleView?id=loader_batchmode.htm&type=5
# Pulled from local ENVT variables
DEFAULTPWD=$DX_DEF_PWD

# Encrypt the default password
ENCRYPT_RESULT=$(java -cp bin/dataloader/dataloader.jar com.salesforce.dataloader.security.EncryptionUtil -e $DEFAULTPWD data/prod/config/login.key | sed -n '1!p')

#Remove any whitespace
ENCRYPT_RESULT="$(echo -e "${ENCRYPT_RESULT}" | sed -e 's/^[[:space:]]*//')"
echo 'using encrypted PWD of '$ENCRYPT_RESULT''

SCRATCH_PWD=$ENCRYPT_RESULT


STARTTIME=$(date +%s)

./scripts/bash/createScratchOrg.sh $SFDXALIAS $USRNAME $DEFAULTPWD

#./scripts/bash/updateUserName.sh $SFDXALIAS $USRNAME

# EDIT - install any AppExchange / Demo components you need
#./scripts/bash/installAppEx.sh "Demo Component - Lightning File Gallery "$SFDXALIAS

./scripts/bash/installDependencies.sh "$SFDXALIAS"

./scripts/bash/installFromGithub.sh kakermanis sdo-dependencies

./scripts/bash/pushLocalSource.sh "$SFDXALIAS"



# EDIT to apply an permission sets that are specific to your scratch org...
#./scripts/bash/applyPermSets.sh tth_BookingReservation_Data_Model $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Loyalty_Data_Model $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_BookingReservation_Data_Model $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Reservation_Hospitality_Fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Reservation_Airline_Fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Traveler_Record $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Rental_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Hospitality_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Airline_Preference_fields $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_Customer_360_Features $SFDXALIAS
./scripts/bash/applyPermSets.sh tth_NBA_Permissions $SFDXALIAS
./scripts/bash/applyPermSets.sh TTH_SDO_Tools_Extensions $SFDXALIAS
./scripts/bash/applyPermSets.sh TTH_SDO_Dependencies_Perms $SFDXALIAS

if [ "$DEPLOYDP" == 'n' ]; then
  echo
  echo 'This is a local build, loading SFDX dataset...'
  echo
  ./scripts/bash/loadDevData.sh "$SFDXALIAS"
fi


if [ "$DEPLOYDP" == 'y' ]; then
  echo
  echo 'This is a fuller build, loading Datapack dataset...'
  #read -p 'Scratch default username: ' scratchUser
  #read -p 'Scratch encrypted password:' scratchPass
  ./scripts/bash/loadProdData.sh $USRNAME $SCRATCH_PWD https://test.salesforce.com

  # EDIT - run any custom annon APEX scripts you need post data load
  ./scripts/bash/runApexScript.sh "scripts/apex/applyBookingImages.apex" $SFDXALIAS
fi

./scripts/bash/runApexScript.sh "scripts/apex/applyNBAIcons.apex" $SFDXALIAS

#sfdx force:apex:execute -f scripts/apex/applyBookingImages.apex -u $SFDXALIAS
#sfdx force:apex:execute -f scripts/apex/applyNBAIcons.apex -u $SFDXALIAS
# EDIT - run any other post installation scripts you need
sfdx shane:theme:activate -n THDark -u $SFDXALIAS

ENDTIME=$(date +%s)
BUILD_TIME_SEC=$(($ENDTIME - $STARTTIME))

echo
echo '************************************************************************'
echo "Build took $BUILD_TIME_SEC seconds to complete..."
echo '************************************************************************'
echo

./scripts/bash/buildLog.sh DevHub $BUILD_TIME_SEC "Uber-ido-build"

echo
echo '******************'
echo 'Opening the org...'
echo '******************'
echo

# Open org to default homepage
sfdx force:org:open -p /lightning/page/home -u $SFDXALIAS
