//
//  DailyTemperaturesListViewController.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation
import UIKit
import Combine

class DailyTemperaturesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //UI COMPONENTS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //VIEWMODELS
    private var dailyForecastVM: DailyForecastViewModel!
    private var dailyDataListVM = DailyDataListViewModel()
    
    //OBSERVERS
    var customObservers: [AnyCancellable] = []
    
    //CELL IDs
    let dailyDataCell = "DailyDataCell"
    
    //SEGUE IDs
    let goToDetailPageSegue = "goToDetailPageSegue"

    // MARK: - UIViewController Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDailyForecastForArea()
    }
    
    // MARK: - View controller Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if  segue.identifier == goToDetailPageSegue,
            let destination = segue.destination as? DetailPageViewController,
            let selectedIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.itemVM = self.itemListViewModel.itemViewModel(at: selectedIndex)
        }   */
    }
    
    // MARK: - Data
    private func fetchDailyForecastForArea(){
        showLoader()
        DailyForecastListViewModel.fetch()
            .receive(on: DispatchQueue.main)  // The tableView needs to be update on the main thread. So instead of doing DispatchQueue inside the receiveValue method, you can tell Combine to notify us on the main thread with this line
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("finished")
                case .failure(let error):
                    self.hideLoader()
                    DebuggingLogger.printData(error)
                    let alert = UIAlertController(title: "Error", message: "Something went wrong: \(error.message)", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                        self.fetchDailyForecastForArea()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))

                    self.present(alert, animated: true)
                }
            }, receiveValue: { [weak self] value in
                //use weak self coz we dont want to cause a memory leak. We also want to avoid retain cycles
                DebuggingLogger.printData("DailyTemperaturesListViewController data: \(value)")
                self?.hideLoader()
                self?.dailyForecastVM = DailyForecastViewModel(value)
                self?.dailyDataListVM.dailyDataListViewModel = value.list.map(DailyDataViewModel.init)
                self?.tableView.reloadData()
            }).store(in: &customObservers)
    }
    
    
    //MARK: - Activity Indicator methods
    private func showLoader() {
        DispatchQueue.main.async {
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
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
