import Foundation

@objc(NeoOrientation)
class NeoOrientation: RCTEventEmitter {
  private struct Constants {
    static var orientationDidChange = "orientationDidChange"
    static var deviceOrientationDidChange = "deviceOrientationDidChange"
    static var lockDidChange = "lockDidChange"
  }
  private var lastOrientation: UIInterfaceOrientation?
  private var lastDeviceOrientation: UIDeviceOrientation?
  private let lock: os_unfair_lock_t = .allocate(capacity: 1)
  private static var orientationMask: UIInterfaceOrientationMask = .all
  
  private var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }
  
  private var orientation: UIInterfaceOrientation {
    let windowScene = UIApplication.shared.windows.first?.windowScene
    let orientation = windowScene?.interfaceOrientation ?? .unknown
    return orientation
  }
  
  private func setOrientation(_ orientationMask: UIInterfaceOrientationMask) {
    NeoOrientation.orientationMask = orientationMask
  }
  
  @objc
  static func getOrientation() -> UIInterfaceOrientationMask {
    return orientationMask
  }
  
  override func supportedEvents() -> [String] {
    return [
      Constants.orientationDidChange,
      Constants.deviceOrientationDidChange,
      Constants.lockDidChange
    ]
  }
  
  override init() {
    super.init()
    lastOrientation = orientation
    lastDeviceOrientation = deviceOrientation
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(deviceOrientationDidChange),
                                           name: UIDevice.orientationDidChangeNotification,
                                           object: nil)
    addListener(Constants.orientationDidChange)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    removeListeners(1)
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
  func lockToPortrait() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.portrait, withMask: .portrait)
    }
  }
  
  @objc
  func lockToPortraitUpsideDown() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.portraitUpsideDown, withMask: .portraitUpsideDown)
    }
  }
  
  @objc
  func lockToLandscape() {
    withLock {
      OperationQueue.main.addOperation { [self] in
        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue,
                                  forKey: "orientation")
        
        let landscape = orientation == .landscapeRight ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.landscapeRight.rawValue
        setOrientation(.landscape)
        UIDevice.current.setValue(landscape, forKey: "orientation")
        
        UIViewController.attemptRotationToDeviceOrientation()
        sendEvent(withName: Constants.lockDidChange,
                  body: ["orientation": "landscapeLeft"])
      }
      
    }
  }
  
  @objc
  func lockToLandscapeRight() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.landscapeLeft, withMask: .landscapeLeft)
    }
  }
  
  @objc
  func lockToLandscapeLeft() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.landscapeRight, withMask: .landscapeRight)
    }
  }
  
  @objc
  func unlockAllOrientations() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.unknown, withMask: .all)
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

extension NeoOrientation {
  @objc
  private func deviceOrientationDidChange() {
    guard deviceOrientation != .unknown else { return }
    
    if orientation != .unknown && orientation != lastOrientation {
      sendEvent(withName: Constants.orientationDidChange,
                body: ["orientation" : orientation.toString])
      lastOrientation = orientation
    }
    
    if deviceOrientation != lastDeviceOrientation {
      sendEvent(withName: Constants.deviceOrientationDidChange,
                body: ["orientation": deviceOrientation.toString])
      lastDeviceOrientation = deviceOrientation
    }
  }
  private func lockToOrientation(_ newOrientation: UIInterfaceOrientation, withMask mask: UIInterfaceOrientationMask) {
    withLock {
      setOrientation(mask)
      let currentDevice = UIDevice.current
      currentDevice.setValue(newOrientation, forKey: "orientation")
      
      if #available(iOS 16.0, *) {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
        windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
      } else {
        UIViewController.attemptRotationToDeviceOrientation()
      }
      sendEvent(withName: Constants.lockDidChange,
                body: ["orientation": newOrientation.toString])
    }
  }
  
  private func withLock<T>(_ closure: () -> T) -> T {
    os_unfair_lock_lock(lock)
    defer { os_unfair_lock_unlock(lock) }
    return closure()
  }
}

