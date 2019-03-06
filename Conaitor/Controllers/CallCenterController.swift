//
//  CallCenterController.swift
//  Conaitor
//
//  Created by Done Santana on 4/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class CallCenterController: UITableViewController {
    var telefonosCallCenter = [CTelefono]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.telefonosCallCenter.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CallCenterViewCell", owner: self, options: nil)?.first as! CallCenterViewCell
        
        cell.ImagenOperadora.image = UIImage(named: self.telefonosCallCenter[indexPath.row].operadora)
        cell.NumeroTelefono.text = self.telefonosCallCenter[indexPath.row].numero

        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "tel://\(telefonosCallCenter[indexPath.row].numero)") {
            UIApplication.shared.openURL(url)
        }

    }

}
