//
//  ViewController.swift
//  Lenses
//
//  Created by Jeremy Kelleher on 7/19/16.
//  Copyright © 2016 JKProductions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lowKey: UILabel!
    var notification : UILocalNotification?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let contactdays = UserDefaults.standard.integer(forKey: "contactsCount")
        lowKey.text = String(contactdays == 0 ? 1 : contactdays)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification = dailyNotification()
        
        if !UserDefaults.standard.bool(forKey: "notifFiring") {
            UIApplication.shared().scheduleLocalNotification(notification!)
            UserDefaults.standard.set(true, forKey: "notifFiring")
        }
    }

    @IBAction func contactsPressed(_ sender: AnyObject) {
        let contactDays = Int(lowKey.text!)
        if contactDays >= 14 {
            lowKey.text = "1"
            UserDefaults.standard.set(1, forKey: "contactsCount")
        } else {
            lowKey.text = String(contactDays! + 1)
            UserDefaults.standard.set(contactDays! + 1, forKey: "contactsCount")
        }
        
    }

    
    func dailyNotification() -> UILocalNotification {
        let category = UIMutableUserNotificationCategory()
        let notification = UILocalNotification()
        
        let glasses = UIMutableUserNotificationAction()
        glasses.identifier = "glasses"
        glasses.isDestructive = false
        glasses.title = "👓"
        glasses.activationMode = UIUserNotificationActivationMode.background
        glasses.isAuthenticationRequired = false
        
        let contacts = UIMutableUserNotificationAction()
        contacts.identifier = "contacts"
        contacts.isDestructive = false
        contacts.title = "👀"
        contacts.activationMode = UIUserNotificationActivationMode.background
        contacts.isAuthenticationRequired = false
        
        category.identifier = "questionOfTheDay"
        category.setActions([contacts,glasses], for: .minimal)
        category.setActions([contacts,glasses], for: .default)
        
        let categories = Set(arrayLiteral: category)
        let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: categories)
        UIApplication.shared().registerUserNotificationSettings(settings)
        
        notification.category = "questionOfTheDay"
        
        let fireDate = DateComponents(hour: 10, minute: 00)
        notification.fireDate = Calendar.current.date(from: fireDate)
        notification.repeatInterval = Calendar.Unit.day
        
        notification.alertTitle = "Optometrist Here!"
        notification.alertBody = "What are you using today?"
        
        return notification
    }
    
    func updateConcacts() {
        lowKey.text = String(UserDefaults.standard.integer(forKey: "contactsCount"))
    }

}

