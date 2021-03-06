//
//  DailyTemperatureDetailViewController.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation
import UIKit
import Lottie

class DailyTemperatureDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //UI COMPONENTS
    @IBOutlet weak var tableView: UITableView!
    private var animationView: AnimationView?
    
    //VIEWMODEL
    public var dailyDataVM: DailyDataViewModel!
    public var dailyForecastVM: DailyForecastViewModel!
    
    //DATA
    public var day: String!
    private var specList = [WeatherDataSpec]()
    
    //CELL IDs
    let weatherDataSpecCell = "WeatherDataSpecCell"

    // MARK: - UIViewController Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:Constants.Font.bold, size:18)!]
        tableView.delegate = self
        tableView.dataSource = self
        adaptData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func adaptData(){
        self.title = day
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 280))
        
        //Animation
        let animationViewWidth = 150.0
        let animationView_x_value = (self.view.bounds.width - animationViewWidth) / 2.0
        let animationView_y_value = 15.0
        animationView = .init(name: dailyDataVM.weatherAnimationName)
        animationView!.frame = CGRect(x: animationView_x_value, y: animationView_y_value, width: animationViewWidth, height: animationViewWidth)
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView!.play()
        headerView.addSubview(animationView!)
        
        //Title
        let margin = 20.0
        let topMargin = getTopMarginForTitle(animationName: dailyDataVM.weatherAnimationName)
        let titleLabel = UILabel(frame: CGRect(x: margin, y: animationViewWidth + animationView_y_value + topMargin, width: self.view.bounds.width - (margin * 2), height: 37))
        titleLabel.font = UIFont(name:Constants.Font.bold, size:22)
        titleLabel.textColor = UIColor.black
        titleLabel.text = dailyDataVM.weather[0].main
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        
        //Subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: margin, y: titleLabel.frame.origin.y + titleLabel.frame.height , width: self.view.bounds.width - (margin * 2), height: 20))
        subtitleLabel.font = UIFont(name:Constants.Font.regular, size:16)
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.text = dailyDataVM.weather[0].weatherDescription
        subtitleLabel.textAlignment = .center
        headerView.addSubview(subtitleLabel)
        
        //Area
        let areaLabel = UILabel(frame: CGRect(x: margin, y: subtitleLabel.frame.origin.y + subtitleLabel.frame.height + 3, width: self.view.bounds.width - (margin * 2), height: 20))
        areaLabel.font = UIFont(name:Constants.Font.medium, size:16)
        areaLabel.textColor = UIColor.black
        areaLabel.text = "\(dailyForecastVM.city.name), \(dailyForecastVM.city.country)"
        areaLabel.textAlignment = .center
        headerView.addSubview(areaLabel)
        
        
        self.tableView.tableHeaderView = headerView
        if day.lowercased() == "today" {
            specList.append(WeatherDataSpec(title: "Current Temperature", value: "\( dailyDataVM.displayTemperature)"))
        }
        
        specList.append(WeatherDataSpec(title: "Max Temperature", value: "\( dailyDataVM.temp.max)??"))
        specList.append(WeatherDataSpec(title: "Min Temperature", value: "\( dailyDataVM.temp.min)??"))
        specList.append(WeatherDataSpec(title: "Pressure", value: "\( dailyDataVM.pressure)"))
        specList.append(WeatherDataSpec(title: "Humidity", value: "\( dailyDataVM.humidity)"))
        specList.append(WeatherDataSpec(title: "Speed", value: "\( dailyDataVM.speed)"))
        specList.append(WeatherDataSpec(title: "Deg", value: "\( dailyDataVM.deg)"))
        specList.append(WeatherDataSpec(title: "Gust", value: "\( dailyDataVM.gust)"))
        specList.append(WeatherDataSpec(title: "Clouds", value: "\( dailyDataVM.clouds)"))
        specList.append(WeatherDataSpec(title: "Pop", value: "\( dailyDataVM.pop)"))
        specList.append(WeatherDataSpec(title: "Rain", value: "\( dailyDataVM.rain)"))
        
        
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

    private func getTopMarginForTitle(animationName: String) -> CGFloat {
        if dailyDataVM.weatherAnimationName == "82377-raining" {
            return 5.0
        }
        else if dailyDataVM.weatherAnimationName == "22193-partly-cloudy" {
            return -25.0
        }
        else if dailyDataVM.weatherAnimationName == "82375-cloudy-weather" {
            return -30.0
        }
        return 0.0
    }
}
