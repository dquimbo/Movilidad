//
//  Utilities.swift
//  Movilidad
//
//  Created by Diego Quimbo on 17/1/22.
//

import Foundation

public struct Utilities {
    
    public static func formatMinutesSeconds(value: Int) -> String {
        let s = (value % 3600) % 60
        return s > 9 ? "00:\(s)" : "00:0\(s)"
    }
    
    public static func getSttingsPlistData() -> [String: Any]? {
        let fullPath = getInternalSettingPlistPath()
        
        // If the internal settings file doesn't exist, take the file saved locally and copy it
        if (!FileManager.default.fileExists(atPath: fullPath.path)) {
            if let bundlePath = getBundleSettingPlistPath() {
                do{
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: fullPath.path)
                }catch{
                    print("Settings.plist copy failure.")
                }
            }
        }
        
        guard let settingsPlist = NSMutableDictionary(contentsOfFile: fullPath.path) as? [String: Any] else {
            return nil
        }

        return settingsPlist
    }
    
    public static func formatDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        
        return dateFormatter.string(from: date)
    }
}

private extension Utilities {
    static func getBundleSettingPlistPath() -> String? {
        return Bundle.main.path(forResource: "Settings", ofType: "plist")
    }
    
    static func getInternalSettingPlistPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Settings.plist")
    }
}
