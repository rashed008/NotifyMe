//
//  PhoneNumberListViewController.swift
//  NotifyMe
//
//  Created by RASHED on 10/7/22.
//

import UIKit
import CallKit
import UserNotifications

class PhoneNumberListViewController: UIViewController,CXCallObserverDelegate, UNUserNotificationCenterDelegate {
    
    //@IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerNumberTextField: UITextField!
    @IBOutlet weak var addNumberBtn: UIButton!
    
    var callObserver = CXCallObserver()
    var phoneNumberArray = [String]()
    var checkButtonStatus = true
    var number = String()
    
    // Notification center property
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.userNotificationCenter.delegate = self
        self.requestNotificationAuthorization()
    }
    
    func setUpUI() {
        //register tableView Cell
        callObserver.setDelegate(self, queue: nil)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        registerNumberTextField.setLeftPaddingPoints(10)
        registerNumberTextField.getTextFieldComponenets()
        
        addNumberBtn.getButtonComponentsWithCornerRadious()
        phoneNumberArray = Utils.getInsertedPhoneNumber()
        
        backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: 22)
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .sound])
    }
    
    //Button Action
    @IBAction func OnTapAddNumber(_ sender: Any) {
        if (registerNumberTextField.text?.isEmpty ?? true) {
            showAlertMessage(message: "Number field is empty")
        } else {
            phoneNumberArray.append(registerNumberTextField.text ?? "")
            Utils.setInsertedPhoneNumber(id: phoneNumberArray as NSArray)
            self.tableView.reloadData()
            registerNumberTextField.text = ""
        }
        phoneNumberArray = Utils.getInsertedPhoneNumber()
    }
    
    func showAlertMessage(message: String) {
        let alertController = UIAlertController(title:nil,message: message,preferredStyle:.alert)
        self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 3, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    
    
    @IBAction func AddNumber(_ sender: Any) {
        if checkButtonStatus == true {
            UIView.animate(withDuration: 0.7, animations: {
                self.tableView.frame.origin.y = 178
            })
            
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.tableView.frame.origin.y = 110
            })
        }
        checkButtonStatus = !checkButtonStatus
    }
    
    @objc func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            //.. 1. detect a dialing outgoing call
            print("Outgoing call using this \(number)")
            self.sendNotification()
        }
        if call.isOutgoing == true && call.hasConnected == true && call.hasEnded == false {
            //.. 2. outgoing call in process
            print("Outgoing call using this \(number)")
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
        let phoneNumbers: [CXCallDirectoryPhoneNumber] = [ 01627545505, +919899999999 ]
        let labels = [ "Telemarketer", "Local business" ]
        
        for (phoneNumber, label) in zip(phoneNumbers, labels) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
            print("Phone Number \(phoneNumber)")
        }
    }
}

//MARK: TableView
extension PhoneNumberListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneNumberArray.count//Utils.getInsertedPhoneNumber().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.selectionStyle = .none
        cell.phoneNumberLbl.text = phoneNumberArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(phoneNumberArray[indexPath.row])
        number = phoneNumberArray[indexPath.row]
        guard let number = URL(string: "tel://" + number) else { return}
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            phoneNumberArray = Utils.getInsertedPhoneNumber()
            self.phoneNumberArray.remove(at: indexPath.row)
            Utils.setInsertedPhoneNumber(id: phoneNumberArray as NSArray)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


//MARK: Setup local notification
extension PhoneNumberListViewController {
    func requestNotificationAuthorization() {
        // Auth options
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "NotifyMe"
        notificationContent.body = "Outgoing call from this \(number)"
        //notificationContent.badge = NSNumber(value: 3)
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
