//: Playground - noun: a place where people can play

import UIKit
import Socket_IO_Client_Swift

var str = "Hello, playground"

let socket = SocketIOClient(socketURL: "104.171.10.34:6012")
socket.on("connect") {data, ack in
    print("socket connected")
}
