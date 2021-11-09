//
//  BizPartners.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//


import Foundation
import AWSDynamoDB

class BizPartners {
    
    @objc(_TtCC9Proximity11BizPartners10BizPartner) class BizPartner : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            //if ProximityApp.Local.getIsProduction() {
            //    return "PROD_Proximity_BusinessPartners"
            //}
            //else {
                return "DEV_BusinessPartners"
            //}
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
    
        
        @objc var Id : String!
        @objc var Created : String!
        @objc var Name: String!
        @objc var Category : String!
        @objc var LogoFileName : String!
        @objc var SmallLogoFileName: String!
        
    }
    
    class BusinessPartnerCase : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_BusinessPartnersCases"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "PartnerId"
        }
        
        @objc var Id : String!
        @objc var PartnerId : String!
        @objc var CreatedTimestamp : String!
        @objc var UserId : String!
        @objc var VerificationType : String!
        @objc var VerificationStrategyType : String!
        @objc var Message : String!
        @objc var AcceptCode : String!
        @objc var DeclineCode : String!
        
        @objc var Status : String!
        @objc var ServerReceivedTime : String!
        @objc var ExpiredInMilliseconds : String!
    }
    
    
    
    
    
    @objc(_TtCC9Proximity11BizPartners14UserBizPartner) class UserBizPartner : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_UserBusinessPartners"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "UserId"
        }
        
        @objc var Id : String!
        @objc var CreatedTimestamp : String!
        @objc var UserId : String!
        @objc var AccountId : String!
        @objc var BusinessPartnerId: String!
        @objc var IsRecoveryEnabled: String!
    }
    
    class BizPartnerCaseResponse : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_BusinessPartnersCasesResponses"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "CaseId"
        }
        
        @objc var Id : String!
        @objc var CreatedTimestamp : String!
        @objc var CaseId : String!
        @objc var UserId : String!
        @objc var AcceptDecline: String!
        @objc var IsPeer: String!
    }
   
    class UserBizPartnerBackup : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_UserBusinessPartnersBackup"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "UserId"
        }
        
        @objc var Id : String!
        @objc var CreatedTimestamp : String!
        @objc var UserId : String!
        @objc var BusinessPartnerId : String!
        @objc var BackupMessage: NSMutableArray!
    }
    
    class UserBizPartnerBackupResponse : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_UserBusinessPartnerBackupResponses"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "UserId"
        }
        
        @objc var Id : String!
        @objc var CreatedTimestamp : String!
        @objc var UserId : String!
        @objc var BusinessPartnerId : String!
        @objc var Message: String!
    }
  
    @objc(_TtCC9PROXIMITY11BizPartners26UserBusinessPartnerSetting) class UserBusinessPartnerSetting : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_UserBusinessPartnerSettings"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "UserId"
        }
        
        @objc var Id : String!
        @objc var UserId : String!
        @objc var UserBusinessPartnerId : String!
        @objc var BusinessPartnerId : String!
        @objc var SettingId : String!
        @objc var Title : String!
        @objc var Description : String!
        @objc var AllowsPeers : String!
        @objc var Peers : NSMutableArray!
        @objc var IsOn : String!
    }
    
    class BusinessPartnersSettingsMenu : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
        class func dynamoDBTableName() -> String {
            return "DEV_BusinessPartnersSettingsMenu"
        }
        
        class func hashKeyAttribute() -> String {
            return "Id"
        }
        
        class func rangeKeyAttribute() -> String {
            return "Title"
        }
        
        @objc var Id : String!
        @objc var Title : String!
        @objc var Description : String!
        @objc var AllowsPeers : String!
    }
    
    
    
    
    
    class Local {
        
        static let storedSelectedBizPartnerIdKeyName : String = "selectedBizPartnerId"
        
        static func setSelectedBizPartnerId(id  : String){
            LocalLoadSaveHelperNew.setStringInKeychain(keyName : storedSelectedBizPartnerIdKeyName, stringValue : id, groupName: nil)
        }
        
        static func getSelectedBizPartnerId() -> String {
            return LocalLoadSaveHelperNew.getStringValueFromKeychain(keyName: storedSelectedBizPartnerIdKeyName, groupName: nil)
        }
        
        static let storedBizPartnersName : String = "bizPartners"
        
        static func getBizPartnersDictionary() -> NSMutableDictionary {
            return LocalLoadSaveHelperNew.getNSMutableDictionary(storedName: storedBizPartnersName)
        }
        
        static func saveBizPartnersDictionary(bizPartners: NSMutableDictionary) {
            
            LocalLoadSaveHelperNew.saveObject(object: bizPartners, storedName: storedBizPartnersName)
        }
        
        static let storedMyAppsName : String = "myApps"
        
        static func getMyAppList() -> NSMutableArray {
            return LocalLoadSaveHelperNew.getNSMutableArray(storedName: storedMyAppsName)
        }
        
        static func saveMyAppList(myApps: NSMutableArray) {
           
            LocalLoadSaveHelperNew.saveObject(object: myApps, storedName: storedMyAppsName)
        }
      
        static let storedMyAppsLogName : String = "myAppLogs"
        
        static func getMyAppLogList() -> NSMutableArray {
            return LocalLoadSaveHelperNew.getNSMutableArray(storedName: storedMyAppsLogName)
        }
        
        static func saveMyAppLogList(myAppLogs: NSMutableArray) {
            
            LocalLoadSaveHelperNew.saveObject(object: myAppLogs, storedName: storedMyAppsLogName)
        }
        
        static let storeCurrentMyAppCodesName : String = "currentMyAppCode"
        
        static func getCurrentMyAppCodeList() -> NSMutableArray {
            return LocalLoadSaveHelperNew.getNSMutableArray(storedName: storeCurrentMyAppCodesName)
        }
        
        static func saveCurrentMyAppCodeList(myCurrentAppCodes: NSMutableArray) {
            
            LocalLoadSaveHelperNew.saveObject(object: myCurrentAppCodes, storedName: storeCurrentMyAppCodesName)
        }
        
        /*
        static let storeUserBusinessPartnerSettings : String = "userBusinessPartnerSettings"
        
        static func getUserBusinessPartnerSettingsList() -> NSMutableArray {
            return LocalLoadSaveHelperNew.getNSMutableArray(storedName: storeUserBusinessPartnerSettings)
        }
      */
        
        static func getBusinessPartner(businessPartnerId : String) -> BizPartner?{
            let partners = BizPartners.Local.getBizPartnersDictionary()
        
            for (_, value) in partners {
                let partner : BizPartners.BizPartner = (value as? BizPartners.BizPartner)!
              
                if partner.Id == businessPartnerId {
                    return partner
                }
            }
            
            return nil
        }
    }
    
    class Helper {
        
    }
    
    static func getBizPartners()-> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 1000
        //scanExpression.filterExpression = ""
        //scanExpression.expressionAttributeValues = [":val": userId]
        
        return dynamoDBObjectMapper.scan(BizPartners.BizPartner.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            
            if let error = task.error as NSError? {
               // S3Helper.fileDownloadCollection.removeAll()
                
                //NSLog("Error in getBizPartners")
                print("The request failed. Error: \(error)")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
            } else if let paginatedOutput = task.result {
          
                let bizPartners : NSMutableDictionary = NSMutableDictionary()
                
                BizPartners.Local.saveBizPartnersDictionary(bizPartners: NSMutableDictionary())
                
                //let fileManager = FileManager.default
                
                if (paginatedOutput.items.count > 0){
                    for bizPartner in paginatedOutput.items as! [BizPartners.BizPartner] {
                        bizPartners[bizPartner.Id!] = bizPartner
                       
                        if bizPartner.SmallLogoFileName != "none" {
                            /*
                            let fileUrl = S3Helper.documentsURLForFilename(name: bizPartner.SmallLogoFileName)
                            let bizPartnerImage = UIImage(contentsOfFile: fileUrl.path)
                                          
                            //if !fileManager.fileExists(atPath: fileUrl.path) || bizPartnerImage == nil {
                            if bizPartnerImage == nil {
                                S3Helper.deleteFileIfExistsAlready(filePath: fileUrl.path)
                                S3Helper.fileDownloadCollection.append(S3Helper.createDownloadRequest(fileName: bizPartner.SmallLogoFileName, imageType: S3Helper.ImageType.bizImage))
                            }
                            else {
                                //print("file already exists")
                            }
                            */
                        }
                        
                        if bizPartner.LogoFileName == "add_sq.png" {
                                //print("about to download add")
                        }
                        
                        if bizPartner.LogoFileName != "none" {
                            /*
                            let fileUrl = S3Helper.documentsURLForFilename(name: bizPartner.LogoFileName)
                            
                            let bizPartnerImage = UIImage(contentsOfFile: fileUrl.path)
                                          
                             //if !fileManager.fileExists(atPath: fileUrl.path)
                            if bizPartnerImage == nil {
                                S3Helper.deleteFileIfExistsAlready(filePath: fileUrl.path)
                                S3Helper.fileDownloadCollection.append(S3Helper.createDownloadRequest(fileName: bizPartner.LogoFileName, imageType: S3Helper.ImageType.bizImage))
                            }
                            else {
                                //print("file already exists")
                            }
                            */
                        }
                    }
                    
                    BizPartners.Local.saveBizPartnersDictionary(bizPartners: bizPartners)
                    
                    //NSLog("Got Business Partners.")
                    
                }
                else {
                    //NSLog("No business partners")
                    BizPartners.Local.saveBizPartnersDictionary(bizPartners: NSMutableDictionary())
                }
                
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"BizPartnersLoaded"), object: nil)
            }
            
            return nil
        })
    }
    
    static func setupBusinessPartnersSettingsMenu() { //}-> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        var settingsMenu : [BizPartners.BusinessPartnersSettingsMenu] = [BizPartners.BusinessPartnersSettingsMenu]()
        
        let menu1 : BizPartners.BusinessPartnersSettingsMenu = BizPartners.BusinessPartnersSettingsMenu()
        menu1.Id = "1"
        menu1.Title = "Account Recovery"
        menu1.Description = "Use PROXIMITY to Recover your account for this partner."
        menu1.AllowsPeers = "No"
        settingsMenu.append(menu1)
        
        let menu2 : BizPartners.BusinessPartnersSettingsMenu = BizPartners.BusinessPartnersSettingsMenu()
        menu2.Id = "2"
        menu2.Title = "2 Factor MFA"
        menu2.Description = "Use PROXIMITY to receive access codes from the partner."
        menu2.AllowsPeers = "Yes"
        settingsMenu.append(menu2)
        
        let menu3 : BizPartners.BusinessPartnersSettingsMenu = BizPartners.BusinessPartnersSettingsMenu()
        menu3.Id = "3"
        menu3.Title = "Notify of Suspicous Activity"
        menu3.Description = "You and your selected connections will receive secure warning messages from this partner."
        menu3.AllowsPeers = "No"
        settingsMenu.append(menu3)
        
        let menu4 : BizPartners.BusinessPartnersSettingsMenu = BizPartners.BusinessPartnersSettingsMenu()
        menu4.Id = "4"
        menu4.Title = "One-Time Passcode"
        menu4.Description = "Use PROXIMITY to generate access codes for this parnter. No need for passwords anymore."
        menu4.AllowsPeers = "No"
        settingsMenu.append(menu4)
        
        for setting in settingsMenu {
            dynamoDBObjectMapper.save(setting).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as NSError? {
                    //NSLog("Error in saveUserBizPartner")
                    print("The request failed. Error: \(error)")
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
                } else {
                }
                
                return task
            })
        }
        
        //return AWSTask<AnyObject>()
    }
    
    @objc static func saveBusinessCase(user : User, peerUser : User, businessCase : BusinessPartnerCase, peerMessage : String)-> AWSTask<AnyObject>{
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        if user.Id != nil {
            return dynamoDBObjectMapper.save(businessCase).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as NSError? {
                    //NSLog("Error in saveUser")
                    print("The request failed. Error: \(error)")
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AWSError"), object: nil)
                } else {
                    //now finish
                    _ = Verifications.createAndSaveOpenVerificationForBusinessCaseRequest(user: user, businessPartnerCase: businessCase, peerUser: peerUser, peerMessage: peerMessage)
                    
                }
                
                return task
            })
        }
        else {
            return AWSTask<AnyObject>(result: nil)
        }
    }
}

