//
//  MagnetometerSensor.swift
//  com.aware.ios.sensor.magnetometer
//
//  Created by Yuuki Nishiyama on 2018/10/30.
//

import UIKit
import CoreMotion
import SwiftyJSON
import com_awareframework_ios_sensor_core

extension Notification.Name{
    public static let actionAwareMagnetometer      = Notification.Name(MagnetometerSensor.ACTION_AWARE_MAGNETOMETER)
    public static let actionAwareMagnetometerStart = Notification.Name(MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_START)
    public static let actionAwareMagnetometerStop  = Notification.Name(MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_STOP)
    public static let actionAwareMagnetometerSetLabel = Notification.Name(MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SET_LABEL)
    public static let actionAwareMagnetometerSync  = Notification.Name(MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SYNC)
}

public protocol MagnetometerObserver{
    func onChanged(data:MagnetometerData)
}

extension MagnetometerSensor{
    public static var TAG = "AWARE::Magnetometer"
    
    public static var ACTION_AWARE_MAGNETOMETER = "ACTION_AWARE_MAGNETOMETER"
    
    public static var ACTION_AWARE_MAGNETOMETER_START = "com.awareframework.android.sensor.magnetometer.SENSOR_START"
    public static var ACTION_AWARE_MAGNETOMETER_STOP = "com.awareframework.android.sensor.magnetometer.SENSOR_STOP"
    
    public static var ACTION_AWARE_MAGNETOMETER_SET_LABEL = "com.awareframework.android.sensor.magnetometer.ACTION_AWARE_MAGNETOMETER_SET_LABEL"
    public static var EXTRA_LABEL = "label"
    
    public static var ACTION_AWARE_MAGNETOMETER_SYNC = "com.awareframework.android.sensor.magnetometer.SENSOR_SYNC"
}

public class MagnetometerSensor: AwareSensor {
    var CONFIG = Config()
    var motion = CMMotionManager()
    var LAST_DATA:CMMagneticField?
    var LAST_TS:Double   = 0.0
    var LAST_SAVE:Double = 0.0
    public var dataBuffer = Array<MagnetometerData>()
    
    public class Config:SensorConfig{
        /**
         * For real-time observation of the sensor data collection.
         */
        public var sensorObserver: MagnetometerObserver? = nil
        
        /**
         * Magnetometer interval in hertz per second: e.g.
         *
         * 0 - fastest
         * 1 - sample per second
         * 5 - sample per second
         * 20 - sample per second
         */
        public var interval: Int = 5
        
        /**
         * Period to save data in minutes. (optional)
         */
        public var period: Double = 1
        
        /**
         * Magnetometer threshold (float).  Do not record consecutive points if
         * change in value is less than the set value.
         */
        public var threshold: Double = 0.0
    
        public override init(){}
        
        public init(_ json:JSON){
            
        }
        
        public func apply(closure:(_ config: MagnetometerSensor.Config) -> Void) -> Self {
            closure(self)
            return self
        }
    }
    
    override convenience init(){
        self.init(MagnetometerSensor.Config())
    }
    
    public init(_ config:MagnetometerSensor.Config){
        super.init()
        self.CONFIG = config
        self.initializeDbEngine(config: config)
        if config.debug{ print(MagnetometerSensor.TAG, "Magnetometer sensor is created. ") }
    }
    
    public override func start() {
        if self.motion.isMagnetometerAvailable && !self.motion.isMagnetometerActive{
            self.motion.magnetometerUpdateInterval = 1.0/Double(CONFIG.interval)
            self.motion.startMagnetometerUpdates(to: .main) { (magnetometerData, error) in
                if let magData = magnetometerData {
                    let x = magData.magneticField.x
                    let y = magData.magneticField.y
                    let z = magData.magneticField.z
                    if let lastData = self.LAST_DATA {
                        if self.CONFIG.threshold > 0 &&
                            abs(x - lastData.x) < self.CONFIG.threshold &&
                            abs(y - lastData.y) < self.CONFIG.threshold &&
                            abs(z - lastData.z) < self.CONFIG.threshold {
                            return
                        }
                    }
                    self.LAST_DATA = magData.magneticField
                    
                    let currentTime:Double = Date().timeIntervalSince1970
                    self.LAST_TS = currentTime
                    
                    let data = MagnetometerData()
                    data.timestamp = Int64(currentTime*1000)
                    data.x = magData.magneticField.x
                    data.y = magData.magneticField.y
                    data.z = magData.magneticField.z
                    data.eventTimestamp = Int64(magData.timestamp*1000)
                    
                    if let observer = self.CONFIG.sensorObserver {
                        observer.onChanged(data: data)
                    }
                    
                    self.dataBuffer.append(data)
                    
                    if currentTime > self.LAST_SAVE + (self.CONFIG.period * 60) {
                        return
                    }
                    
                    let dataArray = Array(self.dataBuffer)
                    self.dbEngine?.save(dataArray, MagnetometerData.TABLE_NAME)
                    self.notificationCenter.post(name: .actionAwareMagnetometer, object: nil)
                    
                    self.dataBuffer.removeAll()
                    self.LAST_SAVE = currentTime
                }
            }
            self.notificationCenter.post(name: .actionAwareMagnetometerStart, object: nil)
        }
    }
    
    public override func stop() {
        if motion.isMagnetometerAvailable && motion.isMagnetometerActive {
            motion.stopMagnetometerUpdates()
            self.notificationCenter.post(name: .actionAwareMagnetometerStop, object: nil)
        }
    }
    
    public override func sync(force: Bool = false) {
        if let engine = self.dbEngine{
            engine.startSync(MagnetometerData.TABLE_NAME, DbSyncConfig.init().apply(closure: { config in
                config.debug = self.CONFIG.debug
            }))
            self.notificationCenter.post(name: .actionAwareMagnetometerSync, object: nil)
        }
    }
}
