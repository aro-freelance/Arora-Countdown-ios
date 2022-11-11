//
//  ViewController.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    
    
    @IBOutlet var tableview: UITableView!
    
    
    let realm = try! Realm()
    
    //results is an autoupdating Realm datatype
    var countdownList : Results<Countdown>?
    
    //TODO: initialize a sound controller
    
    
    
    
    //TODO: look up how to access the background/notifications of ios device.  Equivalent to Service in Android. Then use that to implement the MyService file in my android project. This is to be used to run a timer in the background and compare it to the endtimes on the list of Countdowns. When the time passes, give the user a notification.
    
    // this VC will be the home screen. tableview of timers.  button to add more timers takes you to the add counter VC.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotificationChannel()
        
        //TODO: build sound for notification?
        
        //TODO: update per tick and check if finished by comparing dates
        
        storeNotificationList()
        
        print("view did load. list count \(countdownList?.count ?? 0)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("view will appear. list count \(countdownList?.count ?? 0)")
        
        tableview.reloadData()
        
    }
    
    func createNotificationChannel(){
        
        //TODO: create a background service for notifications
        
    }
    
    func storeNotificationList(){
        
        var numberWithNotifications = 0
        
        //TODO: for each countdown in the list, if notifications or on for it, store information about it, incrementing the number to mark each item in the list
        //this will be retrieved by the Service which runs inthe BG and checks if the timer is ended, and then gives the user a notification
        
        
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        if let storyBoard : UIStoryboard = self.storyboard{
            let addCountdownVC = storyBoard.instantiateViewController(withIdentifier: "AddCountdownVC") as! AddCounterViewController
            self.present(addCountdownVC, animated:true, completion:nil)
        }
        
    }
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countdownList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath)
        
        if let countdown = countdownList?[indexPath.row] {
        
            cell.textLabel?.text = countdown.title
        
        //Ternary Operator
        //value = condition ? valueTrue : valueFalse
        
            cell.accessoryType = countdown.notificationOn ? .detailButton : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        performSegue(withIdentifier: "goToAddCountdown", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AddCounterViewController
        
        if let indexPath = tableview.indexPathForSelectedRow {
            destinationVC.countdown = countdownList?[indexPath.row] ?? Countdown()
        }
        
    }


}

