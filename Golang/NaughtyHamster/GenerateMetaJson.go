package main

import (
	"errors"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/text/gstr"
	"github.com/gogf/gf/v2/util/gconv"
)

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
	csvPath       = "src/metadata.csv"
	csvParamCount = 11
)

func genMetaJson() {
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

	g.Dump(csvDataMap)
}
