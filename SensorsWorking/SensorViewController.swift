//
//  ViewController.swift
//  SensorsWorking
//
//  Created by Abhishek Bhardwaj on 13/10/23.
//

import UIKit
import CoreMotion
class SensorViewController: UIViewController {
    
    @IBOutlet weak var gyroX: UILabel!
    @IBOutlet weak var gyroY: UILabel!
    @IBOutlet weak var gyroZ: UILabel!
    @IBOutlet weak var accelX: UILabel!
    @IBOutlet weak var accelY: UILabel!
    @IBOutlet weak var accelZ: UILabel!
    @IBOutlet weak var gravityX: UILabel!
    @IBOutlet weak var gravityY: UILabel!
    @IBOutlet weak var gravityZ: UILabel!
    
    var motionManager = CMMotionManager()
    var isDeviceMoving = false
    var updateCount = 0
    var maxFrequency = 10
    var accelFactor = 1
    var gravityFactor = 1
    var gyroFactor = 1
    let gravityConversion = 9.81
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMotionUpdates()
    }
    
    func setupMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = 0.5
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { (data, error) in
            if let deviceMotion = data {
                self.processDeviceMotionData(deviceMotion)
            }
        }
    }
    
    func processDeviceMotionData(_ deviceMotion: CMDeviceMotion) {
        // Detect device movement based on roll and pitch angles
        let attitude = deviceMotion.attitude
        let roll = attitude.roll
        let pitch = attitude.pitch
        
        if abs(roll) > 0.1 || abs(pitch) > 0.1 {
            isDeviceMoving = true
        } else {
            isDeviceMoving = false
        }
        
        // Update gyro and acceleration values based on the factors
        updateSensorValues(deviceMotion)
        
        // Display gravity data separately
        let gravityData = deviceMotion.gravity
        gravityX.text = "\(gravityData.x)"
        gravityY.text = "\(gravityData.y)"
        gravityZ.text = "\(gravityData.z)"
    }
    
    func updateSensorValues(_ deviceMotion: CMDeviceMotion) {
        if accelFactor > 0 && updateCount % accelFactor == 0 {
            if isDeviceMoving {
                let userAcceleration = deviceMotion.userAcceleration
                accelX.text = "\(userAcceleration.x * gravityConversion)"
                accelY.text = "\(userAcceleration.y * gravityConversion)"
                accelZ.text = "\(userAcceleration.z * gravityConversion)"
            } else {
                accelX.text = "0.0"
                accelY.text = "0.0"
                accelZ.text = "0.0"
            }
        }
        
        if gyroFactor > 0 && updateCount % gyroFactor == 0 {
            if isDeviceMoving {
                let gyroData = deviceMotion.rotationRate
                gyroX.text = "\(gyroData.x)"
                gyroY.text = "\(gyroData.y)"
                gyroZ.text = "\(gyroData.z)"
            } else {
                gyroX.text = "0.0"
                gyroY.text = "0.0"
                gyroZ.text = "0.0"
            }
        }
        
        if updateCount == maxFrequency {
            updateCount = 0
        }
    }
}

