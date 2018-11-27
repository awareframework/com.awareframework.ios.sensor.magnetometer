//
//  com_awareframework_ios_sensor_magnetometer_Tests.swift
//  com.awareframework.ios.sensor.magnetometer_Tests
//
//  Created by Yuuki Nishiyama on 2018/11/27.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import com_awareframework_ios_sensor_magnetometer

class com_awareframework_ios_sensor_magnetometer_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testConfig(){
        let frequency = 1;
        let threshold = 0.5;
        let period    = 5.0;
        let config :Dictionary<String,Any> = ["frequency":frequency, "threshold":threshold, "period":period]
        
        // defualt
        var sensor = MagnetometerSensor.init(MagnetometerSensor.Config());
        XCTAssertEqual(5, sensor.CONFIG.frequency)
        XCTAssertEqual(0, sensor.CONFIG.threshold)
        XCTAssertEqual(1, sensor.CONFIG.period)

        // apply
        sensor = MagnetometerSensor.init(MagnetometerSensor.Config().apply{config in
            config.frequency = frequency
            config.threshold = threshold
            config.period = period
        });
        XCTAssertEqual(frequency, sensor.CONFIG.frequency)
        XCTAssertEqual(threshold, sensor.CONFIG.threshold)
        XCTAssertEqual(period, sensor.CONFIG.period)
        
        // init with config
        sensor = MagnetometerSensor.init(MagnetometerSensor.Config(config))
        XCTAssertEqual(frequency, sensor.CONFIG.frequency)
        XCTAssertEqual(threshold, sensor.CONFIG.threshold)
        XCTAssertEqual(period, sensor.CONFIG.period)
        
        // set 
        sensor = MagnetometerSensor.init()
        sensor.CONFIG.set(config: config)
        XCTAssertEqual(frequency, sensor.CONFIG.frequency)
        XCTAssertEqual(threshold, sensor.CONFIG.threshold)
        XCTAssertEqual(period, sensor.CONFIG.period)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
