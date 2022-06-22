//
//  UserDefaultsService.swift
//  FileManager
//
//  Created by Alex on 22.06.22.
//

import Foundation

class UserDefaultsService {
    private init() { }
    
    static let shared = UserDefaultsService()
    
    func saveSegmentControl(segmentControlIndex: Int) {
        UserDefaults.standard.set(segmentControlIndex, forKey: UserDefaultsKey.indexOfDisplayMode.rawValue)
        
        switch UserDefaults.standard.string(forKey: UserDefaultsKey.displayMode.rawValue) {
        case "Table":
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.tableViewSegment.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.collectionViewSegment.rawValue)
        case "Collection":
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.collectionViewSegment.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.tableViewSegment.rawValue)
        default:
            return
        }
    }
}

enum UserDefaultsKey: String {
    case indexOfDisplayMode
    case displayMode
    case tableViewSegment
    case collectionViewSegment
}
