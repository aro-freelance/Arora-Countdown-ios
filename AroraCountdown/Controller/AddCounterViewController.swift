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
    
    
    @IBOutlet weak var bellImage: UIImageView!
    
    @IBOutlet weak var countdownTitle: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isEdit : Bool = false
    
    var countdownId = -99
    
    var countdownToEdit : Countdown = Countdown()
    
    var notificationStatus : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.isHidden = true
        
        //TODO: check if there is a countdownId passed from the MainViewController.
        
        if(countdownId >= 0){
            isEdit = true
        }
        
        if(isEdit){
            
            confirmButton.setTitle("Update", for: .normal)
            confirmButton.setTitle("Update", for: .focused)
            confirmButton.setTitle("Update", for: .highlighted)
            
            deleteButton.isHidden = false
            
            //TODO: get stored countdowns
            
            
            //TODO: for the list of countdowns get the one with countdownId and use it to set the date picker using the date information stored. Also use it to set the notification UI stuff.
            
            
        }
        
        
        //TODO: for the edittext ( countdownTitle ) when enter is pressed close the softkeyboard and trim any extra space at the end.
        

    }

    @IBAction func notificationSlider(_ sender: Any) {
        
        //TODO: set it so that if the slider is checked on then
        notificationStatus = true
        //show user a message that notifications are on
        //else
        notificationStatus = false
        //show user a message that notifications are off
        
        
    }
    
    
    @IBAction func datePicker(_ sender: Any) {
        
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        //get user input
        
        let input : String = countdownTitle.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let countdownDate : Date = datePicker.date
        
        //TODO: build and save new countdown
        
        
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        //TODO: delete the countdownToEdit from storage and close this VC (return to the MainVC)
        
    }
    
}
