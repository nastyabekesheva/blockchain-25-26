#!/bin/bash
# Bitcoin regtest lab — capture all outputs
# Usage: bash lab_bitcoin.sh > lab_output.txt 2>&1

CLI="bitcoin-cli -regtest"

echo "=========================================="
echo "1. BLOCKCHAIN INFO"
echo "=========================================="
$CLI getblockchaininfo

echo ""
echo "=========================================="
echo "2. WALLET INFO"
echo "=========================================="
$CLI getwalletinfo

echo ""
echo "=========================================="
echo "3. BALANCE BEFORE TRANSACTION"
echo "=========================================="
$CLI getbalance

echo ""
echo "=========================================="
echo "4. CREATE RECIPIENT ADDRESS"
echo "=========================================="
ADDR=$(bitcoin-cli -regtest getnewaddress "miner")
ADDR2=$(bitcoin-cli -regtest getnewaddress "recipient")
echo "Miner address: $ADDR"
echo "Recipient address: $ADDR2"

echo ""
echo "=========================================="
echo "5. SEND 10 BTC"
echo "=========================================="
TXID=$($CLI -named sendtoaddress address=$ADDR2 amount=10.0 fee_rate=1)
echo "TXID: $TXID"

echo ""
echo "=========================================="
echo "6. UNCONFIRMED TRANSACTION"
echo "=========================================="
$CLI gettransaction $TXID

echo ""
echo "=========================================="
echo "7. MEMPOOL (before confirmation)"
echo "=========================================="
$CLI getmempoolinfo

echo ""
echo "=========================================="
echo "8. GENERATE 1 BLOCK (confirm tx)"
echo "=========================================="
$CLI generatetoaddress 1 $ADDR

echo ""
echo "=========================================="
echo "9. CONFIRMED TRANSACTION"
echo "=========================================="
$CLI gettransaction $TXID

echo ""
echo "=========================================="
echo "10. RECEIVED BY RECIPIENT"
echo "=========================================="
$CLI getreceivedbyaddress $ADDR2

echo ""
echo "=========================================="
echo "11. BALANCE AFTER TRANSACTION"
echo "=========================================="
$CLI getbalance

echo ""
echo "=========================================="
echo "12. BEST BLOCK"
echo "=========================================="
BLOCKHASH=$($CLI getbestblockhash)
echo "Block hash: $BLOCKHASH"
$CLI getblock $BLOCKHASH

echo ""
echo "=========================================="
echo "13. RAW TRANSACTION (decoded)"
echo "=========================================="
$CLI getrawtransaction $TXID true

echo ""
echo "=========================================="
echo "14. UTXO LIST"
echo "=========================================="
$CLI listunspent

echo ""
echo "=========================================="
echo "15. NETWORK INFO"
echo "=========================================="
$CLI getnetworkinfo

echo ""
echo "=========================================="
echo "16. PEER INFO"
echo "=========================================="
$CLI getpeerinfo

echo ""
echo "=========================================="
echo "DONE"
echo "=========================================="
