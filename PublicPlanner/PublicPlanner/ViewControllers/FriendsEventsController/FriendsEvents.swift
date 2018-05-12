//
//  FriendsEvents.swift
//  Public Planner
//
//  Created by Clifford Yin on 1/2/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

/* This code manages the loading and displaying of the schedules of the user's friends. */
class FriendsEvents: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // MARK: Properties
    
    var oneSelect = true
    var nameDetail = [String: String]()
    var saveText = ""
    var events = [NSManagedObject]()
    var openID = ""
    var ref = FIRDatabase.database().reference()
    @IBOutlet weak var friendsEvents: UITableView!
    var myNumbers: Array<AnyObject> = []
    
    // MARK: ViewController overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        ref.child("users").child(openID).child("events").queryOrdered(byChild: "numericDate").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate2.managedObjectContext
            let entity2 =  NSEntityDescription.entity(forEntityName: "Event2", in: managedContext2)
            
            var newItems = [NSManagedObject]()
            
            for item in snapshot.children {
                
                let adding2 = NSManagedObject(entity: entity2!, insertInto: managedContext2)
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let named = childSnapshot.key
                
                let detailedValue = childSnapshot.value as? NSDictionary
                let detailed = detailedValue?["detail"] as! String
                let showedValue = childSnapshot.value as? NSDictionary
                let showDated = showedValue?["date"] as! String
                let orderValue = childSnapshot.value as? NSDictionary
                let orderDated = orderValue?["numericDate"] as! String
                
                adding2.setValue(named, forKey: "name")
                adding2.setValue(detailed, forKey: "detail")
                adding2.setValue(showDated, forKey: "date")
                adding2.setValue(orderDated, forKey: "numericDate")
                
                if (self.checkDate(dated: orderDated)) {
                    newItems.append(adding2)
                }
            }
            
            self.events = newItems
            self.friendsEvents.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    // Sets up friend schedules' events
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "#5") as! TextInputTableCellView2
        let slot = events[indexPath.row]
        let cellText = slot.value(forKey: "name") as? String
        let cellTextSpace = "  " + cellText!
        let cellText2 = slot.value(forKey: "date") as? String
        cell.detailTextLabel?.text = slot.value(forKey: "detail") as? String
        cell.configurate(cellTextSpace, dateText: cellText2!)
        nameDetail[cellTextSpace] = slot.value(forKey: "detail") as? String
        if oneSelect == false {cell.transit.setTitle("", for: UIControlState())}
        return cell
        
    }
    
    // Selecting allows the user to view the specifics of each friend event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.friendsEvents.cellForRow(at: indexPath) as! TextInputTableCellView2
        cell.contentView.backgroundColor = UIColor(red: 1, green: 0.659, blue: 0.094, alpha: 0.7)
        let savedText = cell.textField2.text
        saveText = nameDetail[savedText!]!
        cell.transit.setTitle("Details", for: UIControlState())
        
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.friendsEvents.cellForRow(at: indexPath)! as! TextInputTableCellView2
        cell.transit.setTitle("", for: UIControlState())
    }
    
    //Mark: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "toSave" {
            let svc = segue.destination as! SavedDetail
            svc.toPass = saveText
            
        }
    }


    // Pulls the friend schedules from Firebase along with their events
    func load(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).child("events").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate2.managedObjectContext
            let entity2 =  NSEntityDescription.entity(forEntityName: "Event", in: managedContext2)
            
            var newItems = [NSManagedObject]()
            
            for item in snapshot.children {
              
                let adding2 = NSManagedObject(entity: entity2!, insertInto: managedContext2)
                
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let named = childSnapshot.key
               
                let detailValue = childSnapshot.value as? NSDictionary
                let detailed = detailValue?["detail"] as! String
                let showValue = childSnapshot.value as? NSDictionary
                let showDated = showValue?["date"] as! String
                let orderValue = childSnapshot.value as? NSDictionary
                let orderDated = orderValue?["numericDate"] as! String
                
                adding2.setValue(named, forKey: "name")
                adding2.setValue(detailed, forKey: "detail")
                adding2.setValue(showDated, forKey: "date")
                adding2.setValue(orderDated, forKey: "numericDate")
                if (self.checkDate(dated: orderDated)) {
                    newItems.append(adding2)
                }
            }
            
            self.events = newItems
            }
        
    }
    
    // Only displays friend events that have not occured yet
    func checkDate(dated: String) -> Bool {
        let timeFormatter = DateFormatter()
        let timeFormatter2 = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.short
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strDate = timeFormatter.string(from: Date())
        timeFormatter2.dateFormat = "yyyyMMddHHmmss"
        
        let numericDate = timeFormatter2.string(from: Date())
        let numberDate = numericDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm"
        let date = dateFormatter.date(from:dated)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let finalDate = calendar.date(from:components)
        
        let dated2 = timeFormatter2.string(from: finalDate!)
        print("\(numberDate), \(dated2)")
        if (Int(dated2)! > Int(numberDate)!) {
            return true
        } else {
            return false
        }
    }

}
