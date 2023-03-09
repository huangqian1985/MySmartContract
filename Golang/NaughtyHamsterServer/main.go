package main

import (
	naughtyHamster "NaughtyHamsterServer/NaughtyHamster"
	"context"
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gctx"
	"github.com/gogf/gf/v2/os/glog"
	"github.com/gogf/gf/v2/os/gtimer"
	"log"
	"time"
)

const (
	TotalSupply = "/getTotalSupply"
)

var (
	client               *ethclient.Client
	logger               *glog.Logger
	ctx                  = gctx.New()
	rpcURL, contractAddr string
	crtFile, keyFile     string
	serverPort           int
	totalSupply          int64
)

func main() {
	initLog()

	if err := initConfig(); err != nil {
		panic(err)
	}
	if err := initClient(); err != nil {
		panic(err)
	}

	startTimer()

	s := g.Server()
	s.Group("", func(group *ghttp.RouterGroup) {
		//
		group.Middleware(MiddlewareCORS)
		//
		group.GET(TotalSupply, func(req *ghttp.Request) {
			req.Response.Write(getTotalSupply())
		})
	})
	s.EnableHTTPS(crtFile, keyFile)
	s.SetPort(serverPort)
	s.Run()
}

func MiddlewareCORS(r *ghttp.Request) {
	r.Response.CORSDefault()
	r.Middleware.Next()
}

func initConfig() error {
	if val, err := g.Config().Get(ctx, "ethereum.serverPort"); err != nil {
		return err
	} else {
		serverPort = val.Int()
	}

	if val, err := g.Config().Get(ctx, "ethereum.rpcURL"); err != nil {
		return err
	} else {
		rpcURL = val.String()
	}

	if val, err := g.Config().Get(ctx, "ethereum.contractAddr"); err != nil {
		return err
	} else {
		contractAddr = val.String()
	}

	if val, err := g.Config().Get(ctx, "ethereum.cryFile"); err != nil {
		return err
	} else {
		crtFile = val.String()
	}

	if val, err := g.Config().Get(ctx, "ethereum.keyFile"); err != nil {
		return err
	} else {
		keyFile = val.String()
	}

	logger.Debug(ctx, "initConfig finish")
	return nil
}

func initClient() error {
	var err error
	client, err = ethclient.Dial(rpcURL)
	if err != nil {
		return err
	}
	logger.Debug(ctx, "initClient finish")
	return nil
}

func initLog() {
	logger = glog.New()
	logger.SetConfigWithMap(g.Map{
		"path":     "log",
		"level":    "all",
		"StStatus": 0,
	})
	logger.Debug(ctx, "initlog finish")
}

func startTimer() {
	getTotalSupplyFromEthereum()
	gtimer.Add(ctx, time.Minute, func(ctx context.Context) {
		getTotalSupplyFromEthereum()
		logger.Debug(ctx, fmt.Sprintf("startTimer getTotalSupplyFromEthereum = %d", totalSupply))
	})
	logger.Debug(ctx, "startTimer finish")
}

func getTotalSupply() int64 {
	return totalSupply
}

func getTotalSupplyFromEthereum() {
	address := common.HexToAddress(contractAddr)
	instance, err := naughtyHamster.NewNaughtyHamster(address, client)
	if err != nil {
		logger.Errorf(ctx, "get instance err:%s", err)
		return
	}

	val, err := instance.TotalSupply(nil)
	if err != nil {
		logger.Errorf(ctx, "TotalSupply err:%s", err)
		return
	}

	totalSupply = val.Int64()
}

func test(client *ethclient.Client) {
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
