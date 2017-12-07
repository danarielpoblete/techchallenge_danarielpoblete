//
//  CurrentForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit

final class CurrentForecastTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    // Views
    let locationLabel = UILabel()
    let summaryLabel = UILabel()
    let temperatureLabel = UILabel()
    
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
        backgroundColor = .clear
        
        locationLabel.textColor = .white
        summaryLabel.textColor = .white
        temperatureLabel.textColor = .white
    }
    
    private func setupConstraints() {
        let stackView = UIStackView()
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(summaryLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: 44)
        stackView.autoPinEdge(toSuperviewEdge: .left, withInset: 18)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 18)
        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 44)
    }
    
    // MARK: - Overrides
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        locationLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        temperatureLabel.font = UIFont.systemFont(ofSize: 100, weight: .ultraLight)
    }
    
    // MARK: - Public Methods
    func setupCell(_ forecastData: ForecastData?, location: String?) {
        locationLabel.text = location
        
        summaryLabel.text = {
            guard let forecastData = forecastData else {
                return "-"
            }
            
            return forecastData.summary
        }()
        
        temperatureLabel.text = {
            guard let temperature = forecastData?.temperature else {
                return "--"
            }
            
            return "\(Int(temperature.toCelsius()))°"
        }()
    }
}
