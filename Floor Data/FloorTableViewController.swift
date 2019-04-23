//
//  ViewController.swift
//  Floor Data
//
//  Created by AJMac on 4/16/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit
import CoreData

class FloorTableViewController: UITableViewController {
    
    var floors: [Floor] = []
    
    var managedContext: NSManagedObjectContext?

    @IBAction func addFloor(_ sender: Any) {
        addFloor()
        refreshTable()
    }
    
    @IBAction func increasePrice(_ sender: Any) {
        increasePriceForSelectedFloor()
        refreshTable()
    }
    
    @IBAction func deleteFloor(_ sender: Any) {
        deleteSelectedFloor()
        refreshTable()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        loadFloors()
        
    }
    func addFloor(){
        let floor = Floor(context: managedContext!)
        
        let randIndex = Int(arc4random_uniform(3))
        let randPriceIndex = Int(arc4random_uniform(10))
        
        let prices = [20.00,21.00,22.00,23.00,24.00,25.00,26.00,27.00,28.00,29.00,30.00]
        
        let floor_type = ["Carpet", "Wood", "Tile"]
        
        let price = Float(prices[randPriceIndex])
        let type = floor_type[randIndex]
        
        floor.type = type
        floor.price = price
        
        do {
            try managedContext!.save()
        } catch {
            print ("Error saving, \(error)")
        }
    }
    
    func loadFloors() {
        
        let fetchRequest = NSFetchRequest<Floor>(entityName: "Floor")
        
        do {
            floors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("Error fetching data because \(error)")
        }
    }
    
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
    func deleteSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        managedContext!.delete(floor)
        
        do {
            try managedContext!.save()
        } catch {
            print("Error deleting \(error)")
        }
    }
    
    func increasePriceForSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        floor.price += 1
        
        do {
            try managedContext!.save()
        } catch {
            print("Error updating price because \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        let floor = floors[indexPath.row]
        cell.textLabel?.text = floor.type
        cell.detailTextLabel?.text = ("$\(floor.price) per square foot")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

