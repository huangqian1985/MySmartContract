package main

import (
	"context"
	"github.com/ethereum/go-ethereum/common"
	"log"

	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	client, err := ethclient.Dial("https://eth-goerli.g.alchemy.com/v2/Yy5Huxu5D7mM0_BigYQzKoiPVCxBw69p")
	if err != nil {
		log.Fatal(err)
	}

	// Get the balance of an account
	account := common.HexToAddress("0xd6bAe01Bce8ecc43E5d291172b2029e8c9acE58d")
	balance, err := client.BalanceAt(context.Background(), account, nil)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Account balance:", balance) // 25893180161173005034

	// Get the latest known block
	block, err := client.BlockByNumber(context.Background(), nil)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Latest block:", block.Number().Uint64())

	suggestGas, err := client.SuggestGasPrice(context.Background())
	log.Println(suggestGas, err)
}
