//
//  AddNewRecordViewController.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import UIKit
import Komponents

class AddNewRecordViewController: UIViewController, StatelessComponent {
    
    fileprivate var pointsTextField = UITextField()
    fileprivate var descrTextView = UITextView()

    override func loadView() { loadComponent() }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add New Record"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    func render() -> Tree {
        return View([
            VerticalStack(props: { $0.spacing = 20 }, layout: Layout().fillHorizontally().top(80), [
                Field("Points",
                      text: "",
                      layout: Layout().height(40),
                      ref: &pointsTextField),
                VerticalStack([
                        Label("Description (optional):", props: { $0.font = $0.font?.withSize(11)} ),
                        TextView(text: "", layout: Layout().height(80), ref: &descrTextView)
                    ])
            ]),
            VerticalStack(layout: Layout().fillHorizontally().bottom(0), [
                Button("Save", tap: { [weak self] in self?.save() }, layout: Layout().height(44))
            ])
        ])
    }
    
    @objc fileprivate func save() {
        if let points = Int(pointsTextField.text ?? "") {
            var data: [String : Any] = [.valueKey : points]
            if let descr = descrTextView.text {
                data[.descrKey] = descr
            }
            DataManager.manager.addNewRecord(data) { [weak self] (error) in
                let hasError = error != nil
                let alert = UIAlertController(title: hasError ? nil : "Success", message: hasError ? error?.localizedDescription : "Your record was added", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    if !hasError {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        } else {
            print("points value \(pointsTextField.text ?? "") incorrect")
        }
    }
    
    func didRender() {
        pointsTextField.keyboardType = .numberPad
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
