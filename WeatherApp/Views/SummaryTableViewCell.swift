//
//  SummaryTableViewCell.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 8/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit

final class SummaryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    // Views
    let summaryLabel = UILabel()
    
    // Overrides
    override var textLabel: UILabel? {
        return nil
    }
    
    override var imageView: UIImageView? {
        return nil
    }
    
    override var detailTextLabel: UILabel? {
        return nil
    }
    
    // MARK: - Init
    override init(style: UITableViewCellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        summaryLabel.numberOfLines = 20
        summaryLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        contentView.addSubview(summaryLabel)
        
        summaryLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 27)
        summaryLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 18)
        summaryLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 18)
        summaryLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 27)
    }
    
    // MARK: - Overrides
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    // MARK: - Public Methods
    func setupCell(summary: String?) {
        summaryLabel.text = summary
    }
}
