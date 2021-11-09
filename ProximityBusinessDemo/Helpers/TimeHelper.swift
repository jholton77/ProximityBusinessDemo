//
//  TimeHelper.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/2/21.
//


import Foundation

class TimeHelper {
    
    static func currentUTC() -> String {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let timestamp = dateFormatter.string(from: date)
        
        let dt = dateFormatter.date(from: timestamp)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let utcTimestamp = dateFormatter.string(from: dt!)
        
        return utcTimestamp
    }

    static func UTCToLocalDescriptive(timestamp:String) -> String {
        if timestamp != "none" && timestamp != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let dt = dateFormatter.date(from: timestamp)
            dateFormatter.timeZone = TimeZone.current
            
            //make this Tuesday, June 10, 2020 11:11:11 AM"
            dateFormatter.dateFormat = "MMMM d, yyyy HH:mm:ss a" //"yyyy-MM-dd HH:mm:ss"

            let localTimestamp = dateFormatter.string(from: dt!)
            
            return localTimestamp
        }
        else {
            return ""
        }
    }
    
    static func UTCToLocalShort(timestamp:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: timestamp)
        dateFormatter.timeZone = TimeZone.current
        
        //make this Tuesday, June 10, 2020 11:11:11 AM"
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss a" //"yyyy-MM-dd HH:mm:ss"

        let localTimestamp = dateFormatter.string(from: dt!)
        
        return localTimestamp
    }
    
    static func addMinutesToTime(dateTime : String, minutes : Int) -> String {
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        //dateFormatter.timeZone = TimeZone.current
        //let timestamp = dateFormatter.string(from: date)
        
        let startTimestamp = dateFormatter.date(from: dateTime)
       
  
        let newTimestamp = calendar.date(byAdding: .minute, value: minutes, to: startTimestamp!)
        
        return dateFormatter.string(from: newTimestamp!)
    }
    
    static func checkIfExpired(timestamp : String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
   
        let dateTimestamp = dateFormatter.date(from: timestamp)
        let currentTimestamp = dateFormatter.date(from: currentUTC())
    
        if currentTimestamp! > dateTimestamp! {
            return true
        }
        else {
            return false
        }
    }
    
    static func createUniqueRecoredIdUsingUtcTimestamp(phone : String) -> String {
        let recordId : String = currentUTC() + phone
        
        return recordId
    }
}

