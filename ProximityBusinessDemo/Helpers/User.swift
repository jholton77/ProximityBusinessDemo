//
//  User.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//


import Foundation
import AWSDynamoDB

class Flags : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    class func dynamoDBTableName() -> String {
        if ProximityApp.Local.getIsProduction() {
            return "PROD_Proximity_UserFlags"
        }
        else {
            return "DEV_UserFlags"
        }
    }
    
    class func hashKeyAttribute() -> String {
        return "UserId"
    }
    
    @objc var UserId : String!
    @objc var CreatedTimestamp : String!
    @objc var Verifications: NSNumber!
    @objc var Peers: NSNumber!
    @objc var Unknown: NSNumber!
}

@objc(ProxUser) class User : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
   
    class func dynamoDBTableName() -> String {
        
        if ProximityApp.Local.getIsProduction() {
            return "PROD_Proximity_Users"
        }
        else {
            return "DEV_Users"
        }
    }
    
    class func hashKeyAttribute() -> String {
        return "Id"
    }
    
    class func rangeKeyAttribute() -> String {
        return "Phone"
    }
    
    @objc var Id : String!
    @objc var FirstName : String!
    @objc var LastName: String!
    @objc var Email: String!
    @objc var Phone: String!
    @objc var UDID: String!
    @objc var PublicKeyForMessaging : String!
    @objc var PublicKey : String!
    @objc var DeviceToken : String!
    @objc var LastAccessed : String!
    @objc var UserImage : String!
    @objc var Locked : String!
    @objc var SymKey : String!
    @objc var Demo : String!
    @objc var Version : String!
    @objc var Created : String!
    @objc var IsPremium : String!
    
    class Local {
        static let storedUserName : String = "proxUser"
         
        static func getUser(groupName : String?) -> User {
            let encodedData = LocalLoadSaveHelperNew.getDataFromKeychain(keyName: storedUserName, groupName: groupName)
            
            var user : User = User()
            
            if encodedData != nil {
                do {
                   // user = try NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: encodedData!)!
                    user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData!) as! User
                    //print("this worked!")
                   // print(user)
                }
                catch {
                    print("Error retrieving saved User: \(error)")
                }
            }
            else { //create new user object and save
                user = User()
                save(user: user)
            }
            
            return user
        }
        
        static func save(user: User) {
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                LocalLoadSaveHelperNew.saveDataToKeychain(encodedData: encodedData, keyName: storedUserName, groupName: nil)
            }
            catch {
                print("Save user didn't work.")
            }
        }
    }
    
    class Helper {
        static func createUniqueUserId(user: User) -> String {
            let createKeyId = String.localizedStringWithFormat("%@-%@", NSUUID().uuidString, user.Phone)
            return createKeyId
        }
        
        static func createUniqueUUID() -> String {
            let createKeyId = String.localizedStringWithFormat("%@", NSUUID().uuidString)
            return createKeyId
        }
        
        static func getExistingUser(userPhone: String)-> AWSTask<AnyObject>{
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            
            let scanExpression : AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
            scanExpression.limit = 1000
            scanExpression.filterExpression = "Phone=:val"
            scanExpression.expressionAttributeValues = [":val": userPhone]
            
            //print("Phone: " + userPhone)
            //print("scan expression: " + scanExpression.filterExpression!)
            // task.continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return dynamoDBObjectMapper.scan(User.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
                
                if let error = task.error as NSError? {
                    //NSLog("Error in getExistingUser")
                    print("The request failed. Error: \(error)")
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
                } else if let paginatedOutput = task.result {
                    
                    if (paginatedOutput.items.count > 0){
                        //NSLog("phone exists")
                        
                        for user in paginatedOutput.items as! [User] {
                            //User.Local.save(user: user)
                            DispatchQueue.main.async {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                
                                if appDelegate?.dictUsers[user.Phone] == nil {
                                    appDelegate?.dictUsers[user.Phone] = user
                                }
                            }
                            
                            break
                        }
                    }
                    
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"UserLoaded"), object: nil)
                }
                
                return task
                
            })
        }
        
        static func saveUserFlags(userFlags: Flags)-> AWSTask<AnyObject>{
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            
            //just for testing
            if userFlags.CreatedTimestamp == nil {
                userFlags.CreatedTimestamp = TimeHelper.currentUTC()
                //LocalLoadSaveHelper.saveUserUpdate(userFlag)
            }
            return dynamoDBObjectMapper.save(userFlags).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as NSError? {
                    //NSLog("Error in saveUserFlags")
                    print("The request failed. Error: \(error)")
                } else {
                    // Do something with task.result or perform other operations.
                }
                
                return task
            })
        }
        
        static func updateUserFlags(userId: String, verifyFlag:Bool, peersFlag:Bool, miscFlag:Bool)-> AWSTask<AnyObject>{
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            
            return  dynamoDBObjectMapper.load(Flags.self, hashKey: userId, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                var userFlags : Flags = Flags()
                
                if let error = task.error as NSError? {
                    //NSLog("Error in updateUserFlags")
                    print("The request failed. Error: \(error)")
                } else {
                    if (task.result as? Flags != nil) {
                        userFlags = task.result as! Flags
                        
                        if (verifyFlag){
                            userFlags.Verifications = NSNumber(value: 1)
                        }
                        
                        if (peersFlag) {
                            userFlags.Peers = NSNumber(value: 1)
                        }
                        
                  
                        if (miscFlag) {
                            userFlags.Unknown = NSNumber(value: 1)
                        }
                    }
                    else {
                        //NSLog("No userFlag for this user id")
                    }
                }
                
                if userFlags.UserId != nil {
                    return self.saveUserFlags(userFlags: userFlags)
                }
                else {
                    return task
                }
            })
            
        }
    }
    
}
