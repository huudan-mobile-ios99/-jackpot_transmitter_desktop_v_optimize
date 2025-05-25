import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame

    // Configure window properties
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)

    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    flutterViewController.backgroundColor = .clear

    // 💡 Important: remove shadow and focus ring
    self.hasShadow = false
    flutterViewController.view.focusRingType = .none

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
