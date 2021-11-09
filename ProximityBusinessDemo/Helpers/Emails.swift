//
//  Emails.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/2/21.
//


import Foundation
import AWSDynamoDB

class Emails {
    class Email : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
        class func dynamoDBTableName() -> String {
            if ProximityApp.Local.getIsProduction() {
                return "PROD_Proximity_Emails"
            }
            else {
                return "DEV_Emails"
            }
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "Phone"
        }
        
        @objc var Id : String!
        @objc var Phone : String!
        @objc var OtherPhone: String!
        //@objc var Email : String!
        //@objc var OtherEmail: String!
        @objc var Created: String!
        @objc var EmailType: String!
        @objc var DeviceToken : String!
        @objc var Message : String!
        @objc var Extra1 : String!
        @objc var Extra2 : String!
    }
    
    class Helper {
        
    }
    
    //MARK: AWS Stuff
   
    static func saveEmail(email: Emails.Email) -> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        email.Message = "empty"
        
        return dynamoDBObjectMapper.save(email).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                //NSLog("Error in insertPivEmail")
                print("The request failed. Error: \(error)")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
            } else {
                // Do something with task.result or perform other operations.
            }
            
            return task
        })
        
    }
   
}

