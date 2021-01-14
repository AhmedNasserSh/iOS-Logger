//
//  ViewController.swift
//  LoggerApp
//
//  Created by khaled mohamed el morabea on 2/23/20.
//  Copyright © 2020 Instabug. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    var logs : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.shared.delegate = self
        Logger.shared.reset()
        for i in 0..<5000  {
            Logger.shared.log(message: "message\(i)", errorLevel: i % 2 == 0 ? .error : .verbose)
        }
    }
    
    @IBAction func loadLogs(_ sender: Any) {
        Logger.shared.getLogs()
    }
    
}

extension ViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        cell.logMessage.text = logs?[indexPath.row]
        return cell
    }
    
    
}
extension ViewController :LoggerProtocol {
    func didFetchLogs(logs: [String]) {
        self.logs = []
        self.logs = logs
        tableView.reloadData()
    }
}
