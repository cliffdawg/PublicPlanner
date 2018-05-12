//
//  ViewController.swift
//  Public Planner
//
//  Created by Clifford Yin on 7/23/16.
//  Copyright © 2016 Clifford Yin. All rights reserved.
//

import UIKit
import CoreData
import Firebase


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func
    dismissKeyboard() {
        view.endEditing(true)
    }
}

/* The main page of Public Planner, where all of the user's events are displayed. */
class ViewController: UIViewController, AddEventViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
 
    // MARK: Properties
    
    var oneSelect = true
    var nameDetail = [String: String]()
    var saveText = ""
    var events = [NSManagedObject]()
    var ref = FIRDatabase.database().reference()
    var myNumbers: Array<AnyObject> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: ViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // Check internet connection
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).child("events").queryOrdered(byChild: "numericDate").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
            let managedContext2 = appDelegate2.managedObjectContext
            let entity2 =  NSEntityDescription.entity(forEntityName: "Event", in:managedContext2)
            
            var newItems = [NSManagedObject]()
            
            for item in snapshot.children {
                // Pull data from Firebase
                let adding2 = NSManagedObject(entity: entity2!, insertInto: managedContext2)
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let named = childSnapshot.key
                let detailedValue = childSnapshot.value as? NSDictionary
                let detailed = detailedValue?["detail"] as! String
                let showedValue = childSnapshot.value as? NSDictionary
                let showDated = showedValue?["date"] as! String
                let ordValue = childSnapshot.value as? NSDictionary
                let orderDated = ordValue?["numericDate"] as! String
                
                // Transfer it to core data
                adding2.setValue(named, forKey: "name")
                adding2.setValue(detailed, forKey: "detail")
                adding2.setValue(showDated, forKey: "date")
                adding2.setValue(orderDated, forKey: "numericDate")
                if (self.checkDate(dated: orderDated)) {
                    newItems.append(adding2)
                }
            }
            
            self.events = newItems
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Sets up all the events stored locally in this ViewController's tableView
    func load(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).child("events").observe(.value) { (snapshot: FIRDataSnapshot!) in
            
            let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext2 = appDelegate2.managedObjectContext
            let entity2 =  NSEntityDescription.entity(forEntityName: "Event", in:managedContext2)
            
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
                
                // Stores events in core data
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
    
    // Checks the dates of events and only displays them if the current date has not passed them yet
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
    
    //MARK: Add Todo Delegate
    
    // Adds new event stored locally in phone
    func addNew(_ todo: Event) {
        
        oneSelect = false

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Event", in:managedContext)
        let adding = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        adding.setValue(todo.name, forKey: "name")
        adding.setValue(todo.note, forKey: "detail")
        adding.setValue(todo.dated, forKey: "date")
        adding.setValue(todo.orderDate, forKey: "numericDate")
        
        do {
            try managedContext.save()
            
            events.append(adding)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: TableViewController Methods
    
    func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int  {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let rowNumber = self.events[indexPath.row].value(forKey: "date") as? String
        if editingStyle == .delete {
            var keyArray = [String](nameDetail.keys)
            let removing = keyArray[indexPath.row]
            nameDetail.removeValue(forKey: removing)
            
            // Deletes event from core data
            context.delete(events[indexPath.row] )
            events.remove(at: indexPath.row)
            do {
                try context.save()}
            catch {
                
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            // Deletes event from Firebase database
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(userID!).child("events").observe(.value, with: { (snapshot) -> Void in
                for item in snapshot.children {
                    
                    let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                    let datesValue = childSnapshot.value as? NSDictionary
                    let dates = datesValue?["date"] as! String
                    
                    if dates == rowNumber{
                        (item as AnyObject).ref.removeValue() // When found, remove child from Firebase
                        self.oneSelect = false
                    }
                }
            })
        }
    }
    
    // Sets up event in each cell along with all its details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "#1") as! TextInputTableCellView
        let slot = events[indexPath.row]
        let cellText = slot.value(forKey: "name") as? String
        let cellTextSpace = "  " + cellText!
        let cellText2 = slot.value(forKey: "date") as? String
        cell.detailTextLabel?.text = slot.value(forKey: "detail") as? String
        cell.configure(cellTextSpace, dateText: cellText2!)
        nameDetail[cellTextSpace] = slot.value(forKey: "detail") as? String
        cell.transit.isEnabled = false
        if oneSelect == false {
            cell.transit.setTitle("", for: UIControlState())
        }
        return cell
    }
    
    // If event is selected, give an opportunity to view its specific details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! TextInputTableCellView
        cell.contentView.backgroundColor = UIColor(red: 1, green: 0.659, blue: 0.094, alpha: 0.7)
        let savedText = cell.textField.text
        saveText = nameDetail[savedText!]!
        cell.transit.isEnabled = true
        cell.transit.setTitle("Details", for: UIControlState())
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        let cell = self.tableView.cellForRow(at: indexPath)! as! TextInputTableCellView
        cell.transit.isEnabled = false
        cell.transit.setTitle("", for: UIControlState())
        
    }
    
    //Mark: Navigation methods
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEvent" {
            let destVC = segue.destination as! AddEventViewController
            destVC.delegate = self}
        if segue.identifier == "openDetail" {
            let svc = segue.destination as! SavedDetail
            svc.toPass = saveText
            }
        }
    }

