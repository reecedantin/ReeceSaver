# ReeceSaver - SwiftUI MacOS ScreenSaver Example for 2022

I couldn't find any good examples of a modern Mac screensaver using SwiftUI, so I built my own custom screensaver. It also includes a ConfigureSheet that allows you to set custom values.

This screensaver is meant for 2 displays, one to show a random welcome message with your name (32 possible) and date and time.

The other display takes your GPS coordinates from the settings and displays the current weather from weather.gov.

This project also includes a TestApp that allows you to debug the screensaver. You will need to set the frame size on the view to display properly.

Once you have the screensaver working, build the project with the ScreenSaver target and navigate to the Build Folder (Xcode 13: Product > Show Build Folder in Finder). Navigate to Produts > Release and then double click ReeceSaver.saver to install. If you are making rapid changes, you may need to clean the build folder, delete the screensaver from settings, quit settings, and build again (configure sheet doesn't always update).

