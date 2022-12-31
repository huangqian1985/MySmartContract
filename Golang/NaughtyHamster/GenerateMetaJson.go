package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/text/gstr"
	"github.com/gogf/gf/v2/util/gconv"
)

type AttributeData struct {
	TraitType string `json:"trait_type"`
	Value     string `json:"value"`
}

type MetaJsonData struct {
	Name       string          `json:"name"`
	Desc       string          `json:"description"`
	Image      string          `json:"image"`
	Attributes []AttributeData `json:"attributes"`
}

type CSVData struct {
	ID         int
	BackGround string
	Back       string
	Mount      string
	Body       string
	Clothing   string
	Face       string
	Eyes       string
	Head       string
	RightHand  string
	LeftHand   string
}

var (
	csvDataMap = make(map[int]CSVData)
)

const (
	NFTName        = "Naughty Hamster #"
	NFTIPFSURLBase = "ipfs://xxx/img/"
	pngPath        = "C:\\Users\\黄骞\\OneDrive\\桌面\\Pic"
	csvPath        = "src/metadata.csv"
	jsonOutputPath = "output/json/"
	csvParamCount  = 11
)

func genMetaJsonWithPng() {
	list, _ := gfile.ScanDirFile(pngPath, "*.png", false)
	for _, v := range list {
		if pngData, exist := csvDataMap[gconv.Int(gfile.Name(v))]; exist {
			genJsonWithPNGData(pngData)
		} else {
			fmt.Println(v, "is not exist")
		}
	}
}

func genJsonWithPNGData(pngData CSVData) {
	jsonData := MetaJsonData{}
	jsonData.Name = NFTName + fmt.Sprintf("%04d", pngData.ID)
	jsonData.Desc = "Test Desc"
	jsonData.Image = NFTIPFSURLBase + fmt.Sprintf("%04d.png", pngData.ID)
	var attributeList []AttributeData
	attributeList = append(attributeList, AttributeData{TraitType: "BackGround", Value: pngData.BackGround})
	attributeList = append(attributeList, AttributeData{TraitType: "Back", Value: pngData.Back})
	attributeList = append(attributeList, AttributeData{TraitType: "Mount", Value: pngData.Mount})
	attributeList = append(attributeList, AttributeData{TraitType: "Body", Value: pngData.Body})
	attributeList = append(attributeList, AttributeData{TraitType: "Clothing", Value: pngData.Clothing})
	attributeList = append(attributeList, AttributeData{TraitType: "Face", Value: pngData.Face})
	attributeList = append(attributeList, AttributeData{TraitType: "Eyes", Value: pngData.Eyes})
	attributeList = append(attributeList, AttributeData{TraitType: "Head", Value: pngData.Head})
	attributeList = append(attributeList, AttributeData{TraitType: "RightHand", Value: pngData.RightHand})
	attributeList = append(attributeList, AttributeData{TraitType: "LeftHand", Value: pngData.LeftHand})
	jsonData.Attributes = attributeList

	b, _ := json.Marshal(jsonData)

	outputFile := jsonOutputPath + fmt.Sprintf("%04d.json", pngData.ID)
	gfile.PutBytes(outputFile, b)
}

func loadCSV() {
	err := gfile.ReadLines(csvPath, func(line string) error {
		list := gstr.Split(line, ",")
		if len(list) != csvParamCount {
			return errors.New("list size not equal csvParamCount")
		}

		data := CSVData{}
		data.ID = gconv.Int(list[0])
		data.BackGround = list[1]
		data.Back = list[2]
		data.Mount = list[3]
		data.Body = list[4]
		data.Clothing = list[5]
		data.Face = list[6]
		data.Eyes = list[7]
		data.Head = list[8]
		data.RightHand = list[9]
		data.LeftHand = list[10]
		csvDataMap[data.ID] = data

		return nil
	})

	if err != nil {
		panic(err)
	}

	//g.Dump(csvDataMap)
}
