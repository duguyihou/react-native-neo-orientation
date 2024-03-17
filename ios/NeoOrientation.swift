import Foundation

@objc(NeoOrientation)
class NeoOrientation: RCTEventEmitter {
  struct Constants {
    static var orientationDidChange = "orientationDidChange"
    static var deviceOrientationDidChange = "deviceOrientationDidChange"
    static var lockDidChange = "lockDidChange"
  }
  var lastOrientation: UIInterfaceOrientation?
  let lock: os_unfair_lock_t = .allocate(capacity: 1)

  static var orientationMask: UIInterfaceOrientationMask = .all

  var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }

  var orientation: UIInterfaceOrientation {
    let windowScene = UIApplication.shared.windows.first?.windowScene
    let orientation = windowScene?.interfaceOrientation ?? .unknown
    return orientation
  }

  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    return ["initialOrientation": orientation.toString]
  }

  override class func requiresMainQueueSetup() -> Bool {
    return true
  }
}


