package main

import (
	"encoding/json"
	"fmt"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/glog"
	"io"
	"strings"
	"time"
)

type MetaJsonData struct {
	Name        string      `json:"name"`
	Description string      `json:"description"`
	Image       string      `json:"image"`
	Attributes  interface{} `json:"attributes"`
}

const (
	metaJsonURL = "https://bafybeidzr7ae6vgobzouk4z6a2xavilbpb4ffbohqihf6zbglal4hg6zzm.ipfs.nftstorage.link/json/%d.json"
	pngURL      = "https://bafybeigir73hn3pmqpvmohpuxfaicfkseypmhsf6yxcuftoxg5hckmr2ve.ipfs.nftstorage.link/png/%s"
)

type NFTIPFS struct {
	logger *glog.Logger
}

func NewNFTIPFS() *NFTIPFS {
	ins := NFTIPFS{}
	ins.init()
	return &ins
}

func (n *NFTIPFS) init() {
	n.logger = glog.New()
	n.logger.SetConfigWithMap(g.Map{
		"path":     "log",
		"file":     "ipfs-{Ymd}.log",
		"level":    "all",
		"StStatus": 0,
	})
	n.logger.Debug(ctx, "NFTIPFS initlog finish")
}

func (n *NFTIPFS) start() {
	go n.qryResult()
}

func (n *NFTIPFS) qryResult() {
	client := g.Client()
	for {
		// 0~4999循环访问
		for i := 0; i < 5000; i++ {
			begin := time.Now().UnixMilli()
			resp, err := client.Get(ctx, fmt.Sprintf(metaJsonURL, i))
			jsonCost := time.Now().UnixMilli() - begin
			if err != nil {
				n.logger.Errorf(ctx, "client.Get json err:%s", err)
				continue
			}

			body, err := io.ReadAll(resp.Body)
			if err != nil {
				n.logger.Errorf(ctx, "io.ReadAll err:%s", err)
				continue
			}
			var jsonData MetaJsonData
			err = json.Unmarshal(body, &jsonData)
			if err != nil {
				n.logger.Errorf(ctx, "json.Unmarshal err:%s", err)
				continue
			}
			//
			index := strings.LastIndex(jsonData.Image, "/")
			pngByte := []byte(jsonData.Image)
			pngFileName := string(pngByte[index+1:])

			begin = time.Now().UnixMilli()
			_, err = client.Get(ctx, fmt.Sprintf(pngURL, pngFileName))
			pngCost := time.Now().UnixMilli() - begin
			if err != nil {
				n.logger.Errorf(ctx, "client.Get png err:%s", err)
				continue
			}

			n.logger.Debugf(ctx, "json[%d/%dms], png[%s/%dms]", i, jsonCost, pngFileName, pngCost)

			time.Sleep(time.Minute)
		}
		n.logger.Errorf(ctx, "完成一次完整5000条IPFS数据获取, 24小时后重新执行")
		time.Sleep(time.Hour * 24)
	}
}