# AWARE: Magnetometer

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

This sensor module allows us to access the current **Magnetic Fluid** data. The data is provided by CMDeviceMotion in Core Motion library. Please check the link below for details.

[ Apple | Getting Processed Device-Motion Data ](https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data)

[ Apple | CMDeviceMotion | CMCalibratedMagneticField ](https://developer.apple.com/documentation/coremotion/cmdevicemotion/1616140-magneticfield)

## Requirements
iOS 13 or later

## Installation

1. Open Package Manager Windows
    * Open `Xcode` -> Select `Menu Bar` -> `File` -> `App Package Dependencies...`

2. Find the package using the manager
    * Select `Search Package URL` and type `https://github.com/awareframework/com.awareframework.ios.sensor.magnetometer.git`

3. Import the package into your target.

4. Import com.awareframework.ios.sensor.magnetometer library into your source code.
```swift
import com_awareframework_ios_sensor_magnetometer
```

## Public Functions
### MagnetometerSensor

+ `init(config:MagnetometerSensor.Config?)`: Initializes the magnetometer sensor with the optional configuration.
+ `start()`: Starts the magnetometer sensor with the optional configuration.
+ `stop()`: Stops the service.

### MagnetometerSensor.Config

Class to hold the configuration of the sensor.

#### Fields

+ `sensorObserver: MagnetometerObserver`: Callback for live data updates.
+ `samplingFrequencyHz: Int`: Data samples to collect per second (Hz). (default = `5`)
+ `saveIntervalSeconds: Double`: Interval in seconds at which buffered data is saved to the database. (default = `60`)
+ `threshold: Double`: If set, do not record consecutive points if change in value is less than the set value.
+ `enabled: Bool`: Sensor is enabled or not. (default = `false`)
+ `debug: Bool`: Enable/disable logging. (default = `false`)
+ `label: String`: Label for the data. (default = `""`)
+ `deviceId: String`: Id of the device that will be associated with the events and the sensor. (default = `""`)
+ `dbEncryptionKey: String?`: Encryption key for the database. (default = `nil`)
+ `dbType: DatabaseType`: Which db engine to use for saving data. (default = `.none`)
+ `dbPath: String`: Path of the database. (default = `"aware_magnetometer"`)
+ `dbHost: String?`: Host for syncing the database. (default = `nil`)

## Broadcasts

### Fired Broadcasts

+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER`: fired when magnetometer saved data to db after the save interval ends.

### Received Broadcasts

+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_START`: received broadcast to start the sensor.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_STOP`: received broadcast to stop the sensor.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SYNC`: received broadcast to send sync attempt to the host.
+ `MagnetometerSensor.ACTION_AWARE_MAGNETOMETER_SET_LABEL`: received broadcast to set the data label. Label is expected in the `MagnetometerSensor.EXTRA_LABEL` field of the intent extras.

## Data Representations

### Magnetometer Data

Contains the raw sensor data.

| Field          | Type   | Description                                                     |
| -------------- | ------ | --------------------------------------------------------------- |
| x              | Double | value of X axis (µT)                                            |
| y              | Double | value of Y axis (µT)                                            |
| z              | Double | value of Z axis (µT)                                            |
| eventTimestamp | Int64  | Unixtime milliseconds of the actual sensor event                |
| accuracy       | Int    | Accuracy of the sensor data                                     |
| label          | String | Customizable label. Useful for data calibration or traceability |
| deviceId       | String | AWARE device UUID                                               |
| timestamp      | Int64  | unixtime milliseconds since 1970                                |
| timezone       | Int    | Raw timezone offset of the device                               |
| os             | String | Operating system of the device (ex. ios)                        |
| jsonVersion    | Int    | JSON schema version                                             |

## Example Usage
```swift
var magnetometer = MagnetometerSensor.init( MagnetometerSensor.Config().apply { config in
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

Yuuki Nishiyama (The University of Tokyo), nishiyama@csis.u-tokyo.ac.jp

## License

Copyright (c) 2025 AWARE Mobile Context Instrumentation Middleware/Framework (http://www.awareframework.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

