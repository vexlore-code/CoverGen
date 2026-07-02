import Flutter
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentPickerDelegate {
  private var pendingResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.covergen/pdf_picker",
                                      binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "pickPdf" {
        self?.pendingResult = result
        self?.presentDocumentPicker(controller: controller)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func presentDocumentPicker(controller: UIViewController) {
    let documentPicker: UIDocumentPickerViewController
    if #available(iOS 14.0, *) {
      documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
    } else {
      documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
    }
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = false
    controller.present(documentPicker, animated: true, completion: nil)
  }

  // MARK: - UIDocumentPickerDelegate
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let selectedURL = urls.first else {
      pendingResult?(nil)
      pendingResult = nil
      return
    }
    
    // For safety, copy the file to the temporary directory
    let tempDir = FileManager.default.temporaryDirectory
    let destURL = tempDir.appendingPathComponent("picked_pdf_\(Int(Date().timeIntervalSince1970)).pdf")
    
    do {
      if FileManager.default.fileExists(atPath: destURL.path) {
        try FileManager.default.removeItem(at: destURL)
      }
      try FileManager.default.copyItem(at: selectedURL, to: destURL)
      pendingResult?(destURL.path)
    } catch {
      pendingResult?(selectedURL.path) // Fallback to original URL path if copy fails
    }
    pendingResult = nil
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pendingResult?(nil)
    pendingResult = nil
  }
}
