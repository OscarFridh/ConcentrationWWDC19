//
//  CardCell.swift
//  ConcentrationGame
//
//  Created by Oscar Fridh on 2019-03-21.
//  Copyright © 2019 Oscar Fridh. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    var character: Character? {
        get {
            return label.text?.first
        } set {
            if let newValue = newValue {
                label.text = String(newValue)
            } else {
                label.text = nil
            }
        }
    }
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        
//        clipsToBounds = true
        backgroundColor = nil
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = frame.width/4
        
        // Important that the view retained and fully set up here! Otherwise it won't show up in the playground.
        label = createLabel()
        
        contentView.addSubview(label)
        setupConstraints()
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont.systemFont(ofSize: frame.width*0.6)
        label.textAlignment = .center
        return label
    }
    
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented or needed in this example")
    }
}
