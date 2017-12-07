//
//  ForecastViewController.swift
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

final class ForecastViewController: BaseViewController {
    
    enum Cell {
        case current(forecastData: ForecastData?)
        case daily(forecastData: ForecastData)
    }
    
    // MARK: - Properties
    // Views
    public let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    public let tableView = UITableView()
    public let backgroundImageView = UIImageView()
    
    // Helpers
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let viewModel: ForecastViewModelProtocol
    
    // MARK: - Init
    init(viewModel: ForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    private func setup() {
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = .clear
        
        activityIndicator.hidesWhenStopped = true
        
        tableView.register(CurrentForecastTableViewCell.self, forCellReuseIdentifier: "CurrentForecastTableViewCell")
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: "DailyForecastTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    private func setupConstraints() {
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        backgroundImageView.autoPinEdgesToSuperviewEdges()
        tableView.autoPinEdgesToSuperviewEdges()
        activityIndicator.autoCenterInSuperview()
    }
    
    private func setupBindings() {
        viewWillAppearAnimated
            .drive(onNext: { [unowned self] animated in
                self.navigationController?.setNavigationBarHidden(true, animated: animated)
                
                if let row = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: row, animated: animated)
                }
            })
            .disposed(by: disposeBag)
        
        viewDidAppearAnimated
            .drive(onNext: { [unowned self] _ in
                self.viewModel.fetchForecast()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchForecastStatus
            .drive(onNext: { [unowned self] status in
                switch status {
                case .busy: self.activityIndicator.startAnimating()
                case .idle: fallthrough
                case .success: fallthrough
                case .failed: self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        // Configure each cell of the tableview
        let dateFormatter = DateFormatter()
        
        let tableViewDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Cell>>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .current(let forecastData):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentForecastTableViewCell", for: indexPath) as! CurrentForecastTableViewCell
                
                cell.setupCell(forecastData)
                
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.selectionStyle = .none
                
                return cell
            case .daily(let forecastData):
                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastTableViewCell", for: indexPath) as! DailyForecastTableViewCell

                cell.setupCell(forecastData, dateFormatter: dateFormatter)
                
                // If last cell in section, show the separator
                let leftInset = tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row ? 0 : max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                cell.separatorInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
                
                return cell
            }
        })
        
        // Fill in table view with cells + data when a forecast comes in
        viewModel.forecast
            .filter {
                $0 != nil
            }
            .map {
                $0!
            }
            .map { forecast -> [SectionModel<String, Cell>] in
                let currentSection: SectionModel<String, Cell> = {
                    let cells = [Cell.current(forecastData: forecast.current)]
                    return SectionModel(model: "Current Forecast", items: cells)
                }()
                
                let dailySection: SectionModel<String, Cell> = {
                    let cells = forecast.nextDays?.data.map({ Cell.daily(forecastData: $0) }) ?? []
                    return SectionModel(model: "Daily Forecast", items: cells)
                }()
                
                return [currentSection, dailySection]
            }
            .drive(tableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Cell.self)
            .subscribe(onNext: { [unowned self] cell in
                switch cell {
                case .current: break
                case .daily(let forecastData): self.viewModel.showForecastData(forecastData)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.forecast
            .map {
                $0?.current?.iconName
            }
            .filter {
                $0 != nil
            }
            .map {
                $0!
            }
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] iconName in
                self.backgroundImageView.image = UIImage(named: iconName + "-bg")
            })
            .disposed(by: disposeBag)
    }
}
