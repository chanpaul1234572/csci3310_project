//
//  HistoryTableViewController.swift
//  VisionLearning
//
//  Created by Chan Paul on 19/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import UIKit
import os.log


class HistoryTableViewController: UITableViewController {

    //MARKS: Properties
    var things = [Thing]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedThings = loadThings(){
            things += savedThings
        }
        else{
            loaddata()
        }
        tableView.delegate = self
        
        //tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return things.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HIstoryTableViewCell"
        print("OK for cellIdentitifer")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HIstoryTableViewCell else{
            fatalError("The dequeued cell is not an instance of HIstoryTableViewCell.")
        }

        // Configure the cell...
        let thing = things[indexPath.row]
        
        cell.englishName.text = thing.englishName
        cell.translatedName.text = thing.translatedName
        cell.imageOfTheThing.image = thing.photo
        print("OK")
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            things.remove(at: indexPath.row)
            saveThings()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let historyDetailViewController = segue.destination as? ViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedHistoryCell = sender as? HIstoryTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedHistoryCell) else{
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHistory = things[indexPath.row]
            historyDetailViewController.thing = selectedHistory
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Private Methods
    private func loaddata(){
        let imageOfTheThing1 = UIImage(named: "Lemon")
        let imageOfTheThing2 = UIImage(named: "Orange")
        let imageOfTheThing3 = UIImage(named: "Banana")
        
        guard let thing1 = Thing(englishName: "Lemon", photo: imageOfTheThing1, translatedName: "檸檬") else {
            fatalError("Unable to instantiate thing1")
        }
        
        guard let thing2 = Thing(englishName: "Orange", photo: imageOfTheThing2, translatedName: "橙子") else {
            fatalError("Unable to instantiate thing2")
        }
        
        guard let thing3 = Thing(englishName: "Banana", photo: imageOfTheThing3, translatedName: "香蕉") else {
            fatalError("Unable to instantiate thing3")
        }
        
        things += [thing1, thing2, thing3]
        print(things.count)
        
    }
    
    //MARK: Actions
    @IBAction func unwindToHistory(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? ViewController, let thing = sourceViewController.thing{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                things[selectedIndexPath.row] = thing
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
            
            let newIndexPath = IndexPath(row: things.count, section: 0)
            things.append(thing)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        
            }
            saveThings()
        }
    }
    
    private func saveThings(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(things, toFile: Thing.ArchiveURL.path)
        if isSuccessfulSave{
            os_log("Things successfully saved.", log: OSLog.default, type: .debug)
        }
        else{
            os_log("Failed to save Things...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadThings() -> [Thing]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Thing.ArchiveURL.path) as? [Thing]
    }
    
}
