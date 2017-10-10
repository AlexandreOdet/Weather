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
  
  init(viewModel: ForecastViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: Bundle.main)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
  
  private func setUpTableView() {
    tableView = UITableView(frame: view.frame, style: .grouped)
  }
}
