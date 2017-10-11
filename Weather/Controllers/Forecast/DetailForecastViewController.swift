//
//  DetailForecastViewController.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class DetailForecastViewController: UIViewController {
  var viewModel: ForecastViewModel!
  var tableView: UITableView!
  
  private let cellReuseIdentifier = "forecastCellIdentifier"
  private let disposeBag = DisposeBag()
  
  init(viewModel: ForecastViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: Bundle.main)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = WeekDay(dayOfTheWeek: viewModel.forecastOfTheDay.dayOfTheWeek).printableValue
    viewModel.viewDidLoad()
    setUpTableView()
  }
  
  private func setUpTableView() {
    tableView = UITableView(frame: view.frame, style: .grouped)
    tableView.register(DetailForecastTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    viewModel.isUserInteractionEnabledOnTableView.bind(to: tableView.rx.isUserInteractionEnabled).disposed(by: disposeBag)
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    viewModel.itemsForTableView.bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier,
                                                            cellType: DetailForecastTableViewCell.self)) {
                                                              row, element, cell in
      print("cell \(row) is being created")
      }.disposed(by: disposeBag)
  }
}
