//
//  AddCounterViewController.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import UIKit
import RealmSwift


//this VC is for letting the user set up and save a new counter

class AddCounterViewController: UIViewController{
    
    //TODO: fix close keyboard issue
    
    
    @IBOutlet weak var bellImage: UIImageView!
    
    @IBOutlet weak var countdownTitle: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var slider: UISwitch!
    
    var isEdit : Bool = false
    
    var countdownId = -99
    
    var countdown : Countdown = Countdown()
    
    var isNotificationOn : Bool = true
    
    let realm = try! Realm()
    
    var wasNotificationOn : Bool = false
    
    //results is an autoupdating Realm datatype
    var countdownList : Results<Countdown>?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countdownTitle.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        
        deleteButton.isHidden = true
        
        
        load()
        
        if(isEdit){
            
            confirmButton.setTitle("Update", for: .normal)
            confirmButton.setTitle("Update", for: .focused)
            confirmButton.setTitle("Update", for: .highlighted)
            
            deleteButton.isHidden = false
            
            countdownTitle.text = countdown.title
            datePicker.setDate(countdown.countdownDate, animated: true)
            slider.setOn(countdown.notificationOn, animated: true)
            wasNotificationOn = countdown.notificationOn
            
            
        }
        

    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
    } 
    
    
    @IBAction func sliderChanged(_ sender: UISwitch) {
        
        if sender.isOn{
            isNotificationOn = true
            
        }else{
            
            isNotificationOn = false
            
        }
    }
    
    
    
    
    @IBAction func datePicker(_ sender: Any) {
        
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        //get user input
        
        let input : String = countdownTitle.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let countdownDate : Date = datePicker.date
    
        
        //save new countdown
        if(!isEdit){
            do{
                try realm.write {
                    //build a countdown
                    
                    countdown.id = countdownList?.count ?? 0
                    countdown.title = input
                    countdown.countdownDate = countdownDate
                    countdown.notificationOn = isNotificationOn
                    countdown.isDone = false
                    
                    self.realm.add(countdown)
                    
                    print("save. list count \(self.countdownList?.count ?? 0)")
                    
                }
            } catch {
                print("Error Adding Countdown: \(error)")
            }
        }
        else{
            
            //if we are saving an edit, and there was a previous notification, remove it
            if(wasNotificationOn){
                clearNotification()
            }
            
            do{
                try realm.write {
                    
                    //build a countdown
                    countdown.title = input
                    countdown.countdownDate = countdownDate
                    countdown.notificationOn = isNotificationOn
                    countdown.isDone = false
                    
                    self.realm.add(countdown)
                    
                    print("save. list count \(self.countdownList?.count ?? 0)")
                    
                }
            } catch {
                print("Error Adding Countdown: \(error)")
            }
            
        }
        
        //add notification if it is on
        if(countdown.notificationOn){
            handleNotification()
        }
        
        //performSegue(withIdentifier: "goToMain", sender: self)
        //self.dismiss(animated: false, completion: nil)
        let targetVC = navigationController?.viewControllers.first(where: {$0 is MainViewController})
        if let targetVC = targetVC {
           navigationController?.popToViewController(targetVC, animated: true)
        }
        
    }
 
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        //TODO: get confirmation from user before running the delete functionality
        
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.delete()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func delete(){
        //if we are saving an edit, and there was a previous notification, remove it
        if(wasNotificationOn){
            clearNotification()
        }
        
        //delete countdown
        do{
            try realm.write {
                
                self.realm.delete(self.countdown)
                
                print("save. list count \(self.countdownList?.count ?? 0)")
            }
        } catch {
            print("Error delete Countdown: \(error)")
        }
        
        
        let targetVC = navigationController?.viewControllers.first(where: {$0 is MainViewController})
        if let targetVC = targetVC {
           navigationController?.popToViewController(targetVC, animated: true)
        }
    }
    
    //load data for the request input or use the default value Item.fetchRequest
    func load(){
        
        countdownList = realm.objects(Countdown.self)

        
    }
    
    
    func handleNotification(){
        
        print("handle notification method ping.")
        
        //set up the message to show
        let content = UNMutableNotificationContent()
        content.title = "Arora Countdown"
        content.body = "\(countdown.title) timer completed."
        
        //convert date stored in countdown to datecomponents
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: countdown.countdownDate)
        
        //make a request object
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false)
        
        let identifier = "AroraCountdown\(countdown.id)"
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        //add the request to the notification center
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
               print("Error handling notification. \(error)")
           }
        }
        
    }
    
    func clearNotification(){
        
        print("clear notification method ping.")
        
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = "AroraCountdown\(countdown.id)"
        let identifiers = [identifier]
        //delete notification by identifier
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        
    }
    
}


