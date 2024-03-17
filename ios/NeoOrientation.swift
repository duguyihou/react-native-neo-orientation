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

  private static var orientationMask: UIInterfaceOrientationMask = .all


  var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }

  var orientation: UIInterfaceOrientation {
    let windowScene = UIApplication.shared.windows.first?.windowScene
    let orientation = windowScene?.interfaceOrientation ?? .unknown
    return orientation
  }


  override init() {
    super.init()
    lastOrientation = orientation
    addListener(Constants.orientationDidChange)
  }

  deinit {
    removeListeners(1)
  }

  func setOrientationMask(_ orientationMask: UIInterfaceOrientationMask) {
    NeoOrientation.orientationMask = orientationMask
  }

  @objc
  static func getOrientationMask() -> UIInterfaceOrientationMask {
    return orientationMask
  }


  @objc
  func getOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation { [self] in
      callback([orientation.toString])
    }
  }

  @objc
  func getDeviceOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation { [self] in
      callback([deviceOrientation.toString])
    }
  }

  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    return ["initialOrientation": orientation.toString]
  }

  override class func requiresMainQueueSetup() -> Bool {
    return true
  }
}


