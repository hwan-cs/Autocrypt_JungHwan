//
//  ViewController.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/11.
//

import UIKit
import SnapKit
import MapKit

class MainViewController: UIViewController
{
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
        self.present(nv, animated: true)
    }
    
    private lazy var cityLabel: UILabel =
    {
        let cityLabel = UILabel()
        
        cityLabel.font = UIFont.systemFont(ofSize: 50.0, weight: .regular)
        cityLabel.textColor = .white
        cityLabel.text = "Seoul"
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
        dfStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        dfStackView.isLayoutMarginsRelativeArrangement = true
        dfStackView.spacing = 4
        
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
    
    let moreInfoStackView: UIStackView =
    {
        let miStackView = UIStackView()
        miStackView.axis = .vertical
        miStackView.alignment = .center
        miStackView.distribution = .equalSpacing
        
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
                lbl.text = "습도"
                lbl.textColor = .white
                
                infoView.addSubview(lbl)
                
                lbl.snp.makeConstraints
                { make in
                    make.centerX.centerY.equalToSuperview()
                }
                
                hStackView.addArrangedSubview(infoView)
                infoView.snp.makeConstraints
                { make in
                    make.width.equalTo(hStackView.snp.width).dividedBy(2).inset(4.0)
                    make.height.equalTo(hStackView.snp.width).dividedBy(2).inset(4.0)
                }
            }
            miStackView.addArrangedSubview(hStackView)
            hStackView.snp.makeConstraints
            { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(miStackView.snp.height).dividedBy(2)
            }
        }

        return miStackView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("vdl")
        attribute()
        setupLayout()
        print(scrollView.contentSize.width)
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
    
    func dailyForecastMinMaxString(min: Int, max: Int) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: "최소:\(min)º 최대:\(max)º")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray3, range: NSRange(location: 0, length: 4+String(min).count))
        let maxIdx = attributedString.string.firstIndex(of: " ")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: (maxIdx?.utf16Offset(in: attributedString.string))!+1, length: 4+String(max).count))
        return attributedString
    }
    
//    func alertError() {
//        let alertController = UIAlertController(title: "Error", message: "City not found", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default) {
//            _ in
//            self.textField.text = ""
//            self.textField.becomeFirstResponder()
//        })
//        present(alertController, animated: true, completion: nil)
//    }

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
        
        for cnt in 0..<25
        {
            let iconView = UIView()
            let timeLabel: UILabel =
            {
                let label = UILabel()
                label.text = "\(cnt < 12 ? "오전" : "오후") \(cnt%13)시"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 12.0)
                label.textColor = .white
                return label
            }()
            
            iconView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints
            { make in
                make.top.equalTo(iconView.snp.top).offset(4.0)
                make.left.right.equalToSuperview()
            }
            
            let imageView: UIImageView =
            {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "01d.png")
                return imageView
            }()
            
            iconView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(8.0)
                make.left.right.equalToSuperview()
                make.width.equalTo(50.0)
                make.height.equalTo(30.0)
                make.centerX.equalToSuperview()
            }
            let label: UILabel =
            {
                let label = UILabel()
                label.text = "\(cnt+1)"
                label.textColor = .white
                label.font = .systemFont(ofSize: 12.0)
                return label
            }()

            iconView.addSubview(label)
            label.snp.makeConstraints
            { make in
                make.top.equalTo(imageView.snp.bottom).offset(8)
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
            make.height.equalTo(250.0)
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
            make.top.equalTo(sline2.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        for d in ["오늘", "수", "목", "금", "토"].enumerated()
        {
            let forecastView = UIView()
            
            let forecastDate = UILabel()
            forecastDate.text = d.element
            forecastDate.font = UIFont.systemFont(ofSize: 16.0)
            forecastDate.textColor = .white
            forecastView.addSubview(forecastDate)
            
            forecastDate.snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.top).offset(4.0)
                make.leading.equalToSuperview().inset(12.0)
                make.width.equalTo(100.0)
            }
            
            let forecastImageView: UIImageView =
            {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "01d.png")
                return imageView
                
            }()
            
            forecastView.addSubview(forecastImageView)
            forecastImageView.snp.makeConstraints
            { make in
                make.top.equalTo(forecastView.snp.top)
                make.width.equalTo(50.0)
                make.height.equalTo(forecastView.snp.height)
                make.centerX.equalTo(forecastView.snp.centerX).multipliedBy(0.75)
            }
            
            let forecastTemperature = UILabel()
            forecastTemperature.attributedText = self.dailyForecastMinMaxString(min: -7, max: 11)
            forecastTemperature.font = UIFont.systemFont(ofSize: 16.0)
            forecastTemperature.sizeToFit()
            
            forecastView.addSubview(forecastTemperature)
            
            forecastTemperature.snp.makeConstraints
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
            
            if d.offset == 4
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
        
        let pin = MKPointAnnotation()
        pin.title = "Pin"
        pin.coordinate = CLLocationCoordinate2D(latitude: 36.78361, longitude: 127.004173)
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
    }
}
