//
//  ViewController.swift
//  Babble
//
//  Created by Raymond_Dev on 7/1/15.
//  Copyright (c) 2015 Babble. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import JSQMessagesViewController


class ViewController: JSQMessagesViewController {
    
    var myMessage: Bool! = false

    let socket = SocketIOClient(socketURL: "172.16.100.43:8000")
    
    var userName = ""
    
    var messages = [JSQMessage]()
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func addHandlers() {
        //self.socket.onAny {println("Got event: \($0.event), with items: \($0.items)")}
        
        socket.on("connect") {data, ack in
            print("connected to server!")
        }
        
        socket.on("disconnect") {data, ack in
            print("server disconnected!")
        }
        
        /*socket.on("username") {data, ack in
        if let usr = data?[0] as? String {
        self.username = usr;
        }
        }*/
        
        socket.on("messageReceived") {data, ack in
            if let cur = data?[0] as? String {
                let message = JSQMessage(senderId: "random", displayName: "random", text: cur)
                self.messages += [message]
                print(data)
                self.finishReceivingMessage()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName = randomStringWithLength(16) as String
        self.addHandlers();
        self.socket.connect();
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView!.reloadData()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        
        // remove avatars
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.row]
        if (message.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        self.messages += [newMessage]
        socket.emit("messageSent", newMessage.text)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }

}

