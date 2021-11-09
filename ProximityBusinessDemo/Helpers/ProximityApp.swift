//
//  ProximityApp.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//

import Foundation

@objc class ProximityApp : NSObject {

    @objc static let storedInfoServiceName : String = "proximitybusinessdemo.appInfo"
    
    class Local : NSObject {
        static let storedIsProductionName : String = "isProduction"

        static func setIsProduction(isProduction : Bool) {
            
            if isProduction {
                LocalLoadSaveHelperNew.setStringInKeychain(keyName : storedIsProductionName, stringValue : "true", groupName: nil)
            }
            else {
                LocalLoadSaveHelperNew.setStringInKeychain(keyName : storedIsProductionName, stringValue : "false", groupName: nil)
            }
            
            //let isProduction2 = LocalLoadSaveHelperNew.getStringValueFromKeychain(keyName: storedIsProductionName)
        }

        static func getIsProduction() -> Bool {
            let isProduction = LocalLoadSaveHelperNew.getStringValueFromKeychain(keyName: storedIsProductionName, groupName: nil)
            
            if isProduction == "true" {
                return true
            }
            else {
                return false
            }
        }
    }
}
