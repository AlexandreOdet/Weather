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
    setUpBindings()
  }
  
  private func setUpBindings() {
    viewModel.isValid.map{ $0 }
      .bind(to: searchButton.rx.isEnabled)
      .disposed(by: disposeBag)
    viewModel.requestHasFailed.subscribe(onError: { [unowned self] _ in
      let alert = UIAlertController(title: "Erreur", message: "Oups il semble y avoir une erreur !", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
      self.present(alert, animated: true, completion: nil)
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
      .subscribe(onNext: { [unowned self] indexPath in
        if let cell = self.tableView.cellForRow(at: indexPath) {
          Animation.onClick(sender: cell.contentView)
        }
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailWeatherViewController") as? DetailWeatherViewController else { return }
        nextViewController.viewModel = DetailViewModel(weather: self.viewModel.items.value[indexPath.row])
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
    searchButton.rx.tap.subscribe (onNext: { [unowned self] _ in
      self.viewModel.fetchWeatherFromApi(with: self.viewModel.cityName.value, in: self.viewModel.countryName.value)
    }).disposed(by: disposeBag)
  }
  
  private func setUpLocateMeButton() {
    let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation"),
                                             style: .plain,
                                             target: self,
                                             action: nil)
    navigationItem.rightBarButtonItem = rightBarButtonItem
    
    navigationItem.rightBarButtonItem?.rx.tap.subscribe (onNext: { [unowned self] _ in
      self.viewModel.getUserLocation()
    }).disposed(by: disposeBag)
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


