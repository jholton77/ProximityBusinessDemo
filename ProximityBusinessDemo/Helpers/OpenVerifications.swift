//
//  OpenVerifications.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/2/21.
//


import Foundation
import AWSDynamoDB

class Verifications {
    class Open {
        
        @objc(_TtCCC9Proximity13Verifications4Open12Verification) class Verification : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
            class func dynamoDBTableName() -> String {
                if ProximityApp.Local.getIsProduction() {
                    return "PROD_Proximity_ProxVerificationsOpen"
                }
                else {
                    return "DEV_ProxVerificationsOpen"
                }
            }
            
            class func hashKeyAttribute() -> String {
                return "Id"
            }
            
            class func rangeKeyAttribute() -> String {
                return "MainUserId"
            }
            
            @objc var Id : String!
            @objc var MainUserEmail : String!
            @objc var CreatedTimestamp : String!
            @objc var LastUpdatedTimestamp : String!
            @objc var Status: String!
            @objc var MainUserId: String!
            //@objc var MainUserName: String!
            @objc var MainUserFirstName: String!
            @objc var MainUserLastName: String!
            @objc var MainUserPhoneNumber: String!
            @objc var MainUserAnswer : String!
            @objc var MainUserAnswerTimestamp : String!
            @objc var MainUserImage : String!
            @objc var BusinessPartnerId : String!
            @objc var AccountId : String!
            @objc var AccountInitials : String!
            @objc var MainUserMessage: String!
            @objc var MainUserNotes: String!
            @objc var PeerMessage: String!
            @objc var PeerNotes: String!
            @objc var `Type` : String!
            @objc var Peers : NSMutableArray!
            @objc var Code : String!
            
            @objc var Communications : NSMutableArray!
            @objc var Expiring : String!
            @objc var Extra1 : String!
        }

        class VerificationIdByUserPhone : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
            
            class func dynamoDBTableName() -> String {
                if ProximityApp.Local.getIsProduction() {
                    return "PROD_Proximity_ProxVerificationsOpenByUser"
                }
                else {
                    return "DEV_ProxVerificationsOpenByUser"
                }
            }
            
            class func hashKeyAttribute() -> String {
                return "Id"
            }
            
            class func rangeKeyAttribute() -> String {
                return "Phone"
            }
            
