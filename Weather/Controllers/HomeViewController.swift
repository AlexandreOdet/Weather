//
//  ViewController.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import UIKit
import SnapKit
import GooglePlaces
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

  let disposeBag = DisposeBag()
  
  let viewModel = CityViewModel()
  
  var resultsViewController: GMSAutocompleteResultsViewController?
  var searchController: UISearchController?
  var searchButton = UIButton()
  var tableView: UITableView!
  
  let reuseIdentifier = "WeatherCustomCell"
  
  deinit {
    viewModel.restApiWeather.cancelRequest()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpSearchBar()
    setUpSearchButton()
    setUpTableView()
    viewModel.isValid.map{ $0 }.bind(to: searchButton.rx.isEnabled).disposed(by: disposeBag)
  }
  
  private func setUpTableView() {
    tableView = UITableView(frame: view.frame, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(searchButton.snp.top)
      make.width.equalToSuperview()
      if let navigationController = navigationController {
        make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.height)
      } else {
        make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
      }
    }
    viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: UITableViewCell.self)) {
      row, element, cell in
      cell.textLabel?.text = "\(element) \(row)"
    }.disposed(by: disposeBag)
  }
  
  private func setUpSearchBar() {
    resultsViewController = GMSAutocompleteResultsViewController()
    resultsViewController?.delegate = self
    
    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController
    
    navigationItem.titleView = searchController?.searchBar
    searchController?.searchBar.sizeToFit()
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
  }
  
  private func setUpSearchButton() {
    view.addSubview(searchButton)
    searchButton.snp.makeConstraints { (make) -> Void in
      make.bottom.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(30)
    }
    searchButton.backgroundColor = .white
    searchButton.setTitle("Rechercher", for: .normal)
    searchButton.setTitleColor(.lightGray, for: .disabled)
    searchButton.setTitleColor(.black, for: .normal)
    searchButton.addTarget(self, action: #selector(searchButtonTarget), for: .touchUpInside)
  }
  
  @objc func searchButtonTarget() {
    if searchButton.isEnabled {
      viewModel.fetchWeatherFromApi(city: viewModel.cityName.value, country: viewModel.countryName.value)
    }
  }
}

extension HomeViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    guard let components = place.addressComponents else { return }
    guard let cityComponent = components.first(where: {$0.type == "locality"}) else {return}
    guard let countryComponent = components.first(where: {$0.type == "country"}) else {return}
    
    let city = Variable<String>(cityComponent.name)
    let country = Variable<String>(countryComponent.name)
    
    city.asObservable().bind(to: viewModel.cityName).disposed(by: disposeBag)
    country.asObservable().bind(to: viewModel.countryName).disposed(by: disposeBag)
    
    searchController?.searchBar.text = "\(viewModel.cityName.value), \(viewModel.countryName.value)"
  }
  
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
  }
}

