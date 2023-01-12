//
//  SearchViewController.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class SearchViewController: UIViewController
{
    let tableView = UITableView()
    
    var cityList: [CityList] = []
    
    private lazy var searchTextField: UISearchTextField =
    {
        let textField = UISearchTextField()
        textField.tintColor = .systemGray4
        textField.backgroundColor = .systemGray4
        textField.placeholder = "\tSearch"
        
        return textField
    }()
    
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
        
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else { return }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: .none).response
        { (responseData) in
            guard let data = responseData.data else { return }
            do
            {
                self.cityList = try JSONDecoder().decode([CityList].self, from: data)
                self.tableView.reloadData()
            }
            catch
            {
                print("cannot decode")
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate
{
    
}

extension SearchViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = self.cityList[indexPath.row].name
        config.textProperties.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        config.textProperties.color = .white
        config.secondaryTextProperties.color = .white
        config.secondaryText = self.cityList[indexPath.row].country
        cell.backgroundColor = .clear
        cell.contentConfiguration = config
        return cell
    }
    
    
}
