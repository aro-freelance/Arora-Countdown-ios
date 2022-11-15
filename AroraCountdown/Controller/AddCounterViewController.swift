//
//  AddCounterViewController.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import UIKit
import RealmSwift


//this VC is for letting the user set up and save a new counter

class AddCounterViewController: UIViewController {
    
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
    
    //results is an autoupdating Realm datatype
    var countdownList : Results<Countdown>?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            
        }
        
        
        //TODO: for the edittext ( countdownTitle ) when enter is pressed close the softkeyboard and trim any extra space at the end.
        

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
                    
                    self.realm.add(countdown)
                    
                    print("save. list count \(self.countdownList?.count ?? 0)")
                    
                }
            } catch {
                print("Error Adding Countdown: \(error)")
            }
        }
        else{
            
            do{
                try realm.write {
                    
                    //build a countdown
                    countdown.title = input
                    countdown.countdownDate = countdownDate
                    countdown.notificationOn = isNotificationOn
                    
                    self.realm.add(countdown)
                    
                    print("save. list count \(self.countdownList?.count ?? 0)")
                    
                }
            } catch {
                print("Error Adding Countdown: \(error)")
            }
            
        }
        
        
        //performSegue(withIdentifier: "goToMain", sender: self)
        //self.dismiss(animated: false, completion: nil)
        let targetVC = navigationController?.viewControllers.first(where: {$0 is MainViewController})
        if let targetVC = targetVC {
           navigationController?.popToViewController(targetVC, animated: true)
        }
        
    }
    
    

//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let destinationVC = segue.destination as! MainViewController
//
//        destinationVC.tableview.reloadData()
//
//        print("prepare list size: \(destinationVC.countdownList?.count)")
//
//    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        //TODO: get confirmation from user before running the delete functionality
        
        //delete countdown
        do{
            try realm.write {
                
                self.realm.delete(self.countdown)
                
                print("save. list count \(self.countdownList?.count ?? 0)")
            }
        } catch {
            print("Error delete Countdown: \(error)")
        }
        
        //performSegue(withIdentifier: "goToMain", sender: self)
        //self.dismiss(animated: false, completion: nil)
        
        let targetVC = navigationController?.viewControllers.first(where: {$0 is MainViewController})
        if let targetVC = targetVC {
           navigationController?.popToViewController(targetVC, animated: true)
        }
        
    }
    
    //load data for the request input or use the default value Item.fetchRequest
    func load(){
        
        countdownList = realm.objects(Countdown.self)
        
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("error loading categories \(error)")
//        }
//
//
        //tableView.reloadData()
        
    }
    
}
