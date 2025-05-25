import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)

    if let window = NSApplication.shared.windows.first {
      // Make the window transparent
      window.isOpaque = false
      window.backgroundColor = NSColor.clear

      // Hide window title bar elements
      window.titleVisibility = .hidden
      window.titlebarAppearsTransparent = true
      window.styleMask.insert(.fullSizeContentView)

      // Optional: Make the window not resizable
      window.styleMask.remove(.resizable)

      // Optional: Allow dragging by background
      window.isMovableByWindowBackground = true

      // Optional: Keep window always on top
      window.level = .floating

      // Optional: Remove drop shadow
      window.hasShadow = false

      // Optional: Remove focus ring (yellow border)
      if let contentVC = window.contentViewController {
        contentVC.view.focusRingType = .none
      }
    }
  }
}
