# BitCannaTools Monitoring Validators
BitCanna Tools

## bitcanna_Sign.sh
Signing Check Tools  (by DDeAlmeida)
  Configuration :
  - on ADDRESS you need to set your own validator HEX address
  - this script writes a log to ~/sign_history_bitcanna.txt. It just adds one line per block, checking its signing status.
  - If there are 15 continuous not-signed blocks, the script restarts the chain-maind and send a mail if you configured it.


## check_signers.py 

Check if the validators list is in the bock signers.
