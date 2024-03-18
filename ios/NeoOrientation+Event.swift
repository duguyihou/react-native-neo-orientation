extension NeoOrientation {
  override func startObserving() {
    super.startObserving()
    hasListeners = true
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(deviceOrientationDidChange),
                   name: UIDevice.orientationDidChangeNotification,
                   object: nil)
  }
  
  override func stopObserving() {
    super.stopObserving()
    hasListeners = false
    NotificationCenter.default.removeObserver(self)
  }
  
  override func supportedEvents() -> [String] {
    return [
      Constants.orientationDidChange,
      Constants.deviceOrientationDidChange,
      Constants.lockDidChange
    ]
  }
  
  @objc
  private func deviceOrientationDidChange() {
    if !hasListeners { return }
    guard deviceOrientation != .unknown else { return }
    if orientation != .unknown && orientation != lastOrientation {
      sendEvent(withName: Constants.orientationDidChange,
                body: ["orientation" : orientation.toString])
      lastOrientation = orientation
    }
    
    sendEvent(withName: Constants.deviceOrientationDidChange,
              body: ["deviceOrientation": deviceOrientation.toString])
  }
}