            @objc var Id : String!
            @objc var UserId : String!
            @objc var Phone : String!
            @objc var ProxVerificationId : String!
        }
        
        //MARK: LocalLoadSave
        class Local {
            static let storedOpenVerificationsName : String = "openVerifications"
            
            static func getOpenVerificationsList() -> NSMutableArray {
                return LocalLoadSaveHelperNew.getNSMutableArray(storedName: storedOpenVerificationsName)
            }
            
            static func saveOpenVerificationsList(array: NSMutableArray) {
                //LocalLoadSaveHelperNew.saveNSMutableArray(storedName: storedOpenVerificationsName, array: array)
                LocalLoadSaveHelperNew.saveObject(object: array, storedName: storedOpenVerificationsName)
            }
        }
    }
    
    class Helper {
    }
    //MARK: AWS Stuff
    
    static func save(openVerification: Open.Verification)-> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        //task.continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
        return dynamoDBObjectMapper.save(openVerification).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                //NSLog("Error in saveProxVerificationOpen")
                print("The request failed. Error: \(error)")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
            } else {
                // Do something with task.result or perform other operations.
                ////NSLog("prox verification open save worked!")
            }
            
            return task
        })
    }
    
    static func saveOpenVerificationIdByUserPhone(pair: Open.VerificationIdByUserPhone)-> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        return dynamoDBObjectMapper.save(pair).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                //NSLog("Error in saveProxVerificationOpenByUser")
                print("The request failed. Error: \(error)")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
            } else {
                // Do something with task.result or perform other operations.
                ////NSLog("this worked!")
            }
            
            return task
        })
    }
    
    static func createAccountRecoveryOpenVerification(businessPartnerId : Int, password : String) -> AWSTask<AnyObject>{
        let user = User.Local.getUser(groupName : nil)
        
        let proxOpen : Verifications.Open.Verification = Verifications.Open.Verification()
        
        proxOpen.AccountId = "-1"
        proxOpen.AccountInitials = "..."
        proxOpen.BusinessPartnerId = String(businessPartnerId)
        proxOpen.CreatedTimestamp = TimeHelper.currentUTC()
        proxOpen.LastUpdatedTimestamp = TimeHelper.currentUTC()
        proxOpen.Id = proxOpen.CreatedTimestamp + "-" + user.Email
        proxOpen.MainUserId = user.Id
        proxOpen.MainUserFirstName = user.FirstName
        proxOpen.MainUserLastName = user.LastName
        proxOpen.MainUserEmail = user.Email
        proxOpen.MainUserPhoneNumber = user.Phone
        proxOpen.MainUserImage = user.UserImage
        
        proxOpen.MainUserAnswer = "none"
        proxOpen.MainUserAnswerTimestamp = "none"
        proxOpen.MainUserMessage = "Account Recovery"
        proxOpen.MainUserNotes = "You have requested a one-time use account recovery code that expires in 15 minutes."
        proxOpen.PeerMessage =  "none"
        proxOpen.PeerNotes = "none"
        proxOpen.Status = "Open"
        proxOpen.Type = "AccountRecovery"
        
        proxOpen.Code = password //we will encrypt this just for user to be able to read
        
        proxOpen.Peers = NSMutableArray() //[VerificationPeers.VerificationPeer]()
        let verifyPeer : VerificationPeers.VerificationPeer = VerificationPeers.VerificationPeer()
        verifyPeer.PeerEmail = "none"
        verifyPeer.PeerId = "none"
        verifyPeer.PeerFirstName = "none"
        verifyPeer.PeerLastName = "none"
        verifyPeer.PeerPhoneNumber = "none"
        verifyPeer.PeerImage = "none"
        
        verifyPeer.AnswerTimestamp = "none"
        verifyPeer.Answer = "none"
        
        proxOpen.Peers.add(verifyPeer.convertBackToDictionary())
        
        let communications : NSMutableArray = NSMutableArray()
        communications.add("empty")
        proxOpen.Communications = communications
        
        proxOpen.Expiring = "none"
        proxOpen.Extra1 = "none"
        
        //send an email ??
        //push notification
        //text message
         
        let taskSub  = AWSTask<AnyObject>(result: nil)
        
        return taskSub.continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return Verifications.save(openVerification: proxOpen)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
        
            let pairOpen :Verifications.Open.VerificationIdByUserPhone = Verifications.Open.VerificationIdByUserPhone()
            
            pairOpen.Id = proxOpen.Id + "-" + proxOpen.MainUserEmail
            pairOpen.UserId = proxOpen.MainUserId
            pairOpen.Phone = proxOpen.MainUserPhoneNumber
            pairOpen.ProxVerificationId = proxOpen.Id
            
            return Verifications.saveOpenVerificationIdByUserPhone(pair: pairOpen)//self.saveProxVerificationOpenByUser(open: openByUser)
        })
        
        //return taskSub
    }
    
    static func createAndSaveOpenVerificationForBusinessCaseRequest(user : User, businessPartnerCase : BizPartners.BusinessPartnerCase, peerUser : User, peerMessage : String) -> AWSTask<AnyObject>{
        //let user = User.Local.getUser(groupName : nil)
        
        let proxOpen : Verifications.Open.Verification = Verifications.Open.Verification()
        
        proxOpen.AccountId = "-1"
        proxOpen.AccountInitials = "..."
        proxOpen.BusinessPartnerId = businessPartnerCase.PartnerId
        proxOpen.CreatedTimestamp = TimeHelper.currentUTC()
        proxOpen.LastUpdatedTimestamp = TimeHelper.currentUTC()
        proxOpen.Id = proxOpen.CreatedTimestamp + "-" + user.Email
        proxOpen.MainUserId = user.Id
        proxOpen.MainUserFirstName = user.FirstName
        proxOpen.MainUserLastName = user.LastName
        proxOpen.MainUserEmail = user.Email
        proxOpen.MainUserPhoneNumber = user.Phone
        proxOpen.MainUserImage = user.UserImage
        
        proxOpen.MainUserAnswer = "none"
        proxOpen.MainUserAnswerTimestamp = "none"
        
        var mainUserMessage = businessPartnerCase.VerificationType
        
        //just for demo
        if mainUserMessage == "AccountRecovery" {
            mainUserMessage = "Account Recovery"
        }
        
        mainUserMessage = mainUserMessage! + " Verification" // Request"
        
        proxOpen.MainUserMessage = mainUserMessage
        proxOpen.MainUserNotes = businessPartnerCase.Message
        proxOpen.PeerMessage =  mainUserMessage
        
        //see if we need to customize message
        let customPeerMessage = peerMessage.replacingOccurrences(of: "mainusername", with: user.FirstName + " " + user.LastName)
        proxOpen.PeerNotes = customPeerMessage
        
        
        proxOpen.Status = "Open"
        proxOpen.Type = businessPartnerCase.VerificationStrategyType
        
        proxOpen.Code = "none" //we will encrypt this just for user to be able to read
        
        proxOpen.Peers = NSMutableArray() //[VerificationPeers.VerificationPeer]()
        let verifyPeer : VerificationPeers.VerificationPeer = VerificationPeers.VerificationPeer()
        
        if (proxOpen.Type == "JustUser")
        {
            verifyPeer.PeerEmail = "none"
            verifyPeer.PeerId = "none"
            verifyPeer.PeerFirstName = "none"
            verifyPeer.PeerLastName = "none"
            verifyPeer.PeerPhoneNumber = "none"
            verifyPeer.PeerImage = "none"
            verifyPeer.AnswerTimestamp = "none"
            verifyPeer.Answer = "none"
            
            proxOpen.Peers.add(verifyPeer.convertBackToDictionary())
        }
        else {
            verifyPeer.PeerEmail = peerUser.Email
            verifyPeer.PeerId = peerUser.Id
            verifyPeer.PeerFirstName = peerUser.FirstName
            verifyPeer.PeerLastName = peerUser.LastName
            verifyPeer.PeerPhoneNumber = peerUser.Phone
            verifyPeer.PeerImage = peerUser.UserImage
            verifyPeer.AnswerTimestamp = "none"
            verifyPeer.Answer = "none"
            
            proxOpen.Peers.add(verifyPeer.convertBackToDictionary())
        }
        
        let communications : NSMutableArray = NSMutableArray()
        communications.add("empty")
        proxOpen.Communications = communications
        
        proxOpen.Expiring = "none" //minutes
        proxOpen.Extra1 = businessPartnerCase.Id
        
        //send an email ??
        //push notification
        //text message
         
        let taskSub  = AWSTask<AnyObject>(result: nil)
        
        return taskSub.continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return Verifications.save(openVerification: proxOpen)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
        
            let pairOpen :Verifications.Open.VerificationIdByUserPhone = Verifications.Open.VerificationIdByUserPhone()
            
            pairOpen.Id = proxOpen.Id + "-" + proxOpen.MainUserEmail
            pairOpen.UserId = proxOpen.MainUserId
            pairOpen.Phone = proxOpen.MainUserPhoneNumber
            pairOpen.ProxVerificationId = proxOpen.Id
            
            return Verifications.saveOpenVerificationIdByUserPhone(pair: pairOpen)//self.saveProxVerificationOpenByUser(open: openByUser)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
        
            let pairOpen :Verifications.Open.VerificationIdByUserPhone = Verifications.Open.VerificationIdByUserPhone()
            
            pairOpen.Id = proxOpen.Id + "-" + peerUser.Email
            pairOpen.UserId = peerUser.Id
            pairOpen.Phone = peerUser.Phone
            pairOpen.ProxVerificationId = proxOpen.Id
            
            return Verifications.saveOpenVerificationIdByUserPhone(pair: pairOpen)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
           
            return User.Helper.updateUserFlags(userId: user.Id, verifyFlag: true, peersFlag: false, miscFlag: false)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
           
            return User.Helper.updateUserFlags(userId: peerUser.Id, verifyFlag: true, peersFlag: false, miscFlag: false)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            
            let email : Emails.Email = Emails.Email()//= Email()
            
            email.Id = businessPartnerCase.CreatedTimestamp //this isn't unique enough long term
            email.Message = businessPartnerCase.VerificationType + " Request"
            email.Phone = user.Phone
            email.OtherPhone = "none"
            email.Created = TimeHelper.currentUTC()
            email.EmailType = "BusinessPartnerCaseRequest"
            email.Extra1 = proxOpen.Id
            email.DeviceToken = user.DeviceToken
            
            return Emails.saveEmail(email: email)
        }).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"BusinessCaseRequestFinished"), object: nil)
            
            return nil
        })
        
        
        
        
        //return taskSub
    }
}

