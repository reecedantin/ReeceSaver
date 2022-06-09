//
//  SaverView.swift
//  ReeceSaver
//
//  Created by Reece Dantin on 5/4/22.
//

import ScreenSaver
import Foundation
import SwiftUI


class SaverView: ScreenSaverView {
    
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {

        super.init(frame: frame, isPreview: isPreview)
        
        let screens = NSScreen.screens
        let primaryScreen = screens[0]
        let secondScreen = screens[1]
        
        if (frame.origin.x == primaryScreen.frame.origin.x) {
            let webView = NSHostingView(rootView: ClockView())
            self.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        if (frame.origin.x == secondScreen.frame.origin.x) {
            let webView = NSHostingView(rootView: WeatherView())
            self.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        // Update the "state" of the screensaver in this function
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        let configureSheet = ConfigSheet.sharedInstance
        return configureSheet.mainWindow
    }
}
