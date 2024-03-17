import Foundation

@objc(NeoOrientation)
class NeoOrientation: RCTEventEmitter {
  private var lastOrientation: UIInterfaceOrientation?
  private var lastDeviceOrientation: UIDeviceOrientation?
  private var isLocking: Bool?
  private static var orientationMask: UIInterfaceOrientationMask = .all
  
  private func setOrientation(_ orientationMask: UIInterfaceOrientationMask) {
    NeoOrientation.orientationMask = orientationMask
  }
  
  @objc
  static func getOrientation() -> UIInterfaceOrientationMask {
    return orientationMask
  }
  
  override func supportedEvents() -> [String] {
    return ["orientationDidChange", "deviceOrientationDidChange", "lockDidChange"]
  }
  
  override init() {
    super.init()
    lastOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    lastDeviceOrientation = getDeviceOrientation()
    isLocking = false
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(deviceOrientationDidChange),
                                           name: UIDevice.orientationDidChangeNotification,
                                           object: nil)
    addListener("orientationDidChange")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    removeListeners(1)
  }
  
  
  @objc
  func getOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation {
      var orientation: UIInterfaceOrientation?
      orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
      let orientationStr = self.getOrientationStr(orientation)
      callback([orientationStr])
    }
  }
  
  @objc
  func getDeviceOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation {
      let deviceOrientation = self.getDeviceOrientation()
      let deviceOrientationStr = self.getDeviceOrientationStr(deviceOrientation)
      callback([deviceOrientationStr])
    }
  }
  
  @objc
  func lockToPortrait() {
    OperationQueue.main.addOperation {
      self.lockToOrientation(.portrait, withMask: .portrait)
    }
  }
  
  @objc
  func lockToPortraitUpsideDown() {
    OperationQueue.main.addOperation {
      self.lockToOrientation(.portraitUpsideDown, withMask: .portraitUpsideDown)
    }
  }
  
  @objc
  func lockToLandscape() {
    OperationQueue.main.addOperation { [self] in
      isLocking = true
      let deviceOrientation = lastDeviceOrientation
      var orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
      let orientationStr = getOrientationStr(orientation)
      
      UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
      
      if orientationStr == "landscapeRight" {
        
        setOrientation(.landscape)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
      } else {
        setOrientation(.landscape)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
      }
      
      UIDevice.current.setValue(deviceOrientation, forKey: "orientation")
      UIViewController.attemptRotationToDeviceOrientation()
      sendEvent(withName: "lockDidChange", body: ["orientation": "landscapeLeft"])
      isLocking = false
    }
  }
  
  @objc
  func lockToLandscapeRight() {
    OperationQueue.main.addOperation {
      self.lockToOrientation(.landscapeLeft, withMask: .landscapeLeft)
    }
  }
  
  @objc
  func lockToLandscapeLeft() {
    OperationQueue.main.addOperation {
      self.lockToOrientation(.landscapeRight, withMask: .landscapeRight)
    }
  }
  
  @objc
  func unlockAllOrientations() {
    OperationQueue.main.addOperation {
      self.lockToOrientation(.unknown, withMask: .all)
    }
  }
  
  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    let orientationStr = getOrientationStr(orientation)
    
    return ["initialOrientation": orientationStr]
  }
  
  override class func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension NeoOrientation {
  private func getDeviceOrientation() -> UIDeviceOrientation {
    return UIDevice.current.orientation
  }
  
  @objc
  private func deviceOrientationDidChange() {
    let windowScene = UIApplication.shared.windows.first?.windowScene
    let orientation = windowScene?.interfaceOrientation
    let deviceOrientation = getDeviceOrientation()
    guard deviceOrientation != .unknown else { return }
    
    if orientation != .unknown && orientation != lastOrientation {
      sendEvent(withName: "orientationDidChange", body: ["orientation" : getOrientationStr(orientation)])
      lastOrientation = orientation
    }
    
    if !isLocking! && deviceOrientation != lastDeviceOrientation {
      sendEvent(withName: "deviceOrientationDidChange", body: ["orientation": getDeviceOrientationStr(deviceOrientation)])
      lastDeviceOrientation = deviceOrientation
    }
  }
  private func lockToOrientation(_ newOrientation: UIInterfaceOrientation, withMask mask: UIInterfaceOrientationMask) {
    isLocking = true
    setOrientation(mask)
    let currentDevice = UIDevice.current
    //    currentDevice.setValue(UIInterfaceOrientation.unknown, forKey: "orientation")
    currentDevice.setValue(newOrientation, forKey: "orientation")
    
    if #available(iOS 16.0, *) {
      let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
      windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    } else {
      UIViewController.attemptRotationToDeviceOrientation()
    }
    sendEvent(withName: "lockDidChange", body: ["orientation": getOrientationStr(newOrientation)])
    isLocking = false
  }
  
  private func getOrientationStr(_ orientation: UIInterfaceOrientation?) -> String {
    switch orientation {
    case .portrait:
      return "portrait"
    case .landscapeLeft:
      return "landscapeLeft"
    case .landscapeRight:
      return "landscapeRight"
    case .portraitUpsideDown:
      return "portraitUpsideDown"
    default:
      return "unknown"
    }
  }
  
  private func getDeviceOrientationStr(_ orientation: UIDeviceOrientation?) -> String {
    switch orientation {
    case .portrait:
      return "portrait"
    case .landscapeLeft:
      return "landscapeLeft"
    case .landscapeRight:
      return "landscapeRight"
    case .portraitUpsideDown:
      return "portraitUpsideDown"
    case .faceUp:
      return "faceUp"
    case .faceDown:
      return "faceDown"
    default:
      return "unknown"
    }
  }
}
