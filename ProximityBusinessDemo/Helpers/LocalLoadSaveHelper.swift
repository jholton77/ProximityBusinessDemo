//
//  LocalLoadSaveHelper.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//


import Foundation

class LocalLoadSaveHelperNew {
    
    static func getBool(storedName: String) -> Bool {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: storedName) as? Data
            
            if storedData != nil {
                let value : Bool = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!) as! Bool)
                return value
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
    
    static func saveBool(storedName : String, value : Bool) {
        do {
            //may be able to do this better with sending in anyobject
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            let userDefaults : UserDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: storedName)
            userDefaults.synchronize()
        }
        catch {
            print("Error saving: ", storedName)
        }
    }
    
    static func getInt(storedName: String) -> Int {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: storedName) as? Data
            
            if storedData != nil {
                let value : Int = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!) as! Int)
                return value
            }
            else {
                return 0
            }
        }
        catch {
            return 0
        }
    }
    
    static func saveInt(storedName : String, value : Int) {
        do {
            //may be able to do this better with sending in anyobject
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            let userDefaults : UserDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: storedName)
            userDefaults.synchronize()
        }
        catch {
            print("Error saving: ", storedName)
        }
    }
    
    static func getString(storedName: String) -> String {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: storedName) as? Data
            
            if storedData != nil {
                let value : String = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!) as! String)
                return value
            }
            else {
                return ""
            }
        }
        catch {
            return ""
        }
    }
    
    static func saveString(storedName : String, value : String) {
        do {
            //may be able to do this better with sending in anyobject
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            let userDefaults : UserDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: storedName)
            userDefaults.synchronize()
        }
        catch {
            print("Error saving: ", storedName)
        }
    }
    
    static func getNSMutableArray(storedName: String) -> NSMutableArray {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: storedName) as? Data
            
            if storedData != nil {
                let array : NSMutableArray = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!) as! NSMutableArray)
                return array
            }
            else {
                return NSMutableArray()
            }
        }
        catch {
            return NSMutableArray()
        }
    }
  
    static func getNSMutableDictionary(storedName: String) -> NSMutableDictionary {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: storedName) as? Data
            
            if storedData != nil {
                let dict : NSMutableDictionary = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!) as! NSMutableDictionary)
                return dict
            }
            else {
                return NSMutableDictionary()
            }
        }
        catch {
            return NSMutableDictionary()
        }
    }
    
    //static func saveObject(encodedData : Data, storedName: String) {
    static func saveObject(object : Any, storedName: String) {
        do {
            //may be able to do this better with sending in anyobject
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            let userDefaults : UserDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: storedName)
            userDefaults.synchronize()
        }
        catch {
            print("Error saving: ", storedName)
        }
    }
    
    static func getObject(keyName: String) -> Any? {
        let userDefaults : UserDefaults = UserDefaults()
        
        do {
            let storedData = userDefaults.object(forKey: keyName) as? Data
            
            if storedData != nil {
                let object = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData!))
                return object
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    static func saveDataToKeychain(encodedData : Data, keyName: String, groupName: String?) {
        let keychainWrapper : KeychainWrapper = KeychainWrapper.init(service: ProximityApp.storedInfoServiceName, withGroup: groupName)
        
        //let keychainWrapper : KeychainWrapper = KeychainWrapper.init(service: "testService2", withGroup: groupName)
        
        let findData = keychainWrapper.find(keyName)
        
        if findData == nil { //add to keychain
            if keychainWrapper.insert(keyName, encodedData) {
               //print("Added ", keyName, " successfully to keychain.")
            }
            else {
                print("Error adding ", keyName, " to keychain.")
            }
        }
        else { //update
            if keychainWrapper.update(keyName, encodedData) {
                //print("Updated ", keyName, " successfully to keychain.")
            }
            else {
                print("Error updating ", keyName, " to keychain.")
            }
        }
    }
    
    static func getDataFromKeychain(keyName: String, groupName: String?) -> Data? {
        //let test = TestLocalLoadSave.getBoolValue(fromKeychain: keyName)
        
        let keychainWrapper : KeychainWrapper = KeychainWrapper.init(service: ProximityApp.storedInfoServiceName, withGroup: groupName)
        
        //let keychainWrapper : KeychainWrapper = KeychainWrapper.init(service: "testService2", withGroup: groupName)
        
        let findData = keychainWrapper.find(keyName)
        
        if findData == nil { //doesn't exist
            return nil
        }
        else { //update
            return findData
        }
    }
    
    static func setBoolInKeychain(keyName : String, boolValue : Bool, groupName: String?) {
        var boolString : String = "NO"
        
        if boolValue {
            boolString = "YES"
        }
        
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: boolString, requiringSecureCoding: false)
            //let recoveredBoolString : String = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as! String)
            //let recoveredBoolString : String? = String.init(data: encodedData, encoding: String.Encoding.utf8)
            saveDataToKeychain(encodedData: encodedData, keyName: keyName, groupName: groupName)
        }
        catch {
            print("Error saving Bool: ", keyName, " to keychain.")
        }
    }
    
    static func getBoolValueFromKeychain(keyName: String, groupName: String?) -> Bool {
        let data = getDataFromKeychain(keyName: keyName, groupName: groupName)
        
        if data == nil { //doesn't exist
            return true
        }
        else {
            // NSString *boolString = [[NSString alloc] initWithData:findData encoding:NSUTF8StringEncoding];
            var boolString : String? = nil //String.init(data: data!, encoding: String.Encoding.utf8)
            
            do {
                boolString = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? String)
                //print("recoverdString: ", boolString)
            }
            catch {
                print("error")
            }
                
            if (boolString == nil) {
                return false
            }
            else {
                if boolString == "YES" {
                    return true
                }
                else {
                    return false
                }
            }
        }
    }
    
    static func setStringInKeychain(keyName : String, stringValue : String, groupName: String?) {
      
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: stringValue, requiringSecureCoding: false)
            saveDataToKeychain(encodedData: encodedData, keyName: keyName, groupName: groupName)
        }
        catch {
            print("Error saving String: ", keyName, " to keychain.")
        }
    }
    
    static func getStringValueFromKeychain(keyName: String, groupName: String?) -> String {
        let data = getDataFromKeychain(keyName: keyName, groupName: groupName)
        
        if data == nil { //doesn't exist
            return ""
        }
        else {
            // NSString *boolString = [[NSString alloc] initWithData:findData encoding:NSUTF8StringEncoding];
            var stringValue : String? = nil //String.init(data: data!, encoding: String.Encoding.utf8)!
            do {
                stringValue = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? String)
                //print("recoverdString: ", stringValue)
            }
            catch {
                print("error")
            }
            
            if stringValue == nil {
                return ""
            }
            else {
                return stringValue!
            }
        }
    }
}

