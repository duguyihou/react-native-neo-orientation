extension UIDeviceOrientation {
  var toString: String {
    switch self {
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
