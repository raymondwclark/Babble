//
//  EventHandler.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 1/18/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

private func emitAckCallback(socket: SocketIOClient?, num: Int?)
    (items: AnyObject...) -> Void {
        socket?.emitAck(num ?? -1, withItems: items)
}

private func emitAckCallbackObjectiveC(socket: SocketIOClient?, num: Int?)
    (items: NSArray) -> Void {
        socket?.emitAck(num ?? -1, withItems: items as [AnyObject])
}

struct SocketEventHandler {
    let event: String
    let callback: NormalCallback?
    let callBackObjectiveC: NormalCallbackObjectiveC?
    
    init(event: String, callback: NormalCallback) {
        self.event = event
        self.callback = callback
        self.callBackObjectiveC = nil
    }
    
    init(event: String, callback: NormalCallbackObjectiveC) {
        self.event = event
        self.callback = nil
        self.callBackObjectiveC = callback
    }
    
    func executeCallback(items:NSArray? = nil, withAck ack:Int? = nil, withAckType type:Int? = nil,
        withSocket socket:SocketIOClient? = nil) {
            self.callback != nil ?
                self.callback?(items, emitAckCallback(socket, num: ack))
                : self.callBackObjectiveC?(items, emitAckCallbackObjectiveC(socket, num: ack))
    }
}
