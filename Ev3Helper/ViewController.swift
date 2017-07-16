//
//  ViewController.swift
//  Ev3Helper
//
//  Created by colin3dmax on 2017/7/15.
//  Copyright © 2017年 colin3dmax. All rights reserved.
//

import UIKit
import ExternalAccessory

class ViewController: UIViewController {
    var connection:Ev3Connection?
    var ev3Brick:Ev3Brick?
    var manager = EAAccessoryManager.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: .EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: .EAAccessoryDidDisconnect, object: nil)
        EAAccessoryManager.shared().registerForLocalNotifications()
        
    }
    
    
    @objc private func accessoryConnected(notification:NSNotification){
        print("EAController::accessoryConnected")
        let connectedAccessory = notification.userInfo![EAAccessoryKey] as! EAAccessory
        
        //检查设备是否为EV3
        if !Ev3Connection.supportsEv3Protocol(accessory: connectedAccessory) {
            return
        }
        
        connect(accessory: connectedAccessory)
    
    }
    
    @objc private func accessoryDisconnected(notification:NSNotification){
        print("EAController::accessoryDisconnected")
        let connectedAccessory = notification.userInfo![EAAccessoryKey] as! EAAccessory
        
        //检查设备是否为EV3
        
        if !Ev3Connection.supportsEv3Protocol(accessory: connectedAccessory) {
            return
        }
        
        disconnect()
        
    }
    
    private func getEv3Accessory() -> EAAccessory? {
        let man = EAAccessoryManager.shared()
        let connected = man.connectedAccessories
        
        for tmpAccessory in connected {
            if Ev3Connection.supportsEv3Protocol(accessory: tmpAccessory) {
                return tmpAccessory
            }
        }
        return nil
    }
    
    @IBOutlet weak var linkToState: UILabel!
    @IBOutlet weak var linkToButton: UIButton!
    private func connect(accessory:EAAccessory){
        connection = Ev3Connection(accessory: accessory)
        ev3Brick = Ev3Brick(connection: connection!)
        connection?.open()
        print("成功连接Ev3")
        linkToState.text = "连接Ev3成功"
        
    }
    
    private func disconnect(){
        connection?.close()
        print("关闭Ev3连接")
        linkToState.text =  "断开Ev3成功"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLinkToEv3(_ sender: Any) {
        if(connection==nil || (connection?.isClosed)!){
            linkToState.text =  "Ev3蓝牙连接中..."
            EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil) { (error) in
                if let error = error {
                    print(error)
                    self.linkToState.text =  "Ev3 Link Error"
                }
            }
        }
    }
    
    @IBAction func didPressDownTouchUp(_ sender: Any) {
        print("didTouchUp")
//        ev3Brick?.directCommand.turnMotorAtSpeedForTime(ports: [.B], speed: -20, milliseconds: 1000, brake: false)
        ev3Brick?.directCommand.turnMotorAtPower(onPorts: [.B], withPower: -20)
    }
    
    @IBAction func didPressUpTouchUp(_ sender: Any) {
        print("didTouchUp")
        ev3Brick?.directCommand.stopMotor(onPorts: [.B], withBrake: true)
    }
    
    @IBAction func didPressDownTouchDown(_ sender: Any) {
        print("didTouchDown")
        ev3Brick?.directCommand.turnMotorAtPower(onPorts: [.B], withPower: 20)
    }
    
    @IBAction func didPressUpTouchDown(_ sender: Any) {
        print("didTouchDown")
        ev3Brick?.directCommand.stopMotor(onPorts: [.B], withBrake: true)
    }
    
    @IBAction func didPressDownTouchLeft(_ sender: Any) {
        print("didTouchLeft")
        ev3Brick?.directCommand.turnMotorAtPower(onPorts: [.C], withPower: -20)
    }
    @IBAction func didPressUpTouchLeft(_ sender: Any) {
        print("didTouchLeft")
        ev3Brick?.directCommand.stopMotor(onPorts: [.C], withBrake: true)
    }
    
    @IBAction func didPressDownTouchRight(_ sender: Any) {
        print("didTouchRight")
        ev3Brick?.directCommand.turnMotorAtPower(onPorts: [.C], withPower: 20)
    }
    @IBAction func didPressUpTouchRight(_ sender: Any) {
        print("didTouchRight")
        ev3Brick?.directCommand.stopMotor(onPorts: [.C], withBrake: true)
    }
    
    
    @IBAction func didPressDownTouchOpen(_ sender: Any) {
        print("didTouchOpen")
        
        ev3Brick?.directCommand.turnMotorAtSpeedForTime(ports: [.A], speed: 20, milliseconds: 1000, brake: false)
    }
    
    @IBAction func didPressUpTouchOpen(_ sender: Any) {
        print("didTouchOpen")
        
        ev3Brick?.directCommand.stopMotor(onPorts: [.A], withBrake: true)
    }
    
    @IBAction func didPressDownTouchClose(_ sender: Any) {
        print("didTouchClose")
        ev3Brick?.directCommand.turnMotorAtSpeedForTime(ports: [.A], speed: -20, milliseconds: 1000, brake: false)
        
    }
    @IBAction func didPressUpTouchClose(_ sender: Any) {
        print("didTouchClose")
        ev3Brick?.directCommand.stopMotor(onPorts: [.A], withBrake: true)
        
    }
    
}

