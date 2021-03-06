//
//  AllListsViewController.swift
//  Checklists
//
//  Created by zhuangqiuxiong on 16/3/21.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate{

    var dataModel : DataModel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
        
        let index = NSUserDefaults.standardUserDefaults().integerForKey(ChecklistIndexKey)
        if index >= 0 && index < dataModel.lists.count
        {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataModel.lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "All lists item"
        
        let cell : UITableViewCell
        if let cellReuse = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        {
            cell = cellReuse
        }
        else
        {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }

        // Configure the cell...
        cell.textLabel?.text = self.dataModel.lists[indexPath.row].name
        cell.accessoryType = .DetailDisclosureButton

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: ChecklistIndexKey)
        NSUserDefaults.standardUserDefaults().synchronize()//保证set完之后马上同步保存
        
        performSegueWithIdentifier("ShowChecklist", sender: self.dataModel.lists[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let controller =  self.storyboard!.instantiateViewControllerWithIdentifier("ListDetailVIewController") as! ListDetailViewController
        
        controller.delegate = self
        controller.checklistToEdit = self.dataModel.lists[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowChecklist"{
            
            let newController = segue.destinationViewController as! ChecklistViewController
            newController.checklist = sender as! Checklist
        }
        
        else if segue.identifier == "AddChecklist"{
            
            let newController = segue.destinationViewController as! ListDetailViewController
            newController.delegate = self
        }
        
    }
    
    //MARK: ListDetailViewController Delegate
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingItem newItem: Checklist) {
        
        let newRowIndex = self.dataModel.lists.count
        
        self.dataModel.lists.append(newItem)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingItem editItem: Checklist) {
        
        if let index = self.dataModel.lists.indexOf(editItem){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                
                cell.textLabel!.text = editItem.name
            }
        }
        
    }
    
    //MARK: Navigation controller delegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        //With just two equals signs, for objects such as view controllers, equality is tested by comparing the references, just like === would do. But technically speaking, === is more correct here than ==.
        if viewController === self
        {
            NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: ChecklistIndexKey)
            NSUserDefaults.standardUserDefaults().synchronize()//保证set完之后马上同步保存
        }
        
    }
    

}
