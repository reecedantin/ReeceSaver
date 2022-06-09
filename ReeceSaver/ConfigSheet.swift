//
//  ConfigSheet.swift
//  ReeceSaver
//
//  Created by Reece Dantin on 5/4/22.
//

import Cocoa

class ConfigSheet {
    static var sharedInstance = ConfigSheet()

    
    @IBOutlet var mainWindow: NSWindow!
    
    @IBOutlet weak var nameField: NSTextField!
    
    @IBOutlet weak var latField: NSTextField!
    @IBOutlet weak var longField: NSTextField!
    
    @IBOutlet weak var error: NSTextField!
    
    
    init() {
        let bundle = Bundle(for: ConfigSheet.self)
        bundle.loadNibNamed("ConfigSheet", owner: self, topLevelObjects: nil)
        //    twelveHourCheck.state = settings.twelveHourStateForCheckBox()
        
        let defaults = UserDefaults.standard
        nameField.stringValue = defaults.string(forKey: "name") ?? ""
        latField.stringValue = defaults.string(forKey: "lat") ?? ""
        longField.stringValue = defaults.string(forKey: "long") ?? ""
    }

    @IBAction func cancelButton(_ sender: Any) {
        guard let parent = mainWindow.sheetParent else {
            fatalError("Can't get configure sheet parent window")
        }
        parent.endSheet(mainWindow)
        
    }

    @IBAction func okButton(_ sender: Any) {
        if validLat(lat: latField.stringValue) && validLong(long: longField.stringValue) {
            let defaults = UserDefaults.standard
            defaults.set(nameField.stringValue, forKey: "name")
            defaults.set(latField.stringValue, forKey: "lat")
            defaults.set(longField.stringValue, forKey: "long")
            
            
            guard let parent = mainWindow.sheetParent else {
                fatalError("Can't get configure sheet parent window")
            }
            parent.endSheet(mainWindow)
        } else {
            error.isHidden = false
        }
    }
    
    func validLat(lat: String) -> Bool {
        let number = Double(latField.stringValue)
        
        if number == nil {
            return false
        }
        
        if number! > 90 || number! < -90 {
            return false
        }
        
        return true
    }
    
    func validLong(long: String) -> Bool {
        let number = Double(latField.stringValue)
        
        if number == nil {
            return false
        }
        
        if number! > 180 || number! < -180 {
            return false
        }
        
        return true
    }
    
}

