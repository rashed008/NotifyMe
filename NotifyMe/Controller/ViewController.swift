//
//  ViewController.swift
//  NotifyMe
//
//  Created by RASHED on 10/6/22.
//

import UIKit
import CallKit

class ViewController: UIViewController,CXCallObserverDelegate {
    
    var callObserver = CXCallObserver()
    
    var number = "+8801670938907"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        testTest()
    }
    
    func testTest() {
        //Only for test
    }
    
    func setUP() {
        callObserver.setDelegate(self, queue: nil)
    }
    
    @IBAction func onTapMakeCall(_ sender: Any) {
        guard let number = URL(string: "tel://" + number ) else { return}
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @objc func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            //.. 1. detect a dialing outgoing call
            print("Outgoing call using this \(number)")
        }
        if call.isOutgoing == true && call.hasConnected == true && call.hasEnded == false {
            //.. 2. outgoing call in process
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            //.. 3. incoming call ringing (not answered)
        }
        if call.isOutgoing == false && call.hasConnected == true && call.hasEnded == false {
            //.. 4. incoming call in process
            print("Incoming call are comming from this \(number)")
        }
        if call.isOutgoing == true && call.hasEnded == true {
            //.. 5. outgoing call ended.
        }
        if call.isOutgoing == false && call.hasEnded == true {
            //.. 6. incoming call ended.
        }
        if call.hasConnected == true && call.hasEnded == false && call.isOnHold == false {
            //.. 7. call connected (either outgoing or incoming)
        }
        if call.isOutgoing == true && call.isOnHold == true {
            //.. 8. outgoing call is on hold
        }
        if call.isOutgoing == false && call.isOnHold == true {
            //.. 9. incoming call is on hold
        }
    }
    
    private func addIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) throws {
           let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 18775555555, +919899999999 ]
           let labels = [ "Telemarketer", "Local business" ]

           for (phoneNumber, label) in zip(phoneNumbers, labels) {
               context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
           }
       }
}

