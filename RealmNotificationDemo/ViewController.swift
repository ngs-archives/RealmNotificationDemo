//
//  ViewController.swift
//  RealmNotificationDemo
//
//  Created by Atsushi Nagase on 6/2/16.
//  Copyright © 2016 LittleApps Inc. All rights reserved.
//

import UIKit
import RealmSwift

class TestObject: Object {
    dynamic var value: Double = 0.0
    dynamic var key: String = "onlyme"

    override static func primaryKey() -> String {
        return "key"
    }
}

class ViewController: UIViewController {

    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    var realm: Realm!
    var results: Results<TestObject>!
    var notificationToken: NotificationToken?

    deinit {
        notificationToken?.stop()
        notificationToken = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
        results = realm.objects(TestObject)
        notificationToken = results.addNotificationBlock { _ in
            print("Notified!")
        }
        valueLabel.text = stepper.value.description

    }

    @IBAction func stepperValueChange(sender: AnyObject!) {
        valueLabel.text = stepper.value.description
    }

    @IBAction func saveButtonClick(sender: AnyObject!) {
        realm.beginWrite()
        if let obj = realm.objectForPrimaryKey(TestObject.self, key: "onlyme") {
            obj.value = stepper.value
        } else {
            let obj = TestObject()
            obj.key = "onlyme"
            obj.value = stepper.value
            realm.add(obj)
        }
        try! realm.commitWrite()
    }

}

