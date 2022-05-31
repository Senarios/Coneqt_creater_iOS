//
//  TableViewExtension.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollTableViewToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }
 
        var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1
 
        while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
            lastSectionWithAtLeasOneElements -= 1
        }
 
        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1
 
        guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }
 
        let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}
