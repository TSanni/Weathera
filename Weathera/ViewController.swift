//
//  ViewController.swift
//  Weathera
//
//  Created by Tomas Sanni on 6/18/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let vStack = UIStackView()
    
    // HStack and contents
    let topHStack = UIStackView()
    let locationButton = UIButton()
    let textfield = UITextField()
    let searchIcon = UIButton()
    
    // Weather image
    let conditionImage = UIImageView()
    
    // Temperauture HStack and contents
    let temperatureHStack = UIStackView()
    let temperatureLabel = UILabel()
    let degreeLabel = UILabel()
    let unitLabel = UILabel()

    // City label
    let cityLabelView  = UILabel()
    
    // Spacer
    let spacer = UIView()
    
    //  managers
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        configureVStack()
        configureTopHStack()
        configureConditionImage()
        configureTemperatureHStack()
        configureCityLabelAndSpacer()
        
        // Add tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
     }
    
    func configureVStack() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = .background
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 10
        vStack.contentMode = .scaleToFill
        vStack.alignment = .trailing
        vStack.addArrangedSubview(topHStack)
        vStack.addArrangedSubview(conditionImage)
        vStack.addArrangedSubview(temperatureHStack)
        vStack.addArrangedSubview(cityLabelView)
        vStack.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func locationButtonPressed(button: UIButton) {
        locationManager.startUpdatingLocation()
    }
    

    
    func configureTopHStack() {
        
        topHStack.addArrangedSubview(locationButton)
        topHStack.addArrangedSubview(textfield)
        topHStack.addArrangedSubview(searchIcon)
        topHStack.distribution = .fillProportionally
        topHStack.spacing = 10
        
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.tintColor = .label
        locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        
        textfield.placeholder = "Enter a location"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        textfield.textColor = .white
        
        searchIcon.tintColor = .label
        searchIcon.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            
            searchIcon.widthAnchor.constraint(equalToConstant: 40),
            searchIcon.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureConditionImage() {
        conditionImage.image = UIImage(systemName: "cloud.fill")?.withRenderingMode(.alwaysOriginal)
        conditionImage.translatesAutoresizingMaskIntoConstraints = false
        conditionImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            conditionImage.heightAnchor.constraint(equalToConstant: 120),
            conditionImage.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    func configureTemperatureHStack() {
        temperatureHStack.addArrangedSubview(temperatureLabel)
        temperatureHStack.addArrangedSubview(degreeLabel)
        temperatureHStack.addArrangedSubview(unitLabel)
        temperatureHStack.spacing = 0
        
        temperatureLabel.text = "21"
        temperatureLabel.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        temperatureLabel.textAlignment = .right
        
        degreeLabel.text = "°"
        degreeLabel.font = UIFont.systemFont(ofSize: 100, weight: .light)
        degreeLabel.textAlignment = .left
        
        unitLabel.text = "C"
        unitLabel.font = UIFont.systemFont(ofSize: 100, weight: .light)
        unitLabel.textAlignment = .left
        
    }
    
    func configureCityLabelAndSpacer() {
        cityLabelView.text = "London"
        cityLabelView.font = UIFont.systemFont(ofSize: 30)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfield.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textfield.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        textfield.text = ""
        
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Location manager authorization status raw value: \(manager.authorizationStatus.rawValue)" )
        
        switch manager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                locationManager.startUpdatingLocation()
                break
                
            case .restricted:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                
                break
                
            case .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                
                break
                
            case .notDetermined:  // Authorization not determined yet.
                
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)?.withRenderingMode(.alwaysOriginal)
            self.cityLabelView.text = weather.name
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

#Preview {
    ViewController()
}
