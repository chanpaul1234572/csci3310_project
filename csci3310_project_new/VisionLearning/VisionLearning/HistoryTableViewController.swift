//
//  HistoryTableViewController.swift
//  VisionLearning
//
//  Created by Chan Paul on 19/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import UIKit


class HistoryTableViewController: UITableViewController {

    //MARKS: Properties
    var things = [Thing]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddata()
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

}
