//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 31/05/2022.
//

import UIKit
import MapKit

struct Location: Hashable {
    let city: String
    let country: String
}

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let searchCompleter = MKLocalSearchCompleter()
    var viewModel: SearchViewModelType?
    
    var locations: [Location] = [] {
        didSet {
            locations = Array(Set(locations))
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchCompleter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewNavigation()
    }
    
    override func setupViewNavigation() {
        self.navigationItem.title = AppStrings.search
        super.setupViewNavigation()
    }
}

//MARK: - Instantiate
extension SearchViewController {
    static func instantiate() -> Self? {
        UIStoryboard(name: "SearchView", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as? Self
    }
}

//MARK: - Setup UI
extension SearchViewController {
    private func setupUI() {
        setupViewNavigation()
        setupSearchController()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = AppStrings.search
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        searchResultTableView.keyboardDismissMode = .onDrag
    }

}

//MARK: - Localization Services
extension SearchViewController {
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
    }
    
    func getCityList(results: [MKLocalSearchCompletion]){
            
        for result in results {
            
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            buildCityType(titleComponents, subtitleComponents){ place in
                
                if place.city != "" && place.country != ""{
                    self.locations.append(place)
                }
            }
        }
    }
    
    func buildCityType(_ title: [String],_ subtitle: [String], _ completion: @escaping (Location) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if (title.count > 1 && subtitle.count >= 1) ||  (title.count == 1 && subtitle.count == 1){
                 city = title.first!
                 country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
             }
     
             completion(Location(city: city, country: country))
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1)
        }
    }
}

//MARK: - Search View Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        locations.removeAll()
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}

//MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foundLocation = locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchTableViewCell
        cell?.setupCellUI(with: foundLocation)

        return cell ?? UITableViewCell()
    }
}

//MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foundLocation = locations[indexPath.row]

        getCoordinateFrom(address: "\(foundLocation.city), \(foundLocation.country)") { [weak self] coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            self?.viewModel?.inputs.showWeatherDetail(coordinates: coordinate, cityName: foundLocation.city)
        }
    }
}

//MARK: - Search Completer Delegate
extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        getCityList(results: completer.results)
    }
}

