//
//  VerificationPeers.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/2/21.
//


import Foundation

class VerificationPeers {
    class VerificationPeer : NSObject {
    
        @objc var PeerId : String!
        @objc var PeerEmail : String!
        @objc var PeerFirstName: String!
        @objc var PeerLastName: String!
        @objc var PeerPhoneNumber: String!
        @objc var PeerImage: String!
        @objc var Answer: String!
        @objc var AnswerTimestamp : String!
       
        convenience init(dictionary : [AnyHashable : Any]) {
            self.init()
            self.PeerId = dictionary["PeerId"] as? String
            self.PeerFirstName = dictionary["PeerFirstName"] as? String
            self.PeerLastName = dictionary["PeerLastName"] as? String
            self.PeerEmail = dictionary["PeerEmail"] as? String
            self.PeerPhoneNumber = dictionary["PeerPhoneNumber"] as? String
            self.PeerImage = dictionary["PeerImage"] as? String
            self.Answer = dictionary["Answer"] as? String
            self.AnswerTimestamp = dictionary["AnswerTimestamp"] as? String
        
            //return self;
        }
        
        func convertBackToDictionary() -> NSMutableDictionary{
            let dictionary : NSMutableDictionary = NSMutableDictionary()
            
            dictionary.setValue(PeerId, forKey: "PeerId")
            dictionary.setValue(PeerFirstName, forKey: "PeerFirstName")
            dictionary.setValue(PeerLastName, forKey: "PeerLastName")
            dictionary.setValue(PeerEmail, forKey: "PeerEmail")
            dictionary.setValue(PeerPhoneNumber, forKey: "PeerPhoneNumber")
            dictionary.setValue(PeerImage, forKey: "PeerImage")
            dictionary.setValue(Answer, forKey: "Answer")
            dictionary.setValue(AnswerTimestamp, forKey: "AnswerTimestamp")
            
            return dictionary;
        }
    }
    
    class Helper {
       
        static func initEmptyProxVerificationPeer() -> VerificationPeer{
            let verificationPeer : VerificationPeer = VerificationPeer()
            verificationPeer.PeerEmail = "none"
            verificationPeer.Answer = "none"
            verificationPeer.AnswerTimestamp = "none"
            verificationPeer.PeerId = "none"
            verificationPeer.PeerFirstName = "none"
            verificationPeer.PeerLastName = "none"
            verificationPeer.PeerPhoneNumber = "none"
            verificationPeer.PeerImage = "none"
            
            return verificationPeer
        }
    }
}

