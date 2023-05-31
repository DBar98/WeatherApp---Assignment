//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import UIKit
import MapKit
import CoreLocation

enum SupportedMapType: String, CaseIterable {
    case standard = "Standard"
    case satellite = "Satellite"
    
    var mapType: MKMapType {
        get {
            switch self {
            case .satellite:
                return .satellite
            case .standard:
                return .standard
            }
        }
    }
}

class MapViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel: MapViewModelType?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var userCoordinates: CLLocationCoordinate2D?
    var chosenCity: String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupViewNavigation()
        setupSegmentedControl()
        setupLongPressGesture()
        setupLocationServices()
    }
}

//MARK: - Instantiate
extension MapViewController {
    static func instantiate() -> Self? {
        return UIStoryboard(name: "MapView", bundle: nil)
            .instantiateViewController(withIdentifier: "MapViewController") as? Self
    }
}

//MARK: - Setup UI
extension MapViewController {
    private func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(createNewAnnotation(_:)))
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupSegmentedControl() {
        mapSegmentedControl.removeAllSegments()
        for (idx, mapType) in SupportedMapType.allCases.enumerated() {
            mapSegmentedControl.insertSegment(withTitle: mapType.rawValue.localized(), at: idx, animated: false)
        }
        
        mapSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupViewNavigation() {
        self.navigationItem.backButtonTitle = ""
    }
}

//MARK: - IBAction functions
extension MapViewController {
    
    @IBAction func segmentedControlPressed(_ sender: Any) {
        let selectedMapType = SupportedMapType.allCases[mapSegmentedControl.selectedSegmentIndex].mapType
        mapView.mapType = selectedMapType
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        checkLocationAuthorization()
        showCurrentRegion()
    }
}

//MARK: - objc Functions
extension MapViewController {
    @objc func createNewAnnotation(_ sender: UIGestureRecognizer) {
        let touchPoint = sender.location(in: self.mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let heldPoint = MKPointAnnotation()
        heldPoint.coordinate = coordinates
        
        // Add annotation when long press started
        if (sender.state == .began) {
            
            viewModel?.inputs.addressByReverseGeocoding(latitude: coordinates.latitude,
                                      longitude: coordinates.longitude,
                                      completion: { [weak self] foundPlace in
                
                guard let self = self, let cityName = foundPlace?.locality else { return }
      
                heldPoint.title = cityName
                self.chosenCity = cityName
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(heldPoint)
            }, onError: { error in
                print(error)
            })
        }
        // Cancel the long press to make way for the next gesture
        sender.state = .cancelled
    }
}

//MARK: - Location Services
extension MapViewController {
    
    private func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied, .restricted:
            viewModel?.inputs.showAlert(title: "Missing permissions!",
                                        subtitle: CustomError.locationServicesUnable.localizedDescription)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    private func showCurrentRegion() {
        guard let userCoordinates = userCoordinates else {
            return
        }
        let region = viewModel?.outputs.showCurrentRegion(userCoordinates: userCoordinates, regionInMeters: regionInMeters)
        if let region = region {
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userCoordinates = locValue
    }
}

//MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinates = view.annotation?.coordinate else { return }
            
        if view.annotation is MKUserLocation {
            return
        } else {
            viewModel?.inputs.showWeatherDetail(coordinates: coordinates, cityName: chosenCity)
        }
    }
}
