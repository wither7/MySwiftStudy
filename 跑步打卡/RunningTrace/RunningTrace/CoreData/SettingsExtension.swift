//
//  SettingsExtension.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import Foundation
import CoreData

extension UserSetting{
    
    var colourChoiceConverted: ColourChoice {
            set {
                color = newValue.rawValue
            }
            get {
                ColourChoice(rawValue: color ?? "Blue") ?? .blue
            }
    }
}
