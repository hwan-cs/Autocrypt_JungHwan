//
//  SearchViewController.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import SwiftSpinner
import Combine
import Alamofire

class SearchViewController: UIViewController
{
    let tableView = UITableView()
    
    var cityList: [CityList] = []
    
    var filteredCityList: [CityList] = []
    
    private let disposeBag = DisposeBag()
    
    private var cancellable = Set<AnyCancellable>()
    
    var onDismissBlock : ((Bool, WeatherResult) -> Void)?
    
    private lazy var searchTextField: UISearchTextField =
    {
        let textField = UISearchTextField()
        textField.tintColor = .systemGray4
        textField.backgroundColor = .systemGray4
        textField.placeholder = "\tSearch"
        
        return textField
    }()
    
    @objc func didTapTableView()
    {
        searchTextField.resignFirstResponder()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = H.mainColor
        
        view.addSubview(searchTextField)

        searchTextField.snp.makeConstraints
        { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide).inset(12.0)
            make.height.equalTo(48.0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints
        { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
//        tableView.addGestureRecognizer(tap)
        
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else { return }
        
        let request = Resource<[CityList]>(url: url)

        URLRequest.load(resource: request)
            .catchAndReturn([CityList.empty])
            .subscribe
            { [weak self] result in
                self?.cityList = result
                self?.filteredCityList = self?.cityList ?? []
                self?.tableView.reloadData()
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
        
        self.searchTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .subscribe
            { txt in
                self.filteredCityList = self.cityList.filter{ $0.name!.hasPrefix(txt) }
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SwiftSpinner.show("Fetching weather for \(self.filteredCityList[indexPath.row].name!)", animated: true)
        
        guard let url = URL(string: self.makeLink(city: self.filteredCityList[indexPath.row])) else
        { SwiftSpinner.hide(); return }
        
        
        
        let request = Resource<WeatherResult>(url: url)

        URLRequest.load(resource: request)
            .catchAndReturn(WeatherResult.empty)
            .subscribe
            { [weak self] result in
                self!.dismiss(animated: true)
                {
                    self!.onDismissBlock!(true, result)
                    SwiftSpinner.hide()
                }
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

extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.filteredCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = self.filteredCityList[indexPath.row].name
        config.textProperties.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        config.textProperties.color = .white
        config.secondaryTextProperties.color = .white
        config.secondaryText = self.filteredCityList[indexPath.row].country
        cell.backgroundColor = .clear
        cell.contentConfiguration = config
        cell.selectionStyle = .none
        return cell
    }
}

extension SearchViewController
{
    func makeLink(city: CityList) -> String
    {
        return "https://api.openweathermap.org/data/2.5/weather?id=\(city.id!)&name=\(city.name!)&country=\(city.country!)&lon=\(city.coord!.lon!)&lat=\(city.coord!.lat!)&units=imperial&type=accurate&APPID=\(H.APIKEY)"
    }
}
