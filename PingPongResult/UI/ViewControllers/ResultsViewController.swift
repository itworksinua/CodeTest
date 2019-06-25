//
//  ResultsViewController.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import UIKit
import Komponents

class ResultsViewController: UIViewController, StatelessComponent {
    
    override func loadView() { loadComponent() }
    
    var tableViewRef = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Your results"
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: .userDataUpdated), object: nil, queue: .main) { [weak self] (_) in
//            self?.loadComponent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd))
        
        loadComponent()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func render() -> Tree {
        let data = DataManager.manager.results
        return View([
            Table(layout: .fill, data: data, refresh: nil, delete: nil, configure: { ResultTableViewCell(result: $0) })
        ])
    }
    
    @objc func onAdd() {
        let main = AddNewRecordViewController()
        navigationController?.pushViewController(main, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
