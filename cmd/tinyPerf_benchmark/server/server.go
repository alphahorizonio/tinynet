package main

import (
	"fmt"
	"log"
	"net"
)

func main() {

	tcpAddr, err := net.ResolveTCPAddr("tcp", fmt.Sprintf("0.0.0.0:8888"))
	checkError(err)

	ln, err := net.ListenTCP("tcp", tcpAddr)
	checkError(err)

	for {
		conn, err := ln.Accept()
		checkError(err)

		go handleConnection(conn)
	}
}

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func handleConnection(conn net.Conn) {
	var input [1024]byte

	for {
		n, err := conn.Read(input[0:])
		checkError(err)

		_, err = conn.Write(input[0:n])
		checkError(err)
	}

}