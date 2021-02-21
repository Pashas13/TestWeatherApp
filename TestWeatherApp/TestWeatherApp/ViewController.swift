//
//  ViewController.swift
//  TestWeatherApp
//
//  Created by Pasha on 15.02.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - IBOtlets
    
    @IBOutlet weak var backgroundViewTopConstr: NSLayoutConstraint!
    @IBOutlet weak var backgroundMainImageView: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var rangeTempLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var topCollViewLine: UIView!
    @IBOutlet weak var bottomCollViewLine: UIView!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var backgroundTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Public properties
    
    private var location = CLLocation()
    private let locationManager = CLLocationManager()
    private let apiKey = "&key=82d6ee2021ed4bfc9ef542ee2853ca5f"
    var forecast: WeatherData?
    var urlString: String = ""
    var partOfString: String = ""
    let dateformatter = DateFormatter()
    var weather: ForecastModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.tableView.reloadData()
                self.setValues()
            }
        }
    }
    let userDefaultsManager = UserDefaultsManager()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextView.appearance().linkTextAttributes = [ .foregroundColor: UIColor.white ]
        if let weather = userDefaultsManager.weather {
            self.weather = weather
        }
        setValues()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        location = locationManager.location ?? CLLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        upSwipeGesture.direction = .up
        view.addGestureRecognizer(upSwipeGesture)
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        downSwipeGesture.direction = .down
        view.addGestureRecognizer(downSwipeGesture)
        
        let lon = location.coordinate.longitude
        let lat = location.coordinate.latitude
        
        urlString = "https://api.weatherbit.io/v2.0/forecast/daily&hourly?lat=\(String(describing: lat))&lon=\(String(describing: lon))" + apiKey + "&days=\(9)"
        print(urlString)
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, responds, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                if let data = data {
                    if let weatherDataResponds = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        self.forecast = weatherDataResponds
                        DispatchQueue.main.async { [self] in
                            if let forecast = self.forecast {
                                var hourlyWeather = [HourlyWeather]()
                                var dailyWeather = [DailyWeather]()
                                for element in forecast.data {
                                    var day = ""
                                    var dayOfWeek = ""
                                    let dateformatter = DateFormatter()
                                    dateformatter.dateFormat = "yyyy-MM-dd"
                                    let string = element.date
                                    if let date = dateformatter.date(from: string) {
                                        dateformatter.dateFormat = "dd"
                                        day = "\(dateformatter.string(from: date))"
                                        dateformatter.dateFormat = "yyyy-MM-dd"
                                    }
                                    if let date = dateformatter.date(from: string) {
                                        dateformatter.dateFormat = "EEEE"
                                        dayOfWeek = "\(dateformatter.string(from: date))"
                                    }
                                    let temp = Int(element.temp)
                                    let minTemp = Int(element.minTemp)
                                    let maxTemp = Int(element.maxTemp)
                                    let weather = HourlyWeather(date: day, icon: element.weather.icon, temp: temp)
                                    hourlyWeather.append(weather)
                                    let dayWeather = DailyWeather(day: dayOfWeek, icon: element.weather.icon, minTemp: minTemp, maxTemp: maxTemp)
                                    dailyWeather.append(dayWeather)
                                }
                                let city = "\(forecast.timeZone)".components(separatedBy: "/").last ?? "aaa"
                                let fullDescription = "Today: \(forecast.data[1].weather.description). The low temp will be \(dailyWeather[1].maxTemp)°. Wind direction: \(forecast.data[1].windDirection)."
                                let sunrise = Date(timeIntervalSince1970: TimeInterval(forecast.data[1].sunrise))
                                let sunset = Date(timeIntervalSince1970: TimeInterval(forecast.data[1].sunset))
                                let formatter = DateFormatter()
                                formatter.dateStyle = .none
                                formatter.timeStyle = .short
                                let formattedSunrise = formatter.string(from: sunrise)
                                let formattedSunset = formatter.string(from: sunset)
                                let snow = Int(forecast.data[1].snow)
                                let feelsLike = Int(forecast.data[1].feelsLike)
                                let wind = "\(forecast.data[1].windCdir) \(Int(forecast.data[1].windSpeed)) m/s"
                                let precipitation = Int(forecast.data[1].precipitation)
                                let index = Int(forecast.data[1].uvIndex)
                                let weather = ForecastModel(hourlyWeather: hourlyWeather, city: city, descr: forecast.data[1].weather.description, currentTemp: hourlyWeather[1].temp, minTemp: dailyWeather[1].minTemp, maxTemp: dailyWeather[1].maxTemp, dailyWeather: dailyWeather, fullDescription: fullDescription, sunrise: formattedSunrise, sunset: formattedSunset, snow: snow, humidity: forecast.data[1].humidity, wind: wind, feelsLike: feelsLike, precipitation: precipitation, pressure: forecast.data[1].pressure, visibility: forecast.data[1].visibility, index: index, street: forecast.cityName)
                                self.weather = weather
                                userDefaultsManager.weather = weather
                            } else {
                                return
                            }
                        }
                    } else {
                        print("error")
                    }
                }
            }
            dataTask.resume()
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundMainImageView.image = UIImage(named: "main_image")
        blurEffectView.alpha = 0.3
        bottomLineView.alpha = 0.5
        bottomCollViewLine.alpha = 0.5
        topCollViewLine.alpha = 0.5
        websiteButton.alpha = 0.5
        tableView.allowsSelection = false
    }
    
    // MARK: - Flow functions
    
    @objc func swipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            swipeUP()
        case .down:
            swipeDown()
        default:
            return
        }
    }
    
    func swipeUP() {
        if self.backgroundTableView.frame.origin.y == self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.height {
            return
        } else {
            self.backgroundViewTopConstr.constant -= 170
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
                self.view.layoutIfNeeded()
                self.rangeTempLabel.alpha = 0
                self.mainTempLabel.alpha = 0
            })
            { (result) in
            }
        }
    }
    
    func swipeDown() {
        if self.backgroundTableView.frame.origin.y == self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.height + 170 {
            return
        } else {
            self.backgroundViewTopConstr.constant += 170
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
                self.view.layoutIfNeeded()
                self.rangeTempLabel.alpha = 1
                self.mainTempLabel.alpha = 1
            }) { (result) in
            }
        }
    }
    
    func setValues() {
        guard let weather = weather else { return }
        self.currentLocationLabel.text = weather.city
        self.mainTempLabel.text = "\(weather.currentTemp)°"
        self.descriptionLabel.text = weather.descr
        self.rangeTempLabel.text = "H:\(weather.maxTemp)°  L: \(weather.minTemp)°"
    }
    
}

