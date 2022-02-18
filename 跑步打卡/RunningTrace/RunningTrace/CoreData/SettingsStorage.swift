//
//  SettingsStorage.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import Foundation
import CoreData

class SettingsStorage: NSObject, ObservableObject {
    @Published var storedSettings: [UserSetting] = []
    private let preferencesController: NSFetchedResultsController<UserSetting>

    init(managedObjectContext: NSManagedObjectContext) {
        let request: NSFetchRequest<UserSetting> = UserSetting.fetchRequest()
        request.sortDescriptors = []
        
        preferencesController = NSFetchedResultsController(fetchRequest: request,
        managedObjectContext: managedObjectContext,
        sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        preferencesController.delegate = self

        do {
            try preferencesController.performFetch()
            
            if (preferencesController.fetchedObjects?.count ?? 0 < 1) {
                //默认设置
                let defaultPreferences = UserSetting(context: managedObjectContext)
                defaultPreferences.color = "Blue"
                defaultPreferences.usingPace = true
                defaultPreferences.deleteEnabed = false
                defaultPreferences.usingBestLocation = true
                defaultPreferences.drawingMap = true
              
                storedSettings = [defaultPreferences]
            }
            else {
                storedSettings = preferencesController.fetchedObjects!
            }
        } catch {
            print("Failed to fetch items!")
        }
    }
}

extension SettingsStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let savedPreferences = controller.fetchedObjects as? [UserSetting]
        else { return }

        storedSettings = savedPreferences
    }
}
