import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Request microphone permission
    let audioSession = AVAudioSession.sharedInstance()
    audioSession.requestRecordPermission { granted in
        if granted {
            print("Microphone permission granted.")
        } else {
            print("Microphone permission denied.")
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}