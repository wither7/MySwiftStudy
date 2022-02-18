////
////  RecordListViewModel.swift
////  RunningTrace
////
////  Created by 袁新杰 on 2021/12/12.
////
//
//import Foundation
//import SwiftUI
//import CoreData
//
//class BikeRideListViewModel: ObservableObject {
//
//    init() {
//        let valid = validateCategory(name: currentName)
//        if (valid == false) {
//            currentName = ""
//        }
//    }
//
//    // This is the default ordering
//    func sortByDateDescending() {
//        bikeRides = BikeRide.sortByDate(list: bikeRides, ascending: false)
//        currentSortChoice = .dateDescending
//    }
//
//    func sortByDateAscending() {
//        bikeRides = BikeRide.sortByDate(list: bikeRides, ascending: true)
//        currentSortChoice = .dateAscending
//    }
//
//}
