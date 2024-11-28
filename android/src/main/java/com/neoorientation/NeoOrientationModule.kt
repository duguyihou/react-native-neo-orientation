package com.neoorientation

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ActivityInfo
import android.hardware.SensorManager
import android.provider.Settings
import android.view.OrientationEventListener
import android.view.Surface
import android.view.WindowManager
import com.facebook.common.logging.FLog
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.common.ReactConstants
import com.facebook.react.modules.core.DeviceEventManagerModule

class NeoOrientationModule(private val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext), NeoOrientationListeners {
    private val mReceiver: BroadcastReceiver
    private val mOrientationListener: OrientationEventListener
    private var isLocking = false
    private var isConfigurationChangeReceiverRegistered = false
    private var lastOrientation = ""
    private var lastDeviceOrientation = ""

    init {
        mOrientationListener =
            object : OrientationEventListener(reactContext, SensorManager.SENSOR_DELAY_UI) {
                override fun onOrientationChanged(p0: Int) {
                    var deviceOrientation = lastDeviceOrientation
                    if (p0 == -1) {
                        deviceOrientation = "unknown"
                    } else if (p0 > 355 || p0 < 5) {
                        deviceOrientation = "portrait"
                    } else if (p0 in 86..94) {
                        deviceOrientation = "landscapeRight"
                    } else if (p0 in 176..184) {
                        deviceOrientation = "portraitUpsideDown"
                    } else if (p0 in 266..274) {
                        deviceOrientation = "landscapeLeft"
                    }
                    if (lastDeviceOrientation != deviceOrientation) {
                        lastDeviceOrientation = deviceOrientation
                        val params = Arguments.createMap()
                        params.putString("deviceOrientation", deviceOrientation)
                        if (reactContext.hasActiveReactInstance()) {
                            reactContext.getJSModule(
                                DeviceEventManagerModule.RCTDeviceEventEmitter::class.java
                            ).emit("deviceOrientationDidChange", params)
                        }
                    }
                    val orientation: String = currentOrientation
                    if (lastOrientation != orientation) {
                        lastOrientation = orientation
                        val params = Arguments.createMap()
                        params.putString("orientation", orientation)
                        if (reactContext.hasActiveReactInstance()) {
                            reactContext.getJSModule(
                                DeviceEventManagerModule.RCTDeviceEventEmitter::class.java
                            ).emit("orientationDidChange", params)
                        }
                    }
                }
            }
        if (mOrientationListener.canDetectOrientation()) {
            mOrientationListener.enable()
        } else {
            mOrientationListener.disable()
        }
        mReceiver = object : BroadcastReceiver() {
            override fun onReceive(p0: Context?, p1: Intent?) {
                val orientation: String = currentOrientation
                lastOrientation = orientation
                val params = Arguments.createMap()
                params.putString("orientation", orientation)
                if (reactContext.hasActiveReactInstance()) {
                    reactContext.getJSModule(
                        DeviceEventManagerModule.RCTDeviceEventEmitter::class.java
                    ).emit("orientationDidChange", params)
                }
            }
        }
        NeoOrientationActivityLifecycle.instance?.registerListeners(this)
    }

    private val currentOrientation: String
        get() {
            val display = (reactApplicationContext.getSystemService(Context.WINDOW_SERVICE) as WindowManager).defaultDisplay
            return when (display.rotation) {
                Surface.ROTATION_0 -> "portrait"
                Surface.ROTATION_90 -> "landscapeLeft"
                Surface.ROTATION_180 -> "portraitUpsideDown"
                Surface.ROTATION_270 -> "landscapeRight"
                else -> "unknown"
            }
        }

    override fun getName(): String {
        return "NeoOrientation"
    }

    @ReactMethod
    fun getOrientation(callback: Callback) {
        val orientation = currentOrientation
        callback.invoke(orientation)
    }

    @ReactMethod
    fun getDeviceOrientation(callback: Callback) {
        callback.invoke(lastDeviceOrientation)
    }

    @ReactMethod
    fun lockToPortrait() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        isLocking = true

        lastOrientation = "portrait"
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }
        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun lockToPortraitUpsideDown() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT
        isLocking = true

        lastOrientation = "portraitUpsideDown"
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }

        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun lockToLandscape() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
        isLocking = true

        // force send an UI orientation event
        lastOrientation = "landscapeLeft"
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }

        // send a locked event
        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun lockToLandscapeLeft() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
        isLocking = true

        // force send an UI orientation event
        lastOrientation = "landscapeLeft"
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }

        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun lockToLandscapeRight() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE
        isLocking = true

        lastOrientation = "landscapeRight"
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }

        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun unlockAllOrientations() {
        val activity = currentActivity ?: return
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
        isLocking = false

        lastOrientation = lastDeviceOrientation
        val params = Arguments.createMap()
        params.putString("orientation", lastOrientation)
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("orientationDidChange", params)
        }

        val lockParams = Arguments.createMap()
        lockParams.putString("orientation", "unknown")
        if (reactContext.hasActiveReactInstance()) {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit("lockDidChange", lockParams)
        }
    }

    @ReactMethod
    fun getAutoRotateState(callback: Callback) {
        val resolver = reactContext.contentResolver
        val rotateLock = Settings.System.getInt(
            resolver,
            Settings.System.ACCELEROMETER_ROTATION, 0
        ) == 1
        callback.invoke(rotateLock)
    }

    override fun getConstants(): Map<String, Any> {
        val constants = HashMap<String, Any>()
        val orientation = currentOrientation
        constants["initialOrientation"] = orientation
        return constants
    }

    override fun start() {
        mOrientationListener.enable()
        val intentFilter = IntentFilter("onConfigurationChanged").apply {
//            addFlags(Intent.FLAG_RECEIVER_REGISTERED_ONLY)
        }

        reactContext.registerReceiver(mReceiver, intentFilter, Context.RECEIVER_NOT_EXPORTED)
        isConfigurationChangeReceiverRegistered = true
    }

    override fun stop() {
        mOrientationListener.disable()
        try {
            if (isConfigurationChangeReceiverRegistered) {
                reactContext.unregisterReceiver(mReceiver)
                isConfigurationChangeReceiverRegistered = false
            }
        } catch (e: Exception) {
            FLog.w(ReactConstants.TAG, "Receiver already unregistered", e)
        }
    }

    override fun release() {
        FLog.d(ReactConstants.TAG, "orientation detect disabled.")
        mOrientationListener.disable()
        val activity = currentActivity ?: return
        try {
            if (isConfigurationChangeReceiverRegistered) {
                activity.unregisterReceiver(mReceiver)
                isConfigurationChangeReceiverRegistered = false
            }
        } catch (e: Exception) {
            FLog.w(ReactConstants.TAG, "Receiver already unregistered", e)
        }
    }

    @ReactMethod
    fun addListener(eventName: String?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    fun removeListeners(count: Int?) {
        // Keep: Required for RN built in Event Emitter Calls.
    }
}