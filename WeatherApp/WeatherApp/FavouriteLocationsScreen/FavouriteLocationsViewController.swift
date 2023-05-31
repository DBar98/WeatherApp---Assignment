//
//  FavouriteLocationsViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//

import UIKit
import CoreLocation

class FavouriteLocationsViewController: BaseViewController {

    @IBOutlet weak var favouriteLocationsCollectionView: UICollectionView!
    var viewModel: FavouriteLocationsViewModelType?
    var favouriteLocations: [FavouriteLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupInputs()
        setupOutputs()
    }
    
    override func setupViewNavigation() {
        self.navigationItem.title = AppStrings.favourites
        super.setupViewNavigation()
    }
}

//MARK: - Instantiate
extension FavouriteLocationsViewController {
    static func instantiate() -> Self? {
        return UIStoryboard(name: "FavouriteLocationsView", bundle: nil)
            .instantiateViewController(withIdentifier: "FavouriteLocationsViewController") as? Self
    }
}

//MARK: - Setup UI
extension FavouriteLocationsViewController {
    private func setupUI() {
        setupViewNavigation()
        setupCollectionView()
        setupInputs()
        setupOutputs()
    }
    
    private func setupCollectionView() {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        
        self.favouriteLocationsCollectionView.dataSource = self
        self.favouriteLocationsCollectionView.delegate = self
        self.favouriteLocationsCollectionView.register(UINib(nibName: "FavouriteLocationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteLocationsCollectionViewCell")
        self.favouriteLocationsCollectionView.collectionViewLayout = collectionLayout
    }
}

//MARK: - Setup Inputs
extension FavouriteLocationsViewController {
    func setupInputs() {
        viewModel?.inputs.getFavouritesLocations()
    }
}

//MARK: - Setup Outputs
extension FavouriteLocationsViewController {
    func setupOutputs() {
        viewModel?.outputs.onLocationFound = { [weak self] in
            self?.favouriteLocations = $0
            
            DispatchQueue.main.async {
                self?.favouriteLocationsCollectionView.reloadData()
            }
        }
        
        viewModel?.outputs.onNoDataFound = { [weak self] in
            let alert = UIAlertController.showAlertWithCancelButton(title: ErrorStrings.error,
                                                                    message: $0)
            self?.present(alert,
                          animated: true,
                          completion: nil)
        }
    }
}

//MARK: - Collection View Data Source

extension FavouriteLocationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteLocationsCollectionViewCell", for: indexPath) as? FavouriteLocationsCollectionViewCell
        let favouriteLocation = favouriteLocations[indexPath.row]
        
        cell?.setupCellUI(favouriteLocation: favouriteLocation)
        return cell ?? UICollectionViewCell()
    }
}

extension FavouriteLocationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        return CGSize(width: collectionViewWidth/2.1, height: collectionViewWidth/2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favouriteLocation = favouriteLocations[indexPath.row]

        let coordinates = CLLocationCoordinate2D(latitude: favouriteLocation.latitude,
                                            longitude: favouriteLocation.longitude)
        viewModel?.inputs.showWeatherDetail(coordinates: coordinates, cityName: favouriteLocation.locationName)
    }
}

//MARK: - Collection View Delegate
extension FavouriteLocationsViewController: UICollectionViewDelegate {
    
}

