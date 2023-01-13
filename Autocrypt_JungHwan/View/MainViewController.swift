//
//  ViewController.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/11.
//

import UIKit
import SnapKit
import MapKit
import Combine
import RxSwift

class MainViewController: UIViewController
{
    private let disposeBag = DisposeBag()
    
    private let day = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let moreInfo = ["습도", "구름", "바람 속도", "기압"]
    
    private lazy var scrollView: UIScrollView =
    {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tap)
        
        return scrollView
    }()
    
    @objc func didTapScrollView()
    {
        searchTextField.resignFirstResponder()
    }
    
    private let contentView = UIView()
        
    private lazy var searchTextField: UISearchTextField =
    {
        let textField = UISearchTextField()
        textField.tintColor = .systemGray4
        textField.backgroundColor = .systemGray4
        textField.placeholder = "\tSearch"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentSearchVC))
        textField.addGestureRecognizer(tap)
        
        return textField
    }()

    @objc func presentSearchVC()
    {
        let nv = SearchViewController()
        nv.modalPresentationStyle = .fullScreen
        nv.onDismissBlock =
        { success, result, city in
            if success
            {
                self.weatherResult = result
                self.cityLabel.text = city.name!
                self.currentTemperatureLabel.text = "\(self.weatherResult!.current.temp)º"
                self.weatherStatusLabel.text = self.weatherResult!.current.weather.last!.main
                self.minMaxTemperatureLabel.text = self.minMaxTempString(min: Int(self.weatherResult!.daily!.last!.temp.min), max: Int(self.weatherResult!.daily!.last!.temp.max))
                self.weatherResult!.hourly!.reverse()
                for i in 0..<16
                {
                    self.hourlyForecastTemperatureLabel[i].text = "\(self.weatherResult!.hourly![i*3].temp)º"
                    self.hourlyForecastTimeLabel[i].text = "\(i == 0 ? "지금" : "\(i*3)시간 전")"
                    self.hourlyForecastImageView[i].image = UIImage(named: "\(self.weatherResult!.hourly![i*3].weather!.first!.icon).png")
                }
                
                for j in 0..<5
                {
                    let weekday = NSCalendar.current.component(.weekday, from: Date(timeIntervalSince1970: self.weatherResult!.daily![j].dt))
                    
                    self.dailyForecastDateLabel[j].text = "\(j == 0 ? "오늘" : self.day[weekday-1])"

                    self.dailyForecastImageView[j].image = UIImage(named: "\(self.weatherResult!.daily![j].weather.first!.icon).png")

                    let dailyMinMax = self.weatherResult!.daily![j].temp
                    self.dailyForecastMinMaxTemperatureLabel[j].attributedText = self.dailyForecastMinMaxString(min: dailyMinMax.min, max: dailyMinMax.max)
                }
                
                var idx = 0
                for k in 0..<2
                {
                    for l in 0..<2
                    {
                        switch idx
                        {
                        case 0:
                            self.moreInfoLabel[idx].text = "\(Int(self.weatherResult!.current.humidity))%"
                        case 1:
                            self.moreInfoLabel[idx].text = "\((Int(self.weatherResult!.current.clouds)))%"
                        case 2:
                            self.moreInfoLabel[idx].text = "\((self.weatherResult!.current.wind_speed))m/s"
                        case 3:
                            self.moreInfoLabel[idx].text = "\((Int(self.weatherResult!.current.clouds))) hpa"
                        default:
                            break
                        }
                        idx += 1
                    }
                }
                
                self.pin.title = city.name!
                self.pin.coordinate = CLLocationCoordinate2D(latitude: city.coord!.lat!, longitude: city.coord!.lon!)
                self.mapView.setCamera(MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: city.coord!.lat!, longitude: city.coord!.lon!), fromDistance: 10000, pitch: 1.0, heading: 0.0), animated: true)
            }
            else
            {
                print("couldnt load weather")
            }
        }
        self.present(nv, animated: true)
    }
    
    private lazy var cityLabel: UILabel =
    {
        let cityLabel = UILabel()
        
        cityLabel.font = UIFont.systemFont(ofSize: 50.0, weight: .regular)
        cityLabel.textColor = .white
        cityLabel.text = "Asan"
        cityLabel.sizeToFit()
        
        return cityLabel
    }()
    
    private lazy var currentTemperatureLabel: UILabel =
    {
        let ctLabel = UILabel()
        
        ctLabel.font = UIFont.systemFont(ofSize: 64.0, weight: .medium)
        ctLabel.textColor = .white
        ctLabel.text = "-7º"
        ctLabel.sizeToFit()
        
        return ctLabel
    }()
    
    private lazy var weatherStatusLabel: UILabel =
    {
        let wsLabel = UILabel()
        
        wsLabel.font = UIFont.systemFont(ofSize: 32.0, weight: .medium)
        wsLabel.textColor = .white
        wsLabel.text = "맑음"
        wsLabel.sizeToFit()
        
        return wsLabel
    }()
    
    private lazy var minMaxTemperatureLabel: UILabel =
    {
        let mMTLabel = UILabel()
        
        mMTLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        mMTLabel.textColor = .white
        mMTLabel.text = self.minMaxTempString(min: -1, max: -11)
        mMTLabel.sizeToFit()
        
        return mMTLabel
    }()
    
    private lazy var hourlyForecastView: UIView =
    {
        let view = UIView()
        view.layer.cornerRadius = 12.0
        view.backgroundColor = H.infoViewColor
        
        return view
    }()
    
    private lazy var hourlyForecastScrollView: UIScrollView =
    {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.cornerRadius = 12.0
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private lazy var hourlyForecastStackView: UIStackView =
    {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var hourlyForecastTimeLabel: [UILabel] =
    {
        var arr = [UILabel]()
        for _ in 0..<16
        {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12.0)
            label.textColor = .white
            arr.append(label)
        }
        return arr
    }()
    
    private lazy var hourlyForecastImageView: [UIImageView] =
    {
        var arr = [UIImageView]()
        for _ in 0..<16
        {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            arr.append(imageView)
        }
        return arr
    }()
    
    private lazy var hourlyForecastTemperatureLabel: [UILabel] =
    {
        var arr = [UILabel]()
        for _ in 0..<16
        {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 12.0)
            arr.append(label)
        }
        return arr
    }()
    
    private lazy var hourlyForecastDescriptionLabel: UILabel =
    {
        let hfdLabel = UILabel()
        hfdLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        hfdLabel.textColor = .white
        hfdLabel.text = "돌풍의 풍속은 최대 4m/s 입니다."
        hfdLabel.sizeToFit()
        return hfdLabel
    }()
    
    func separatorLine() -> UIView
    {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.snp.makeConstraints
        { make in
            make.height.equalTo(1.0)
        }
        return separator
    }
    
    private lazy var dailyForecastView: UIView =
    {
        let dfView = UIView()
        dfView.layer.cornerRadius = 12.0
        dfView.backgroundColor = H.infoViewColor
        
        return dfView
    }()
    
    private lazy var dailyForecastDateLabel: [UILabel] =
    {
        var arr = [UILabel]()
        for _ in 0..<5
        {
            let forecastDate = UILabel()
            forecastDate.font = UIFont.systemFont(ofSize: 16.0)
            forecastDate.textColor = .white
            arr.append(forecastDate)
        }
        return arr
    }()
    
    private lazy var dailyForecastImageView: [UIImageView] =
    {
        var arr = [UIImageView]()
        for _ in 0..<5
        {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            arr.append(imageView)
        }
        return arr
    }()
    
    private lazy var dailyForecastMinMaxTemperatureLabel: [UILabel] =
    {
        var arr = [UILabel]()
        for _ in 0..<5
        {
            let forecastTemperature = UILabel()
            forecastTemperature.font = UIFont.systemFont(ofSize: 16.0)
            forecastTemperature.sizeToFit()
            arr.append(forecastTemperature)
        }
        return arr
    }()
    
    private lazy var dailyForecastDescriptionLabel: UILabel =
    {
        let dfdLabel = UILabel()
        dfdLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        dfdLabel.textColor = .white
        dfdLabel.text = "5일간의 일기예보"
        dfdLabel.sizeToFit()
        
        return dfdLabel
    }()
    
    private lazy var dailyForecastStackView: UIStackView =
    {
        let dfStackView = UIStackView()
        dfStackView.axis = .vertical
        dfStackView.alignment = .center
        dfStackView.distribution = .equalSpacing
        dfStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        dfStackView.isLayoutMarginsRelativeArrangement = true
//        dfStackView.spacing = 4
        
        return dfStackView
    }()
    
    private lazy var rainfallLabel: UILabel =
    {
        let rfLabel = UILabel()
        rfLabel.text = "강수량"
        rfLabel.textColor = .white
        rfLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        rfLabel.sizeToFit()
        
        return rfLabel
    }()
    
    private lazy var weatherMapView: UIView =
    {
        let wmView = UIView()
        wmView.layer.cornerRadius = 12.0
        wmView.backgroundColor = H.infoViewColor
        
        return wmView
    }()
    
    private lazy var mapView: MKMapView =
    {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    private lazy var pin: MKPointAnnotation =
    {
        let pin = MKPointAnnotation()
        pin.title = "Asan"
        pin.coordinate = CLLocationCoordinate2D(latitude: 36.78361, longitude: 127.004173)
        return pin
    }()
    
    let moreInfoStackView: UIStackView =
    {
        let miStackView = UIStackView()
        miStackView.axis = .vertical
        miStackView.alignment = .center
        miStackView.distribution = .equalSpacing

        return miStackView
    }()
    
    private lazy var moreInfoLabel: [UILabel] =
    {
        var arr = [UILabel]()
        for _ in 0..<4
        {
            let moreInfoLabel = UILabel()
            moreInfoLabel.font = UIFont.systemFont(ofSize: 32.0, weight: .medium)
            moreInfoLabel.sizeToFit()
            moreInfoLabel.textColor = .systemGray3
            arr.append(moreInfoLabel)
        }
        return arr
    }()
    
    var weatherResult: WeatherResult?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.attribute()
        
        guard let url = URL(string: self.makeLink(city: CityList(id: 1839726, name: "Asan", coord: Coord(lon: 127.004173, lat: 36.7836113), country: "KR"))) else { return }
        
        print(url)
        
        let request = Resource<WeatherResult>(url: url)

        URLRequest.load(resource: request)
            .catchAndReturn(WeatherResult.empty)
            .subscribe
            { result in
                self.weatherResult = result
                self.weatherResult!.hourly!.reverse()
                
                self.setupLayout()
                
                self.currentTemperatureLabel.text = "\(self.weatherResult!.current.temp)º"
                self.weatherStatusLabel.text = self.weatherResult!.current.weather.last!.main
                self.minMaxTemperatureLabel.text = self.minMaxTempString(min: Int(self.weatherResult!.daily!.last!.temp.min), max: Int(self.weatherResult!.daily!.last!.temp.max))
            }
            onError:
            { error in
                print(error.localizedDescription)
            }
            onCompleted:
            {
                print("Completed")
            }
            onDisposed:
            {
                print("Disposed")
            }.disposed(by: disposeBag)
    }
}

