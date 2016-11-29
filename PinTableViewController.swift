//
//  PinTableViewController.swift
//  iBillboard
//
//  Created by Harrison Voslow on 11/7/16.
//  Copyright © 2016 Harrison Voslow. All rights reserved.
//

import UIKit
import CoreData

class PinTableViewController: UITableViewController {
    
    //var pins = [Pin(t:"Title1",d:"description1")]
    //var currentPin :Pin = Pin(t:"",d:"")
    var pins = [NSManagedObject]()
    var currentIndex: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        addPin(t: "The Man Himself", d: "We pulled this glorious image of our Lord and Savior, Thomas Jefferson, from imgur using a url link.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pins"
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedItem(sender:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.tableView.addGestureRecognizer(tapRecognizer)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //addPin(t: "The Man Himself", d: "We pulled this glorious image of our Lord and Savior, Thomas Jefferson, from imgur using a url link.")
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.tableView.reloadData();
    }
    
    @IBAction func clickedItem(sender:UITapGestureRecognizer){
        let point = sender.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil {
            //currentIndex = indexPath!.row;
            //currentItem = items[currentIndex];
            //performSegue(withIdentifier: "DetailSegue", sender: self)
            //self.tableView.reloadData();
            print((pins[indexPath!.row].value(forKey: "title") as? String)!)
            //currentPin = pins[indexPath!.row]
            currentIndex = indexPath!.row
            performSegue(withIdentifier: "DetailSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = (pins[indexPath.row].value(forKey: "title") as? String)!;
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let PinViewController = segue.destination as! PinViewController
            //PinViewController.pin = currentPin
            //PinViewController.pin = pins[currentIndex]
            PinViewController.pinIndex = currentIndex
            PinViewController.pins = pins
        }
        self.tableView.reloadData();
    }
    
    func addPin(t: String, d: String) {
        let context = getContext()
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "PinEntity", in: context)
        
        let pin = NSManagedObject(entity: entity!, insertInto: context)
        
        //3
        pin.setValue(t, forKey: "title")
        pin.setValue(d, forKey: "desc")
        
        //4
        do {
            try context.save()
            //5
            pins.append(pin)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
