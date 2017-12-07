//
//  DailyForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit

final class DailyForecastTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    // Views
    let dayLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureHighLabel = UILabel()
    let temperatureLowLabel = UILabel()
    
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
        
        // Labels
        dayLabel.textColor = .white
        
        temperatureHighLabel.textColor = .white
        temperatureHighLabel.textAlignment = .right
        
        temperatureLowLabel.textColor = UIColor(white: 216.0/255.0, alpha: 1)
        temperatureLowLabel.textAlignment = .right
        
        // Image
        iconImageView.contentMode = .scaleAspectFill
    }
    
    private func setupConstraints() {
        let temperatureStackView = UIStackView()
        temperatureStackView.addArrangedSubview(temperatureHighLabel)
        temperatureStackView.addArrangedSubview(temperatureLowLabel)
        temperatureStackView.axis = .horizontal
        temperatureStackView.spacing = 9
        temperatureStackView.alignment = .trailing
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureStackView)
        
        dayLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        dayLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 18)
        dayLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        
        iconImageView.autoCenterInSuperview()
        iconImageView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        
        temperatureHighLabel.autoSetDimension(.width, toSize: 28, relation: .greaterThanOrEqual)
        temperatureLowLabel.autoSetDimension(.width, toSize: 28, relation: .greaterThanOrEqual)
        
        temperatureStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 9)
        temperatureStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 18)
        temperatureStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 9)
    }
    
    // MARK: - Overrides
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        dayLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        temperatureHighLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15.0, weight: .regular)
        temperatureLowLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15.0, weight: .regular)
    }
    
    // MARK: - Public Methods
    func setupCell(_ forecastData: ForecastData, dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "EEEE"
        
        dayLabel.text = dateFormatter.string(from: forecastData.time)
        
        iconImageView.image = {
            guard let iconName = forecastData.iconName else {
                return nil
            }
            
            return UIImage(named: iconName)
        }()
        
        temperatureHighLabel.text = {
            guard let temperatureHigh = forecastData.temperatureHigh else {
                return "-"
            }
            
            return "\(Int(temperatureHigh.toCelsius()))"
        }()
        
        temperatureLowLabel.text = {
            guard let temperatureLow = forecastData.temperatureLow else {
                return "-"
            }
            
            return "\(Int(temperatureLow.toCelsius()))"
        }()
    }
}
