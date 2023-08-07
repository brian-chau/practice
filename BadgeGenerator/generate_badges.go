package main

import (
	"bytes"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/narqo/go-badge"
)

var (
	result  = flag.String("result", "", "Test Result")
	linecov = flag.String("linecov", "", "Line Coverage")
	fxncov  = flag.String("fxncov", "", "Function Coverage")
)

func fetch_test_color(result string) (color string) {
	switch result {
	case "Pass":
		color = "#00FF00"
	case "Fail":
		color = "#FF0000"
	}
	return
}

func fetch_coverage_color(result string) (color string) {
	n, _ := strconv.Atoi(result)
	R := (255 * (100 - n)) / 100
	G := (255 * n) / 100
	B := 0

	color = fmt.Sprintf("#%02x%02x%02x", R, G, B)

	return
}

func generate_badge(field string, value string) {
	flag.Parse()
	color := "Green"
	if field == "Test Result" {
		color = fetch_test_color(value)
	} else if strings.Contains(field, "Coverage") {
		color = fetch_coverage_color(value)
	}

	buf := &bytes.Buffer{}
	err := badge.Render(field, value, badge.Color(color), buf)
	if err != nil {
		log.Fatal(err)
	}

	field = strings.ReplaceAll(field, " ", "_")
	os.WriteFile("./TestResults/Badges/"+field+".svg", buf.Bytes(), 0644)
}

func main() {
	flag.Parse()

	generate_badge("Test Result", *result)
	generate_badge("Line Coverage", *linecov)
	generate_badge("Fxn Coverage", *fxncov)
}
