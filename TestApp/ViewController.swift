//
//  ViewController.swift
//  TestApp
//
//  Created by Reece Dantin on 6/3/22.
//

import Cocoa
import ScreenSaver
import SwiftUI

class ViewController: NSViewController {

    // MARK: - Properties
       private var saver: ScreenSaverView?
//       private var timer: Timer?

       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           let containerView: NSView! = view
           let demoView = NSHostingView(rootView: ClockView())
           containerView.addSubview(demoView)
           demoView.translatesAutoresizingMaskIntoConstraints = false
           demoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
           demoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
           demoView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
           demoView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
       }

       deinit {
//           timer?.invalidate()
       }

       // MARK: - Helper Functions
       private func addScreensaver() {
           if let saver = SaverView(frame: view.frame, isPreview: false) {
               view.addSubview(saver)
               
               self.saver = saver
           }
       }

}

