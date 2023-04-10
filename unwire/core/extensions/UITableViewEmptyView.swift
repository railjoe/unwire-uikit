//
//  UITableViewEmptyView.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import UIKit

extension UITableView {
    
    func showEmptyView(title: String?, message: String?) {
        
        let emptyView = UIView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        messageLabel.textColor = UIColor.label.withAlphaComponent(0.5)
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        

        titleLabel.topAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func hideEmptyView() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

