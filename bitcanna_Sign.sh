#! /bin/bash

# Set Enable Email to 1 to enable email notifications and fill in the blanks
ENABLE_EMAIL=0
FROM_ADDRESS=
TO_ADDRESS=
# Number of missed blocks before an email is sent
ALERT_MISSING_BLOCKS=15
export CURRENT_BLOCK=0
#SET ADDRESS VALIDATOR
export ADDRESS=3DC460BB9B0F124D27D013A319719476D980D550
export NOT_SIGNING_COUNT=0

while true; 
do

HEIGHT=$(curl --max-time 10 -sSL "http://seed1.bitcanna.io:26657/block" | jq -r '.result.block.header.height')

function send_email_notify
{
    if [ "$ENABLE_EMAIL" = 1 ]; then
		mail -s "BitCanna Monitor: '$POOL_ID'" -a From:Admin\<$FROM_ADDRESS\> --return-address=$FROM_ADDRESS $TO_ADDRESS <<< 'Validator is Missing Blocks!!  
		Expected: '$EXPECTED_BLOCKS'
		Produced: '$PRODUCED_BLOCKS'
		Blocks Missed: '$BLOCKS_MISSED'
		Alert Trigger: '$ALERT_MISSING_BLOCKS' Missing Blocks'
	fi
}


if [ $CURRENT_BLOCK != $HEIGHT ];
then

    VALID_SIGN=$(curl --max-time 10 -sSL "http://seed1.bitcanna.io:26657/block" | jq -r --arg ADDRESS "${ADDRESS}" '.result as $result | .result.block.last_commit.signatures[] | select(.validator_address | . != null and . != "" and . == $ADDRESS) | $result.block.header.height')
    if [[ -z "${VALID_SIGN}" ]]; then
            date +"%d/%m/%y-%H:%M:%S  ❌ Not signing @ Block#${HEIGHT}" >> ~/sign_history_bitcanna.txt

            ((NOT_SIGNING_COUNT++))
            if [ $NOT_SIGNING_COUNT -gt $ALERT_MISSING_BLOCKS ]; then
                    echo "Restarting the service @ Block#${HEIGHT}"
					send_email_notify
                    sudo systemctl restart bcnad.service
                    NOT_SIGNING_COUNT=0
            fi

    else
           date +"%d/%m/%y-%H:%M:%S  👍 Signing @ Block#${HEIGHT}" >> ~/sign_history_bitcanna.txt
           NOT_SIGNING_COUNT=0
    fi

    CURRENT_BLOCK=$HEIGHT

fi

done;