private extension MainViewController
{
    func kelvinToCelsius(kValue: Float) -> String
    {
        let celsius = kValue - 273.15
        return String(format: "%.0f", celsius)
    }
    
    func minMaxTempString(min: Int, max: Int) -> String
    {
        return "최고: \(max)º | 최저: \(min)º"
    }
    
    func makeLink(city: CityList) -> String
    {
        return "https://api.openweathermap.org/data/2.5/onecall?lat=\(city.coord!.lat!)&lon=\(city.coord!.lon!)&exclude=minutely,alerts&units=metric&appid=\(H.APIKEY)"
    }
    
    func dailyForecastMinMaxString(min: Double, max: Double) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: "최소:\(min)º 최대:\(max)º")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray3, range: NSRange(location: 0, length: 4+String(min).count))
        let maxIdx = attributedString.string.firstIndex(of: " ")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: (maxIdx?.utf16Offset(in: attributedString.string))!+1, length: 4+String(max).count))
        return attributedString
    }

    func attribute()
    {
        view.backgroundColor = H.mainColor
    }
    
    func setupLayout()
    {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints
        { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints
        { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(searchTextField)

        searchTextField.snp.makeConstraints
        { make in
            make.leading.top.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(48.0)
        }
        
        [cityLabel, currentTemperatureLabel, weatherStatusLabel, minMaxTemperatureLabel].forEach
        {
            contentView.addSubview($0)
            $0.snp.makeConstraints
            { make in
                make.centerX.equalTo(view.snp.centerX)
            }
        }
        
        cityLabel.snp.makeConstraints
        { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(32.0)
        }
        
        currentTemperatureLabel.snp.makeConstraints
        { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(24.0)
        }
        
        weatherStatusLabel.snp.makeConstraints
        { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(24.0)
        }
        
        minMaxTemperatureLabel.snp.makeConstraints
        { make in
            make.top.equalTo(weatherStatusLabel.snp.bottom).offset(8.0)
        }
        
        contentView.addSubview(hourlyForecastView)
        hourlyForecastView.snp.makeConstraints
        { make in
            make.top.equalTo(minMaxTemperatureLabel.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
            make.height.equalTo(150.0)
        }
        
        hourlyForecastView.addSubview(hourlyForecastDescriptionLabel)
        hourlyForecastDescriptionLabel.snp.makeConstraints
        { make in
            make.top.equalTo(hourlyForecastView.snp.top).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
        }
        
        let sline1 = separatorLine()
        hourlyForecastView.addSubview(sline1)
        sline1.snp.makeConstraints
        { make in
            make.top.equalTo(hourlyForecastDescriptionLabel.snp.bottom).offset(12.0)
            make.leading.trailing.equalTo(contentView).inset(24.0)
        }
        
        for cnt in 0..<16
        {
            let iconView = UIView()
            
            hourlyForecastTimeLabel[cnt].text = "\(cnt == 0 ? "지금" : "\(cnt*3)시간 전")"
            
            iconView.addSubview(hourlyForecastTimeLabel[cnt])
            hourlyForecastTimeLabel[cnt].snp.makeConstraints
            { make in
                make.top.equalTo(iconView.snp.top).offset(4.0)
                make.left.right.equalToSuperview()
            }
        
            hourlyForecastImageView[cnt].image = UIImage(named: "\(self.weatherResult!.hourly![cnt*3].weather!.first!.icon).png")
            
            iconView.addSubview(hourlyForecastImageView[cnt])
            hourlyForecastImageView[cnt].snp.makeConstraints
            { make in
                make.top.equalTo(hourlyForecastTimeLabel[cnt].snp.bottom).offset(8.0)
                make.left.right.equalToSuperview()
                make.width.equalTo(50.0)
                make.height.equalTo(30.0)
                make.centerX.equalToSuperview()
            }
            
            hourlyForecastTemperatureLabel[cnt].text = "\(self.weatherResult!.hourly![cnt*3].temp)º"
            
            iconView.addSubview(hourlyForecastTemperatureLabel[cnt])
            hourlyForecastTemperatureLabel[cnt].snp.makeConstraints
            { make in
                make.top.equalTo(hourlyForecastImageView[cnt].snp.bottom).offset(8)
                make.bottom.centerX.equalToSuperview()
            }
            // stackView에 추가
            hourlyForecastStackView.addArrangedSubview(iconView)
        }

        hourlyForecastScrollView.addSubview(hourlyForecastStackView)

        hourlyForecastStackView.snp.makeConstraints
        { make in
            make.top.left.right.bottom.height.equalToSuperview()
        }
        
        hourlyForecastView.addSubview(hourlyForecastScrollView)
        
        hourlyForecastScrollView.snp.makeConstraints
        { make in
            make.top.equalTo(sline1.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        hourlyForecastScrollView.contentSize = hourlyForecastStackView.frame.size
        
        contentView.addSubview(dailyForecastView)
        dailyForecastView.snp.makeConstraints
        { make in
            make.top.equalTo(hourlyForecastView.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
            make.height.equalTo(275.0)
        }
        
        dailyForecastView.addSubview(dailyForecastDescriptionLabel)
        dailyForecastDescriptionLabel.snp.makeConstraints
        { make in
            make.top.equalTo(dailyForecastView.snp.top).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
        }
        
        let sline2 = separatorLine()
        dailyForecastView.addSubview(sline2)
        sline2.snp.makeConstraints
        { make in
            make.top.equalTo(dailyForecastDescriptionLabel.snp.bottom).offset(12.0)
            make.leading.trailing.equalTo(contentView).inset(24.0)
        }
        
        dailyForecastView.addSubview(dailyForecastStackView)
        
        dailyForecastStackView.snp.makeConstraints
        { make in
            make.top.equalTo(sline2.snp.bottom).offset(4.0)
            make.left.right.bottom.equalToSuperview()
        }
        
        for d in 0..<5
        {
            let forecastView = UIView()
            
            let weekday = NSCalendar.current.component(.weekday, from: Date(timeIntervalSince1970: self.weatherResult!.daily![d].dt))
            
            self.dailyForecastDateLabel[d].text = "\(d == 0 ? "오늘" : day[weekday-1])"
            
            forecastView.addSubview(self.dailyForecastDateLabel[d])
            
            self.dailyForecastDateLabel[d].snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.top).offset(4.0)
                make.leading.equalToSuperview().inset(12.0)
                make.width.equalTo(100.0)
            }
            
            dailyForecastImageView[d].image = UIImage(named: "\(self.weatherResult!.daily![d].weather.first!.icon).png")

            forecastView.addSubview(dailyForecastImageView[d])
            dailyForecastImageView[d].snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.top)
                make.width.equalTo(30.0)
                make.height.equalTo(forecastView.snp.height)
                make.centerX.equalTo(forecastView.snp.centerX).multipliedBy(0.75)
            }

            let dailyMinMax = self.weatherResult!.daily![d].temp
            dailyForecastMinMaxTemperatureLabel[d].attributedText = self.dailyForecastMinMaxString(min: dailyMinMax.min, max: dailyMinMax.max)

            forecastView.addSubview(dailyForecastMinMaxTemperatureLabel[d])

            dailyForecastMinMaxTemperatureLabel[d].snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.top).offset(4.0)
                make.trailing.equalTo(forecastView.snp.trailing)
            }

            dailyForecastStackView.addArrangedSubview(forecastView)

            forecastView.snp.makeConstraints
            { make in
                make.left.right.equalToSuperview().inset(8.0)
                make.height.equalTo(dailyForecastStackView.snp.height).multipliedBy(0.15)
            }

            let sline = separatorLine()

            if d == 4
            {
                continue
            }

            dailyForecastStackView.addSubview(sline)

            sline.snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.bottom).offset(4.0)
                make.leading.trailing.equalTo(contentView).inset(24.0)
            }
        }
        
        contentView.addSubview(weatherMapView)
        
        weatherMapView.snp.makeConstraints
        { make in
            make.top.equalTo(dailyForecastView.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(12.0)
            make.height.equalTo(400.0)
        }
        
        weatherMapView.addSubview(rainfallLabel)
        
        rainfallLabel.snp.makeConstraints
        { make in
            make.top.equalTo(weatherMapView).offset(12.0)
            make.leading.equalTo(weatherMapView.snp.leading).offset(12.0)
        }
        
        weatherMapView.addSubview(mapView)
    
        mapView.addAnnotation(pin)
        
        mapView.snp.makeConstraints
        { make in
            make.top.equalTo(rainfallLabel.snp.bottom).offset(12.0)
            make.left.right.bottom.equalTo(weatherMapView).inset(12.0)
        }
        
        contentView.addSubview(moreInfoStackView)
        
        moreInfoStackView.snp.makeConstraints
        { make in
            make.top.equalTo(weatherMapView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(400.0)
            make.bottom.equalToSuperview()
        }
        
        var idx = 0
        for i in 0..<2
        {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.alignment = .center
            hStackView.distribution = .equalSpacing
            
            for j in 0..<2
            {
                let infoView = UIView()
                infoView.layer.cornerRadius = 12.0
                infoView.backgroundColor = H.infoViewColor
                
                let lbl = UILabel()
                lbl.text = self.moreInfo[idx]
                lbl.textColor = .white
                
                infoView.addSubview(lbl)
                
                lbl.snp.makeConstraints
                { make in
                    make.left.top.equalToSuperview().inset(8.0)
                }
                
                infoView.addSubview(self.moreInfoLabel[idx])
                
                self.moreInfoLabel[idx].snp.makeConstraints
                { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().inset(8.0)
                }
                
                switch idx
                {
                case 0:
                    self.moreInfoLabel[idx].text = "\(Int(self.weatherResult!.current.humidity))%"
                case 1:
                    self.moreInfoLabel[idx].text = "\((Int(self.weatherResult!.current.clouds)))%"
                case 2:
                    self.moreInfoLabel[idx].text = "\((self.weatherResult!.current.wind_speed))m/s"
                case 3:
                    self.moreInfoLabel[idx].text = "\((Int(self.weatherResult!.current.clouds))) hpa"
                default:
                    break
                }
                
                hStackView.addArrangedSubview(infoView)
                infoView.snp.makeConstraints
                { make in
                    make.width.equalTo(hStackView.snp.width).dividedBy(2).inset(4.0)
                    make.height.equalTo(hStackView.snp.width).dividedBy(2).inset(4.0)
                }
                
                idx += 1
            }
            moreInfoStackView.addArrangedSubview(hStackView)
            hStackView.snp.makeConstraints
            { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(moreInfoStackView.snp.height).dividedBy(2)
            }
        }
    }
}
