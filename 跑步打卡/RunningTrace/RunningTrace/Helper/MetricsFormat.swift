//
//  MetricsFormat.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/11.
//

import Foundation
import CoreLocation
import SwiftUI

// Class to format metrics throughout the history and cycle tabs
class MetricsFormat {
    static func formatDate(date: Date) -> String {
            
//        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "MMMM dd, yyyy"
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return(dateFormatter.string(from: date))
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium)
    }
    
    static func formatStartTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "h:mm a"
        return(dateFormatter.string(from: date))
    }
    
    static func formatDistance(distance: CLLocationDistance, usingMetric: Bool) -> String {
        let distanceKilometres = round(100 * distance/1000)/100
        let distanceMiles = round(100 * (0.621371 * distance/1000))/100
        let distanceUnits = usingMetric ? "km" : "mi"
        let distanceString = "\(usingMetric ? distanceKilometres : distanceMiles) " + distanceUnits
        return distanceString
    }
    
    static func formatTime(time: TimeInterval) -> String {
        var timeString = ""
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if (hours > 0) {
            timeString = "\(hours)h"
        }
        if (minutes > 0) {
            timeString = timeString + " \(minutes)m"
        }
        if (seconds > 0 || timeString == "") {
            timeString = timeString + " \(seconds)s"
        }
        return timeString
    }
    
    //时间(s)转配速
    static func formatPaceTime(time: TimeInterval) -> String {
        var timeString = ""
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
     
        timeString = " \(minutes)' \(seconds)\" "
        
        return timeString
    }
    
    
    //计算平均速度
    static func formatAverageSpeed( distance: CLLocationDistance, time: TimeInterval, usingPace: Bool) -> String {
       
        if (time <= 0 || distance <= 0 ) {
            return usingPace ? "00'00''" : "0.0 m/s"
        }
        let speedMetresPerSecond = distance/time
        
        if(!usingPace){
           
            let tmp =  String(format: "%.1f", speedMetresPerSecond)
            return "\(tmp)m/s"
        }
        //计算配速
        let sec : Double = 1000.0 / speedMetresPerSecond
        
        return formatPaceTime(time: sec)
    }
    
    static func formatElevation(elevations: [CLLocationDistance], usingMetric: Bool) -> String {
        var elevationGain: CLLocationDistance = 0.0
        let elevationUnits = usingMetric ? "m" : "ft"
        
        for index in 0..<elevations.count {
            if (index > 0) {
                if (elevations[index] > elevations[index-1]) {
                    elevationGain += elevations[index] - elevations[index-1]
                }
            }
        }
        
        let elevationMetres = round(100 * elevationGain)/100
        let elevationFeet = round(100 * (3.28084 * elevationGain))/100
        let elevationString = "\(usingMetric ? elevationMetres : elevationFeet) " + elevationUnits
        return elevationString
    }
    
    static func formatTopSpeed(speeds: [CLLocationSpeed], usingMetric: Bool) -> String {
        let topSpeed = speeds.max() ?? 0.0
        
        let speedUnits = usingMetric ? "km/h" : "mph"
        let speedKMH = round(100 * (3.6 * topSpeed))/100
        let speedMPH = round(100 * (2.23694 * topSpeed))/100
        let speedString = "\(usingMetric ? speedKMH : speedMPH) " + speedUnits
        return speedString
    }
    
    // Used in the statistics tab for the average speed record
    static func formatSingleSpeed(speed: CLLocationSpeed, usingMetric: Bool) -> String {
        let speedUnits = usingMetric ? "km/h" : "mph"
        let speedKMH = round(100 * (3.6 * speed))/100
        let speedMPH = round(100 * (2.23694 * speed))/100
        let speedString = "\(usingMetric ? speedKMH : speedMPH) " + speedUnits
        return speedString
    }
    
    static func formatDistanceWithoutUnits(distance: CLLocationDistance, usingMetric: Bool) -> String {
        let distanceKilometres = round(100 * distance/1000)/100
        let distanceMiles = round(100 * (0.621371 * distance/1000))/100
        let distanceString = "\(usingMetric ? distanceKilometres : distanceMiles)"
        return distanceString
    }
    
    static func getDistanceUnits(usingMetric: Bool) -> String {
        return usingMetric ? "km" : "mi"
    }
    
    static func formatSpeedWithoutUnits(speed: CLLocationSpeed, usingPace: Bool) -> String {
        //speed 默认单位是 m/s
        if (speed < 0) {
            return "0.0"
        }
        
        let speedString = "\(speed)"
        return speedString
    }
    
    static func getSpeedUnits(usingMetric: Bool) -> String {
        return usingMetric ? "km/h" : "mph"
    }
    
    static func formatElevationWithoutUnits(elevation: CLLocationDistance, usingMetric: Bool) -> String {
        let elevationMetres = round(100 * elevation)/100
        let elevationFeet = round(100 * (3.28084 * elevation))/100
        let elevationString = "\(usingMetric ? elevationMetres : elevationFeet)"
        return elevationString
    }
    
    static func getElevationUnits(usingMetric: Bool) -> String {
        return usingMetric ? "m" : "ft"
    }
    
    static func convertColourChoiceToUIColor(colour: ColourChoice) -> UIColor {
           switch colour {
           case .red:
               return UIColor.systemRed
           case .orange:
               return UIColor.systemOrange
           case .yellow:
               return UIColor.systemYellow
           case .green:
               return UIColor.systemGreen
           case .blue:
               return UIColor.systemBlue
           case .indigo:
               return UIColor.systemIndigo
           case .violet:
               return UIColor.systemPurple
           }
       }
}

