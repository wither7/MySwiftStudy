//
//  ColourChoice.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import Foundation
import SwiftUI

enum ColourChoice: String, CaseIterable, Identifiable {
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case violet

    var id: String { self.rawValue }
}
