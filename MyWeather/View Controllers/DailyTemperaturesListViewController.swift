//
//  DailyTemperaturesListViewController.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation
import UIKit
import Combine
import Kingfisher
import Lottie
import CoreLocation

class DailyTemperaturesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //UI COMPONENTS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var headerTitleLabel: UILabel?
    private var headerSubtitleLabel: UILabel?
    private var headerTemperatureLabel: UILabel?
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var errorRefreshButton: UIButton!
    @IBOutlet weak var errorAnimationView: AnimationView!
    
    //VIEWMODELS
    private var dailyForecastVM: DailyForecastViewModel!
    private var dailyDataListVM = DailyDataListViewModel()
    
    //USER LOCATION
    var manager = CLLocationManager()
    var currentUserLocation : CLLocation?
    
    //OBSERVERS
    var customObservers: [AnyCancellable] = []
    
    //CELL IDs
    let dailyDataCell = "DailyDataCell"
    
    //SEGUE IDs
    let goToDetailPageSegue = "goToDetailPageSegue"

    // MARK: - UIViewController Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:Constants.Font.bold, size:18)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name:Constants.Font.bold, size:30)!]
        
        //UITableView config
        tableView.delegate = self
        tableView.dataSource = self
        
        //UI config
        createHeader()
        errorRefreshButton.titleLabel?.font = UIFont(name:Constants.Font.regular, size:14)
        errorAnimationView.contentMode = .scaleAspectFit
        errorAnimationView.loopMode = .loop
        errorAnimationView.animationSpeed = 0.5
        hideErrorView()
        
        //User location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //becauase tableview animations if you navigate to detail page then navigate back
        self.tableView.reloadData()
    }
    
    // MARK: - View controller Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == goToDetailPageSegue,
            let destination = segue.destination as? DailyTemperatureDetailViewController,
            let selectedIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.dailyDataVM = self.dailyDataListVM.dailyDataViewModelAtIndex(selectedIndex)
            destination.day = destination.dailyDataVM.getDay(index: selectedIndex)
            destination.dailyForecastVM = self.dailyForecastVM
        }   
    }
    
    // MARK: - Data
    private func fetchDailyForecastForArea(){
        guard let userLocation = currentUserLocation else {
            self.showErrorView(message: "Could not fetch weather forecast because user location could not be retrieved")
            return
        }
        showLoader()
        DailyForecastListViewModel.fetch(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, daysCount: Constants.AppConfig.ForecastDays)
            .receive(on: DispatchQueue.main)  // The tableView needs to be update on the main thread. So instead of doing DispatchQueue inside the receiveValue method, you can tell Combine to notify us on the main thread with this line
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("finished")
                case .failure(let error):
                    DebuggingLogger.printData(error)
                    self.showErrorView(message: error.message)
                   /* let alert = UIAlertController(title: "Error", message: "Something went wrong: \(error.message)", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                        self.fetchDailyForecastForArea()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))

                    self.present(alert, animated: true) */
                }
            }, receiveValue: { [weak self] value in
                //use weak self coz we dont want to cause a memory leak. We also want to avoid retain cycles
                DebuggingLogger.printData("DailyTemperaturesListViewController data: \(value)")
                self?.hideLoader()
                self?.dailyForecastVM = DailyForecastViewModel(value)
                self?.dailyDataListVM.dailyDataListViewModel = value.list.map(DailyDataViewModel.init)
                self?.adaptHeader()
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }).store(in: &customObservers)
    }
    
    //MARK: - Header
    private func createHeader(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        
        let margin = 20.0
        headerTitleLabel = UILabel(frame: CGRect(x: margin, y: 20, width: self.view.bounds.width - (margin * 2), height: 37))
        headerTitleLabel!.font = UIFont(name:Constants.Font.bold, size:22)
        headerTitleLabel!.textColor = UIColor.black
        headerTitleLabel!.textAlignment = .center
        headerView.addSubview(headerTitleLabel!)
        
        //Temperature
        headerTemperatureLabel = UILabel(frame: CGRect(x: margin, y: headerTitleLabel!.frame.origin.y + headerTitleLabel!.frame.height , width: self.view.bounds.width - (margin * 2), height: 46))
        headerTemperatureLabel!.font = UIFont(name:Constants.Font.bold, size:40)
        headerTemperatureLabel!.textColor = UIColor.black
        headerTemperatureLabel!.textAlignment = .center
        headerView.addSubview(headerTemperatureLabel!)
        
        //Subtitle
        headerSubtitleLabel = UILabel(frame: CGRect(x: margin, y: headerTemperatureLabel!.frame.origin.y + headerTemperatureLabel!.frame.height , width: self.view.bounds.width - (margin * 2), height: 20))
        headerSubtitleLabel!.font = UIFont(name:Constants.Font.regular, size:16)
        headerSubtitleLabel!.textColor = UIColor.black
        headerSubtitleLabel!.textAlignment = .center
        headerView.addSubview(headerSubtitleLabel!)

        self.tableView.tableHeaderView = headerView
    }
    
    private func adaptHeader(){
        self.headerTitleLabel!.text = self.dailyForecastVM.city.name
        self.headerTemperatureLabel!.text = self.dailyDataListVM.dailyDataViewModelAtIndex(0).displayTemperature
        self.headerSubtitleLabel!.text = self.dailyDataListVM.dailyDataViewModelAtIndex(0).subtitle
    }
    
    //MARK: - Activity Indicator methods
    private func showLoader() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    //MARK: - Error View
    @IBAction func refreshForecast(_ sender: Any) {
        self.errorRefreshButton.titleLabel?.font = UIFont(name:Constants.Font.regular, size:14)     //bug fix
        fetchDailyForecastForArea()
    }
    
    private func showErrorView(message: String) {
        DispatchQueue.main.async {
            self.errorRefreshButton.titleLabel?.font = UIFont(name:Constants.Font.regular, size:14)     //bug fix
            self.tableView.isHidden = true
            self.errorDescriptionLabel.text = message
            self.errorView.isHidden = false
            self.errorAnimationView.play()
            self.hideLoader()
        }
    }
    
    private func hideErrorView() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.errorAnimationView.stop()
        }
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dailyDataListVM.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyDataListVM.dailyDataListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.dailyDataListVM.dailyDataViewModelAtIndex(indexPath.row)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dailyDataCell, for: indexPath) as? DailyDataTableViewCell else {
            fatalError()
        }
        cell.titleLabel?.text = vm.getDay(index: indexPath.row)
        cell.subtitleLabel?.text = vm.subtitle
        
        cell.animationView.animation = Animation.named(vm.weatherAnimationName)
        cell.animationView.contentMode = .scaleAspectFit
        cell.animationView.loopMode = .loop
        cell.animationView.animationSpeed = 0.5
        cell.animationView.play()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var shouldFetchWeatherData = false;
        if (currentUserLocation == nil){
            shouldFetchWeatherData = true;
        }
        
        currentUserLocation = locations[0]
        if (shouldFetchWeatherData){
            fetchDailyForecastForArea()
        }
    }
}
