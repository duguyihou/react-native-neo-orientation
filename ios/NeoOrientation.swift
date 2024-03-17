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
  private var isLocking = false
  private static var orientationMask: UIInterfaceOrientationMask = .all

  private var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }

  private var orientation: UIInterfaceOrientation? {
    let windowScene = UIApplication.shared.windows.first?.windowScene
    let orientation = windowScene?.interfaceOrientation
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
      let orientationStr = getOrientationStr(orientation)
      callback([orientationStr])
    }
  }

  @objc
  func getDeviceOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation {
      let deviceOrientationStr = self.getDeviceOrientationStr(self.deviceOrientation)
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
      sendEvent(withName: Constants.lockDidChange, body: ["orientation": "landscapeLeft"])
      isLocking = false
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
    let orientationStr = getOrientationStr(orientation)

    return ["initialOrientation": orientationStr]
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
                body: ["orientation" : getOrientationStr(orientation)])
      lastOrientation = orientation
    }

    if !isLocking && deviceOrientation != lastDeviceOrientation {
      sendEvent(withName: Constants.deviceOrientationDidChange,
                body: ["orientation": getDeviceOrientationStr(deviceOrientation)])
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
    sendEvent(withName: Constants.lockDidChange,
              body: ["orientation": getOrientationStr(newOrientation)])
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
