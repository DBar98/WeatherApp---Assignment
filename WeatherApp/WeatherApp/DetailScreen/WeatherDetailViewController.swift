//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import UIKit
import Foundation
import Combine

class WeatherDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var weatherTableView: UITableView!

    //MARK: - Properties
    var viewModel: WeatherDetailViewModelType?
    private var forecastItems: [ForecastItem]?
    private var currentWeatherData: CurrentWeatherData?
    private var favouriteButtonType: TableViewButtonType = .defaulType

    //MARK: - Combine Props
    private var cancellable: AnyCancellable?
    
    private var isFavourite: Bool = false {
        didSet {
            switch isFavourite {
            case true:
                favouriteButtonType = .cancelType
            case false:
                favouriteButtonType = .defaulType
            }
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputs()
        setupOutputs()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupFavouriteButton()
    }
}

//MARK: - Instantiate
extension WeatherDetailViewController {
    static func instantiate() -> Self? {
        return UIStoryboard(name: "WeatherDetailView", bundle: nil)
            .instantiateViewController(withIdentifier: "WeatherDetailViewController") as? Self
    }
}

//MARK: - Setup Inputs
extension WeatherDetailViewController {
    func setupInputs() {
        viewModel?.inputs.fetchForecastData(pathVariable: .forecasts)
    }
}

//MARK: - Setup Outputs
extension WeatherDetailViewController {
    
    private func setupOutputs() {
        getWeatherForecast()
        weatherDataFetchFailure()
        fetchData()
    }
    
    private func getWeatherForecast() {
        viewModel?.outputs.onWeatherDataFetch = { [ weak self ] forecastData in
            guard let dailyData = forecastData.daily else { return }
            guard let currentData = forecastData.current else { return }
            
            self?.forecastItems = dailyData.map {
                ForecastItem(day: $0.dt,
                             dailyRain: ($0.pop * 100),
                             temperature: $0.temp.max,
                             weatherId: $0.weather[0].id)
            }
            
            self?.currentWeatherData = CurrentWeatherData(currentTemp: String("\(currentData.temp.roundToNearestInt())°C"),
                                                          currentWeatherDesc: currentData.weather[0].weatherDescription.capitalizingFirstLetter(),
                                                          feelsLike: String("\(AppStrings.feelsLike) \(currentData.feelsLike.roundToNearestInt())°C"))
            
            DispatchQueue.main.async {
                self?.weatherTableView.reloadData()
            }
        }
    }
    
    private func weatherDataFetchFailure() {
        viewModel?.outputs.onError = { [weak self] error in
            let errorAlert = UIAlertController.showAlertWithCancelButton(title: ErrorStrings.error,
                                                                         message: error)
            DispatchQueue.main.async {
                self?.present(errorAlert,
                              animated: true,
                              completion: nil)
            }
        }

        viewModel?.outputs.onNoInteretConnection = { [weak self] error in
            let errorAlert = UIAlertController.showAlertWithCancelButton(title: ErrorStrings.connectionError,
                                                                         message: error)
            DispatchQueue.main.async {
                self?.present(errorAlert,
                              animated: true,
                              completion: nil)
            }
        }
    }

    //MARK: Combine Output setup
    private func fetchData() {
        
        cancellable = viewModel?.inputs.fetchForecastDataCombine()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        let errorAlert = UIAlertController.showAlertWithCancelButton(title: ErrorStrings.connectionError,
                                                                                     message: error.localizedDescription)
                        self?.present(errorAlert,
                                      animated: true,
                                      completion: nil)
                    }
                }
            },
                  receiveValue: { data in
                
                print("COMBINE STARTS ...")
                print(data)
                print("COMBINE ENDS ...")
            })
    }
}

//MARK: - Setup UI
extension WeatherDetailViewController {
    
    private func setupUI() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        //        weatherTableView.separatorStyle = .none
        weatherTableView.backgroundColor = .clear
        
        weatherTableView.register(UINib(nibName: "WeatherDetailTableViewCell",
                                        bundle: nil),
                                  forCellReuseIdentifier: "WeatherDetailTableViewCell")
        
        weatherTableView.register(UINib(nibName: "CustomFooterView",
                                        bundle: nil),
                                  forHeaderFooterViewReuseIdentifier: "CustomFooterView")
        
        weatherTableView.register(UINib(nibName: "CustomHeaderView",
                                        bundle: nil),
                                  forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
    }
    
    private func setupNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        
        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [ NSAttributedString.Key.font: FontsManager.systemBiggerSemiBold]
        let backImage = UIImage(systemName: "arrow.backward.circle.fill")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    private func setupFavouriteButton() {
        guard let title = self.navigationItem.title,
              let viewModel = viewModel else { return }
        
        isFavourite = viewModel.inputs.findLocationByCityName(cityName: title) != nil
    }
}

//MARK: - Table View Data Source
extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as? WeatherDetailTableViewCell
        guard let forecastItems = forecastItems else { return UITableViewCell() }
        let item = forecastItems[indexPath.row]
        
        cell?.setupCellUI(with: item)
        return cell ?? UITableViewCell()
    }
    
    //MARK: - Table View Custom Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooterView") as? CustomFooterView

        guard let footerView = footerView else { return nil }
        footerView.setupView(buttonType: favouriteButtonType)
        footerView.delegate = self
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Table View Custom Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderView
        
        guard let currentWeatherData = currentWeatherData,
              let headerView = headerView else { return nil }
        headerView.setupHeaderUI(currentWeatherData: currentWeatherData)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height / 4
    }
}

extension WeatherDetailViewController: CustomFooterViewDelegate {
    func didPressedFavouriteButton(isFavourite: Bool) {

        self.isFavourite = isFavourite
        guard let title = self.navigationItem.title else { return }

        switch isFavourite {
        case true:
            viewModel?.inputs.saveLocation(locationName: title)
        case false:
            let locationToDelete = viewModel?.inputs.findLocationByCityName(cityName: title)
            guard let locationToDelete = locationToDelete else {
                return
            }
            viewModel?.inputs.deleteLocation(location: locationToDelete)
        }
    }
}

//MARK: - Table View Delegate
extension WeatherDetailViewController: UITableViewDelegate {
}