// MARK: - Extension UICollectionView

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        if let weather = weather {
            cell.imageView.image = UIImage(named: weather.hourlyWeather[indexPath.row].icon)
            cell.hoursLabel.text = weather.hourlyWeather[indexPath.row].date
            cell.tempLabel.text = "\(weather.hourlyWeather[indexPath.row].temp)"
        }
        return cell
    }
}

// MARK: - Extension CLLocationManager

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            _ = location.coordinate.latitude
            _ = location.coordinate.longitude
        }
    }
}

// MARK: - Extension UITableView

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
                return 7
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell else {
                return UITableViewCell()
            }
            if let weather = weather {
                cell.dateLabel.text = weather.dailyWeather[indexPath.row].day
                cell.descriptionImage.image = UIImage(named: weather.dailyWeather[indexPath.row].icon)
                cell.maxTempLabel.text = "\(weather.dailyWeather[indexPath.row].maxTemp)"
                cell.minTempLabel.text = "\(weather.dailyWeather[indexPath.row].minTemp)"
            }
            return cell
        } else if indexPath.section == 1 {
            guard let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SecondTableViewCell.self), for: indexPath) as? SecondTableViewCell else {
                return UITableViewCell()
            }
            if let weather = weather {
                secondCell.label.text = weather.fullDescription
            }
            return secondCell
        } else if indexPath.section == 2 {
            guard let thirdCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ThirdTableViewCell.self), for: indexPath) as? ThirdTableViewCell else {
                return UITableViewCell()
            }
            thirdCell.sunriseLabel.text = "SUNRISE"
            if let weather = weather {
                thirdCell.descriptionLabel.text = weather.sunrise
            }
            return thirdCell
        } else if indexPath.section == 3 {
            guard let fourthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: FourthTableViewCell.self), for: indexPath) as? FourthTableViewCell else {
                return UITableViewCell()
            }
            fourthCell.sunsetLabel.text = "SUNSET"
            if let weather = weather {
                fourthCell.descriptionLabel.text = weather.sunset
            }
            return fourthCell
        } else if indexPath.section == 4 {
            guard let fifthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: FifthTableViewCell.self), for: indexPath) as? FifthTableViewCell else {
                return UITableViewCell()
            }
            fifthCell.chanceOfSnowLabel.text = "CHANCE OF SNOW"
            if let weather = weather {
                fifthCell.descriptionLabel.text = "\(weather.snow) %"
            }
            return fifthCell
        } else if indexPath.section == 5 {
            guard let sixthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SixthTableViewCell.self), for: indexPath) as? SixthTableViewCell else {
                return UITableViewCell()
            }
            sixthCell.humidityLabel.text = "HUMIDITY"
            if let weather = weather {
                sixthCell.descriptionLabel.text = "\(weather.humidity) %"
            }
            return sixthCell
        } else if indexPath.section == 6 {
            guard let seventhCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SeventhTableViewCell.self), for: indexPath) as? SeventhTableViewCell else {
                return UITableViewCell()
            }
            seventhCell.windLabel.text = "WIND"
            if let weather = weather {
                seventhCell.descriptionLabel.text = weather.wind
            }
            return seventhCell
        } else if indexPath.section == 7 {
            guard let eighthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EighthTableViewCell.self), for: indexPath) as? EighthTableViewCell else {
                return UITableViewCell()
            }
            eighthCell.feelsLikeLabel.text = "FEELS LIKE"
            if let weather = weather {
                eighthCell.descriptionLabel.text = "\(weather.feelsLike)°"
            }
            return eighthCell
        } else if indexPath.section == 8 {
            guard let ninthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NinthTableViewCell.self), for: indexPath) as? NinthTableViewCell else {
                return UITableViewCell()
            }
            ninthCell.precipitationLabel.text = "PRECIPITATION"
            if let weather = weather {
                ninthCell.descriptionLabel.text = "\(weather.precipitation) cm"
            }
            return ninthCell
        } else if indexPath.section == 9 {
            guard let tenthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TenthTableViewCell.self), for: indexPath) as? TenthTableViewCell else {
                return UITableViewCell()
            }
            tenthCell.pressureLabel.text = "PRESSURE"
            if let weather = weather {
                tenthCell.descriptionLabel.text = "\(weather.pressure) mm Hg"
            }
            return tenthCell
        } else if indexPath.section == 10 {
            guard let eleventhCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EleventhTableViewCell.self), for: indexPath) as? EleventhTableViewCell else {
                return UITableViewCell()
            }
            eleventhCell.visibilityLabel.text = "VISIBILITY"
            if let weather = weather {
                eleventhCell.descriptionLabel.text = "\(weather.visibility) km"
            }
            return eleventhCell
        } else if indexPath.section == 11 {
            guard let twelfthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TwelfthTableViewCell.self), for: indexPath) as? TwelfthTableViewCell else {
                return UITableViewCell()
            }
            twelfthCell.uvIndexLabel.text = "UV INDEX"
            if let weather = weather {
                twelfthCell.descriptionLabel.text = "\(weather.index)"
            }
            return twelfthCell
        } else if indexPath.section == 12 {
            guard let thirteenthCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ThirteenthTableViewCell.self), for: indexPath) as? ThirteenthTableViewCell else {
                return UITableViewCell()
            }
            if let weather = weather {
                thirteenthCell.descriptionLabel.text = "Weather for \(weather.street)"
                if let link = URL(string: "https://yandex.by/maps") {
                    let linkAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.link : link, NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
                    let attributedString = NSMutableAttributedString(string: "Open in Maps", attributes: linkAttributes)
                    thirteenthCell.textView.attributedText = attributedString
                }
            }
            return thirteenthCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 35
        } else if indexPath.section == 1 {
            return 90
        } else {
            return 65
        }
    }
}
