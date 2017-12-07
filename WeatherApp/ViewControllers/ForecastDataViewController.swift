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
    
    enum Cell {
        case current(forecastData: ForecastData?)
        case daily(forecastData: ForecastData)
    }
    
    // MARK: - Properties
    // Views
    public let tableView = UITableView()
    
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
        tableView.register(CurrentForecastTableViewCell.self, forCellReuseIdentifier: "CurrentForecastTableViewCell")
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: "DailyForecastTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
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
    }
}
