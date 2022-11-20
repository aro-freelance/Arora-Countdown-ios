//
//  ViewController.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import UIKit
import RealmSwift
import AVFoundation

class MainViewController: UITableViewController {
    
    /*
     Notification Reference Guide: https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
     */
    
    
    
    @IBOutlet var tableview: UITableView!
    
    let realm = try! Realm()
    
    //results is an autoupdating Realm datatype
    var countdownList : Results<Countdown>?
    
    var timer = Timer()
    var timerList = [String]()
    
    //list of the id numbers find in countdown list to handle completion or countdown (incase two finish at once)
    var handleCompletionList = [Int]()
    
    
    // this VC will be the home screen. tableview of timers.  button to add more timers takes you to the add counter VC.

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = 120

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        timer.invalidate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //load countdowns to the tableview
        load()
        
        //make timer list
        buildTimerList()
        //run update per tick the first time
        updatePerTick()
        
        //update per tick
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePerTick), userInfo: nil, repeats: true)
        
        
    }
    
    
    
   
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        if let storyBoard : UIStoryboard = self.storyboard{
            let addCountdownVC = storyBoard.instantiateViewController(withIdentifier: "AddCountdownVC") as! AddCounterViewController
            self.present(addCountdownVC, animated:true, completion:nil)
        }
        
    }
    
    
    //load data for the request input or use the default value Item.fetchRequest
    func load(){
        
        countdownList = realm.objects(Countdown.self)

        tableView.reloadData()
        
    }
    
    func buildTimerList(){
        
        for countdown in countdownList!{
            
            let now = Date()
            let calendar = Calendar.current
            //convert date stored in countdown to datecomponents
            let timer = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now, to: countdown.countdownDate)

            var timerString = ""
            
            if(timer.year ?? 0 > 0){
                timerString.append("Years: \(timer.year ?? 0)  ")
            }
            if(timer.month ?? 0 > 0){
                timerString.append("Months: \(timer.month ?? 0)  ")
            }
            if(timer.day ?? 0 > 0){
                timerString.append("Days: \(timer.day ?? 0)  ")
            }
            if(timer.hour ?? 0 > 0){
                timerString.append("Hours: \(timer.hour ?? 0)  ")
            }
            if(timer.minute ?? 0 > 0){
                //under 5 minutes but above 1
                if(timer.minute ?? 0 < 5){
                    timerString.append("Minutes: \(timer.minute ?? 0)  ")
                    timerString.append("Seconds: \(timer.second ?? 0)")
                }
                //more than 5 minutes
                else{
                    timerString.append("Minutes: \(timer.minute ?? 0)")
                }
            }
            //less than 1 minute but more than 0 seconds
            else if (timer.second ?? 0 > 0){
                timerString.append("Seconds: \(timer.second ?? 0)")
                //timerString.append("Less than 1 minute remaining")
            }
            
            
            if(timerString == ""){
                
                if(!countdown.isDone){
                    
                    handleCompletionList.append(countdown.id)
                    
                }
            
                timerString = "Complete"
            }
            
            
            timerList.append(timerString)
            
        }
        
        tableview.reloadData()
        
    }
    
    @objc func updatePerTick(){
        
        timerList.removeAll()
        
        //update the table with new timer information each tick
        buildTimerList()
        
        for id in handleCompletionList{ handleCountdownEnd(id) }
        
    }
    
    func handleCountdownEnd(_ id: Int){
        
        for countdown in countdownList!{
         
            if(countdown.id == id){
                
                if(countdown.notificationOn){
                    AudioServicesPlaySystemSound(1005)
                }
                
                do{
                    try realm.write {
            
                        countdown.isDone = true
                        
                        self.realm.add(countdown)
                        
                        print("update countdown to done")
                        
                    }
                } catch {
                    print("Error updating Countdown: \(error)")
                }
                
                // Create new Alert
                var dialogMessage = UIAlertController(title: "Countdown Complete", message: "\(countdown.title) countdown has completed.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                
                if(!handleCompletionList.isEmpty){
                    handleCompletionList.removeFirst()
                }
                
                
                
            }
        
        }
        
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countdownList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: make a custom cell that displays title + timer info cleaner
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath)
        
        if let countdown = countdownList?[indexPath.row] {
            
            let timer = timerList[indexPath.row]
            
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 10
            
            cell.textLabel?.text = "\(countdown.title) \n\n\(timer)"
            
            //Ternary Operator
            //value = condition ? valueTrue : valueFalse
            
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgView.image = UIImage(systemName: "bell.circle")!
            cell.accessoryView = countdown.notificationOn ? imgView : .none
            
            
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
            destinationVC.isEdit = true
        }
        
    }


}

