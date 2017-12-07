//
//  ForecastDataViewController.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PureLayout

final class ForecastDataViewController: BaseViewController {
    
    struct LabelValuePair {
        let label: String
        let value: String
    }
    
    // MARK: - Properties
    // Views
    public let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    // Helpers
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let viewModel: ForecastDataViewModelProtocol
    
    // MARK: - Init
    init(viewModel: ForecastDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        // Table View
        tableView.register(Value1TableViewCell.self, forCellReuseIdentifier: "Value1TableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    private func setupBindings() {
        viewWillAppearAnimated
            .drive(onNext: { [unowned self] animated in
                self.navigationController?.setNavigationBarHidden(false, animated: animated)
            })
            .disposed(by: disposeBag)
        
        viewModel.forecastData
            .map {
                DateFormatter.localizedString(from: $0.time, dateStyle: DateFormatter.Style.full, timeStyle: DateFormatter.Style.none)
            }
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
        // Configure each cell of the tableview
        let dateFormatter = DateFormatter()
        
        let tableViewDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LabelValuePair>>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Value1TableViewCell", for: indexPath)
            
            cell.textLabel?.text = item.label
            cell.detailTextLabel?.text = item.value
            cell.selectionStyle = .none
            cell.accessoryType = .none
            
            return cell

        })
        
        // Fill in table view with cells + data when forecast data comes in
        let forecastData = viewModel.forecastData
        let location = viewModel.location
        
        Driver.combineLatest(forecastData, location) { ($0, $1) }
            .map { forecastData, location -> [SectionModel<String, LabelValuePair>] in
                
                // Map forecast data into cell data
                let cells: [LabelValuePair] = [
                    LabelValuePair(label: "Temperature".localizedCapitalized, value: "\(Int(forecastData.temperature?.toCelsius() ?? 0))°"),
                    LabelValuePair(label: "Temperature high".localizedCapitalized, value: "\(Int(forecastData.temperatureHigh?.toCelsius() ?? 0))°"),
                    LabelValuePair(label: "Temperature low".localizedCapitalized, value: "\(Int(forecastData.temperatureLow?.toCelsius() ?? 0))°"),
                    LabelValuePair(label: "Feels like".localizedCapitalized, value: "\(Int(forecastData.apparentTemperature?.toCelsius() ?? 0))°"),
                    LabelValuePair(label: "Chance of rain".localizedCapitalized, value: "\(Int(forecastData.precipitationProbability?.toCelsius() ?? 0))°"),
                ]
                return [SectionModel(model: "Data", items: cells)]
            }
            .drive(tableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
        
        
        tableViewDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
    }
}
