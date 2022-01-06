//
//  DailyTemperatureDetailViewController.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation
import UIKit

class DailyTemperatureDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //UI COMPONENTS
    @IBOutlet weak var tableView: UITableView!
    
    //VIEWMODEL
    public var dailyDataVM: DailyDataViewModel!
    
    //DATA
    public var day: String!
    private var specList = [WeatherDataSpec]()
    
    //CELL IDs
    let weatherDataSpecCell = "WeatherDataSpecCell"

    // MARK: - UIViewController Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.delegate = self
        tableView.dataSource = self
        adaptData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func adaptData(){
        self.title = day
        
        specList.append(WeatherDataSpec(title: "pressure", value: "\( dailyDataVM.pressure)"))
        specList.append(WeatherDataSpec(title: "humidity", value: "\( dailyDataVM.humidity)"))
        specList.append(WeatherDataSpec(title: "speed", value: "\( dailyDataVM.speed)"))
        specList.append(WeatherDataSpec(title: "deg", value: "\( dailyDataVM.deg)"))
        specList.append(WeatherDataSpec(title: "gust", value: "\( dailyDataVM.gust)"))
        specList.append(WeatherDataSpec(title: "clouds", value: "\( dailyDataVM.clouds)"))
        specList.append(WeatherDataSpec(title: "pop", value: "\( dailyDataVM.pop)"))
        specList.append(WeatherDataSpec(title: "rain", value: "\( dailyDataVM.rain)"))
        
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.specList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let spec = self.specList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: weatherDataSpecCell, for: indexPath) as? WeatherDataSpecTableViewCell else {
            fatalError()
        }
        cell.titleLabel?.text = spec.title
        cell.valueLabel?.text = spec.value
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
