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
import Kingfisher

class HomeViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  let viewModel = HomeViewModel()
  
  var resultsViewController: GMSAutocompleteResultsViewController?
  var searchController: UISearchController?
  var searchButton = UIButton()
  
  @IBOutlet weak var tableView: UITableView!
  
  let reuseIdentifier = "WeatherCustomCell"
  
  deinit {
    viewModel.cancelRequest()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
    setUpSearchBar()
    setUpSearchButton()
    setUpTableView()
    setUpLocateMeButton()
  }
  
  private func setUpBindings() {
    viewModel.isValid.map{ $0 }
      .bind(to: searchButton.rx.isEnabled)
      .disposed(by: disposeBag)
    viewModel.requestHasFailed.subscribe(onError: { [weak self] _ in
      guard let strongSelf = self else { return }
      let alert = UIAlertController(title: "Erreur", message: "Oups il semble y avoir une erreur !", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
      strongSelf.present(alert, animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  
  private func setUpTableView() {
    tableView.register(WeatherTableViewCustomCell.self, forCellReuseIdentifier: reuseIdentifier)
    viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier,
                                                               cellType: WeatherTableViewCustomCell.self)) {
                                                                row, element, cell in
                                                                cell.cityNameLabel.text = element.name
                                                                let urlString = "\(Constants.network.openWeatherApiIconsUrl)\(element.weathers![0].icon!)\(Constants.network.openWeatherApiIconsFormat)"
                                                                let url = URL(string: urlString)
                                                                cell.cityWeatherIcon.kf.setImage(with: url)
      }.disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let strongSelf = self else { return }
        if let cell = strongSelf.tableView.cellForRow(at: indexPath) {
          Animation.onClick(sender: cell.contentView)
        }
        guard let nextViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "DetailWeatherViewController") as? DetailWeatherViewController else { return }
        nextViewController.viewModel = DetailViewModel(weather: strongSelf.viewModel.items.value[indexPath.row])
        strongSelf.navigationController?.pushViewController(nextViewController, animated: true)
      }).disposed(by: disposeBag)
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
  
  private func setUpLocateMeButton() {
    let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(locateMeButtonTarget))
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  @objc func searchButtonTarget() {
    if searchButton.isEnabled {
      viewModel.fetchWeatherFromApi(with: viewModel.cityName.value, in: viewModel.countryName.value)
    }
  }
  
  @objc func locateMeButtonTarget() {
    viewModel.getUserLocation()
  }
}

extension HomeViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    guard let components = place.addressComponents else { return }
    guard let cityComponent = components.first(where: {$0.type == "locality"}) else {return}
    guard let countryComponent = components.first(where: {$0.type == "country"}) else {return}
    
    viewModel.cityName.value = cityComponent.name
    viewModel.countryName.value = countryComponent.name
    
    searchController?.searchBar.text = "\(viewModel.cityName.value), \(viewModel.countryName.value)"
  }
  
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
    let alert = UIAlertController(title: "Erreur", message: "Oups il semble y avoir un problème avec ta demande", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}


