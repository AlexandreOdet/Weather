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

class ViewController: UIViewController {

  let disposeBag = DisposeBag()
  
  let viewModel = CityViewModel()
  
  var resultsViewController: GMSAutocompleteResultsViewController?
  var searchController: UISearchController?
  var searchButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resultsViewController = GMSAutocompleteResultsViewController()
    resultsViewController?.delegate = self
    
    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController
    
    navigationItem.titleView = searchController?.searchBar
    searchController?.searchBar.sizeToFit()
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    
    
    setUpSearchButton()
    viewModel.isValid.map{ $0 }.bind(to: searchButton.rx.isEnabled).addDisposableTo(disposeBag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setUpSearchButton() {
    view.addSubview(searchButton)
    searchButton.snp.makeConstraints { (make) -> Void in
      make.bottom.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(30)
    }
    searchButton.backgroundColor = .red
    searchButton.setTitle("Rechercher", for: .normal)
    searchButton.setTitleColor(.blue, for: .disabled)
    searchButton.setTitleColor(.white, for: .normal)
  }
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    guard let components = place.addressComponents else { return }
    for component in components {
      print(component.name, component.type)
    }
    guard let cityComponent = components.first(where: {$0.type == "locality"}) else {return}
    guard let countryComponent = components.first(where: {$0.type == "country"}) else {return}
    
    let city = Variable<String>(cityComponent.name)
    let country = Variable<String>(countryComponent.name)
    
    city.asObservable().bind(to: viewModel.cityName).addDisposableTo(disposeBag)
    country.asObservable().bind(to: viewModel.countryName).addDisposableTo(disposeBag)
    
    searchController?.searchBar.text = "\(city.value), \(country.value)"
  }
  
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
    print(error)
  }
}
