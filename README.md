# Aware Magnetometer

[![CI Status](https://img.shields.io/travis/awareframework/com.awareframework.ios.sensor.magnetometer.svg?style=flat)](https://travis-ci.org/awareframework/com.awareframework.ios.sensor.magnetometer)
[![Version](https://img.shields.io/cocoapods/v/com.awareframework.ios.sensor.magnetometer.svg?style=flat)](https://cocoapods.org/pods/com.awareframework.ios.sensor.magnetometer)
[![License](https://img.shields.io/cocoapods/l/com.awareframework.ios.sensor.magnetometer.svg?style=flat)](https://cocoapods.org/pods/com.awareframework.ios.sensor.magnetometer)
[![Platform](https://img.shields.io/cocoapods/p/com.awareframework.ios.sensor.magnetometer.svg?style=flat)](https://cocoapods.org/pods/com.awareframework.ios.sensor.magnetometer)

## Requirements
iOS 10 or later 

## Installation

com.aware.ios.sensor.magnetometer is available through [CocoaPods](https://cocoapods.org). 

1. To install it, simply add the following line to your Podfile:
```ruby
pod 'com.aware.ios.sensor.magnetometer'
```

2. Import com.aware.ios.sensor.magnetometer library into your source code.
```swift
import com_aware_ios_sensor_magnetometer
```

## Public functions
### MagnetometerSensor

+ `init(config:MagnetometerSensor.Config?)` : Initializes the magnetometer sensor with the optional configuration.
+ `start()`: Starts the gyroscope sensor with the optional configuration.
+ `stop()`: Stops the service.

### MagnetometerSensor.Config

Class to hold the configuration of the sensor.

#### Fields
+ `sensorObserver: MagnetometerObserver`: Callback for live data updates.
+ `frequency: Int`: Data samples to collect per second (Hz). (default = 5)
+ `period: Double`: Period to save data in minutes. (default = 1)
+ `threshold: Double`: If set, do not record consecutive points if change in value is less than the set value.
+ `enabled: Boolean` Sensor is enabled or not. (default = `false`)
+ `debug: Boolean` enable/disable logging to Xcode console. (default = `false`)
+ `label: String` Label for the data. (default = "")
+ `deviceId: String` Id of the device that will be associated with the events and the sensor. (default = "")
+ `dbEncryptionKey` Encryption key for the database. (default = `null`)
+ `dbType: Engine` Which db engine to use for saving data. (default = `Engine.DatabaseType.NONE`)
+ `dbPath: String` Path of the database. (default = "aware_gyroscope")
+ `dbHost: String` Host for syncing the database. (default = `null`)

## Broadcasts

### Fired Broadcasts

+ `MagnetometerSensor.ACTION_AWARE_GYROSCOPE` fired when gyroscope saved data to db after the period ends.

### Received Broadcasts

+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_START`: received broadcast to start the sensor.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_STOP`: received broadcast to stop the sensor.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SYNC`: received broadcast to send sync attempt to the host.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SET_LABEL`: received broadcast to set the data label. Label is expected in the `MagnetometerSensor.EXTRA_LABEL` field of the intent extras.

## Data Representations

### Magnetometer Data

Contains the raw sensor data.

| Field     | Type   | Description                                                     |
| --------- | ------ | --------------------------------------------------------------- |
| x         | Double  | value of X axis                                                 |
| y         | Double  | value of Y axis                                                 |
| z         | Double  | value of Z axis                                                 |
| label     | String | Customizable label. Useful for data calibration or traceability |
| deviceId  | String | AWARE device UUID                                               |
| label     | String | Customizable label. Useful for data calibration or traceability |
| timestamp | Int64   | unixtime milliseconds since 1970                                |
| timezone  | Int    | Raw timezone offset of the device                          |
| os        | String | Operating system of the device (ex. ios)                    |


## Example usage
```swift
var magnetometer = MagnetometerSensor.init( MagnetometerSensor.Config().apply{ config in
    config.debug = true
    config.sensorObserver = Observer()
})
magnetometer?.start()
```

```swift
class Observer:MagnetometerObserver {
    func onDataChanged(data:MagnetometerData){
        // Your code here..
    }
}
```

## Author

Yuuki Nishiyama, tetujin@ht.sfc.keio.ac.jp

## License

Copyright (c) 2018 AWARE Mobile Context Instrumentation Middleware/Framework (http://www.awareframework.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

