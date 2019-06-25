//
//  ResultTableViewCell.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import UIKit
import Komponents

class ResultTableViewCell: /*UITableViewCell,*/ StatelessComponent {

    var data: [String: Any] = [:]
    
    init(result: [String: Any]) {
        data = result
    }
    
    func render() -> Tree {
        let hasDescr = (self.data.descr?.count ?? 0) > 0
        return View(layout: Layout().height(100).fill(), [
            VerticalStack(layout: Layout().fill(padding: 20), hasDescr ? [
                    Label("Result with \(data.value ?? 0) points", props: { $0.textColor = .black }),
                    Label(self.data.descr!, props: { $0.textColor = .black })
                ] : [
                    Label("Result with \(data.value ?? 0) points", props: { $0.textColor = .black })
                ])
        ])
    }
}
